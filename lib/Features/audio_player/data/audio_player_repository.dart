import 'package:just_audio/just_audio.dart';

class AudioPlayerRepository {
  final AudioPlayer _player = AudioPlayer(); //justaudio

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get durationStream => _player.durationStream;
Stream<Duration> get positionStream => _player.positionStream;

Future<void> playSong(String pathOrUri) async{
  if (pathOrUri.startsWith('http')|| pathOrUri.startsWith('blob:')){
    await _player.setUrl(pathOrUri);
  }
  else{
    await _player.setFilePath(pathOrUri);
  }
  await _player.play();
}

Future<void> pause() async => await _player.pause();
Future<void> resume() async => await _player.play();
Future<void> seek(Duration position) async => await _player.seek(position);

}