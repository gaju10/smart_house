import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_house/auth/bloc/auth_bloc.dart';
import 'package:smart_house/favourite_tracks/repository/favourite_track_repository.dart';
import 'package:smart_house/iteration_screen/screen/iteration_screen.dart';
import 'package:smart_house/tracks/bloc/track_bloc.dart';
import 'package:smart_house/tracks/bloc/track_event.dart';
import 'package:smart_house/tracks/bloc/track_state.dart';
import 'package:smart_house/tracks/widget/track_card.dart';

class TrackScreen extends StatefulWidget {
  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  final TrackBloc trackBloc = TrackBloc();
  FavouriteTrackRepository favouriteTrackRepository = FavouriteTrackRepository();
  AuthBloc _authBloc;
  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    trackBloc.dispatch(InitBloc());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: trackBloc,
        builder: (context, TrackState state) {
          if (state.tracks == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
              children: state.tracks.map((track) {
            return TrackCard(
              track: track,
              onTapFavourite: () {
                favouriteTrackRepository.likeTrack(_authBloc.currentState.firebaseUser.uid, track);
              },
              onTapPlay: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrackIteration(
                            trackName: track.trackName,
                            iterations: track.iteration,
                        trackDurationInSeconds: track.trackTime,
                          ),
                    ),
                  ),
            );
          }).toList());
        });
  }
}
