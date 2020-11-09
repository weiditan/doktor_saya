import 'dart:io';

import 'package:doktorsaya/functions/progressDialog.dart' as pr;
import 'package:doktorsaya/pages/message/ext/attachmentPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

showAttachmentBottomSheet(BuildContext context, String sender, String receiver) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gambar'),
                onTap: () => _showFilePicker(context, FileType.image, "Gambar",sender,receiver),
              ),
              ListTile(
                  leading: Icon(Icons.videocam),
                  title: Text('Video'),
                  onTap: () =>
                      _showFilePicker(context, FileType.video, "Video",sender,receiver)),
              ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text('Dokumen'),
                onTap: () => _showFilePicker(context, FileType.any, "Dokumen",sender,receiver),
              ),
            ],
          ),
        );
      });
}

_showFilePicker(BuildContext context, FileType fileType, String type, String sender, String receiver) async {
  await pr.show(context, "Memuatkan");

  FilePickerResult result = await FilePicker.platform.pickFiles(type: fileType);

  await pr.hide();

  if (result != null) {
    File file = File(result.files.single.path);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AttachmentPage(sender, receiver, type, file)));
  }
}
