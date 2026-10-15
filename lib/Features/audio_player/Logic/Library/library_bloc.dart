import 'package:flutter_bloc/flutter_bloc.dart';

import 'library_event.dart';
import 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc() : super(const LibraryState()) {
    on<SelectLibrarySection>((event, emit) {
      emit(
        state.copyWith(
          selectedSection: event.section,
          clearSelectedItem: true,
        ),
      );
    });

    on<SelectLibraryItem>((event, emit) {
      emit(
        state.copyWith(
          selectedItem: event.item,
          clearSelectedItem: event.item == null,
        ),
      );
    });
  }
}