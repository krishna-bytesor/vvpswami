import 'package:just_audio/just_audio.dart' as ja;

import 'audio_manager.dart';
import 'audioplayerfull_screen.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MiniPlayer extends StatelessWidget {
  final AudioManager audio = AudioManager();

  MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ja.PlayerState>(
      stream: audio.player.playerStateStream,
      builder: (context, snapshot) {
        final isPlaying = snapshot.data?.playing ?? false;
        final video =
        audio.videos.isNotEmpty ? audio.videos[audio.currentIndex] : null;

        if (video == null) return const SizedBox.shrink();

        return Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AudioPlayerFullScreen(),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFAE6D0), Color(0xFFFCD8DF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (video['thumbnail'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        video['thumbnail']!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      video['title'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed: audio.previous,
                    color: Colors.pinkAccent,
                    tooltip: 'Previous',
                  ),
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle,
                      size: 28,
                    ),
                    onPressed: audio.toggle,
                    color: Colors.pinkAccent,
                    tooltip: isPlaying ? 'Pause' : 'Play',
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: audio.next,
                    color: Colors.pinkAccent,
                    tooltip: 'Next',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
