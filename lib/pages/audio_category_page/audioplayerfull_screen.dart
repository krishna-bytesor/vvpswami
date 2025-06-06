import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'audio_manager.dart';

class AudioPlayerFullScreen extends StatelessWidget {
  final AudioManager audio = AudioManager();

  AudioPlayerFullScreen({super.key});

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
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // ✅ Go back to the previous screen
            },
          ),
          title: Text(
            'Now Playing',
            style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),

        body: ValueListenableBuilder<Map<String, String>?>(
          valueListenable: audio.currentVideoNotifier,
          builder: (context, video, _) {
            final thumbnail = video?['thumbnail'];
            final title = video?['title'] ?? 'Now Playing';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                if (thumbnail != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      thumbnail,
                      height: 250,
                      width: MediaQuery.of(context).size.width - 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("London",
                        style: TextStyle(color: Colors.blue, fontSize: 13)),
                    Text(" | ", style: TextStyle(fontSize: 13)),
                    Text("2022",
                        style: TextStyle(color: Colors.blue, fontSize: 13)),
                    Text(" | ", style: TextStyle(fontSize: 13)),
                    Text("Prabhupada",
                        style: TextStyle(color: Colors.blue, fontSize: 13)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite_border, color: Colors.pink)),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.playlist_play, color: Colors.pink)),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.queue_music, color: Colors.pink)),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.download, color: Colors.pink)),
                  ],
                ),
                Divider(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text("Transcript",
                          style: TextStyle(color: Colors.pinkAccent)),
                      Text("Up Next", style: TextStyle(color: Colors.pinkAccent)),
                      Text("Shloka", style: TextStyle(color: Colors.pinkAccent)),
                    ],
                  ),
                ),
                Divider(),
                StreamBuilder<Duration>(
                  stream: audio.player.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final total = audio.player.duration ?? Duration.zero;
                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(thumbnail ?? ''),
                          ),
                          title: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          subtitle: Text("Prabhupada",
                              style: TextStyle(fontSize: 12)),
                        ),
                        Slider(
                          value: position.inSeconds.toDouble().clamp(0, total.inSeconds.toDouble()),
                          max: total.inSeconds.toDouble(),
                          onChanged: (value) {
                            audio.player.seek(Duration(seconds: value.toInt()));
                          },
                          activeColor: Colors.pinkAccent,
                          inactiveColor: Colors.grey[300],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDuration(position),
                                  style: TextStyle(fontSize: 12)),
                              Text(_formatDuration(total),
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Playback Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.replay_10),
                      onPressed: () {
                        final current = audio.player.position;
                        audio.player.seek(current - Duration(seconds: 10));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_previous),
                      onPressed: audio.previous,
                    ),
                    InkWell(
                      onTap:audio.toggle,
                      child: StreamBuilder<PlayerState>(
                        stream: audio.player.playerStateStream,
                        builder: (context, snapshot) {
                          final isPlaying = snapshot.data?.playing ?? false;
                          return Icon(
                            isPlaying ? Icons.pause_circle : Icons.play_circle,
                            size: 64,
                          );
                        },
                      ),
                    ),

                    IconButton(
                      icon: Icon(Icons.skip_next),
                      onPressed: audio.next,
                    ),
                    IconButton(
                      icon: Icon(Icons.forward_10),
                      onPressed: () {
                        final current = audio.player.position;
                        audio.player.seek(current + Duration(seconds: 10));
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

}
