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
  List<Object> get props => [];
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

  const PlayerStatusState({
    required this.currentSong,
    required this.isPlaying,
    required this.position,
    required this.duration, required this.playlist,  this.repeatMode = RepeatMode.off,
    this.isShuffle = false,
  });

  @override
  List<Object> get props => [
        currentSong,
        isPlaying,
        position,
        duration,
        playlist,
        isShuffle,
        repeatMode
      ];
}