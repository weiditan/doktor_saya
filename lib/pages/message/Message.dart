import 'package:doktorsaya/pages/message/ext/messageContainer.dart';
import 'package:flutter/material.dart';
import 'package:doktorsaya/pages/profile/ext/profileImage.dart';
import 'ext/attachment.dart';
import 'ext/messageDatabase.dart';
import 'ext/recordAudio.dart';
import 'package:doktorsaya/functions/progressDialog.dart' as pr;

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();

  final Map data;
  Message(this.data);
}

class _MessageState extends State<Message> {
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _title()),
      body: MessageContainer(
        sender: widget.data['sender'],
        receiver: widget.data['receiver'],
      ),
      bottomSheet: _messageBar(),
    );
  }

  Widget _title() {
    return Container(
      child: Row(
        children: <Widget>[
          showSmallIconProfileImage(
              widget.data['doctor_image'], widget.data['doctor_online']),
          SizedBox(width: 10),
          Flexible(
            child: Container(child: Text(widget.data['doctor_name'])),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _messageBar() {
    return Container(
      height: 51.5,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[300], width: 1.5),
        ),
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.mic,
              color: Colors.black,
            ),
            onPressed: () {
              showRecordAudioBottomSheet(
                  context, widget.data['sender'], widget.data['receiver']);
            },
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration.collapsed(
                  hintText: 'Tulis mesej',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                controller: _messageController,
              ),
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.attach_file,
              color: Colors.black,
            ),
            onPressed: () {
              showAttachmentBottomSheet(
                  context, widget.data['sender'], widget.data['receiver']);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.black,
            ),
            onPressed: () async {
              if (_messageController.text != "") {
                await pr.show(context, "Hantar");

                addTextMessage(widget.data['sender'], widget.data['receiver'],
                        _messageController.text)
                    .then((_) async {
                  await pr.hide();
                  _messageController.text = "";
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
