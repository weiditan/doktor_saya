import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ViewVideo extends StatefulWidget {
  @override
  _ViewVideoState createState() => _ViewVideoState();

  final String title, url;
  ViewVideo(this.title, this.url);
}

class _ViewVideoState extends State<ViewVideo> {
  FlickManager flickManager;

  @override
  void initState() {
    super.initState();

    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(widget.url),
        autoPlay: false);
  }

  @override
  void dispose() {
    flickManager.dispose();

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
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Container(
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
      ),
    );
  }
}
