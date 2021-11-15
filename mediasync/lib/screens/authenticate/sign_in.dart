import 'package:flutter/material.dart';
import 'file:///C:/Users/sihes/AndroidStudioProjects/mediasync/lib/shared/misc_widgets.dart';
import 'package:mediasync/services/auth.dart';
import 'package:mediasync/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        title: Text('Sign in to Media Sync'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(
              Icons.person_add,
              color: Colors.white,
            ),
            label: Text(
              'Register',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              widget.toggleView();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (value) {
                      setState(() => email = value);
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Password'),
                    obscureText: true,
                    validator: (val) => val.length<6 ? 'Incorrect password' : null,
                    onChanged: (value) {
                      setState(() => password = value);
                    },
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    color: Colors.blueAccent,
                    child: Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() => loading = true);
                        dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                        if (result == null) {
                          setState(() {
                            error = 'Could not sign in with those credentials';
                            loading = false;
                          });
                        }
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    color: Colors.blueAccent,
                    child: Text(
                      'Sign in anonymously',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      setState(() => loading = true);
                      dynamic result = await _auth.signInAnon();
                      if (result == null) {
                        setState(() {
                          error = 'Could not sign in';
                          loading = false;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Text(error),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
