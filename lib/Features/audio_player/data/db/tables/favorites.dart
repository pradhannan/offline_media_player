
// ignore_for_file: file_names

import 'package:drift/drift.dart';

class Favorites extends Table {
  TextColumn get songId => text()();

  @override
  Set<Column> get primaryKey => {songId};
}