import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DownloadAndOpenAttachment extends StatefulWidget {
  final String url, fileName, context;
  const DownloadAndOpenAttachment(
      {Key key,
      @required this.url,
      @required this.fileName,
      @required this.context})
      : super(key: key);

  @override
  _DownloadAndOpenAttachmentState createState() =>
      _DownloadAndOpenAttachmentState();
}

class _DownloadAndOpenAttachmentState extends State<DownloadAndOpenAttachment> {
  String _filePath,_url;
  bool _fileExist;
  bool _downloading = false;
  Timer _t;

  Future<void> _getData() async {
    _t = Timer.periodic(Duration(milliseconds: 100), (Timer timer) async {
      if (_url != widget.url) {
        _url = widget.url;
        _filePath = await _getFilePath();
        _fileExist = await _checkFileExist(_filePath);
      }
    });


  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    _t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (_fileExist) {
          await OpenFile.open(_filePath);
        } else {
          setState(() {
            _downloading = true;
          });
          _download();
        }
      },
      child: Container(
        color: Colors.grey[300],
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              (_downloading)
                  ? CircularProgressIndicator()
                  : (_fileExist != null && _fileExist)
                      ? Icon(
                          Icons.insert_drive_file,
                          color: Colors.orange,
                        )
                      : Icon(
                          Icons.file_download,
                          color: Colors.orange,
                        ),
              SizedBox(
                width: 5,
              ),
              Flexible(
                child: Text(
                  widget.context,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _getFilePath() async {
    Directory appDocDirectory;
    if (Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }

    return appDocDirectory.path + "/" + widget.fileName;
  }

  Future<bool> _checkFileExist(filePath) async {

    if (await File(filePath).exists()) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _download() async {
    final Dio _dio = Dio();

    await _dio.download(widget.url, _filePath,
        onReceiveProgress: _onReceiveProgress);

    _fileExist = await _checkFileExist(_filePath);
    setState(() {
      _downloading = false;
    });
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
}
