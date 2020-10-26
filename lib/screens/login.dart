//import 'package:firebase_auth/';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpmeapp/widgets/appdrawer.dart';
import 'package:provider/provider.dart';

import '../providers/user_data.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LOGIN / REGISTER')),
      body: FormScreen(),
      drawer: HomeDrawer(),
    );
  }
}

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  bool _loading = false;

  void _saveForm() async {
    if (_isLogin) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _controller1.text, password: _controller.text)
          .then(
              (value) => Provider.of<MyUser>(context, listen: false).getinfo())
          .then((value) => Navigator.of(context).popAndPushNamed('/'))
          .catchError((onError) => Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(onError.toString()))));
    } else {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _controller1.text, password: _controller.text)
          .then((b) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .set({
          'uid': b.user.uid,
          'name': _info['username'],
          'email': _controller1.text,
          'friends': []
        }).then((value) => Navigator.of(context).popAndPushNamed('/'));
      }).catchError((onError) => Scaffold.of(context).showSnackBar(
              SnackBar(content: const Text("There was an error"))));
    }
  }

  final _controller = TextEditingController();
  final _controller1 = TextEditingController();
  final _key = GlobalKey<FormState>();
  Map<String, String> _info = {'email': '', 'password': '', 'username': ''};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var _isLogin = true;
  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Card(
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: AnimatedContainer(
                constraints: BoxConstraints(
                    minHeight: _isLogin
                        ? MediaQuery.of(context).size.height * 0.40
                        : MediaQuery.of(context).size.height * 0.46),
                duration: Duration(milliseconds: 259),
                curve: Curves.easeInBack,
                height: _isLogin
                    ? MediaQuery.of(context).size.height * 0.40
                    : MediaQuery.of(context).size.height * 0.60,
                padding: EdgeInsets.all(16),
                child: AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _isLogin
                        ? MediaQuery.of(context).size.height * 0.33
                        : MediaQuery.of(context).size.height * 0.60,
                  ),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInBack,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _key,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            controller: _controller1,
                            onChanged: (val) {
                              _info['email'] = val.trim();
                            },
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val.isEmpty || !val.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                            ),
                          ),
                          if (!_isLogin)
                            Container(
                              child: TextFormField(
                                onChanged: (val) {
                                  _info['username'] = val.trim();
                                },
                                validator: (val) {
                                  if (val.length < 4) {
                                    return 'Please enter atleast 4 characters';
                                  }
                                  return null;
                                },
                                decoration:
                                    InputDecoration(labelText: 'User Name'),
                              ),
                            ),
                          TextFormField(
                            controller: _controller,
                            onChanged: (val) {
                              _info['password'] = val.trim();
                            },
                            validator: (val) {
                              if (val.length < 7) {
                                return 'Password must be atleast 7 characters long';
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(labelText: 'Password'),
                          ),
                          if (!_isLogin)
                            Container(
                              child: TextFormField(
                                validator: (val) {
                                  print(val);
                                  print(_controller.text);
                                  if (val != _controller.text) {
                                    return 'Password doesn\'t match';
                                  }
                                  return null;
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    labelText: 'Confirm password'),
                              ),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: _saveForm,
                            child: Text(_isLogin ? 'Login' : 'Sign up'),
                          ),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                                !_isLogin ? 'Login' : 'Create a new account'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
