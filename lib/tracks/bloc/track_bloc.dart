import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:smart_house/tracks/bloc/track_event.dart';
import 'package:smart_house/tracks/bloc/track_state.dart';
import 'package:smart_house/tracks/model/track_model.dart';
import 'package:smart_house/tracks/repository/track_repository.dart';

class TrackBloc extends Bloc<TrackEvent, TrackState> {
  final TrackRepository _trackRepository = TrackRepository();

  @override
  // TODO: implement initialState
  TrackState get initialState => TrackState();

  @override
  Stream<TrackState> mapEventToState(TrackEvent event) async* {
    if(event is InitBloc){
      _trackRepository.getTracks().listen((snapshot) {
        dispatch(
          LoadTracks(
            tracks: Track.listFromDocuments(snapshot.documents),
          ),
        );
      });
      yield currentState;
    }
    if (event is LoadTracks) {
      print(event.tracks);
      yield currentState.copyWith(tracks: event.tracks);
    }
  }
}
