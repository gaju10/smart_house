import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smart_house/auth/bloc/auth_bloc.dart';
import 'package:smart_house/favourite_tracks/repository/favourite_track_repository.dart';
import 'package:smart_house/iteration_screen/screen/iteration_screen.dart';
import 'package:smart_house/tracks/bloc/track_bloc.dart';
import 'package:smart_house/tracks/bloc/track_event.dart';
import 'package:smart_house/tracks/bloc/track_state.dart';
import 'package:smart_house/tracks/model/track_model.dart';
import 'package:smart_house/tracks/widget/track_card.dart';

class FavouriteTrack extends StatefulWidget {
  @override
  _FavouriteTrackState createState() => _FavouriteTrackState();
}

class _FavouriteTrackState extends State<FavouriteTrack> {
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
    return StreamBuilder(
        stream: favouriteTrackRepository.getFavouriteTracks(_authBloc.currentState.firebaseUser.uid),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (snapshots.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var tracks = Track.listFromDocuments(snapshots.data.documents);
          if(tracks.isEmpty){
            return Center(
              child: Text('Nothing to show'),
            );
          }
          return ListView(
              children: tracks.map((track) {
                return TrackCard(
                  secondary: <Widget>[
                    IconSlideAction(
                      icon: Icons.delete,
                      color: Colors.red,
                      onTap: (){favouriteTrackRepository.unlikeTrack(_authBloc.currentState.firebaseUser.uid, track);},
                      caption: 'Remove',
                    ),
                  ],
                  track: track,
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
              },).toList());
        });
  }
}
