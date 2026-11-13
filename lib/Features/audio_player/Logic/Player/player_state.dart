import 'package:equatable/equatable.dart';
import '../../domain/song_model.dart';

enum RepeatMode {
  off,
  all,
  one,
}

abstract class PlayerState extends Equatable {
  const PlayerState();

  @override
  List<Object?> get props => [];
}

class PlayerInitialState extends PlayerState {}

class PlayerStatusState extends PlayerState {
  final SongModel currentSong;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final List<SongModel> playlist;
  final RepeatMode repeatMode;
  final bool isShuffle;
  final bool isSleepTimerActive;
final Duration? sleepTimeRemaining;
final bool sleepAfterCurrentSong;

  const PlayerStatusState({
    required this.currentSong,
    required this.isPlaying,
    required this.position,
    required this.duration, required this.playlist,  this.repeatMode = RepeatMode.off,
    this.isShuffle = false,
    this.isSleepTimerActive = false,
this.sleepTimeRemaining,
this.sleepAfterCurrentSong = false,

  });

  @override
  List<Object?> get props => [
        currentSong,
        isPlaying,
        position,
        duration,
        playlist,
        isShuffle,
        repeatMode,
        isSleepTimerActive,
sleepTimeRemaining,
sleepAfterCurrentSong,
      ];
}
class PlayerQueueStoppedState extends PlayerState {
  final List<SongModel> playlist;

  const PlayerQueueStoppedState({
    required this.playlist,
  });

  @override
  List<Object> get props => [playlist];
}