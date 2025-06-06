import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerFullScreen extends StatefulWidget {
  final String videoId;
  final String title;

  const VideoPlayerFullScreen({
    Key? key,
    required this.videoId,
    required this.title,
  }) : super(key: key);

  @override
  State<VideoPlayerFullScreen> createState() => _VideoPlayerFullScreenState();
}

class _VideoPlayerFullScreenState extends State<VideoPlayerFullScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFEFDBB6),
            Color(0xFFFAEDD6),
            Color(0xFFFEF7E7),
            Color(0xFFEFDBB6),
            Color(0xFFFAEDD6)
          ],
          stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          begin: AlignmentDirectional(0.31, -1.0),
          end: AlignmentDirectional(-0.31, 1.0),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Now Playing',
            style: TextStyle(
              color: Colors.pinkAccent,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: YoutubePlayer(controller: _controller),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("London", style: TextStyle(color: Colors.blue)),
                Text(" | "),
                Text("2022", style: TextStyle(color: Colors.blue)),
                Text(" | "),
                Text("Prabhupada", style: TextStyle(color: Colors.blue)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.pink),
                    onPressed: () {}),
                IconButton(
                    icon: const Icon(Icons.playlist_add, color: Colors.pink),
                    onPressed: () {}),
                IconButton(
                    icon: const Icon(Icons.share, color: Colors.pink),
                    onPressed: () {}),
                IconButton(
                    icon: const Icon(Icons.download, color: Colors.pink),
                    onPressed: () {}),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
