import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/audio_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/audio_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/audio_state.dart';
import '../Logic/player_bloc.dart';
import '../Logic/player_event.dart';
import '../Logic/player_state.dart';

class SongListScreen extends StatelessWidget {
  const SongListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Media Player'),
        centerTitle: true,
      ),
      body: BlocBuilder<AudioBloc, AudioState>(
        builder: (context, state) {
          if (state is AudioLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AudioError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error ${state.message}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AudioBloc>().add(FetchSongsEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is AudioLoaded) {
            if (state.songs.isEmpty) {
              return const Center(child: Text('No songs found on device.'));
            }
            return ListView.builder(
              itemCount: state.songs.length,
              itemBuilder: (context, index) {
                final song = state.songs[index];
                return ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    context.read<PlayerBloc>().add(PlaySongEvent(song));
                  },
                );
              },
            );
          }
          return const Center(child: Text('Press fetch to load songs.'));
        },
      ),
      bottomNavigationBar: BlocBuilder<PlayerBloc,PlayerState> (builder: (context, state ){
        if (state  is PlayerStatusState){
          return Container(
            height: 60,
            color: Colors.blueGrey[900],
            child: Row(
              children: [
                const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Icon(Icons.music_note, color: Colors.white),), 
                Expanded(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
          Text(
            state.currentSong.title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            state.currentSong.artist,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
                )),
               IconButton(onPressed: (){
                context.read<PlayerBloc>().add(TogglePlayPauseEvent());
               }, icon: Icon(
                  state.isPlaying ? Icons.pause_circle : Icons.play_circle
                ))
              ],
            ),
          );
        }
        return const SizedBox.shrink();
        
      }),
    );
  }
}
