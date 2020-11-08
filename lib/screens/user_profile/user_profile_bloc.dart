
import 'dart:async';

import 'package:zbot_app/auth/user_model.dart';

class UserProfileBloc {
  final _email = StreamController<String>();
  final _username = StreamController<String>();
  final _fullName = StreamController<String>();
  final _bio = StreamController<String>();
  final _location = StreamController<List<String>>();

  // Set Data
  void changeEmail(String email) => _email.sink.add(email);
  void changeUsername(String username) => _username.sink.add(username);
  void changeFullName(String fullName) => _fullName.sink.add(fullName);
  void changeBio(String bio) => _bio.sink.add(bio);
  void changeLocation(List<String> locations) => _location.sink.add(locations);

  // Get data
  get email => _email.stream;
  get username => _username.stream;
  get fullName => _fullName.stream;
  get bio => _bio.stream;
  get locations => _location.stream;

  dispose() {
    _email.close();
    _username.close();
    _fullName.close();
    _bio.close();
    _location.close();
  }
}
