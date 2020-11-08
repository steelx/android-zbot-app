
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zbot_app/auth/auth_provider.dart';
import 'package:zbot_app/auth/user_model.dart';
import 'package:zbot_app/constants.dart';
import 'package:zbot_app/resources/api_client.dart';
import 'package:zbot_app/screens/user_profile/profile_form_component.dart';
import 'package:zbot_app/screens/user_profile/user_profile_bloc.dart';

class UserProfileScreen extends StatelessWidget {

  static final String path = "/profile";

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    ApiClient apiClient = Provider.of<ApiClient>(context);

    if (!auth.isAuth) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: uiDefaultPadding),
        child: Text("not authenticated"),
      );
    }

    User user = auth.user;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: uiDefaultPadding),
        child: ProfileFormComponent(user, apiClient),
      ),
    );
  }
}
