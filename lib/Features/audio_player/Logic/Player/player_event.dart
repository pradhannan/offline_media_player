import 'package:equatable/equatable.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';



abstract class PlayerEvent extends Equatable{

  const PlayerEvent();
  @override
   List <Object> get props => [];
}

class PlaySongEvent extends PlayerEvent{
  
 final SongModel song; 
 final List<SongModel> playlist;
  const PlaySongEvent(this.song, this.playlist);

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


class NextSongEvent extends PlayerEvent {}

class PreviousSongEvent extends PlayerEvent {}


class ReorderQueueEvent extends PlayerEvent {
  final int oldIndex;
  final int newIndex;

  const ReorderQueueEvent(this.oldIndex, this.newIndex);

  @override
  List<Object> get props => [oldIndex, newIndex];
}

class ToggleRepeatEvent extends PlayerEvent {}
class HandleSongCompletionEvent extends PlayerEvent {}

