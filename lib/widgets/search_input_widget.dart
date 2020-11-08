
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zbot_app/constants.dart';
import 'package:zbot_app/resources/r6_stats.dart';
import 'package:zbot_app/screens/player_stats/r6_player_stats_screen.dart';
import 'package:zbot_app/widgets/r6search/search_bloc.dart';

class SearchInputWidget extends StatelessWidget {
  final String platformType;
  SearchInputWidget(this.platformType);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showSearch(context: context, delegate: Search(platformType)),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: uiTextColor,
            ),
            Text("Search", style: Theme.of(context).textTheme.subtitle1.copyWith(
              color: uiTextColor,
            ))
          ],
        ),
      ),
    );
  }

}

class Search extends SearchDelegate {
  final String _platformType;

  Search(this._platformType);

  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon on the left of app bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //show some results based on selection
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              'Search Item must be longer than two letters',
            ),
          )
        ],
      );
    }

    //Add the search term to the searchBloc.
    //The Bloc will then handle the searching and add the results to the searchResults stream.
    //This is the equivalent of submitting the search term to whatever search service you are using
    Provider.of<SearchBloc>(context)
        .searchR6Stats(query, this._platformType);

    return Column(
      children: <Widget>[
        StreamBuilder(
          stream: Provider.of<SearchBloc>(context).statsResult,
          builder: (context, AsyncSnapshot<List<Profile>> snapshot) {
            if (!snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                ],
              );
            }

            var results = snapshot.data;

            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (ctx, index) {
                  var profile = results[index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => R6PlayerStatsScreen(
                            platform_type: profile.platform_type,
                            profile_id: profile.profile_id,
                            player_name: profile.name_on_platform,
                        )
                    )),
                    child: ListTile(
                      leading: Icon(Icons.send),
                      title: Text("${profile.name_on_platform} | ${profile.platform_type}"),
                    ),
                  );
                }
            );
          },
        )
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //show when someone searches for something
    return Column();
  }
}
