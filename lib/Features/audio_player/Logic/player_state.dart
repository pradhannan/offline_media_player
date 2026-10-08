import 'package:equatable/equatable.dart';
import '../domain/song_model.dart';

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

  const PlayerStatusState({
    required this.currentSong,
    required this.isPlaying,
    required this.position,
    required this.duration,
  });

  @override
  List<Object> get props => [
        currentSong,
        isPlaying,
        position,
        duration,
      ];
}