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


//When Android's notification changes the track, the stream listener will dispatch this event
//The bloc will then update its state through a normal event handler, where emit is safe
class CurrentIndexChangedEvent extends PlayerEvent {
  final int index;

  const CurrentIndexChangedEvent(this.index);

  @override
  List<Object> get props => [index];
}


class ReorderQueueEvent extends PlayerEvent {
  final int oldIndex;
  final int newIndex;

  const ReorderQueueEvent(this.oldIndex, this.newIndex);

  @override
  List<Object> get props => [oldIndex, newIndex];
}

class ToggleRepeatEvent extends PlayerEvent {}
class HandleSongCompletionEvent extends PlayerEvent {}
class ToggleShuffleEvent extends PlayerEvent {}


class PlayNextEvent extends PlayerEvent {
  final SongModel song;

  const PlayNextEvent(this.song);

  @override
  List<Object> get props => [song];
}

class AddToQueueEvent extends PlayerEvent {
  final SongModel song;

  const AddToQueueEvent(this.song);

  @override
  List<Object> get props => [song];
}

class RemoveFromQueueEvent extends PlayerEvent {
  final int index;

  const RemoveFromQueueEvent(this.index);

  @override
  List<Object> get props => [index];
}


class StartSleepTimerEvent extends PlayerEvent {
  final Duration duration;

  const StartSleepTimerEvent(this.duration);

  @override
  List<Object> get props => [duration];
}

class CancelSleepTimerEvent extends PlayerEvent {}
class SleepAfterCurrentSongEvent extends PlayerEvent {}

class SleepTimerExpiredEvent extends PlayerEvent {}