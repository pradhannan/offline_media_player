import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_state.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_state.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';
import 'package:on_audio_query/on_audio_query.dart' hide SongModel;

class SongTile extends StatelessWidget {
  final SongModel song;

  const SongTile({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocBuilder<PlayerBloc, PlayerState>(
      buildWhen: (previous, current) {
        if (previous is PlayerStatusState && current is PlayerStatusState) {
          return previous.currentSong.id != current.currentSong.id;
        }
        return true;
      },
      builder: (context, playerState,) {
        final isPlaying = playerState is PlayerStatusState &&
            song.id == playerState.currentSong.id;

            
       
        return Container(
                   decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(16),
                                     
                                         border: isPlaying
                                             ? Border.all(
                                                 //color: Theme.of(context).colorScheme.primary,
                                                 width: 1.5,
                                               )
                                             : null,
                                       ),
                   child: ListTile(
                     tileColor: isPlaying ? colors.primary.withValues(alpha: 0.12) : null,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(16),
                     ),
                     leading: SizedBox(
                       width: 48,
                       height: 48,
                       child: Stack(
                         alignment: Alignment.center,
                         children: [
                           ClipOval(
                             child: QueryArtworkWidget(
                               key: ValueKey(song.id),
                               id: int.parse(song.id),
                               type: ArtworkType.AUDIO,
                               artworkWidth: 48,
                               artworkHeight: 48,
                               artworkFit: BoxFit.cover,
                               nullArtworkWidget: Container(
                                 decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   gradient: LinearGradient(
                                     colors: [colors.primary, colors.secondary],
                                     begin: Alignment.topLeft,
                                     end: Alignment.bottomRight,
                                   ),
                                 ),
                                 child: Icon(
                                   Icons.album_rounded,
                                   color: colors.onPrimary,
                                   size: 28,
                                 ),
                               ),
                             ),
                           ),
                           
                         ],
                       ),
                     ),
                     title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                     subtitle: Text(
                       song.artist,
                       maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                     ),
                     trailing: IconButton(
                       icon: const Icon(Icons.more_vert),
                       onPressed: () {
                         // We'll add the menu actions next.
                       },
                     ),
                     onTap: () {
                       final currentState = context.read<PlayerBloc>().state;
                   
                       if (currentState is PlayerStatusState &&
                           song.id == currentState.currentSong.id) {
                         context.read<PlayerBloc>().add(TogglePlayPauseEvent());
                       } else {
                         final audioState = context.read<AudioBloc>().state;
                   
                         if (audioState is AudioLoaded) {
                           context.read<PlayerBloc>().add(
                             PlaySongEvent(song, audioState.songs),
                           );
                         }
                       }
                     },
                   ),
                 );
      },
    );
  }
}
