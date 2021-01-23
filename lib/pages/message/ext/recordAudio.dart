import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

import 'uploadAttachment.dart';

FlutterAudioRecorder _recorder;
Recording _recording;

Map<String, String> _data = {
  "label": "Tekan dan tahan untuk merakam audio.",
  "time": '0:00:00'
};

Future _init(sender) async {
  String customPath = '/' + sender + '_';
  Directory appDocDirectory;
  if (Platform.isIOS) {
    appDocDirectory = await getApplicationDocumentsDirectory();
  } else {
    appDocDirectory = await getExternalStorageDirectory();
  }

  // can add extension like ".mp4" ".wav" ".m4a" ".aac"
  customPath = appDocDirectory.path +
      customPath +
      DateTime.now().millisecondsSinceEpoch.toString();

  // .wav <---> AudioFormat.WAV
  // .mp4 .m4a .aac <---> AudioFormat.AAC
  // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.

  _recorder = FlutterAudioRecorder(customPath,
      audioFormat: AudioFormat.WAV, sampleRate: 32000);
  await _recorder.initialized;
}

Future _prepare(context, sender) async {
  var hasPermission = await FlutterAudioRecorder.hasPermissions;
  if (hasPermission) {
    await _init(sender);
    _recording = await _recorder.current();
  } else {
    Navigator.pop(context);
  }
}

Future _startRecording() async {
  await _recorder.start();
  _recording = await _recorder.current();

  Timer.periodic(Duration(milliseconds: 10), (Timer t) async {
    if (_recording.status == RecordingStatus.Stopped) {
      t.cancel();
    } else {
      _recording = await _recorder.current();
      _data["time"] = '${_recording?.duration ?? "0:00:00"}'.split('.')[0];
    }
  });
}

Future _stopRecording() async {
  _recording = await _recorder.stop();
}

Stream<Map<String, String>> _getData() async* {
  while (true) {
    yield _data;
    await Future.delayed(Duration(milliseconds: 100));
  }
}

showRecordAudioBottomSheet(
    BuildContext context, String sender, String receiver) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        _prepare(context, sender).then((_) {
          print('${_recording.path}');
        });

        return Container(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              StreamBuilder<Map<String, String>>(
                stream: _getData(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, String>> snapshot) {
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text('没有Stream');
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                      return Column(
                        children: [
                          Text('${snapshot.data["label"]}'),
                          Text('${snapshot.data["time"]}'),
                        ],
                      );

                    case ConnectionState.done:
                      return Text('Stream已关闭');
                  }
                  return null; // unreachable
                },
              ),
              GestureDetector(
                onLongPress: () async {
                  _data["label"] = "Lepas untuk hantar.";
                  _startRecording();
                  print('start recording');
                },
                onLongPressUp: () {
                  _data["label"] = "Tekan dan tahan untuk merakam audio.";
                  _stopRecording().then((value) => uploadAttachment(
                      context, _recording.path, "Audio", sender, receiver));
                  print('stop recording');
                },
                child: Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.red,
                    shape: CircleBorder(),
                  ),
                  width: 60,
                  height: 60,
                  child: IconButton(
                    icon: Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
