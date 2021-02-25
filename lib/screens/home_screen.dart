import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_franchise_group/providers/auth.dart';
import 'package:the_franchise_group/providers/user_details.dart';
import 'package:the_franchise_group/widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (_isInit) {
      final prefs = await SharedPreferences.getInstance();

      prefs.setBool('isFirst', false);

      Provider.of<UserDetails>(context, listen: false).fetchUser();

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Franchise Group'),
      ),
      drawer: AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).indicatorColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
//              color: Theme.of(context).accentColor,
            ),
            label: 'TFG Fav',
//            backgroundColor: Theme.of(context).indicatorColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star_border,
//              color: Theme.of(context).accentColor,
            ),
            label: 'TFG Unfav',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Home',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'This is a non interactive page.',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              'Please click on the hamburger icon.',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
