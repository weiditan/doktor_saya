import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "image",style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Image.file(File("data/user/0/com.example.doktorsaya/cache/file_picker/call.png"))
      
      /*PhotoView(
        imageProvider: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
      ),*/
    );
  }
}
