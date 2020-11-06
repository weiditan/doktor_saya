import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

showAttachmentBottomSheet(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Image'),
                onTap: () => _showFilePicker(),
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Video'),
                //onTap: () => showFilePicker(FileType.VIDEO)
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text('File'),
                //onTap: () => showFilePicker(FileType.ANY),
              ),
            ],
          ),
        );
      });
}

_showFilePicker() async {
  FilePickerResult result = await FilePicker.platform.pickFiles(
    type: FileType.image
  );

  if(result != null) {
    File file = File(result.files.single.path);
    print(file);
  } else {
    // User canceled the picker
  }
}