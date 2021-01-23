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
  String _url = "";
  AudioPlayer _player = AudioPlayer();
  StreamSubscription _durationSubscription,
      _positionSubscription,
      _completionSubscription;

  Duration _duration = Duration();
  Duration _position = Duration();
  Timer _t;

  _prepare() async {
    _t = Timer.periodic(Duration(milliseconds: 100), (Timer timer) async {
      if (_url != widget.url) {
        _url = widget.url;
        _position = Duration();
        _duration = Duration();
        await _player.stop();
        await _player.setUrl(widget.url);
      }
    });

    _durationSubscription = _player.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });

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
    _t.cancel();
    _player.dispose();
    _durationSubscription?.cancel();
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
        Flexible(
          child: Slider(
            value: _position.inMilliseconds.toDouble(),
            min: 0.0,
            max: _duration.inMilliseconds.toDouble(),
            onChanged: (v) async {
              await _player.seek(Duration(milliseconds: v.toInt()));
            },
          ),
        ),
        Text(
          "${_position.inMinutes}:${_position.inSeconds.remainder(60).toString().padLeft(2, '0')}/${_duration.inMinutes}:${_duration.inSeconds.remainder(60).toString().padLeft(2, '0')}",
          style: TextStyle(color: Colors.black),
        ),
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
