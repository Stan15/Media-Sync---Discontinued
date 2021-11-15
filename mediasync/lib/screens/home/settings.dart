import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mediasync/models/user_data.dart';
import 'package:mediasync/screens/home/home.dart';
import 'package:mediasync/services/database.dart';
import 'package:mediasync/services/url_validation.dart';
import 'package:mediasync/shared/misc_widgets.dart';

class Settings extends StatefulWidget {
  final UserData userData;

  Settings({this.userData});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  double settingsColPadding = 10;
  double settingsRowPadding = 20;
  double textFieldSize = 40;

  @override
  Widget build(BuildContext context) {
    if (audioDestination.value==null || videoDestination.value==null) {
      ensureDownloadDestinations();
    }

    List<String> playlists = widget.userData.playlists;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          SizedBox(height: 45),
          Divider(thickness: 1),
          ListTile(
            title: Text(
              'Sync Audio',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Color.fromRGBO(10,10,10,1),
              ),
            ),
            trailing: Switch(
              value: widget.userData.syncAudio,
              onChanged: (bool value) {
                setState(() {
                  DatabaseService(uid: widget.userData.uid).setSyncAudio(value);
                });
              },
              activeColor: Colors.blueAccent,
            ),
          ),
          ListTile(
            title: Text(
              'Sync Video',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Color.fromRGBO(10,10,10,1),
              ),
            ),
            trailing: Switch(
              value: widget.userData.syncVideo,
              onChanged: (bool value) {
                setState(() {
                  DatabaseService(uid: widget.userData.uid).setSyncVideo(value);
                });
              },
              activeColor: Colors.blueAccent,
            ),
          ),
          ListTile(
            title: Text(
              'Audio Destination',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Color.fromRGBO(10,10,10,1),
              ),
            ),
            trailing: ValueListenableBuilder(
              valueListenable: audioDestination,
              builder: (BuildContext context, String value, Widget child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      height: textFieldSize,
                      width: MediaQuery.of(context).size.width*.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(audioDestination.value ?? ''),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.folder),
                      color: Colors.blueGrey,
                      onPressed: () {
                        pickDirectory(context: context, currentDir: Directory(audioDestination.value)).then((directory) {
                          if (directory != null) {
                            setState(() {
                              setSaveDestination(mediaType: 'audio',destination: directory.path);
                            });
                          }
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          ListTile(
            title: Text(
              'Video Destination',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Color.fromRGBO(10,10,10,1),
              ),
            ),
            trailing: ValueListenableBuilder(
              valueListenable: videoDestination,
              builder: (BuildContext context, String value, Widget child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      height: textFieldSize,
                      width: MediaQuery.of(context).size.width*.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(videoDestination.value ?? ''),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.folder),
                      color: Colors.blueGrey,
                      onPressed: () {
                        pickDirectory(context: context, currentDir: Directory(videoDestination.value)).then((directory) {
                          if (directory != null) {
                            setState(() {
                              setSaveDestination(mediaType: 'video',destination: directory.path);
                            });
                          }
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: settingsColPadding),
          Divider(thickness: 1),
          SizedBox(height: settingsColPadding),
          Center(
            child: Text(
              'Playlists',
              style: TextStyle(
                color: Color.fromRGBO(10,10,10,1),
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(height: settingsColPadding),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: ListView.builder(
              padding: EdgeInsets.all(0.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: playlists.length+1,
              itemBuilder: (context, index) {
                if (index >= playlists.length && playlists.length==widget.userData.playlistLimit) {
                  return Container();
                }

                Color buttonColor;
                IconData icon;
                String displayText;
                bool add;

                if (index < playlists.length) {
                  buttonColor = Color(0xffFF7E7E);
                  icon = Icons.remove;
                  displayText = playlists[index];
                  add = false;
                }else {
                  buttonColor = Color(0xff416DFC);
                  icon = Icons.add;
                  displayText = '';
                  add = true;
                }

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: textFieldSize,
                            width: MediaQuery.of(context).size.width*.58,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: Colors.white,
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),

                            child: GestureDetector(
                              onTap: () {
                                if (add) {
                                  createAddPlaylistAlertDialog(context).then((link) {
                                    setState(() {
                                      if (validateUrl(url: link,restrict: 'playlist')) {
                                        DatabaseService(uid: widget.userData.uid).addPlaylist(link);
                                      }
                                    });
                                  });
                                }
                              },
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(displayText),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width*0.09,
                            child: RawMaterialButton(
                              onPressed: () {
                                if (!add) {
                                  setState(() {
                                    DatabaseService(uid: widget.userData.uid).removePlaylist(playlists[index]);
                                  });
                                }else {
                                  createAddPlaylistAlertDialog(context).then((link) {
                                    setState(() {
                                      if (validateUrl(url: link,restrict: 'playlist')) {
                                        DatabaseService(uid: widget.userData.uid).addPlaylist(link);
                                      }
                                    });
                                  });
                                }
                              },
                              child: Icon(icon),
                              fillColor: buttonColor,
                              shape: CircleBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: index==playlists.length ? 0 : 10)
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

