import 'package:flutter/material.dart';
import 'package:mediasync/models/user.dart';
import 'package:mediasync/screens/authenticate/authenticate.dart';
import 'package:mediasync/screens/home/home.dart';
import 'package:mediasync/screens/home/home_stream.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    if (user==null) {
      return Authenticate();
    }else {
      return HomeStream(user: user);
    }
  }
}
