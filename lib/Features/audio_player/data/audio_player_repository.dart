  import 'package:just_audio/just_audio.dart';
  // ignore: depend_on_referenced_packages
  import 'package:audio_service/audio_service.dart';
  import 'dart:io';

  import 'package:on_audio_query/on_audio_query.dart' hide SongModel;
  import '../domain/song_model.dart';

  class AudioPlayerRepository {
    final AudioPlayer _player = AudioPlayer(); //justaudio
    final OnAudioQuery _audioQuery = OnAudioQuery();
    final Map<String, MediaItem> _mediaItemCache = {};

    Stream<PlayerState> get playerStateStream => _player.playerStateStream;
    Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get positionStream => _player.positionStream;


  Stream<int?> get currentIndexStream => _player.currentIndexStream;
  //press Next or Previous in the Android notification, just_audio changes its own current playlist index
  //PlayerBloc needs to know about that change so it can update currentSong and the rest of the app's UI
  //this getter exposes that index to the Bloc

  Future<void> playSong(SongModel song) async{
    final mediaItem = await _createMediaItem(song);
    
  if (song.uri.startsWith('http')) {
    await _player.setAudioSource(
      AudioSource.uri(
        Uri.parse(song.uri),
        tag: mediaItem,
      ),
    );
  } else {
    await _player.setAudioSource(
      AudioSource.file(
        song.uri,
        tag: mediaItem,
      ),
    );
  }
    await _player.play();
  }
  Future<void> playPlaylist(
    List<SongModel> songs,
    int initialIndex,
  ) async {
  final mediaItems = await Future.wait(
    songs.map((song) => _createMediaItem(song)),
  );

  final sources = <AudioSource>[];

  for (int i = 0; i < songs.length; i++) {
    final song = songs[i];

    final sourceUri = song.uri.startsWith('http')
        ? Uri.parse(song.uri)
        : Uri.file(song.uri);

    sources.add(
      AudioSource.uri(
        sourceUri,
        tag: mediaItems[i],
      ),
    );
  }





    await _player.setAudioSources(
      sources,
      initialIndex: initialIndex,
    );

    await _player.play();
  }

  Future<void> updatePlaylist(
  List<SongModel> songs,
  int currentIndex,
) async {
  // Save the current playback position and playing status before rebuilding the playlist.
  final currentPosition = _player.position;
  final wasPlaying = _player.playing;

  final sources = <AudioSource>[];

  for (final song in songs) {
    final mediaItem = await _createMediaItem(song);

    final sourceUri = song.uri.startsWith('http')
        ? Uri.parse(song.uri)
        : Uri.file(song.uri);

    sources.add(
      AudioSource.uri(
        sourceUri,
        tag: mediaItem,
      ),
    );
  }

  // Rebuild the playlist at the current song and its previous position.
  await _player.setAudioSources(
    sources,
    initialIndex: currentIndex,
    initialPosition: currentPosition,
  );

  // Resume only if playback was active before synchronization.
  if (wasPlaying) {
    await _player.play();
  }
}
  Future<AudioSource> _createAudioSource(SongModel song) async {
    final mediaItem = await _createMediaItem(song);

    final sourceUri = song.uri.startsWith('http')
        ? Uri.parse(song.uri)
        : Uri.file(song.uri);

    return AudioSource.uri(
      sourceUri,
      tag: mediaItem,
    );
  }

  Future<void> insertSong(int index, SongModel song) async {
    final source = await _createAudioSource(song);
    await _player.insertAudioSource(index, source);
  }

  Future<void> addSong(SongModel song) async {
    final source = await _createAudioSource(song);
    await _player.addAudioSource(source);
  }

  Future<void> removeSongAt(int index) async {
    await _player.removeAudioSourceAt(index);
  }

  Future<void> moveSong(int oldIndex, int newIndex) async {
    await _player.moveAudioSource(oldIndex, newIndex);
  }


  Future<MediaItem> _createMediaItem(SongModel song) async {
    final cachedItem = _mediaItemCache[song.id];

  if (cachedItem != null) {
    return cachedItem;
  }
    String? artworkPath;

    try {
      final artworkBytes = await _audioQuery.queryArtwork(
        int.parse(song.id),
        ArtworkType.AUDIO,
      );

      if (artworkBytes != null && artworkBytes.isNotEmpty) {
        final artworkFile = File(
          '${Directory.systemTemp.path}/swarika_artwork_${song.id}.jpg',
        );

        await artworkFile.writeAsBytes(artworkBytes, flush: true);
        artworkPath = artworkFile.path;
      }
    } catch (_) {
      // Continue playback even if artwork cannot be retrieved.
    }

    final mediaItem = MediaItem(
    id: song.id,
    title: song.title,
    artist: song.artist,
    album: song.album,
    duration: Duration(milliseconds: song.duration),
    artUri: artworkPath == null ? null : Uri.file(artworkPath),
  );

  _mediaItemCache[song.id] = mediaItem;  //cache  cause first request retrieves artwork and caches it. Subsequent requests reuse the cached metadata

  return mediaItem;
  }

  Future<void> pause() async => await _player.pause();
  Future<void> resume() async => await _player.play();
  Future<void> stop() async => await _player.stop();
  Future<void> seek(Duration position) async => await _player.seek(position);
  Future<void> seekToIndex(int index) async {
    await _player.seek(Duration.zero, index: index);
    await _player.play();
  }
  //seekToIndex() simply moves to another song in the already-loaded playlist
  //This avoids retrieving artwork and rebuilding the playlist every time with skip


  Future<void> setRepeatMode(LoopMode mode) async {
    await _player.setLoopMode(mode);
  }

  Future<void> dispose() async {
      await _player.dispose();
    }
  }