import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zbot_app/auth/auth_provider.dart';
import 'package:zbot_app/config/palette.dart';
import 'package:zbot_app/data/data.dart';
import 'package:zbot_app/widgets/r6search/r6stats_search_widget.dart';
import 'package:zbot_app/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _dropdownSelectedItem = 'uplay';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final auth = Provider.of<Auth>(context);

    return Scaffold(
      appBar: CustomAppBar(),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(screenHeight),
          ...[if(auth.isAuth) _buildFeaturedCards(screenHeight)],
          ...[if(!auth.isAuth) _buildSignupNow(screenHeight)],
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Palette.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Rainbow 6 Siege stats',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'You can search for player stats here, make sure to change platform type from dropdown.',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                R6statsSearchWidget(),
              ],
            )
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildFeaturedCards(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Benefits of registration',
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: featuredCards
                  .map((e) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(e["link"]);
                    },
                    child: Column(
                          children: <Widget>[
                            Image.asset(
                              e.keys.first,
                              height: screenHeight * 0.12,
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Text(
                              e.values.first,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                  ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSignupNow(double screenHeight) {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil("/login", (Route<dynamic> route) => false);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          padding: const EdgeInsets.all(10.0),
          height: screenHeight * 0.15,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFAD9FE4), Palette.primaryColor],
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset('assets/images/r6-finka.png'),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Sign-up / Login',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Follow the instructions\nto get your login',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    maxLines: 2,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
