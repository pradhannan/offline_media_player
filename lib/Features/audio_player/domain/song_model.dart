  // ignore: file_names
  import 'package:equatable/equatable.dart';

  class SongModel extends Equatable {
    final String id;
    final String title;
    final String artist;
    final String album;
    final String uri;
    final String? artistId;
   
    final String? genre;
    
    final int duration; // in milliseconds
    final String? artworkUri;

    const SongModel({
    
      this.genre,
     
      required this.id,
      required this.title,
      required this.artist,
      required this.album,
      required this.uri,
      required this.duration,
      this.artworkUri,  this.artistId,
    });

    @override
    List<Object?> get props => [
      id,
      title,
      artist,
      album,
      uri,
      duration,
      artworkUri,
      artistId,
      
      genre,
      
    ];
  }
