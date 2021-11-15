import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mediasync/models/user_data.dart';
import 'package:mediasync/screens/home/settings.dart';
import 'package:mediasync/services/auth.dart';
import 'package:mediasync/services/url_validation.dart';
import 'package:mediasync/shared/misc_widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:permission/permission.dart';
import 'package:cloud_functions/cloud_functions.dart';

class Home extends StatefulWidget {
  final UserData userData;

  Home({this.userData});

  @override
  _HomeState createState() => _HomeState();
}

ValueNotifier<bool> progressing = ValueNotifier<bool>(false);
ValueNotifier<double> progressValue = ValueNotifier<double>(0);
ValueNotifier<Widget> progressMessage = ValueNotifier<Widget>(Container());

ValueNotifier<String> audioDestination = ValueNotifier<String>('');
ValueNotifier<String> videoDestination = ValueNotifier<String>('');

ValueNotifier<bool> searchingForUnsynced = ValueNotifier<bool>(false);
ValueNotifier<int> numOfUnsynced = ValueNotifier<int>(0);

Directory defaultAudioDirectory;
Directory defaultVideoDirectory;

class _HomeState extends State<Home> with TickerProviderStateMixin{

  final AuthService _auth = AuthService();

  void initState() {
    getPermissions();
    super.initState();
    setState(() {
      _setDefaultDestinations() async {
        defaultAudioDirectory = Directory('${(await getExternalStorageDirectory()).path}/MediaSync/Audios');
        defaultVideoDirectory = Directory('${(await getExternalStorageDirectory()).path}/MediaSync/Videos');
      }

      _init() async {
        progressing.value = false;
        progressValue.value = 0;
        searchingForUnsynced.value = false;
        numOfUnsynced.value = 0;
        await _setDefaultDestinations();
        await ensureDownloadDestinations();
        getUnsyncedFiles(userData: widget.userData);
      }
      _init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(
              Icons.person,
              color: Colors.blueGrey,
            ),
            label: Text(
              'logout',
              style: TextStyle(
                color: Colors.blueGrey,
              ),
            ),
            onPressed: () async{
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: SlidingUpPanel(
        maxHeight: 0.85*MediaQuery.of(context).size.height,
        minHeight: 70,
        parallaxEnabled: false,
        parallaxOffset: .5,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        body: Stack(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(500),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, .23),
                                  offset: Offset(0, 0),
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(8),
                            child: ValueListenableBuilder(
                                valueListenable: searchingForUnsynced,
                                builder: (BuildContext context, bool value, Widget child) {
                                  return ValueListenableBuilder(
                                      valueListenable: numOfUnsynced,
                                      builder: (BuildContext context, int value, Widget child) {
                                        return  Row(
                                          children: <Widget>[
                                            AnimatedContainer(
                                              height: 35,
                                              width: 35,
                                              duration: Duration(milliseconds: 300),
                                              decoration: BoxDecoration(
                                                  color: searchingForUnsynced.value ? Colors.blueAccent: numOfUnsynced.value==0 ? Colors.greenAccent : Colors.redAccent,
                                                  borderRadius: BorderRadius.circular(500.0)
                                              ),
                                              child: AnimatedSwitcher(  //refresh icon if finding unsynced files, text if number of unsynced files is not 0, check mark if it is
                                                duration: Duration(milliseconds: 300),
                                                child: searchingForUnsynced.value ? Icon(
                                                  Icons.refresh,
                                                  size: 25,
                                                  color: Colors.white,
                                                ) : numOfUnsynced.value!=0 ? Center(child: Text(
                                                  numOfUnsynced.value.toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                  ),
                                                )) : Icon(
                                                  Icons.check,
                                                  size: 25,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),

                                            AnimatedSize(
                                              duration: Duration(milliseconds: 400),
                                              vsync: this,
                                              child: searchingForUnsynced.value ? Container() : Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  numOfUnsynced.value==0 ? 'All Done!' : numOfUnsynced.value.toString() + ' unsynced files',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      }
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      ValueListenableBuilder(
                        valueListenable: progressing,
                        builder: (BuildContext context, bool value, Widget child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    if (!progressing.value) {
                                      SyncData(widget.userData);
                                    }
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  'Sync',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                color: Colors.blueAccent,
                              ),
                              SizedBox(width: 50),
                              RaisedButton(
                                onPressed: () {
                                  if (!progressing.value) {
                                    createDownloadAlertDialog(context).then((link) {
                                      String format =  link.substring(0,2).trim();
                                      link = link.substring(2).trim();
                                      if (validateUrl(url:link)) {
                                        if (format=='a') {
                                          DownloadMedia(url: link, format: 'audio');
                                        }
                                        else if(format=='v') {
                                          DownloadMedia(url: link, format: 'video');
                                        }
                                      }
                                    });
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  'Download',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                color: Colors.blueAccent,
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 25),
                      ValueListenableBuilder(
                        valueListenable: progressValue,
                        builder: (BuildContext context, double value, Widget child) {
                          return ValueListenableBuilder(
                            valueListenable: progressMessage,
                            builder: (BuildContext context, Widget value, Widget child) {
                              return AnimatedSize(
                                duration: Duration(milliseconds: 400),
                                vsync: this,
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  height: progressing.value ? null : 0.0,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 1,
                                      color: Color.fromRGBO(223, 223, 223, 1),
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Progress',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromRGBO(100, 100, 100, 1),
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      progressMessage.value,
                                      SizedBox(height: 30),
                                      LinearProgressIndicator(
                                        value: progressValue.value,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0,horizontal: 20.0),
                  child: Text(
                    'Media Sync',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ]
        ),
        header: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
              ),
              child: Column(
                children: <Widget>[
                  Center(child: Container(
                    height: 5,
                    width: 20,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(223, 223, 223, 1),
                      borderRadius: BorderRadius.circular(500),
                    ),
                  )),
                  SizedBox(height: 3),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        panelBuilder: (ScrollController scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Settings(userData: widget.userData),
        ),
      ),
    );
  }
}


//--------------------------------------------------------------------------------------------------------------

Future<void> SyncData(UserData usrData) async {

  if (!(usrData.syncAudio || usrData.syncVideo)) {
    return null;
  }

  progressing.value = !progressing.value;
  progressValue.value = 0;
  progressMessage.value = progressMessageSearching();
  List<String> unsyncedFiles = await getUnsyncedFiles(userData: usrData);

  Timer(Duration(seconds: 3), () {
    progressValue.value = .3;
    DownloadMedia(url: 'http://void', format: 'audio');
  });
  Timer(Duration(seconds: 5), () {
    progressing.value = false;
    progressValue.value = 0;
  });
}


void DownloadMedia({String url, String format}) async {

  bool storagePermissionGranted = await getPermissions();
  if (!storagePermissionGranted) {
    return null;
  }

  print(format + ' - ' + url);
  progressing.value = true;
  progressValue.value = .5;
  String fileExtension;

  String fileName = 'sample';

  if (format=='video') {
    fileExtension = '.mp4';
  }else {
    fileExtension = '.mp3';
  }
  progressMessage.value = progressMessageDownloading(fileName+fileExtension);

  Timer(Duration(seconds: 5), () {
    progressing.value = false;
    progressValue.value = 0;
  });

}


Future<List<String>> getUnsyncedFiles({UserData userData}) async{
  searchingForUnsynced.value = true;

  Timer(Duration(seconds: 3), () {
    searchingForUnsynced.value = false;
  });

  List<String> audioFiles = await ListFilesInDir(directory:Directory(audioDestination.value), format: 'audio');
  List<String> videoFiles = await ListFilesInDir(directory:Directory(videoDestination.value), format: 'video');



  if (userData.syncAudio) {
    for (String file in audioFiles) {
      print(file);
    }
  }
  if (userData.syncVideo) {
    for (String file in videoFiles) {
      print(file);
    }
  }

  try {
    final HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: 'getDownloadLinks');
    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'getAudio': userData.syncAudio,
        'getVideo': userData.syncVideo,
        'audioBlacklist': audioFiles,
        'videoBlacklist': videoFiles,
        'playlists': userData.playlists,
        'downloadPlaylists': true,
      },
    );
    print(result.data);
  } on CloudFunctionsException catch (e) {
    print('caught firebase functions exception');
    print(e.code);
    print(e.message);
    print(e.details);
  } catch (e) {
    print('caught generic exception');
    print(e);
  }

  List<String> unsyncedFiles = <String>['shshshsh','ase bg','dkd','susiw','ao','eidndk'];
  numOfUnsynced.value = unsyncedFiles.length;

  return unsyncedFiles;
}

Future<void> ensureDownloadDestinations() async { //If download destinations are not set or no longer exist, set it to the default destination
  String audioPath = await getSaveDestination(mediaType: 'audio');
  String videoPath = await getSaveDestination(mediaType: 'video');

  Directory directory;
  Directory _rootDir = await getExternalStorageDirectory();
  if (audioPath==null || !(await Directory(audioPath).exists())) {
    final Directory _audioSaveFolder =  defaultAudioDirectory;

    if(await _audioSaveFolder.exists()){ //if folder already exists return directory
      directory =  _audioSaveFolder;
    }else{//if folder not exists create folder and then return directory
      final Directory _audioDirNewFolder=await _audioSaveFolder.create(recursive: true);
      directory = _audioDirNewFolder;
    }
    setSaveDestination(mediaType: 'audio',destination: directory.path);
  }
  if (videoPath==null || !(await Directory(videoPath).exists())) {
    final Directory _videoSaveFolder =  defaultVideoDirectory;

    if(await _videoSaveFolder.exists()){ //if folder already exists return directory
      directory =  _videoSaveFolder;
    }else{//if folder not exists create folder and then return directory
      final Directory _videoDirNewFolder=await _videoSaveFolder.create(recursive: true);
      directory = _videoDirNewFolder;
    }
    setSaveDestination(mediaType: 'video',destination: directory.path);
  }
}

void setSaveDestination({String mediaType, String destination}) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (mediaType=='audio') {
    prefs.setString('audioDest',destination);
    audioDestination.value = destination;
  }else if (mediaType=='video') {
    prefs.setString('videoDest',destination);
    videoDestination.value = destination;
  }
}
Future<String> getSaveDestination({String mediaType}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String destination;
  if (mediaType=='audio') {
    destination = prefs.getString('audioDest');
    audioDestination.value = destination;
  }else if (mediaType=='video') {
    destination = prefs.getString('videoDest');
    videoDestination.value = destination;
  }
  return destination;
}

Future<List<String>> ListFilesInDir({Directory directory, String format}) async {
  bool storagePermissionGranted = await getPermissions();
  if (!storagePermissionGranted) {
    return null;
  }

  List<String> fileNameList = [];
  List<FileSystemEntity> filesInDir = directory.listSync(recursive: true, followLinks: false);

  for (FileSystemEntity file in filesInDir) {
    String fileName = file.path.split('/').last;
    bool fileIsAudio = fileName.endsWith('.mp3');
    bool fileIsVideo = fileName.endsWith('.mp4');

    if (fileIsAudio && format=='audio') {
      fileNameList.add(fileName);
    }
    if (fileIsVideo && format=='video') {
      fileNameList.add(fileName);
    }
  }


  return fileNameList;
}

Future<bool> getPermissions() async {
  final permissions = await Permission.getPermissionsStatus([PermissionName.Storage]);
  bool granted = false;
  switch (permissions[0].permissionStatus) {
    case PermissionStatus.allow:
      granted = true;
      break;
    case PermissionStatus.always:
      granted = true;
      break;
    default:
  }
  if (!granted) {
    await Permission.requestPermissions([PermissionName.Storage]);
    await Permission.getPermissionsStatus([PermissionName.Storage]).then((List<Permissions> p) {
      if(p[0].permissionStatus == PermissionStatus.allow || p[0].permissionStatus == PermissionStatus.always) {
        granted = true;
      }
    });
  }

  return granted;
}