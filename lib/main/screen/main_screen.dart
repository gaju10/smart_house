import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_house/auth/bloc/auth_bloc.dart';
import 'package:smart_house/auth/bloc/auth_event.dart';
import 'package:smart_house/common/widget/side_navigation.dart';
import 'package:smart_house/favourite_tracks/favourite_screen.dart';
import 'package:smart_house/tracks/widget/track_card.dart';
import 'package:smart_house/tracks/screen/track_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AuthBloc _authBloc = AuthBloc();

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 60.0,
          color: Colors.blue,
          child: TabBar(
            tabs: [
              Tab(child: Text('Community training'),icon: Icon(Icons.audiotrack,)),
              Tab(child: Text('Your training'),icon: Icon(Icons.favorite),),
            ],
            labelColor: Colors.white,
            indicator: BoxDecoration(
              color: Colors.deepPurple
            ),
          ),
        ),
        drawer: SideNavigation(),
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
          title: Text('Home screen'),
          centerTitle: true,
        ),
        body: TabBarView(
          children: <Widget>[
            TrackScreen(),
            FavouriteTrack(),
          ],
        ),
      ),
    );
  }
}
