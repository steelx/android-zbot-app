
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:zbot_app/resources/r6_stats.dart';

class PlayerStatsBloc {
  final BehaviorSubject<PlayerStats> _playerStats = BehaviorSubject<PlayerStats>();
  Stream<PlayerStats> get playerStats => _playerStats.stream;

  fetchPlayerStats(String platform_type, String profile_id) {
  }
}