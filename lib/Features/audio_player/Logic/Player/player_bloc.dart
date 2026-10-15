// ignore_for_file: unused_import

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' hide PlayerEvent, PlayerState;
import 'package:media_player_app/Features/audio_player/Logic/Player/player_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_state.dart';
import 'package:media_player_app/Features/audio_player/data/audio_player_repository.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final AudioPlayerRepository audioPlayerRepository;

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  SongModel? _currentSong;
  List<SongModel> _playlist = [];
  List<SongModel> _originalPlaylist = [];
  int _currentIndex = -1;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  RepeatMode _repeatMode = RepeatMode.off;
  bool _repeatCurrentOnce = false;
   bool _completionQueued = false;
   bool _isShuffle = false;

  PlayerBloc({required this.audioPlayerRepository})
    : super(PlayerInitialState()) {
    //PLAY
    on<PlaySongEvent>(_onPlaySong);
    on<TogglePlayPauseEvent>(_onTogglePlayPause);
    on<SeekPositionEvent>(_onSeekPosition);
    on<NextSongEvent>(_onNextSong);
    on<PreviousSongEvent>(_onPreviousSong);

    //Queue
    on<ReorderQueueEvent>(_onReorderQueue);

    //Repeat&shuffle
    on<ToggleRepeatEvent>(_onToggleRepeat);
    on<HandleSongCompletionEvent>(_onSongCompleted);
    on<ToggleShuffleEvent>(_onToggleShuffle);

    _listenToPlayerStreams();
  }

  void _listenToPlayerStreams() {
    _playerStateSubscription = audioPlayerRepository.playerStateStream.listen((
      playerState,
    ) {
      _isPlaying = playerState.playing;
      _emitCurrentStatus();

      if (playerState.processingState == ProcessingState.completed) {
        if (!_completionQueued) {
          _completionQueued = true;
          add(HandleSongCompletionEvent());
        }
      } else {
        _completionQueued = false;
      }
    });

    _positionSubscription = audioPlayerRepository.positionStream.listen((pos) {
      _position = pos;
      _emitCurrentStatus();
    });

    _durationSubscription = audioPlayerRepository.durationStream.listen((dur) {
      _duration = dur ?? Duration.zero;
      _emitCurrentStatus();
    });
  }

  void _emitCurrentStatus() {
    if (_currentSong != null) {
      // ignore: invalid_use_of_visible_for_testing_member
      emit(
        PlayerStatusState(
          currentSong: _currentSong!,
          isPlaying: _isPlaying,
          position: _position,
          duration: _duration,
          playlist: List.unmodifiable(_playlist),
          repeatMode: _repeatMode,
          isShuffle: _isShuffle,
          //show queue without modifying the real list
        ),
      );
    }
  }

  Future<void> _onPlaySong(
    PlaySongEvent event,
    Emitter<PlayerState> emit,
  ) async {
    _playlist = event.playlist;
    _originalPlaylist = List.from(_playlist);
    _currentIndex = _playlist.indexWhere(
      (song) => song.id == event.song.id,
    ); //song id in the list is equal to song id user clicked
    _currentSong = event.song;
    _repeatCurrentOnce = false;
    _emitCurrentStatus();
    await audioPlayerRepository.playSong(event.song.uri);
  }

  Future<void> _onNextSong(
    NextSongEvent event,
    Emitter<PlayerState> emit,
  ) async {
    if (_playlist.isEmpty || _currentIndex < 0) return;

    if (_currentIndex < _playlist.length - 1) {
      await _playSongAtIndex(_currentIndex + 1);
    } else if (_repeatMode == RepeatMode.all) {
      await _playSongAtIndex(0);
    }
  }

  Future<void> _onPreviousSong(
    PreviousSongEvent event,
    Emitter<PlayerState> emit,
  ) async {
    if (_playlist.isEmpty || _currentIndex < 0) return;

    if (_currentIndex > 0) {
      await _playSongAtIndex(_currentIndex - 1);
    } else if (_repeatMode == RepeatMode.all) {
      await _playSongAtIndex(_playlist.length - 1);
    }
  }

  Future<void> _onTogglePlayPause(
    TogglePlayPauseEvent event,
    Emitter<PlayerState> emit,
  ) async {
    if (_isPlaying) {
      await audioPlayerRepository.pause();
    } else {
      await audioPlayerRepository.resume();
    }
  }

  Future<void> _onSeekPosition(
    SeekPositionEvent event,
    Emitter<PlayerState> emit,
  ) async {
    await audioPlayerRepository.seek(event.position);
  }

  Future<void> _playSongAtIndex(int index) async {

      if (index < 0 || index >= _playlist.length) return;
        _currentIndex = index;
    _currentSong = _playlist[index];
    _position = Duration.zero;
    _duration = Duration.zero;
    _emitCurrentStatus(); //emits PlayerStatusState. BlocBuilder rebuilds. UI display the new song's title and artwork.

    await audioPlayerRepository.playSong(_currentSong!.uri);
  }

  void _onReorderQueue(ReorderQueueEvent event, Emitter<PlayerState> emit) {
    if (event.oldIndex < 0 || //oldIndex -> where the song currently is.
        event.oldIndex >= _playlist.length) {
      //if first song or invalid pos, return
      return;
    }

    var newIndex =
        event.newIndex; //newIndex -> where the user wants to move it.

    if (newIndex < 0 || newIndex >= _playlist.length) {
      return;
    }

    final song = _playlist.removeAt(
      event.oldIndex,
    ); // takes the song out of its old position and keeps it in song.
    _playlist.insert(
      newIndex,
      song,
    ); //puts that same song into its new position.

    _currentIndex = _playlist.indexWhere(
      //currentplaying song is moved
      (item) => item.id == _currentSong?.id,
    );

    _emitCurrentStatus(); // publishes the updated queue through PlayerStatusState.
  }
void _onToggleShuffle(
  ToggleShuffleEvent event,
  Emitter<PlayerState> emit,
) {
  _isShuffle = !_isShuffle; //T becomes F and vice versa

if (_isShuffle) {
  _playlist.shuffle(); //randomize
} else {
  _playlist = List.from(_originalPlaylist); //creates a separate list with the same song order.
}

_currentIndex = _playlist.indexWhere(
  (song) => song.id == _currentSong?.id,
);

_emitCurrentStatus();
}
  void _onToggleRepeat(ToggleRepeatEvent event, Emitter<PlayerState> emit) {
    _repeatMode = switch (_repeatMode) {
      RepeatMode.off => RepeatMode.all,
      RepeatMode.all => RepeatMode.one,
      RepeatMode.one => RepeatMode.off,
    };


    _repeatCurrentOnce = false;

    _emitCurrentStatus();
  }

  Future<void> _onSongCompleted(
    HandleSongCompletionEvent event,
    Emitter<PlayerState> emit,
  ) async {
    if (_playlist.isEmpty || _currentIndex < 0) return;

    if (_repeatMode == RepeatMode.one && !_repeatCurrentOnce) {
      //repeat
      _repeatCurrentOnce = true;
      await _playSongAtIndex(_currentIndex);
      return;
    }

    _repeatCurrentOnce = false;

    if (_currentIndex < _playlist.length - 1) {
      //play song if exists
      await _playSongAtIndex(_currentIndex + 1);
    } else if (_repeatMode == RepeatMode.all) {
      await _playSongAtIndex(0);
    }else {
  _isPlaying = false;
  _emitCurrentStatus();
}
  }

  @override
  Future<void> close() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    return super.close();
  }
}
