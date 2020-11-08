import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zbot_app/auth/auth_provider.dart';
import 'package:zbot_app/config/palette.dart';
import 'package:zbot_app/constants.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    return AppBar(
      backgroundColor: Palette.primaryColor,
      elevation: 0.0,
      title: Text("Siege Frontier F", style: TextStyle(color: uiGreenColor)),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        iconSize: 28.0,
        onPressed: () {
          Navigator.of(context).pushNamed("/profile");
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.directions),
          iconSize: 28.0,
          onPressed: () {
            auth.logout()
                .then((_) {
                  Navigator.of(context).pushNamed("/");
            });
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
