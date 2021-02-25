import 'package:the_franchise_group/screens/edit_user_details.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
//  var id = '';

//  @override
//  void didChangeDependencies() {
//    if (_init) {
//      Provider.of<UserAddress>(context, listen: false).fetchAddress();
//      Provider.of<UserAddress>(context).address.isNotEmpty
//          ? id = Provider.of<UserAddress>(context).address.first.id
//          : id = null;
//    }
//    _init = false;
//    super.didChangeDependencies();
//  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Center(
                child: Text('Welcome @TFG'),
              ),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              leading: Icon(Icons.format_align_left),
              title: Text('Manage User'),
              onTap: () {
//              setState(() {
//                _init = true;
//              });
//                id != null
//                    ? Navigator.of(context).pushNamed(
//                  EditAddressScreen.routeName,
//                  arguments: id,
//                )
//                    : Navigator.of(context).pushNamed(
//                  EditAddressScreen.routeName,
//                );

                Navigator.of(context).pushNamed(
                  EditUserDetailsScreen.routeName,
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
