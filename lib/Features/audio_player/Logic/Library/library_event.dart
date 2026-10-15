import 'package:equatable/equatable.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object?> get props => [];
}

// CHANGED: Event fired when the user taps a section chip.
class SelectLibrarySection extends LibraryEvent {
  final String section;

  const SelectLibrarySection(this.section);

  @override
  List<Object?> get props => [section];
}

class SelectLibraryItem extends LibraryEvent {
  final String? item;

  const SelectLibraryItem(this.item);

  @override
  List<Object?> get props => [item];
}