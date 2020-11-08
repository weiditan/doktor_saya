import 'dart:io';

import 'package:doktorsaya/pages/message/ext/uploadAttachment.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class AttachmentPage extends StatefulWidget {
  @override
  _AttachmentPageState createState() => _AttachmentPageState();

  final String type;
  final File file;
  AttachmentPage(this.type, this.file);
}

class _AttachmentPageState extends State<AttachmentPage> {
  FlickManager flickManager;

  @override
  void initState() {
    super.initState();

    if (widget.type == "Video") {
      flickManager = FlickManager(
          videoPlayerController: VideoPlayerController.file(widget.file),
          autoPlay: false);
    }
  }

  @override
  void dispose() {
    if (widget.type == "Video") {
      flickManager.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          widget.type,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Flexible(
            child: _showAttachment(),
          ),
          _submitButton(),
        ],
      ),
    );
  }

  Widget _showAttachment() {
    switch (widget.type) {
      case "Gambar":
        {
          return PhotoView(
            imageProvider: AssetImage(widget.file.path),
          );
        }
        break;

      case "Video":
        {
          return Container(
            child: FlickVideoPlayer(
              flickManager: flickManager,
              flickVideoWithControls: FlickVideoWithControls(
                videoFit: BoxFit.contain,
                controls: FlickPortraitControls(),
              ),
              flickVideoWithControlsFullscreen: FlickVideoWithControls(
                videoFit: BoxFit.contain,
                controls: FlickLandscapeControls(),
              ),
            ),
          );
        }
        break;

      case "Dokumen":
        {
          return Text(widget.type);
        }
        break;

      default:
        {
          return Container();
        }
    }
  }

  Widget _submitButton() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          color: Colors.orange,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Hantar",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          onPressed: () {
            if (widget.type == "Video") {
              flickManager.flickControlManager.pause();
            }
            uploadAttachment(context, widget.file.path);
          },
        ),
      ),
    );
  }
}
