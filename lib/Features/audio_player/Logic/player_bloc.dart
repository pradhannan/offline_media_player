// ignore_for_file: unused_import

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' hide PlayerEvent, PlayerState;
import 'package:media_player_app/Features/audio_player/Logic/player_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/player_state.dart';
import 'package:media_player_app/Features/audio_player/data/audio_player_repository.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final AudioPlayerRepository audioPlayerRepository;

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  SongModel? _currentSong;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  PlayerBloc({required this.audioPlayerRepository}) : super(PlayerInitialState()) {
    on<PlaySongEvent>(_onPlaySong);
    on<TogglePlayPauseEvent>(_onTogglePlayPause);
    on<SeekPositionEvent>(_onSeekPosition);

    _listenToPlayerStreams();
  }

  void _listenToPlayerStreams() {
    _playerStateSubscription = audioPlayerRepository.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      _emitCurrentStatus();
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
      emit(PlayerStatusState(
        currentSong: _currentSong!,
        isPlaying: _isPlaying,
        position: _position,
        duration: _duration,
      ));
    }
  }

  Future<void> _onPlaySong(PlaySongEvent event, Emitter<PlayerState> emit) async {
    _currentSong = event.song;
    await audioPlayerRepository.playSong(event.song.uri);
  }

  Future<void> _onTogglePlayPause(TogglePlayPauseEvent event, Emitter<PlayerState> emit) async {
    if (_isPlaying) {
      await audioPlayerRepository.pause();
    } else {
      await audioPlayerRepository.resume();
    }
  }

  Future<void> _onSeekPosition(SeekPositionEvent event, Emitter<PlayerState> emit) async {
    await audioPlayerRepository.seek(event.position);
  }

  @override
  Future<void> close() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    return super.close();
  }
}