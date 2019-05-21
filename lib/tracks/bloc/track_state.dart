import 'package:smart_house/tracks/model/track_model.dart';

class TrackState{
  final List<Track> tracks;

  TrackState({this.tracks});

  TrackState copyWith({List<Track> tracks}){
    return TrackState(tracks: tracks ?? this.tracks);
  }
}