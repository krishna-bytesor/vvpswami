import 'package:vvpswami/pages/videos_category_page/vide_playlist.dart';
import 'dart:convert';
import '/backend/api_requests/api_calls.dart';
import '/components/bottom_nav_bar/bottom_nav_bar_widget.dart';
import '/components/empty/empty_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/unused/more_option/more_option_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:text_search/text_search.dart';
import 'videos_category_page_model.dart';
export 'videos_category_page_model.dart';
import 'package:http/http.dart' as http;
class VideosCategoryPageWidget extends StatefulWidget {
  const VideosCategoryPageWidget({super.key});

  static String routeName = 'VideosCategoryPage';
  static String routePath = '/videos';

  @override
  State<VideosCategoryPageWidget> createState() =>
      _VideosCategoryPageWidgetState();
}

class _VideosCategoryPageWidgetState extends State<VideosCategoryPageWidget> {
  late VideosCategoryPageModel _model;
  final String apiKey = 'AIzaSyBtRo-dtrCB7i_-NzuM2NDmWwzt-i3gElQ';
  final String channelId = 'UCjrZAhLymD8iNXs8hKoND0A'; // replace with your channel ID
  List<Map<String, dynamic>> playlists = []; // list of playlists with info

  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    fetchPlaylists();
  }

  Future<List<String>> fetchPlaylistVideoIds(String playlistId) async {
    final url =
        'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=$playlistId&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List items = data['items'];
      return items
          .map<String>(
              (item) => item['snippet']['resourceId']['videoId'].toString())
          .toList();
    }
    return [];
  }

  Future<String> fetchTotalDuration(List<String> videoIds) async {
    if (videoIds.isEmpty) return "0:00";

    final ids = videoIds.join(',');
    final url =
        'https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id=$ids&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      int totalSeconds = 0;

      for (var item in data['items']) {
        final duration = item['contentDetails']['duration'];
        totalSeconds += parseISO8601Duration(duration).inSeconds;
      }

      final durationFormatted =
          "${(totalSeconds ~/ 60).toString().padLeft(2, '0')}:${(totalSeconds % 60).toString().padLeft(2, '0')}";
      return durationFormatted;
    }
    return "0:00";
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

  Future<void> fetchPlaylists() async {
    final url =
        'https://www.googleapis.com/youtube/v3/playlists?part=snippet,contentDetails&channelId=$channelId&maxResults=25&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List items = data['items'];

      List<Map<String, dynamic>> updatedPlaylists = [];

      for (var item in items) {
        final playlistId = item['id'].toString();
        final playlistTitle = item['snippet']['title'].toString();
        final thumbnail = item['snippet']['thumbnails']['medium']['url'].toString();
        final itemCount = item['contentDetails']['itemCount']?.toString() ?? '0';

        final videoIds = await fetchPlaylistVideoIds(playlistId);
        final duration = await fetchTotalDuration(videoIds);

        updatedPlaylists.add({
          'title': playlistTitle,
          'playlistId': playlistId,
          'thumbnail': thumbnail,
          'itemCount': itemCount,
          'duration': duration,
        });
      }

      setState(() {
        playlists = updatedPlaylists;
      });
    }
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
            Color(0xFFFAEDD6),
          ],
          stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          begin: AlignmentDirectional(0.31, -1.0),
          end: AlignmentDirectional(-0.31, 1.0),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // <- Important!
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Audio',
            style: TextStyle(
              color: Colors.pinkAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Icon(Icons.search, color: Colors.black),
          ],
        ),
        body: playlists.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Text("Playlist",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.grid_view, color: Colors.grey[700]),
                      SizedBox(width: 12),
                      Icon(Icons.view_list, color: Colors.grey[700]),
                    ],
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: playlists.length,
                      itemBuilder: (context, index) {
                        final playlist = playlists[index];
                        return Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 8.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => VideoPlaylistItemScreen(
                                    playlistId: playlist['playlistId'],
                                    title: playlist['title'],
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    playlist['thumbnail'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        playlist['title'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "${playlist['itemCount']} audios",
                                        style: TextStyle(
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

}
