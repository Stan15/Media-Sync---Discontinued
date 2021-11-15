import 'dart:io';

import 'package:directory_picker/directory_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


const textInputDecoration = InputDecoration(
  hintText: 'Email',
  fillColor: Color.fromRGBO(235,250,255, 1),
  filled: true,
);

Future<String> createDownloadAlertDialog(BuildContext context) {
  TextEditingController customController = TextEditingController();

  return showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Text('Enter video or playlist link'),
      content: TextField(
        controller: customController,
      ),
      actions: <Widget>[
        MaterialButton(
          elevation: 5.0,
          child: Text('Download Audio'),
          onPressed: () {
            Navigator.of(context).pop('a '+customController.text.toString());
          },
        ),
        MaterialButton(
          elevation: 5.0,
          child: Text('Download Video'),
          onPressed: () {
            Navigator.of(context).pop('v '+customController.text.toString());
          },
        ),
      ],
    );
  });
}

Future<String> createAddPlaylistAlertDialog(BuildContext context) {
  TextEditingController customController = TextEditingController();

  return showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Text('Enter playlist link'),
      content: TextField(
        controller: customController,
      ),
      actions: <Widget>[
        MaterialButton(
          elevation: 5.0,
          child: Text('Submit'),
          onPressed: () {
            Navigator.of(context).pop(customController.text.toString());
          },
        ),
      ],
    );
  });
}


Future<Directory> pickDirectory({BuildContext context, Directory currentDir}) async {
  Directory directory = currentDir;
  if (directory == null || directory.path.isEmpty || !(await directory.exists())) {
    directory = await getExternalStorageDirectory();
  }

  return await DirectoryPicker.pick(
      allowFolderCreation: true,
      context: context,
      rootDirectory: directory,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))));
}

Widget progressMessageDownloading(fileName) {
  return Row(
    children: <Widget>[
      Icon(
        Icons.file_download,
        color: Color.fromRGBO(0, 0, 0, 0.4),
        size: 13,
      ),
      Text(
        fileName,
        style: TextStyle(
          color: Color.fromRGBO(0, 0, 0, 0.4),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    ],
  );
}

Widget progressMessageSearching() {
  return Row(
    children: <Widget>[
      Icon(
        Icons.search,
        color: Color.fromRGBO(0, 0, 0, 0.4),
        size: 13,
      ),
      Text(
        'Searching for unsynced files',
        style: TextStyle(
          color: Color.fromRGBO(0, 0, 0, 0.4),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    ],
  );
}