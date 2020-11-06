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
      body: PhotoView(
        imageProvider: NetworkImage(
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
      ),
    );
  }
}
