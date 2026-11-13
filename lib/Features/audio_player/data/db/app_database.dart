import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:media_player_app/Features/audio_player/data/db/tables/favorites.dart';
import 'package:media_player_app/Features/audio_player/data/db/tables/playlists.dart';
import 'package:media_player_app/Features/audio_player/data/db/tables/playlists_songs.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Favorites,
    Playlists,
    PlaylistSongs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'swarika_database',
  );
}