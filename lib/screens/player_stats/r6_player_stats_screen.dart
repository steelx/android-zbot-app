
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zbot_app/config/palette.dart';
import 'package:zbot_app/config/styles.dart';
import 'package:zbot_app/constants.dart';
import 'package:zbot_app/data/data.dart';
import 'package:zbot_app/resources/api_client.dart';
import 'package:zbot_app/resources/loader_with_future.dart';
import 'package:zbot_app/resources/r6_stats.dart';
import 'package:zbot_app/widgets/bar_chart_widget.dart';
import 'package:zbot_app/widgets/player_stats_grid.dart';

class R6PlayerStatsScreen extends StatelessWidget {
  final String platform_type;
  final String profile_id;
  final String player_name;

  R6PlayerStatsScreen({@required this.platform_type, @required this.profile_id, @required this.player_name});

  @override
  Widget build(BuildContext context) {
    var apiClient = Provider.of<ApiClient>(context);

    return LoaderWithFutureWidget(
      apiCall: apiClient.get("/ubi/find_stats?profile_id=$profile_id&region_id=apac&platform_type=$platform_type"),
      create: (response, ctx) {
        var stats = PlayerStats.fromJson(response);
        return buildBody(stats, apiClient);
      },
      error: (e, ctx) => Container(
        child: Text("Cannot load player stats!"),
        padding: const EdgeInsets.all(uiDefaultPadding),
      ),
    );
  }

  Widget buildBody(PlayerStats stats, ApiClient apiClient) {
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      appBar: AppBar(
        title: Text("Player stats"),
        backgroundColor: Palette.primaryColor,
        elevation: 0.0,
      ),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(stats),
          // _buildRegionTabBar(),
          // _buildStatsTabBar(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            sliver: SliverToBoxAdapter(
              child: StatsGrid(stats: stats, apiClient: apiClient, profile_id: this.profile_id, platform_type: this.platform_type),
            ),
          ),
          // SliverPadding(
          //   padding: const EdgeInsets.only(top: 20.0),
          //   sliver: SliverToBoxAdapter(
          //     child: BarChartWidget(covidCases: covidUSADailyNewCases),
          //   ),
          // ),
        ],
      ),
    );
  }

  SliverPadding _buildHeader(PlayerStats stats) {
    var rank = get_rank(stats.rank, stats.season);

    return SliverPadding(
      padding: const EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Text(
              player_name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 20.0),
            CircleAvatar(
              backgroundColor: Colors.black12,
              radius: 16.0,
              child: Image.network(rank[1]),
            ),
            const SizedBox(width: 8.0),
            Text(
              rank[0],
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildRegionTabBar() {
    return SliverToBoxAdapter(
      child: DefaultTabController(
        length: 2,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: TabBar(
            indicator: BubbleTabIndicator(
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
              indicatorHeight: 40.0,
              indicatorColor: Colors.white,
            ),
            labelStyle: Styles.tabTextStyle,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Text('My Country'),
              Text('Global'),
            ],
            onTap: (index) {},
          ),
        ),
      ),
    );
  }

  SliverPadding _buildStatsTabBar() {
    return SliverPadding(
      padding: const EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
        child: DefaultTabController(
          length: 3,
          child: TabBar(
            indicatorColor: Colors.transparent,
            labelStyle: Styles.tabTextStyle,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: <Widget>[
              Text('Total'),
              Text('Today'),
              Text('Yesterday'),
            ],
            onTap: (index) {},
          ),
        ),
      ),
    );
  }

}

/*
* {
  "max_mmr": 2344.0,
  "skill_mean": 18.79406,
  "deaths": 137,
  "profile_id": "b5072e90-ad85-4bd8-9d18-e0bfe5f2aba5",
  "next_rank_mmr": 1900.0,
  "rank": 8,
  "max_rank": 13,
  "board_id": "pvp_ranked",
  "skill_stdev": 6.1807256,
  "kills": 157,
  "last_match_skill_stdev_change": -0.041490614,
  "update_time": "2020-10-02T08:11:42.562000+00:00",
  "last_match_mmr_change": -77.0,
  "abandons": 0,
  "season": 19,
  "top_rank_position": 0,
  "last_match_skill_mean_change": -0.76590765,
  "mmr": 1879.0,
  "previous_rank_mmr": 1800.0,
  "last_match_result": 2,
  "wins": 13,
  "region": "apac",
  "losses": 19
}
* */


List<String> get_rank(int rank_id, int season) {
  var rank = ["Unranked", "https://i.imgur.com/jNJ1BBl.png"];
  if (season >= 15) {
    if (rank_id == 0) {return ["Unranked", "https://i.imgur.com/jNJ1BBl.png"];}
    else if (rank_id <= 5) {
    if (rank_id == 1) { rank = ["Copper Ⅴ", "https://i.imgur.com/B8NCTyX.png"];}
    else if (rank_id == 2) { rank = ["Copper Ⅳ", "https://i.imgur.com/ehILQ3i.jpg"];}
    else if (rank_id == 3) { rank = ["Copper Ⅲ", "https://i.imgur.com/6CxJoMn.jpg"];}
    else if (rank_id == 4) { rank = ["Copper Ⅱ", "https://i.imgur.com/eI11lah.jpg"];}
    else if (rank_id == 5) { rank = ["Copper Ⅰ", "https://i.imgur.com/0J0jSWB.jpg"];}
    return rank;
    }
    else if (rank_id <= 10) {
    if (rank_id == 6) { rank = ["Bronze Ⅴ", "https://i.imgur.com/TIWCRyO.png"];}
    else if (rank_id == 7) { rank = ["Bronze Ⅳ", "https://i.imgur.com/42AC7RD.jpg"];}
    else if (rank_id == 8) { rank = ["Bronze Ⅲ", "https://i.imgur.com/QD5LYD7.jpg"];}
    else if (rank_id == 9) { rank = ["Bronze Ⅱ", "https://i.imgur.com/9AORiNm.jpg"];}
    else if (rank_id == 10) { rank = ["Bronze Ⅰ", "https://i.imgur.com/hmPhPBj.jpg"];}
    return rank;
    }
    else if (rank_id <= 15) {
    if (rank_id == 11) { rank = ["Silver Ⅴ", "https://i.imgur.com/PY2p17k.png"];}
    else if (rank_id == 12) { rank = ["Silver Ⅳ", "https://i.imgur.com/D36ZfuR.jpg"];}
    else if (rank_id == 13) { rank = ["Silver Ⅲ", "https://i.imgur.com/m8GToyF.jpg"];}
    else if (rank_id == 14) { rank = ["Silver Ⅱ", "https://i.imgur.com/EswGcx1.jpg"];}
    else if (rank_id == 15) { rank = ["Silver Ⅰ", "https://i.imgur.com/KmFpkNc.jpg"];}
    return rank;
    }
    else if (rank_id <= 18) {
      if (rank_id == 16) { rank = ["Gold Ⅲ", "https://i.imgur.com/B0s1o1h.jpg"];}
      else if (rank_id == 17) { rank = ["Gold Ⅱ", "https://i.imgur.com/ELbGMc7.jpg"];}
      else if (rank_id == 18) { rank = ["Gold Ⅰ", "https://i.imgur.com/ffDmiPk.jpg"];}
      return rank;
    }
    else if (rank_id <= 21) {
    if (rank_id == 19) { rank = ["Platinum Ⅲ", "https://i.imgur.com/tmcWQ6I.png"];}
    else if (rank_id == 20) {rank = ["Platinum Ⅱ", "https://i.imgur.com/CYMO3Er.png"];}
    else if (rank_id == 21) { rank = ["Platinum Ⅰ", "https://i.imgur.com/qDYwmah.png"];}
    return rank;
    }
    else if (rank_id <= 22) {
    return ["Diamond", "https://i.imgur.com/37tSxXm.png"];
    }
    else {return ["Champion", "https://i.imgur.com/VlnwLGk.png"];}
  }
  else {
    if (rank_id == 0) {
    return ["Unranked", "https://i.imgur.com/jNJ1BBl.png"];
    }
    else if (rank_id <= 4) {
    if (rank_id == 1) { rank = ["Copper Ⅳ", "https://i.imgur.com/ehILQ3i.jpg"];}
    else if (rank_id == 2) { rank = ["Copper Ⅲ", "https://i.imgur.com/6CxJoMn.jpg"];}
    else if (rank_id == 3) { rank = ["Copper Ⅱ", "https://i.imgur.com/eI11lah.jpg"];}
    else if (rank_id == 4) { rank = ["Copper Ⅰ", "https://i.imgur.com/0J0jSWB.jpg"];}
    return rank;
    }
    else if (rank_id <= 8) {
    if (rank_id == 5) { rank = ["Bronze Ⅳ", "https://i.imgur.com/42AC7RD.jpg"];}
    else if (rank_id == 6) { rank = ["Bronze Ⅲ", "https://i.imgur.com/QD5LYD7.jpg"];}
    else if (rank_id == 7) { rank = ["Bronze Ⅱ", "https://i.imgur.com/9AORiNm.jpg"];}
    else if (rank_id == 8) { rank = ["Bronze Ⅰ", "https://i.imgur.com/hmPhPBj.jpg"];}
    return rank;
    }
    else if (rank_id <= 12) {
    if (rank_id == 9) { rank = ["Silver Ⅳ", "https://i.imgur.com/D36ZfuR.jpg"];}
    else if (rank_id == 10) { rank = ["Silver Ⅲ", "https://i.imgur.com/m8GToyF.jpg"];}
    else if (rank_id == 11) { rank = ["Silver Ⅱ", "https://i.imgur.com/EswGcx1.jpg"];}
    else if (rank_id == 12) { rank = ["Silver Ⅰ", "https://i.imgur.com/KmFpkNc.jpg"];}
    return rank;
    }
    else if (rank_id <= 16) {
    if (rank_id == 13) { rank = ["Gold Ⅳ", "https://i.imgur.com/6Qg6aaH.jpg"];}
    else if (rank_id == 14) { rank = ["Gold Ⅲ", "https://i.imgur.com/B0s1o1h.jpg"];}
    else if (rank_id == 15) { rank = ["Gold Ⅱ", "https://i.imgur.com/ELbGMc7.jpg"];}
    else if (rank_id == 16) { rank = ["Gold Ⅰ", "https://i.imgur.com/ffDmiPk.jpg"];}
    return rank;
    }
    else if (rank_id <= 19) {
    if (rank_id == 17) { rank = ["Platinum Ⅲ", "https://i.imgur.com/Sv3PQQE.jpg"];}
    else if (rank_id == 18) { rank = ["Platinum Ⅱ", "https://i.imgur.com/Uq3WhzZ.jpg"];}
    else if (rank_id == 19) { rank = ["Platinum Ⅰ", "https://i.imgur.com/xx03Pc5.jpg"];}
    return rank;
    }
    else {
    return ["Diamond", "https://i.imgur.com/nODE0QI.jpg"];
    }
  }
}
