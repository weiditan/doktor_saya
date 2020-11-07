import 'dart:io';

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
      );
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
        body: _showAttachment());
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
          return FlickVideoPlayer(
            flickManager: flickManager,
            flickVideoWithControls: FlickVideoWithControls(
              videoFit: BoxFit.fitWidth,
              controls: FlickPortraitControls(),
            ),
            flickVideoWithControlsFullscreen: FlickVideoWithControls(
              videoFit: BoxFit.fitWidth,
              controls: FlickLandscapeControls(),
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
}
