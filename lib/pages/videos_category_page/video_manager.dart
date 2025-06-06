import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'dart:async';

class VideoManager {
  static final VideoManager _instance = VideoManager._internal();
  factory VideoManager() => _instance;
  VideoManager._internal();

  final AudioPlayer player = AudioPlayer();
  List<Map<String, String>> videos = [];
  int currentIndex = 0;
  final ValueNotifier<Map<String, String>?> currentVideoNotifier = ValueNotifier(null);

  Future<void> playVideos(List<Map<String, String>> videoList, int index) async {
    videos = videoList;
    currentIndex = index;
    await _loadAndPlay();
  }

  Future<void> _loadAndPlay() async {
    final video = videos[currentIndex];
    currentVideoNotifier.value = video;
    final videoId = video['videoId']!;
    final file = await _downloadAndSaveAudio(videoId);
    await player.setAudioSource(
      AudioSource.file(
        file.path,
        tag: MediaItem(id: file.path, title: video['title'] ?? 'Unknown'),
      ),
    );
    await player.play();
    player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) next();
    });
    if (currentIndex + 1 < videos.length) {
      final nextId = videos[currentIndex + 1]['videoId']!;
      unawaited(_downloadAndSaveAudio(nextId));
    }
  }

  Future<File> _downloadAndSaveAudio(String videoId) async {
    final yt = YoutubeExplode();
    try {
      final video = await yt.videos.get(videoId);
      final safeTitle = video.title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/$safeTitle.mp3';
      final file = File(path);
      if (file.existsSync()) return file;
      final manifest = await yt.videos.streamsClient.getManifest(videoId);
      final audioStream = manifest.audioOnly.withHighestBitrate();
      final stream = yt.videos.streamsClient.get(audioStream);
      final sink = file.openWrite();
      await stream.pipe(sink);
      await sink.close();
      return file;
    } finally {
      yt.close();
    }
  }

  void toggle() => player.playing ? player.pause() : player.play();
  void next() {
    if (currentIndex < videos.length - 1) {
      currentIndex++;
      _loadAndPlay();
    }
  }
  void previous() {
    if (currentIndex > 0) {
      currentIndex--;
      _loadAndPlay();
    }
  }
}
