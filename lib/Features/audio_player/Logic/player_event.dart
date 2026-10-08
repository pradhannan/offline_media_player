import 'package:equatable/equatable.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';



abstract class PlayerEvent extends Equatable{

  const PlayerEvent();
  @override
   List <Object> get props => [];
}

class PlaySongEvent extends PlayerEvent{
  
 final SongModel song; 
  const PlaySongEvent(this.song);

  @override
  List<Object> get props => [song];
}

class TogglePlayPauseEvent extends PlayerEvent {}

class SeekPositionEvent extends PlayerEvent {
  final Duration position;
  const SeekPositionEvent(this.position);

  @override
  List<Object> get props => [position];
}