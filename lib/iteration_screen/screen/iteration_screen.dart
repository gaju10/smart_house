import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_house/auth/bloc/auth_bloc.dart';
import 'package:smart_house/iteration_screen/repository/session_repository.dart';
import 'package:smart_house/tracks/model/iteration_model.dart';
import 'package:flutter_midi/flutter_midi.dart';

class TrackIteration extends StatefulWidget {
  final String trackName;
  final int trackDurationInSeconds;
  final List<Iteration> iterations;

  TrackIteration(
      {Key key, this.trackName, this.iterations, this.trackDurationInSeconds})
      : super(key: key);

  @override
  _TrackIterationState createState() => _TrackIterationState();
}

class _TrackIterationState extends State<TrackIteration>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  SessionRepository sessionRepository = SessionRepository();
  List<String> drumTypes;
  double widthPerSeconds = 80.0;
  AnimationController _animationController;
  Tween<Duration> _tween;
  Animation<Duration> _animation;
  String currentStatus;
  bool sync = false;

  @override
  void initState() {
    super.initState();
    sessionRepository.checkSession().listen((snapshot) {
      var doc = snapshot.documents
          .where((doc) => doc.data['instrumentId'] == '3224')
          .toList();
      if (sync) {
        if (doc.first.data['statusMap']['response'] != true) {
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text(
                    'Sync',
                    style: TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                  children: <Widget>[
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              },
              barrierDismissible: false);
        } else {
          setState(() {
            sync = false;
          });
          Navigator.pop(context);
          runCommand(doc.first.data['statusMap']['status']);
        }
      }
    });
    _animationController = AnimationController(
        duration: Duration(seconds: widget.trackDurationInSeconds),
        vsync: this);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
      }
    });
    _tween = Tween(
        begin: Duration(seconds: 0),
        end: Duration(seconds: widget.trackDurationInSeconds));
    _animation = _tween.animate(_animationController);
    _animation.addListener(() {
      setState(() {
        scrollController
            .jumpTo(_animation.value.inMilliseconds / 1000 * widthPerSeconds);
      });
    });
    drumTypes = [
      'left_drum',
      'middle_left_drum',
      'middle_right_drum',
      'right_drum',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trackName),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.blue.withOpacity(0.2),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height / 1.5
                        : MediaQuery.of(context).size.height / 2.0,
                child: Stack(
                  children: <Widget>[
                    ListView(
                      controller: scrollController,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          width: 150.0,
                          child: Padding(
                            padding: EdgeInsets.only(right:8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(child: Container(child: Center(child: Text('left_drum'),))),
                                Expanded(child: Container(child: Center(child: Text('middle_left_drum')))),
                                Expanded(child: Container(child: Center(child: Text('middle_right_drum')))),
                                Expanded(child: Container(child: Center(child: Text('right_drum')))),
                              ],),
                          ),
                        ),
                        Column(
                          children: drumTypes.map(
                            (string) {
                              return Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left:
                                  MediaQuery.of(context).orientation == Orientation.portrait ? 8.0 : 200.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: 2.0),
                                    ),
                                  ),
                                  width: widthPerSeconds *
                                      widget.trackDurationInSeconds,
                                  child: Stack(
                                      children: widget.iterations
                                          .map<Widget>((iteration) {
                                    var widget;
                                    iteration.drumTypes.forEach((s) {
                                      if (s == string) {
                                        widget = Padding(
                                          padding: EdgeInsets.only(
                                              left: iteration.start.inSeconds * widthPerSeconds),
                                          child: Container(
                                            color: Colors.purple.withOpacity(0.2),
                                            width: 80.0,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  choseColor(string),
                                              radius: 80.0,
                                            ),
                                          ),
                                        );
                                      }
                                    });
                                    return widget == null
                                        ? Container()
                                        : widget;
                                  }).toList()),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                    Container(
                      width: 2.0,
                      color: Colors.black,
                      margin: EdgeInsets.only(left: MediaQuery.of(context).orientation == Orientation.portrait ? 8.0 + 150.0 : 200.0 + 150.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                border: Border(
                  top: BorderSide(color: Colors.black),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    onPressed: sync == true
                        ? null
                        : currentStatus == 'play'
                            ? () {}
                            : () {
                                setState(() {
                                  sync = true;
                                });
                                currentStatus = 'play';
                                sessionRepository.setStatus(
                                  BlocProvider.of<AuthBloc>(context)
                                      .currentState
                                      .firebaseUser
                                      .uid,
                                  'play',
                                  widget.iterations,
                                  widget.trackDurationInSeconds,
                                );
                              },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    onPressed: sync == true
                        ? null
                        : currentStatus == 'pause'
                            ? () {}
                            : () {
                                setState(() {
                                  sync = true;
                                });
                                currentStatus = 'pause';
                                runCommand('pause');
                                sessionRepository.setPauseStatus(
                                  BlocProvider.of<AuthBloc>(context)
                                      .currentState
                                      .firebaseUser
                                      .uid,
                                  widget.iterations,
                                  widget.trackDurationInSeconds,
                                  _animation.value.inSeconds,
                                );
                              },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.stop,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    onPressed: sync == true
                        ? null
                        : currentStatus == 'stop'
                            ? () {}
                            : () {
                                setState(() {
                                  sync = true;
                                });
                                currentStatus = 'stop';
                                runCommand('stop');
                                sessionRepository.setStatus(
                                  BlocProvider.of<AuthBloc>(context)
                                      .currentState
                                      .firebaseUser
                                      .uid,
                                  'stop',
                                  widget.iterations,
                                  widget.trackDurationInSeconds,
                                );
                              },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void runCommand(String status) {
    if (status == 'play') {
      _animationController.forward();
    } else if (status == 'pause') {
      _animationController.stop();
    } else if (status == 'stop') {
      _animationController.reset();
    }
  }

  Color choseColor(String drumType) {
    if (drumType == 'left_drum') {
      return Colors.red;
    } else if (drumType == 'middle_left_drum') {
      return Colors.yellow;
    } else if (drumType == 'middle_right_drum') {
      return Colors.green;
    } else if (drumType == 'right_drum') {
      return Colors.blue;
    }
  }

  @override
  void dispose() {
    sessionRepository.clearSession('3224');
    super.dispose();
  }
}
