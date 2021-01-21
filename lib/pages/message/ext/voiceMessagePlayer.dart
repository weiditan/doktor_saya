import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class VoiceMessagePlayer extends StatefulWidget {
  @override
  _VoiceMessagePlayerState createState() => _VoiceMessagePlayerState();

  final String url;
  VoiceMessagePlayer({Key key, @required this.url}) : super(key: key);
}

class _VoiceMessagePlayerState extends State<VoiceMessagePlayer> {
  AudioPlayer _player = AudioPlayer();
  StreamSubscription _positionSubscription, _completionSubscription;

  Duration _endTime = new Duration();
  Duration _position = new Duration();

  _prepare() async {
    await _player.setUrl(widget.url);

    await Future.delayed(Duration(seconds: 1));
    _endTime = Duration(milliseconds: await _player.getDuration());
    setState(() {});

    _positionSubscription = _player.onAudioPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });

    _completionSubscription = _player.onPlayerCompletion.listen((event) {
      setState(() {});
    });
  }

  @override
  void initState() {
    _prepare();
    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    _positionSubscription?.cancel();
    _completionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _icon(),
        Slider(
          value: _position.inSeconds.toDouble(),
          min: 0.0,
          max: _endTime.inSeconds.toDouble(),
          onChanged: (v) async {
            await _player.seek(Duration(seconds: v.round()));
          },
        ),
        Text(
            "${_position.inMinutes}:${_position.inSeconds.remainder(60).toString().padLeft(2, '0')}/${_endTime.inMinutes}:${_endTime.inSeconds.remainder(60).toString().padLeft(2, '0')}"),
      ],
    );
  }

  Widget _icon() {
    if (_player.state == AudioPlayerState.PLAYING) {
      return IconButton(
        icon: Icon(
          Icons.pause,
          color: Colors.grey[600],
        ),
        onPressed: () {
          setState(() {
            _player.pause();
          });
        },
      );
    } else {
      return IconButton(
        icon: Icon(
          Icons.play_arrow,
          color: Colors.grey[600],
        ),
        onPressed: () {
          setState(() {
            _player.resume();
          });
        },
      );
    }
  }
}
