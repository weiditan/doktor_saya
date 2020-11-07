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
                onTap: () => _showFilePicker(FileType.image),
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Video'),
                onTap: () => _showFilePicker(FileType.video)
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text('File'),
                onTap: () => _showFilePicker(FileType.any),
              ),
            ],
          ),
        );
      });
}

_showFilePicker(FileType fileType) async {
  FilePickerResult result = await FilePicker.platform.pickFiles(
    type: fileType
  );

  if(result != null) {
    File file = File(result.files.single.path);
    print(file);
    print(file.path);
  } else {
    // User canceled the picker
  }
}