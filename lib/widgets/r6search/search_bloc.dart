import 'package:zbot_app/resources/r6_stats.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  final _dataFetcher = PublishSubject<List<Profile>>();

  Stream<List<Profile>> get statsResult => _dataFetcher.stream;

  searchR6Stats(String username, String platform) async {
    List<Profile> profiles = await R6Stats.getStats(username, platform);
    _dataFetcher.sink.add(profiles);
  }

  dispose() {
    _dataFetcher.close();
  }
}
