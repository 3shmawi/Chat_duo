import 'package:flutter/material.dart';

class ImageViewerPage extends StatelessWidget {
  final List<String> imagePaths;
  final int initialIndex;

  const ImageViewerPage(
      {super.key, required this.imagePaths, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Viewer"),
      ),
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Center(
            child: Image.network(
              imagePaths[index],
              fit: BoxFit.fitHeight,
            ),
          );
        },
      ),
    );
  }
}
