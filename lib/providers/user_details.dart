import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String id;
  final String name;
  final String contact;

  User({
    @required this.id,
    @required this.name,
    @required this.contact,
  });
}

class UserDetails with ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    contact: '',
  );
  //final String authToken;
  final String userId;

  UserDetails(this.userId);

  User get user {
    print('reachhhhhh');
    print(_user.name);
    return _user;
  }

//  Future<void> fetchUser() async {
//    print('111');
//    final url =
//        'https://the-franchise-group-default-rtdb.firebaseio.com/user/$userId.json';
////    final url =
////        'https://store-f24d4.firebaseio.com/finalOrder/$userId/address.json';
//    //'?auth=$authToken';
//    final response = await http.get(url);
////    final User loadedUser;
//    final extractedData = json.decode(response.body) as Map<String, dynamic>;
//    if (extractedData == null) {
//      return;
//    }
//    extractedData.forEach((userId, userValue) {
//      _user = User(
//        id: userId,
//        name: userValue['name'],
//        contact: userValue['contact'],
//      );
//    });
//    notifyListeners();
//  }

  Future<void> addUser(User user) async {
    print('reach');
    final timeStamp = DateTime.now();
    final url =
        'https://the-franchise-group-default-rtdb.firebaseio.com/user/$userId/.json';
//    final url =
//        'https://store-f24d4.firebaseio.com/finalOrder/$userId/address.json';
    //'?auth=$authToken';
    final response = await http.post(
      url,
      body: json.encode({
        'name': user.name,
        'contact': user.contact,
      }),
    );

    _user = User(
      id: json.decode(response.body)['name'],
      name: user.name,
      contact: user.contact,
    );

    print(_user.name);
    notifyListeners();
  }

  Future<void> updateAddress(String id, User newUser) async {
    final urlUpdate =
        'https://the-franchise-group-default-rtdb.firebaseio.com/user/$userId/.json';
    await http.patch(
      urlUpdate,
      body: json.encode({
        'name': newUser.name,
        'contact': newUser.contact,
      }),
    );
    _user = newUser;
    notifyListeners();
  }
}
