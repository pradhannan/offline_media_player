
 // ignore_for_file: unused_import

import 'dart:async';

import 'package:flutter/material.dart' hide RepeatMode;
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
  StreamSubscription<int?>? _currentIndexSubscription;
  //lets the bloc listen to the audio player's current index and later cancel that listener safely

  SongModel? _currentSong;
  List<SongModel> _playlist = [];
  List<SongModel> _originalPlaylist = [];
  int _currentIndex = -1;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  RepeatMode _repeatMode = RepeatMode.off;
  
  bool _completionQueued = false;
  bool _isShuffle = false;

  // Prevents temporary audio-player indexes from updating the UI during playlist synchronization.
  bool _isSyncingPlaylist = false;

  Timer? _sleepTimer;
  bool _sleepAfterCurrentSong = false;
  Timer? _sleepCountdownTimer;
  DateTime? _sleepTimerEndTime;

  PlayerBloc({required this.audioPlayerRepository})
      : super(PlayerInitialState()) {
    //PLAY
    on<PlaySongEvent>(_onPlaySong);
    on<TogglePlayPauseEvent>(_onTogglePlayPause);
    on<SeekPositionEvent>(_onSeekPosition);
    on<NextSongEvent>(_onNextSong);
    on<PreviousSongEvent>(_onPreviousSong);
    on<CurrentIndexChangedEvent>(_onCurrentIndexChanged);

    //Queue
    on<ReorderQueueEvent>(_onReorderQueue);
    on<PlayNextEvent>(_onPlayNext);
    on<AddToQueueEvent>(_onAddToQueue);
    on<RemoveFromQueueEvent>(_onRemoveFromQueue);

    //Repeat&shuffle
    on<ToggleRepeatEvent>(_onToggleRepeat);
    on<HandleSongCompletionEvent>(_onSongCompleted);
    on<ToggleShuffleEvent>(_onToggleShuffle);

    //sleep
    on<StartSleepTimerEvent>(_onStartSleepTimer);
    on<CancelSleepTimerEvent>(_onCancelSleepTimer);
    on<SleepTimerExpiredEvent>(_onSleepTimerExpired);
    on<SleepAfterCurrentSongEvent>(_onSleepAfterCurrentSong);

    _listenToPlayerStreams();
  }

  void _listenToPlayerStreams() {
    _playerStateSubscription =
        audioPlayerRepository.playerStateStream.listen((playerState) {
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

    // Ignore temporary position and duration updates while the playlist is being synchronized.
_positionSubscription =
    // Keep progress updates flowing; only ignore them while the player is changing playlists.
audioPlayerRepository.positionStream.listen((pos) {
  _position = pos;
  _emitCurrentStatus();

});

_durationSubscription =
   // Keep the actual loaded song duration synchronized with the UI.
audioPlayerRepository.durationStream.listen((dur) {
  if (dur != null) {
    _duration = dur;
    _emitCurrentStatus();
  }
});

    //The stream listener now only forwards the new index to Bloc
    // _onCurrentIndexChanged() handles validation, updates the current song, and emits the UI state
    _currentIndexSubscription =
        audioPlayerRepository.currentIndexStream.listen((index) {
      // Ignore temporary indexes while the audio playlist is being synchronized.
      if (index == null || _isSyncingPlaylist) return;

      add(CurrentIndexChangedEvent(index));
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
          isSleepTimerActive: _sleepTimer != null || _sleepAfterCurrentSong, //when sleep timer is not null, it becomes true
          sleepTimeRemaining: _sleepTimerEndTime == null //norecordrd time = null
              ? null
              : _sleepTimerEndTime!.difference(DateTime.now()).isNegative //else calculate time between now and timer end
                  ? Duration.zero //if timer end
                  : _sleepTimerEndTime!.difference(DateTime.now()),
          sleepAfterCurrentSong: _sleepAfterCurrentSong,
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

    // Initialize progress values for the newly selected song.
_position = Duration.zero;
_duration = Duration(milliseconds: event.song.duration);
    _emitCurrentStatus();
  //  debugPrint('Artwork URI: ${event.song.artworkUri}');

       // Prevent temporary indexes from changing the selected song while loading a new playlist.
    _isSyncingPlaylist = true;

    try {
      await audioPlayerRepository.playPlaylist(
        _playlist,
        _currentIndex,
      );
    } finally {
      _isSyncingPlaylist = false;
    }
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

    await audioPlayerRepository.seekToIndex(_currentIndex); //press Next or Previous, we only need to move to the correct index in that loaded playlist
  }

  Future<void> _onReorderQueue(
    ReorderQueueEvent event,
    Emitter<PlayerState> emit,
  ) async {
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

    // Synchronize just_audio's source order with the reordered BLoC playlist.
    // Ignore temporary index emissions while the audio source is moving.
    _isSyncingPlaylist = true;
    try {
      await audioPlayerRepository.moveSong(
        event.oldIndex,
        newIndex,
      );
    } finally {
      _isSyncingPlaylist = false;
    }

    _emitCurrentStatus(); // publishes the updated queue through PlayerStatusState.
  }

  Future<void> _onToggleShuffle(
    ToggleShuffleEvent event,
    Emitter<PlayerState> emit,
  ) async {
    _isShuffle = !_isShuffle; //T becomes F and vice versa

      late final List<SongModel> targetPlaylist;


    if (_isShuffle) {
      //randomize
    targetPlaylist = List<SongModel>.from(_playlist)..shuffle();
    } else {
          //creates a separate list with the same song order.

    targetPlaylist = List<SongModel>.from(_originalPlaylist);
    }


  //  keep track of the audio source order while moving songs.
  final currentAudioOrder = List<SongModel>.from(_playlist);
//prevent temporary index and progress updates during source reordering.
  _isSyncingPlaylist = true;
     try {
    // move existing audio sources instead of rebuilding the entire playlist.
    for (int targetIndex = 0;
        targetIndex < targetPlaylist.length;
        targetIndex++) {
      final oldIndex = currentAudioOrder.indexWhere(
        (song) => song.id == targetPlaylist[targetIndex].id,
      );

      if (oldIndex == -1 || oldIndex == targetIndex) continue;

      await audioPlayerRepository.moveSong(oldIndex, targetIndex);

      //  keep our local source order synchronized with just_audio.
      final movedSong = currentAudioOrder.removeAt(oldIndex);
      currentAudioOrder.insert(targetIndex, movedSong);
    }

    _playlist = targetPlaylist;

    _currentIndex = _playlist.indexWhere(
      (song) => song.id == _currentSong?.id,
    );
  } finally {
    // allow stream updates again after reordering finishes.
    _isSyncingPlaylist = false;
  }
    _emitCurrentStatus();
  }

  Future<void> _onToggleRepeat(
    ToggleRepeatEvent event,
    Emitter<PlayerState> emit,
  )async {
    _repeatMode = switch (_repeatMode) {
      RepeatMode.off => RepeatMode.all,
      RepeatMode.all => RepeatMode.one,
      RepeatMode.one => RepeatMode.off,
    };

     // Apply the selected repeat mode directly to just_audio.
  await audioPlayerRepository.setRepeatMode(
    switch (_repeatMode) {
      RepeatMode.off => LoopMode.off,
      RepeatMode.all => LoopMode.all,
      RepeatMode.one => LoopMode.one,
    },
  );


    _emitCurrentStatus();
  }

  Future<void> _onSongCompleted(
    HandleSongCompletionEvent event,
    Emitter<PlayerState> emit,
  ) async {
    if (_playlist.isEmpty || _currentIndex < 0) return;

    if (_sleepAfterCurrentSong) {
      _sleepAfterCurrentSong = false;
      _isPlaying = false;
      _emitCurrentStatus();
      return;
    }

    if (_repeatMode == RepeatMode.one) {
  // Restart the current song from the beginning without changing its playlist index.
  _position = Duration.zero;
  _emitCurrentStatus();

  await audioPlayerRepository.seek(Duration.zero);
  await audioPlayerRepository.resume();
  return;
}


    if (_currentIndex < _playlist.length - 1) {
      //play song if exists
      await _playSongAtIndex(_currentIndex + 1);
    } else if (_repeatMode == RepeatMode.all) {
      await _playSongAtIndex(0);
    } else {
      _isPlaying = false;
      _emitCurrentStatus();
    }
  }

  Future<void> _onPlayNext(
    PlayNextEvent event,
    Emitter<PlayerState> emit,
  ) async {
    if (_currentIndex < 0 || _currentSong == null) return;

    _playlist.insert(_currentIndex + 1, event.song);

    // Insert the new audio source directly after the currently playing song.
    await audioPlayerRepository.insertSong(
      _currentIndex + 1,
      event.song,
    );

    final originalIndex = _originalPlaylist.indexWhere(
      (song) => song.id == _currentSong!.id,
    );

    if (originalIndex != -1) {
      _originalPlaylist.insert(originalIndex + 1, event.song);
    } else {
      _originalPlaylist.add(event.song);
    }

    _emitCurrentStatus();
  }

  void _onCurrentIndexChanged(
    CurrentIndexChangedEvent event,
    Emitter<PlayerState> emit,
  ) {
    final index = event.index;

    if (index < 0 || index >= _playlist.length) return;
    if (index == _currentIndex) return;

    _currentIndex = index;
    _currentSong = _playlist[index];

    final currentState = state;

    if (currentState is PlayerStatusState) {
      emit(
        PlayerStatusState(
          currentSong: _currentSong!,
          isPlaying: currentState.isPlaying,
          position: Duration.zero,
          duration: Duration(milliseconds: _currentSong!.duration),
          playlist: _playlist,
          repeatMode: currentState.repeatMode,
          isShuffle: currentState.isShuffle,
          isSleepTimerActive: currentState.isSleepTimerActive,
          sleepTimeRemaining: currentState.sleepTimeRemaining,
          sleepAfterCurrentSong: currentState.sleepAfterCurrentSong,
        ),
      );
    }
  }

  Future<void> _onAddToQueue(
    AddToQueueEvent event,
    Emitter<PlayerState> emit,
  ) async {
    _playlist.add(event.song);
    _originalPlaylist.add(event.song);

    // Add only the new audio source instead of rebuilding the entire playlist.
    await audioPlayerRepository.addSong(event.song);

    _emitCurrentStatus();
  }

  Future<void> _onRemoveFromQueue(
    RemoveFromQueueEvent event,
    Emitter<PlayerState> emit,
  ) async {
    final index = event.index;

    if (index < 0 || index >= _playlist.length) return;

    final removedSong = _playlist[index];
    final isCurrentSong = index == _currentIndex;

    // Remove the selected item from the active queue.
    _playlist.removeAt(index);

    // Keep the original playlist synchronized.
    final originalIndex = _originalPlaylist.indexWhere(
      (song) => song.id == removedSong.id,
    );

    if (originalIndex != -1) {
      _originalPlaylist.removeAt(originalIndex);
    }

    if (isCurrentSong) {
      await audioPlayerRepository.stop();

      // Remove the current audio source from the audio player's playlist too.
      await audioPlayerRepository.removeSongAt(index);

      // No next song exists.
      if (index >= _playlist.length) {
        _currentSong = null;
        _currentIndex = -1;
        _isPlaying = false;
        _position = Duration.zero;
        _duration = Duration.zero;

        emit(PlayerQueueStoppedState(
          playlist: List.unmodifiable(_playlist),
        ));

        return;
      }

      // The next song has shifted into the removed song's position.
      _currentIndex = index;
      _currentSong = _playlist[_currentIndex];
      _position = Duration.zero;
      _duration = Duration.zero;

      // Select and play the next song in the existing audio playlist.
      await audioPlayerRepository.seekToIndex(_currentIndex);

      _emitCurrentStatus();
      return;
    }

    // If a song before the current song was removed,
    // shift the current index back by one.
    if (index < _currentIndex) {
      _currentIndex--;
    }

    // Remove only the selected audio source without interrupting playback.
    await audioPlayerRepository.removeSongAt(index);

    _emitCurrentStatus();
  }

  void _onStartSleepTimer(
    StartSleepTimerEvent event,
    Emitter<PlayerState> emit,
  ) {
    _sleepTimer?.cancel();
    _sleepCountdownTimer?.cancel();

    _sleepAfterCurrentSong = false;
    _sleepTimerEndTime = DateTime.now().add(event.duration); //add time to the now time

    _sleepTimer = Timer(event.duration, () {
      add(SleepTimerExpiredEvent());
    });

    _sleepCountdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _emitCurrentStatus(), //upgrading remaining time by -1sec second
    );
  }

  void _onCancelSleepTimer(
    CancelSleepTimerEvent event,
    Emitter<PlayerState> emit,
  ) {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    _sleepCountdownTimer = null;
    _sleepTimerEndTime = null;
    _sleepAfterCurrentSong = false;
  }

  Future<void> _onSleepTimerExpired(
    SleepTimerExpiredEvent event,
    Emitter<PlayerState> emit,
  ) async {
    _sleepTimer?.cancel();
    _sleepCountdownTimer?.cancel();
    _sleepTimer = null;
    _sleepCountdownTimer = null;
    _sleepTimerEndTime = null;

    await audioPlayerRepository.pause();

    _isPlaying = false;
    _emitCurrentStatus();
  }

  void _onSleepAfterCurrentSong(
    SleepAfterCurrentSongEvent event,
    Emitter<PlayerState> emit,
  ) {
    _sleepTimer?.cancel();
    _sleepCountdownTimer?.cancel();

    _sleepTimer = null;
    _sleepCountdownTimer = null;
    _sleepTimerEndTime = null;
    _sleepAfterCurrentSong = true;
  }

  @override
  Future<void> close() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _sleepTimer?.cancel();
    _sleepCountdownTimer?.cancel();
    _currentIndexSubscription?.cancel();

    return super.close();
  }
}
