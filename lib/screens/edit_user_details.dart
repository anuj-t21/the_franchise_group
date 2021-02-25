import 'dart:io';

import 'package:the_franchise_group/providers/auth.dart';
import 'package:the_franchise_group/widgets/pickers/user_image_picker.dart';

import '../providers/user_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditUserDetailsScreen extends StatefulWidget {
  static const routeName = '/edit-user';

  @override
  _EditUserDetailsScreenState createState() => _EditUserDetailsScreenState();
}

class _EditUserDetailsScreenState extends State<EditUserDetailsScreen> {
  final _contactFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _initValue = true;

  File _userImageFile;

  var _initProduct = {
    'name': '',
    'contact': '',
    'imageUrl': '',
  };
  var _isLoading = false;

  var _editedProduct = User(
    id: '',
    name: '',
    contact: '',
    imageUrl: '',
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initValue) {
      final addId = Provider.of<Auth>(context).userId;
      if (addId != null) {
        _editedProduct = Provider.of<UserDetails>(context).user;
        _initProduct = {
          'name': _editedProduct.name,
          'contact': _editedProduct.contact,
          'imageUrl': _editedProduct.imageUrl,
        };
      }
    }
    _initValue = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _contactFocusNode.dispose();
    super.dispose();
  }

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  Future<void> _saveForm() async {
    final _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != null) {
      if (_userImageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(_editedProduct.id + '.jpg');

        await ref.putFile(_userImageFile).onComplete;

        final url = await ref.getDownloadURL();

        _editedProduct = User(
          id: _editedProduct.id,
          name: _editedProduct.name,
          contact: _editedProduct.contact,
          imageUrl: url,
        );
      }

      await Provider.of<UserDetails>(context, listen: false)
          .updateAddress(_editedProduct.id, _editedProduct);
      await _showPriceDialog();
    } else {
      try {
        await Provider.of<UserDetails>(context, listen: false)
            .addUser(_editedProduct);
        await _showPriceDialog();
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred'),
            content: Text('Something went wrong'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'Okay!',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Future<bool> _showPriceDialog() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('User Saved!'),
        content: const Text('You can continue.'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
            child: Text(
              'Okay',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User Details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
//      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initProduct['name'],
                      decoration: InputDecoration(labelText: 'Name'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_contactFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = User(
                          id: _editedProduct.id,
                          name: value,
                          contact: _editedProduct.contact,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a Name.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initProduct['contact'],
                      decoration: InputDecoration(labelText: 'Contact'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _contactFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide contact.';
                        }
                        if (value.length != 10) {
                          return 'Please provide a valid number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = User(
                          id: _editedProduct.id,
                          name: _editedProduct.name,
                          contact: value,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    UserImagePicker(_pickedImage, _initProduct['imageUrl']),
                  ],
                ),
              ),
            ),
    );
  }
}
