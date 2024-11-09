import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaWidget extends StatefulWidget {
  final String mediaUrl;

  const MediaWidget({super.key, required this.mediaUrl});

  @override
  State<MediaWidget> createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (_isVideo(widget.mediaUrl)) {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.mediaUrl))
            ..initialize().then((_) {
              setState(() {}); // Refresh to show first frame of video
            });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  bool _isVideo(String url) {
    return url.contains(".mp4") || url.contains(".mov") || url.contains(".avi");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 150,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: _isVideo(widget.mediaUrl)
            ? Stack(
                children: [
                  if (_videoController != null &&
                      _videoController!.value.isInitialized)
                    AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    )
                  else
                    const Center(child: CircularProgressIndicator()),

                  // Play button overlay
                  const Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ],
              )
            : CachedNetworkImage(
                imageUrl: widget.mediaUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
      ),
    );
  }
}
