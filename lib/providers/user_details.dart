import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String id;
  final String name;
  final String contact;
  final String imageUrl;

  User({
    @required this.id,
    @required this.name,
    @required this.contact,
    @required this.imageUrl,
  });
}

class UserDetails with ChangeNotifier {
  User _user;
  //final String authToken;
  final String userId;

  UserDetails(this.userId, this._user);

  User get user {
    print('reachhhhhh');
//    print(_user.name);
    return _user;
  }

  Future<void> fetchUser() async {
    print('111');
    final url =
        'https://the-franchise-group-default-rtdb.firebaseio.com/user/$userId.json';
//    final url =
//        'https://store-f24d4.firebaseio.com/finalOrder/$userId/address.json';
    //'?auth=$authToken';
    final response = await http.get(url);
//    final User loadedUser;
    print(response.body);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    print(extractedData);
    extractedData.forEach((userId, userValue) {
      _user = User(
          id: userId,
          name: userValue['name'],
          contact: userValue['contact'],
          imageUrl: userValue['imageUrl']);
    });
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    print('reach');
//    final timeStamp = DateTime.now();
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
        'imageUrl': '',
      }),
    );

    _user = User(
      id: json.decode(response.body)['name'],
      name: user.name,
      contact: user.contact,
      imageUrl: '',
    );

    print(_user.name);
    notifyListeners();
  }

  Future<void> updateAddress(String id, User newUser) async {
    final urlUpdate =
        'https://the-franchise-group-default-rtdb.firebaseio.com/user/$userId/$id/.json';
    await http.patch(
      urlUpdate,
      body: json.encode({
        'name': newUser.name,
        'contact': newUser.contact,
        'imageUrl': newUser.imageUrl,
      }),
    );
    _user = newUser;
    notifyListeners();
  }
}
