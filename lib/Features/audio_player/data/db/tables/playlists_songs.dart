import 'package:drift/drift.dart';
import 'playlists.dart';

class PlaylistSongs extends Table {
  IntColumn get playlistId => integer().references(
        Playlists,
        #id,
        onDelete: KeyAction.cascade,
      )();

  TextColumn get songId => text()();

  @override
  Set<Column> get primaryKey => {playlistId, songId};
}