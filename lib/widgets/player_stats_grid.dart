import 'package:flutter/material.dart';
import 'package:zbot_app/constants.dart';
import 'package:zbot_app/resources/api_client.dart';
import 'package:zbot_app/resources/loader_with_future.dart';
import 'package:zbot_app/resources/r6_stats.dart';

class StatsGrid extends StatelessWidget {
  final PlayerStats stats;
  final ApiClient apiClient;
  final String profile_id;
  final String platform_type;


  StatsGrid({this.stats, this.apiClient, this.profile_id, this.platform_type});

  @override
  Widget build(BuildContext context) {
    var kd = (stats.kills/stats.deaths).toStringAsFixed(2);

    return Container(
      height: MediaQuery.of(context).size.height * 0.50,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard('Wins/Losses', "${stats.wins}/${stats.losses}", Colors.orange),
                _buildStatCard("Kills/Deaths [KD: $kd]", "${stats.kills}/${stats.deaths}", Colors.red),
              ],
            ),
          ),

          Flexible(
            child: LoaderWithFutureWidget(
              apiCall: apiClient.get("/ubi/find_populations_statistics?profile_id=${this.profile_id}&platform_type=${this.platform_type}&statistics=casualpvp_timeplayed,generalpvp_timeplayed,rankedpvp_matchwon,rankedpvp_matchlost,rankedpvp_timeplayed,rankedpvp_matchplayed,rankedpvp_kills,rankedpvp_death,generalpvp_kills,generalpvp_deaths"),
              create: (response, ctx) {
                if (response["results"]["$profile_id"] == null) {
                  return noResult("Play time");
                }
                var populationStats = (response["results"]["$profile_id"] as Map).cast<String, dynamic>();
                int generalPlaytime = populationStats["generalpvp_timeplayed:infinite"] ?? 0;
                int generalpvpKills = populationStats["generalpvp_kills:infinite"] ?? 0;
                var timePlayed = secondsToHms(generalPlaytime);

                return Row(
                  children: [
                    _buildStatCard("Play time", "$timePlayed", Colors.blueGrey),
                    _buildStatCard("PVP Kills", "$generalpvpKills", Colors.blueGrey),
                  ],
                );
              },
              error: (e, ctx) => loaderError(),
            ),
          ),

          Flexible(
            child: LoaderWithFutureWidget(
              apiCall: apiClient.get("/ubi/find_player_xp_profiles?profile_id=${this.profile_id}&platform_type=${this.platform_type}"),
              create: (response, ctx) {
                var xpProfiles = (response["player_profiles"] as List).cast<Map<String, dynamic>>()
                    .map((p) => XpProfile.fromJson(p)).toList();

                return Row(
                  children: [
                    _buildStatCard("XP", "${xpProfiles[0].xp}", Colors.black38),
                    _buildStatCard("Level", "${xpProfiles[0].level}", Colors.black38),
                  ],
                );
              },
              error: (e, ctx) => loaderError(),
            ),
          ),
        ],
      ),
    );
  }

  Widget noResult(String msg) {
    return Row(
      children: [
        _buildStatCard(msg, "0", Colors.blueGrey)
      ],
    );
  }

  Widget loaderError() {
    return Container(
      child: Text("Error loading player stats!"),
      padding: const EdgeInsets.all(uiDefaultPadding/2),
    );
  }

  Expanded _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String secondsToHms(int d) {
//1430466
  var h = (d / 3600).round();
  var m = (d % 3600 / 60).round();
  // var s = (d % 3600 % 60);
  return "${h.toString()}h ${m.toString()}m";
}