import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediasync/models/user_data.dart';
import 'package:mediasync/services/url_validation.dart';
import 'package:intl/intl.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userDataCollection  = Firestore.instance.collection('userSyncData');

  Future updateUserData(bool syncAudio, bool syncVideo, List<String> playlists, int playlistLimit) async {
    return await userDataCollection.document(uid).setData({
      'syncAudio': syncAudio,
      'syncVideo': syncVideo,
      'playlists': playlists,
      'playlistLimit': playlistLimit,
    });
  }

  void setSyncAudio(bool syncAudio) {
    userDataCollection.document(uid).updateData({
      'syncAudio': syncAudio,
    });
  }

  void setSyncVideo(bool syncVideo) {
    userDataCollection.document(uid).updateData({
      'syncVideo': syncVideo,
    });
  }

  bool addPlaylist(String url) {
    bool added = false;
    if (validateUrl(url: url, restrict: 'playlist')) {
      userDataCollection.document(uid).updateData({
        'playlists': FieldValue.arrayUnion(<String>[url])
      });
      added = true;
    }
    return added;
  }

  Future<void> removePlaylist(String url) async{
    DocumentReference docRef = userDataCollection.document(uid);
    DocumentSnapshot doc = await docRef.get();
    List playlists = doc.data['playlists'];
    if (playlists.contains(url)) {
      docRef.updateData({
        'playlists': FieldValue.arrayRemove([url])
      });
    }
  }

  Future<void> syncRequest({List<String> audioBlacklist, List<String> videoBlacklist}) {
    if (audioBlacklist==null) {
      audioBlacklist = [];
    }
    if (videoBlacklist==null) {
      videoBlacklist = [];
    }
    int requestTimeStamp = DateTime.now().millisecondsSinceEpoch;
    String downloadRequestID = '$uid : $requestTimeStamp';
    userDataCollection.document(uid).updateData({
      'downloadRequest': <dynamic>[downloadRequestID, audioBlacklist, videoBlacklist].toList(),
    });
  }
}