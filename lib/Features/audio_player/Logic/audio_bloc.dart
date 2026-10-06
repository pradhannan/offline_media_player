import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/audio_repository.dart';
import 'audio_event.dart';
import 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioRepository _audioRepository;
  Future<void> _onFetchSongs(
    FetchSongsEvent event,
    Emitter<AudioState> emit,
  ) async {
    emit(AudioLoading());
    try {
      final songs = await _audioRepository.fetchSongs();
      emit(AudioLoaded(songs));
    } catch (e) {
      emit(AudioError(e.toString()));
    }
  }

  AudioBloc({required AudioRepository audioRepository})
    : _audioRepository = audioRepository,
      super(AudioInitial()) {
    on<FetchSongsEvent>(_onFetchSongs);
  }
}
