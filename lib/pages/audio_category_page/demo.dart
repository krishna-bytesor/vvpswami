
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'audio_manager.dart';
import 'audioplayerfull_screen.dart';


class PlaylistItemScreen extends StatefulWidget {
  final String playlistId;
  final String title;

  const PlaylistItemScreen({required this.playlistId, required this.title});

  @override
  _PlaylistItemScreenState createState() => _PlaylistItemScreenState();
}

class _PlaylistItemScreenState extends State<PlaylistItemScreen> {
  final String apiKey = 'AIzaSyBtRo-dtrCB7i_-NzuM2NDmWwzt-i3gElQ';
  List<Map<String, String>> videos = [];

  @override
  void initState() {
    super.initState();
    fetchPlaylistItems();
  }

  Future<void> fetchPlaylistItems() async {
    final url =
        'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=25&playlistId=${widget.playlistId}&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List items = data['items'];
      List<String> videoIds = items
          .map<String>((item) => item['snippet']['resourceId']['videoId'].toString())
          .toList();
      Map<String, String> durations = await fetchDurations(videoIds);
      setState(() {
        videos = items.map<Map<String, String>>((item) {
          final videoId = item['snippet']['resourceId']['videoId'].toString();
          return {
            'title': item['snippet']['title'].toString(),
            'videoId': videoId,
            'thumbnail': item['snippet']['thumbnails']['medium']['url'].toString(),
            'duration': durations[videoId] ?? '0:00',
          };
        }).toList();
      });
    }
  }

  Future<Map<String, String>> fetchDurations(List<String> videoIds) async {
    final Map<String, String> durations = {};
    final ids = videoIds.join(',');
    final url =
        'https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id=$ids&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (var item in data['items']) {
        final videoId = item['id'];
        final duration = item['contentDetails']['duration'];
        durations[videoId] = formatDuration(parseISO8601Duration(duration));
      }
    }
    return durations;
  }

  Duration parseISO8601Duration(String input) {
    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
    final match = regex.firstMatch(input);
    if (match == null) return Duration.zero;
    final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
    final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
    final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Icon(Icons.arrow_back, color: Colors.black),
          title: Text(
            widget.title,
            style: TextStyle(
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          centerTitle: true,
          actions: [
            Icon(Icons.filter_list, color: Colors.black),
            SizedBox(width: 16),
          ],
        ),
        body: videos.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      video['thumbnail']!,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video['title']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text("CC.AL. 13", style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                            SizedBox(width: 8),
                            Text("vvvpswami", style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                            SizedBox(width: 8),
                            Text("2021", style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                final audio = AudioManager();
                                await audio.playVideos(videos, index);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AudioPlayerFullScreen(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.play_arrow, size: 16),
                              label: Text("Play"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                textStyle: TextStyle(fontSize: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.favorite_border, size: 20, color: Colors.grey[700]),
                            SizedBox(width: 12),
                            Icon(Icons.playlist_play, size: 20, color: Colors.grey[700]),
                            SizedBox(width: 12),
                            Icon(Icons.queue_music, size: 20, color: Colors.grey[700]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

}