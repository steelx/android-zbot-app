import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class R6Stats {

  static Future<List<Profile>> getStats(String username, String platform) async {
    final response = await http.get("http://10.0.2.2:8080/ubi/find_profile?name_on_platform=$username&platform_type=$platform");
    Map<String, dynamic> data = jsonDecode(response.body);
    return (data["profiles"] as List).map((e) => Profile.fromJson(e)).toList();
  }
}

// ignore: non_constant_identifier_names
class PlayerStats {
  final double max_mmr;
  final double skill_mean;
  final int deaths;
  final String profile_id;
  final double next_rank_mmr;
  final int rank;
  final int max_rank;
  final String board_id;
  final double skill_stdev;
  final int kills;
  final double last_match_skill_stdev_change;
  final String update_time; //"2020-08-23T12:05:48.558000+00:00"
  final double last_match_mmr_change;
  final int abandons;
  final int season;
  final int top_rank_position;
  final double last_match_skill_mean_change;
  final double mmr;
  final double previous_rank_mmr;
  final int last_match_result;
  final int wins;
  final String region; //"apac"
  final int losses;

  PlayerStats.fromJson(Map<String, dynamic> data)
    :
      this.max_mmr = data["maxMmr"],
      this.skill_mean = data["skillMean"],
      this.deaths = data["deaths"],
      this.profile_id = data["profileId"],
      this.next_rank_mmr = data["nextRankMmr"],
      this.rank = data["rank"],
      this.max_rank = data["maxRank"],
      this.board_id = data["boardId"],
      this.skill_stdev = data["skillStdev"],
      this.kills = data["kills"],
      this.last_match_skill_stdev_change = data["lastMatchSkillStdevChange"],
      this.update_time = data["updateTime"], //"2020-08-23T12:05:48.558000+00:00"
      this.last_match_mmr_change = data["lastMatchMmrChange"],
      this.abandons = data["abandons"],
      this.season = data["season"],
      this.top_rank_position = data["topRankPosition"],
      this.last_match_skill_mean_change = data["lastMatchSkillMeanChange"],
      this.mmr = data["mmr"],
      this.previous_rank_mmr = data["previousRankMmr"],
      this.last_match_result = data["lastMatchResult"],
      this.wins = data["wins"],
      this.region = data["region"], //"apac"
      this.losses = data["losses"];

}

class XpProfile {
  final int xp;
  final String profile_id;
  final int lootbox_probability;
  final int level;

  XpProfile.fromJson(Map<String, dynamic> data)
  :
    this.xp = data["xp"],
    this.profile_id = data["profile_id"],
    this.lootbox_probability = data["lootbox_probability"],
    this.level = data["level"];
}


class Profile {
  final String profile_id;
  final String user_id;
  final String platform_type;
  final String id_on_platform;
  final String name_on_platform;

  Profile.fromJson(Map<String, dynamic> data)
  :
    this.profile_id = data["profileId"],
    this.user_id = data["userId"],
    this.platform_type = data["platformType"],
    this.id_on_platform = data["idOnPlatform"],
    this.name_on_platform = data["nameOnPlatform"];
}