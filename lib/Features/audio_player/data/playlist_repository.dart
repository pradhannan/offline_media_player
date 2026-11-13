
import 'package:drift/drift.dart';
import 'db/app_database.dart';


class PlaylistRepository {
  final AppDatabase database;

  PlaylistRepository(this.database);

 

  // Add a song to Favorites
  Future<void> addFavorite(String songId) async {
    await database.into(database.favorites).insertOnConflictUpdate(
          FavoritesCompanion.insert(songId: songId),
        );
  }

  // Remove a song from Favorites
  Future<void> removeFavorite(String songId) async {
    await (database.delete(database.favorites)
          ..where((favorite) => favorite.songId.equals(songId)))
        .go();
  }

  // Check whether a song is favorited
  Future<bool> isFavorite(String songId) async {
    final result = await (database.select(database.favorites)
          ..where((favorite) => favorite.songId.equals(songId)))
        .getSingleOrNull();

    return result != null;
  }

  // Get all favorite song IDs
  Future<List<String>> getFavoriteSongIds() async {
    final results = await database.select(database.favorites).get();

    return results.map((favorite) => favorite.songId).toList();
  }



  // Create a playlist
  Future<int> createPlaylist(String name) async {
    return database.into(database.playlists).insert(
          PlaylistsCompanion.insert(name: name),
        );
  }

  // Rename a playlist
  Future<void> renamePlaylist(int id, String newName) async {
    await (database.update(database.playlists)
          ..where((playlist) => playlist.id.equals(id)))
        .write(
      PlaylistsCompanion(name: Value(newName)),
    );
  }

  // Delete a playlist
  Future<void> deletePlaylist(int id) async {
    await (database.delete(database.playlists)
          ..where((playlist) => playlist.id.equals(id)))
        .go();
  }

  // Get all playlists
  Future<List<Playlist>> getPlaylists() async {
    return database.select(database.playlists).get();
  }

 

  // Add a song to a playlist
  Future<void> addSongToPlaylist(int playlistId, String songId) async {
    await database.into(database.playlistSongs).insertOnConflictUpdate(
          PlaylistSongsCompanion.insert(
            playlistId: playlistId,
            songId: songId,
          ),
        );
  }

  // Remove a song from a playlist
  Future<void> removeSongFromPlaylist(
    int playlistId,
    String songId,
  ) async {
    await (database.delete(database.playlistSongs)
          ..where((playlistSong) =>
              playlistSong.playlistId.equals(playlistId) &
              playlistSong.songId.equals(songId)))
        .go();
  }

  // Get all song IDs in a playlist
  Future<List<String>> getPlaylistSongIds(int playlistId) async {
    final results = await (database.select(database.playlistSongs)
          ..where((playlistSong) =>
              playlistSong.playlistId.equals(playlistId)))
        .get();

    return results.map((playlistSong) => playlistSong.songId).toList();
  }
}
