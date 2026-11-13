
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/playlist_repository.dart';
import 'playlist_event.dart';
import 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final PlaylistRepository repository;

  PlaylistBloc({required this.repository})
      : super(const PlaylistState()) {
    // FAVORITES

    on<LoadFavoritesEvent>((event, emit) async {
      try {
        final ids = await repository.getFavoriteSongIds();

        emit(state.copyWith(
          favoriteSongIds: ids.toSet(),
          clearError: true,
        ));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });

    on<AddFavoriteEvent>((event, emit) async {
      try {
        await repository.addFavorite(event.songId);

        emit(state.copyWith(
          favoriteSongIds: {
            ...state.favoriteSongIds,
            event.songId,
          },
          clearError: true,
        ));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });

    on<RemoveFavoriteEvent>((event, emit) async {
      try {
        await repository.removeFavorite(event.songId);

        final updatedIds = Set<String>.from(state.favoriteSongIds)
          ..remove(event.songId);

        emit(state.copyWith(
          favoriteSongIds: updatedIds,
          clearError: true,
        ));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });

    // PLAYLISTS

    on<LoadPlaylistsEvent>((event, emit) async {
  try {
    final playlists = await repository.getPlaylists();

    final Map<int, List<String>> allPlaylistSongIds = {};

    for (final playlist in playlists) {
      allPlaylistSongIds[playlist.id] =
          await repository.getPlaylistSongIds(playlist.id);
    }

    emit(state.copyWith(
      playlists: playlists,
      playlistSongIds: allPlaylistSongIds,
      clearError: true,
    ));
  } catch (e) {
    emit(state.copyWith(errorMessage: e.toString()));
  }
});

    on<CreatePlaylistEvent>((event, emit) async {
      try {
        await repository.createPlaylist(event.name);

        final playlists = await repository.getPlaylists();

        emit(state.copyWith(
          playlists: playlists,
          clearError: true,
        ));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });

    on<RenamePlaylistEvent>((event, emit) async {
      try {
        await repository.renamePlaylist(
          event.playlistId,
          event.newName,
        );

        final playlists = await repository.getPlaylists();

        emit(state.copyWith(
          playlists: playlists,
          clearError: true,
        ));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });

    on<DeletePlaylistEvent>((event, emit) async {
      try {
        await repository.deletePlaylist(event.playlistId);

        final playlists = await repository.getPlaylists();

        final updatedSongs =
            Map<int, List<String>>.from(state.playlistSongIds)
              ..remove(event.playlistId);

        emit(state.copyWith(
          playlists: playlists,
          playlistSongIds: updatedSongs,
          clearError: true,
        ));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });

    // PLAYLIST SONGS

    on<LoadPlaylistSongsEvent>((event, emit) async {
      try {
        final ids = await repository.getPlaylistSongIds(
          event.playlistId,
        );

        final updatedSongs =
            Map<int, List<String>>.from(state.playlistSongIds);

        updatedSongs[event.playlistId] = ids;

        emit(state.copyWith(
          playlistSongIds: updatedSongs,
          clearError: true,
        ));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });

    on<AddSongToPlaylistEvent>((event, emit) async {
      try {
        await repository.addSongToPlaylist(
          event.playlistId,
          event.songId,
        );

        final ids = await repository.getPlaylistSongIds(
          event.playlistId,
        );

        final updatedSongs =
            Map<int, List<String>>.from(state.playlistSongIds);

        updatedSongs[event.playlistId] = ids;

        emit(state.copyWith(
          playlistSongIds: updatedSongs,
          clearError: true,
        ));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });

    on<RemoveSongFromPlaylistEvent>((event, emit) async {
      try {
        await repository.removeSongFromPlaylist(
          event.playlistId,
          event.songId,
        );

        final ids = await repository.getPlaylistSongIds(
          event.playlistId,
        );

        final updatedSongs =
            Map<int, List<String>>.from(state.playlistSongIds);

        updatedSongs[event.playlistId] = ids;

        emit(state.copyWith(
          playlistSongIds: updatedSongs,
          clearError: true,
        ));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });
  }
}
