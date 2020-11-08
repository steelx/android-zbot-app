import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zbot_app/auth/auth_provider.dart';
import 'package:zbot_app/common/stream_proxy_provider.dart';
import 'package:zbot_app/config/custom_route.dart';
import 'package:zbot_app/resources/api_client.dart';
import 'package:zbot_app/screens/auth_screen.dart';
import 'package:zbot_app/screens/home_screen.dart';
import 'package:zbot_app/screens/user_profile/maps_screen.dart';
import 'package:zbot_app/screens/user_profile/user_profile_bloc.dart';
import 'package:zbot_app/screens/user_profile/user_profile_screen.dart';

import 'package:zbot_app/screens/splash_screen.dart';
import 'package:zbot_app/widgets/r6search/search_bloc.dart';
import 'constants.dart';

void main() {
  const API_ENDPOINT = String.fromEnvironment('API_ENDPOINT',
      defaultValue: 'http://10.0.2.2:8080');

  runApp(MyApp(API_ENDPOINT));
}

class MyApp extends StatelessWidget {
  final String _apiEndpoint;

  MyApp(this._apiEndpoint);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>(create: (_) => Auth.addApiClient(ApiClient(http.Client(), Uri.decodeFull(this._apiEndpoint)))),
          StreamProxyProvider<Auth, ApiClient>(
            streamProvider: (_, auth) => auth.apiClient,
            initialReturnValue: ApiClient(http.Client(), Uri.decodeFull(this._apiEndpoint)),
          ),

          Provider<UserProfileBloc>(create: (_) => UserProfileBloc()),
          Provider<Future<SharedPreferences>>(create: (_) => SharedPreferences.getInstance()),
          Provider<SearchBloc>(create: (_) => SearchBloc()),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Lay Siege',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: uiBackgroundColor,
              primaryColor: uiPrimaryColor1,
              secondaryHeaderColor: uiSecondaryColor,
              backgroundColor: uiBackgroundColor,
              textTheme: Theme.of(context).textTheme.apply(bodyColor: uiTextColor),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              canvasColor: uiBackgroundColor,
              inputDecorationTheme: Theme.of(context)
                  .inputDecorationTheme
                  .copyWith(
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: uiTextColor,
                    ),
                    hintStyle: TextStyle(color: uiTextColor.withOpacity(.6)),
                  ),
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              }),
            ),
            home: auth.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResult) =>
                        authResult.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : HomeScreen(),
                  ),
            routes: {
              "/login": (ctx) => AuthScreen(),
              "/maps": (ctx) => MapsScreen(),
              UserProfileScreen.path: (ctx) => UserProfileScreen(),
            },
          ),
        ),
    );
  }
}
