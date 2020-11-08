
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:zbot_app/screens/user_profile/user_profile_bloc.dart';


class MapsScreen extends StatelessWidget {
  MapsScreen();

  Widget build(BuildContext context) {
    UserProfileBloc bloc = Provider.of<UserProfileBloc>(context);

    return Scaffold(
        body: Center(
            child: SearchMapPlaceWidget(
                apiKey: "AIzaSyAkFJAgGsANjvsGFa1oH15BH0SOCdo3yDE",
                onSelected: (Place place) async {
                  // List fullJson = (place.fullJSON["terms"] as List).cast<Map<String, dynamic>>();
                  var location = (place.fullJSON["terms"] as List).map((m) => m["value"] as String).toList();
                  bloc.changeLocation(location);

                  Navigator.of(context).pop();
                },
            )
        )
    );
  }
}