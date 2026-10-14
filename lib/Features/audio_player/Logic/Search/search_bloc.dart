import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Search/search_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Search/search_state.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  List<SongModel> _allSongs = [];
  String _query = '';
  String _filter = 'All';

  SearchBloc() : super(const SearchInitial()) {
    on<SearchSongsLoadedEvent>(_onSongsLoaded);
    on<SearchQueryChangedEvent>(_onQueryChanged);
    on<SearchFilterChangedEvent>(_onFilterChanged);
  }

  void _onSongsLoaded(
    SearchSongsLoadedEvent event,
    Emitter<SearchState> emit,
  ) {
    _allSongs = event.songs;
    _emitSearchResults(emit);
  }

  void _onQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<SearchState> emit,
  ) {
    _query = event.query.trim().toLowerCase();
    _emitSearchResults(emit);
  }
  void _onFilterChanged(
  SearchFilterChangedEvent event,
  Emitter<SearchState> emit,
) {
  _filter = event.filter;
  _emitSearchResults(emit);
}

  void _emitSearchResults(Emitter<SearchState> emit) {
    final results = _query.isEmpty
    ? <SongModel>[]
    : _allSongs.where((song) {
        final title = song.title.toLowerCase();
        final artist = song.artist.toLowerCase();
        final album = song.album.toLowerCase();

        return _filter == 'Songs'
            ? title.contains(_query)
            : _filter == 'All'
                ? title.contains(_query) ||
                    artist.contains(_query) ||
                    album.contains(_query)
                : false;
      }).toList();

final albums = _query.isEmpty || _filter != 'Albums'
    ? <String>[]
    : _allSongs
        .map((song) => song.album)
        .where((album) => album.toLowerCase().contains(_query))
        .toSet()   //avoid duplicate
        .toList();

final artists = _query.isEmpty || _filter != 'Artists'
    ? <String>[]
    : _allSongs
        .map((song) => song.artist)
        .where((artist) => artist.toLowerCase().contains(_query))
        .toSet()
        .toList();

    emit(SearchResultsState(
  query: _query,
  results: results,
  albums: albums,
  artists: artists,
));
  }
}