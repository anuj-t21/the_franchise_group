import 'package:flutter/material.dart';
import 'package:the_franchise_group/widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Franchise Group'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
