
import 'package:equatable/equatable.dart';

abstract class PlaylistEvent extends Equatable {
  const PlaylistEvent();

  @override
  List<Object?> get props => [];
}

// FAVORITES

class LoadFavoritesEvent extends PlaylistEvent {
  const LoadFavoritesEvent();
}

class AddFavoriteEvent extends PlaylistEvent {
  final String songId;

  const AddFavoriteEvent(this.songId);

  @override
  List<Object?> get props => [songId];
}

class RemoveFavoriteEvent extends PlaylistEvent {
  final String songId;

  const RemoveFavoriteEvent(this.songId);

  @override
  List<Object?> get props => [songId];
}

// PLAYLISTS

class LoadPlaylistsEvent extends PlaylistEvent {
  const LoadPlaylistsEvent();
}

class CreatePlaylistEvent extends PlaylistEvent {
  final String name;

  const CreatePlaylistEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class RenamePlaylistEvent extends PlaylistEvent {
  final int playlistId;
  final String newName;

  const RenamePlaylistEvent({
    required this.playlistId,
    required this.newName,
  });

  @override
  List<Object?> get props => [playlistId, newName];
}

class DeletePlaylistEvent extends PlaylistEvent {
  final int playlistId;

  const DeletePlaylistEvent(this.playlistId);

  @override
  List<Object?> get props => [playlistId];
}

// PLAYLIST SONGS

class LoadPlaylistSongsEvent extends PlaylistEvent {
  final int playlistId;

  const LoadPlaylistSongsEvent(this.playlistId);

  @override
  List<Object?> get props => [playlistId];
}

class AddSongToPlaylistEvent extends PlaylistEvent {
  final int playlistId;
  final String songId;

  const AddSongToPlaylistEvent({
    required this.playlistId,
    required this.songId,
  });

  @override
  List<Object?> get props => [playlistId, songId];
}

class RemoveSongFromPlaylistEvent extends PlaylistEvent {
  final int playlistId;
  final String songId;

  const RemoveSongFromPlaylistEvent({
    required this.playlistId,
    required this.songId,
  });

  @override
  List<Object?> get props => [playlistId, songId];
}
