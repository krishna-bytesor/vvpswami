
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:vvpswami/pages/videos_category_page/video_manager.dart';
import 'package:vvpswami/pages/videos_category_page/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart';



class VideoPlaylistItemScreen extends StatefulWidget {
  final String playlistId;
  final String title;

  const VideoPlaylistItemScreen({required this.playlistId, required this.title});

  @override
  _VideoPlaylistItemScreenState createState() => _VideoPlaylistItemScreenState();
}

class _VideoPlaylistItemScreenState extends State<VideoPlaylistItemScreen> {
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

      Map<String, Map<String, String>> details = await fetchVideoDetails(videoIds);

      setState(() {
        videos = videoIds.map<Map<String, String>>((id) {
          return {
            ...?details[id],
          };
        }).toList();
      });
    }
  }
  String extractRecordingDate(String description) {
    final match = RegExp(r'Recording Date:\s*(\d{4}-\d{2}-\d{2})').firstMatch(description);
    return match != null ? match.group(1)! : 'Unknown';
  }

  String extractLocation(String description) {
    final match = RegExp(r'Location:\s*(.+)').firstMatch(description);
    return match != null ? match.group(1)!.split('\n').first.trim() : 'Unknown';
  }

  Future<Map<String, Map<String, String>>> fetchVideoDetails(List<String> videoIds) async {
    final Map<String, Map<String, String>> details = {};
    final ids = videoIds.join(',');
    final url =
        'https://www.googleapis.com/youtube/v3/videos?part=snippet,contentDetails,statistics&id=$ids&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (var item in data['items']) {
        final videoId = item['id'];
        final snippet = item['snippet'];
        final statistics = item['statistics'];
        final content = item['contentDetails'];
        final description = snippet['description'] ?? '';

        details[videoId] = {
          'videoId': videoId,
          'title': snippet['title'],
          'description': description,
          'channel': snippet['channelTitle'],
          'publishedAt': snippet['publishedAt'],
          'thumbnail': snippet['thumbnails']['medium']['url'],
          'duration': formatDuration(parseISO8601Duration(content['duration'])),
          'views': statistics['viewCount'] ?? '0',
          'likes': statistics['likeCount'] ?? '0',
          'comments': statistics['commentCount'] ?? '0',
          'definition': content['definition'] ?? 'sd',
          'language': snippet['defaultAudioLanguage'] ?? 'Unknown',
          'recordingDate': extractRecordingDate(description),
          'location': extractLocation(description),
        };
      }
    }
    return details;
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // ✅ Go back to the previous screen
            },
          ),
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
            : Stack(
          children: [
            ListView.builder(
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
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video['title'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 6),
                            Text(
                              video['description'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                            ),
                            SizedBox(height: 4),
                            Wrap(
                              spacing: 10,
                              children: [
                                Text("📺 ${video['channel']}", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                Text("🗓 ${video['publishedAt']?.substring(0, 10)}", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                Text("🎞 ${video['duration']}", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                Text("👁 ${video['views']} views", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                Text("👍 ${video['likes']} likes", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                Text("💬 ${video['comments']} comments", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                Text("💬 ${video['description']} description", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => VideoPlayerFullScreen(
                                          videoId: video['videoId']!,
                                          title: video['title']!,
                                        ),
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

          ],
        ),
      ),
    );
  }

}