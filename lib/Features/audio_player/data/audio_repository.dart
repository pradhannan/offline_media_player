import 'package:equatable/equatable.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart' as audio_query;
import 'package:file_picker/file_picker.dart';


class AudioRepository {

  final audio_query.OnAudioQuery _audioQuery = audio_query.OnAudioQuery();
  // 1. Permission check method
  Future<bool> requestPermission() async {
    if (kIsWeb) return true;
    final status = await Permission.audio.request();
    if (status.isGranted) return true;
    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  // 2. Fetch songs method
  Future<List<SongModel>> fetchSongs() async {
    if (kIsWeb) {
      return await pickSongsFromWeb();
    }

    
    final hasPermission = await requestPermission(); 
    if (!hasPermission) {
      throw Exception('Storage permission denied');
    }

    final rawSongs = await _audioQuery.querySongs(
      sortType: audio_query.SongSortType.TITLE,
      orderType: audio_query.OrderType.ASC_OR_SMALLER,
      uriType: audio_query.UriType.EXTERNAL,
      ignoreCase: true,
    );

    return  rawSongs.map((song) {
  return SongModel(
    id: song.id.toString(),
    title: song.title,
    artist: song.artist ?? 'Unknown Artist',
    album: song.album ?? 'Unknown Album',
    uri: song.data, // 'data' holds the file path on device
    duration: song.duration ?? 0,
  );
}).toList();
  }

  // 3. Web picker stub
  Future<List<SongModel>> pickSongsFromWeb() async {
  final result = await FilePicker.pickFiles(
    type: FileType.audio,
    
  );

  // If the user cancelled the picker dialog
  if (result == null || result.isEmpty) {
    return [];
  }

  // We will map the picked files next!
  return  result.map((file) {
  return SongModel(
    id: file.name, // Uses file name as a unique identifier on Web
    title: file.name.replaceAll(RegExp(r'\.[^.]+$'), ''), // Removes extension like .mp3
    artist: 'Web Track',
    album: 'Uploaded',
    uri: file.path ?? file.toString(), // Holds Web blob URL or path
    duration: 0, // Duration resolved later when audio player loads stream
  );
}).toList();
}
}