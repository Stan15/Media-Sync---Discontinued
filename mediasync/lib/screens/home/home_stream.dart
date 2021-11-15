import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mediasync/models/user_data.dart';
import 'package:mediasync/screens/home/home.dart';
import 'package:mediasync/services/database.dart';
import 'package:mediasync/shared/loading.dart';
import 'package:provider/provider.dart';

class HomeStream extends StatelessWidget {

  final user;

  HomeStream({this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('userSyncData').document(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        }

        UserData userData = UserData(
          syncAudio: snapshot.data['syncAudio'] ?? true,
          syncVideo: snapshot.data['syncVideo'] ?? false,
          playlists: snapshot.data['playlists'].cast<String>() ?? <String>[],
          playlistLimit: snapshot.data['playlistLimit'] ?? 3,
          uid: user.uid,
        );
        return Home(userData: userData);
      },
    );
  }
}
