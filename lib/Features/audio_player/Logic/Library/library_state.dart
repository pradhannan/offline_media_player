import 'package:equatable/equatable.dart';

class LibraryState extends Equatable {
  final String selectedSection;

  final String? selectedItem;

  const LibraryState({
    this.selectedSection = 'Songs',
    this.selectedItem,
  });

  LibraryState copyWith({
    String? selectedSection,
    String? selectedItem,
    bool clearSelectedItem = false,
  }) {
    return LibraryState(
      selectedSection: selectedSection ?? this.selectedSection,
      selectedItem: clearSelectedItem
          ? null
          : selectedItem ?? this.selectedItem,
    );
  }

  @override
  List<Object?> get props => [selectedSection, selectedItem];
}