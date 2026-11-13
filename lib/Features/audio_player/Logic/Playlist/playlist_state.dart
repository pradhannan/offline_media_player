
import 'package:equatable/equatable.dart';
import 'package:media_player_app/Features/audio_player/data/db/app_database.dart';

class PlaylistState extends Equatable {
  final Set<String> favoriteSongIds;
  final List<Playlist> playlists;
  final Map<int, List<String>> playlistSongIds;
  final bool isLoading;
  final String? errorMessage;

  const PlaylistState({
    this.favoriteSongIds = const {},
    this.playlists = const [],
    this.playlistSongIds = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  PlaylistState copyWith({
    Set<String>? favoriteSongIds,
    List<Playlist>? playlists,
    Map<int, List<String>>? playlistSongIds,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PlaylistState(
      favoriteSongIds: favoriteSongIds ?? this.favoriteSongIds,
      playlists: playlists ?? this.playlists,
      playlistSongIds: playlistSongIds ?? this.playlistSongIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        favoriteSongIds,
        playlists,
        playlistSongIds,
        isLoading,
        errorMessage,
      ];
}
