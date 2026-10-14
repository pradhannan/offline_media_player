import 'package:equatable/equatable.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchResultsState extends SearchState {
  final String query;
  final List<SongModel> results;
  final List<String> albums;
final List<String> artists;

  const SearchResultsState({
    required this.query,
    required this.results,
    this.albums = const [],
this.artists = const [],
  });

  @override
  List<Object?> get props => [query, results, albums, artists];
}