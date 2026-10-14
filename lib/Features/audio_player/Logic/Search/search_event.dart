import 'package:equatable/equatable.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChangedEvent extends SearchEvent {
  final String query;

  const SearchQueryChangedEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchSongsLoadedEvent extends SearchEvent {
  final List<SongModel> songs;

  const SearchSongsLoadedEvent(this.songs);

  @override
  List<Object?> get props => [songs];
}

class SearchFilterChangedEvent extends SearchEvent {
  final String filter;

  const SearchFilterChangedEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}