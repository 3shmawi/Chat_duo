import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class MediaViewerPage extends StatefulWidget {
  final List<String> mediaUrls; // URLs of images and videos
  final int initialIndex;

  const MediaViewerPage({
    super.key,
    required this.mediaUrls,
    required this.initialIndex,
  });

  @override
  MediaViewerPageState createState() => MediaViewerPageState();
}

class MediaViewerPageState extends State<MediaViewerPage> {
  late PageController _pageController;
  List<VideoPlayerController?> _videoControllers = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
    _initializeControllers();
  }

  // Initialize video controllers for video URLs only
  void _initializeControllers() {
    _videoControllers = widget.mediaUrls.map((url) {
      // Check if the URL is a video
      if (_isVideo(url)) {
        // Create the VideoPlayerController for each video URL
        final controller = VideoPlayerController.networkUrl(Uri.parse(url));

        // Initialize the video controller and update the UI when done
        controller.initialize().then((_) {
          // Ensure the first frame is shown after initialization
          setState(() {});
        });

        return controller;
      } else {
        // For image URLs, return null
        return null;
      }
    }).toList();
  }

  bool _isVideo(String url) {
    return url.contains('.mp4') || url.contains('.mov') || url.contains('.avi');
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller?.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Media Viewer"),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.mediaUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final url = widget.mediaUrls[index];
              if (_isVideo(url)) {
                // If it's a video, return the video player
                final controller = _videoControllers[index];
                return controller != null && controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: VideoPlayer(controller),
                      )
                    : const Center(child: CircularProgressIndicator());
              } else {
                // If it's an image, return the image viewer
                return PhotoView(
                  imageProvider: NetworkImage(url),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              }
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.mediaUrls.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentIndex ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _isVideo(widget.mediaUrls[_currentIndex])
          ? FloatingActionButton(
              onPressed: () {
                final controller = _videoControllers[_currentIndex];
                if (controller != null) {
                  setState(() {
                    controller.value.isPlaying
                        ? controller.pause()
                        : controller.play();
                  });
                }
              },
              child: Icon(
                _videoControllers[_currentIndex]?.value.isPlaying ?? false
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
