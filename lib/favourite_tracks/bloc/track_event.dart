import 'package:smart_house/tracks/model/track_model.dart';

abstract class TrackEvent{}

class InitBloc extends TrackEvent{

}
class LoadTracks extends TrackEvent{
  final List<Track> tracks;

  LoadTracks({this.tracks});
}