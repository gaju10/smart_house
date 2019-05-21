import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_house/tracks/model/iteration_model.dart';

class Track{
  final String trackId;
  final int trackTime;
  final String trackName;
  final String trackUrl;
  final String trackImageUrl;
  final String trackAuthor;
  final String difficult;
  final String description;
  final List<Iteration> iteration;

  Track({this.description,this.trackTime,this.trackId,this.trackName, this.trackUrl, this.trackImageUrl, this.trackAuthor, this.difficult, this.iteration});

  Track copyWith({String trackName,
  String trackUrl,
    String trackId,
  String trackImageUrl,
  String trackAuthor,
  String difficult,
    String description,
    int trackTime,
  List<Iteration> iteration,}){
    return Track(
      trackAuthor: trackAuthor ?? this.trackAuthor,
      trackName: trackName ?? this.trackName,
      trackImageUrl: trackImageUrl ?? this.trackImageUrl,
      trackUrl: trackUrl ?? this.trackUrl,
      iteration: iteration ?? this.iteration,
      difficult: difficult ?? this.difficult,
      trackId: trackId ?? this.trackId,
      trackTime: trackTime ?? this.trackTime,
      description: description ?? this.description,
    );
  }
  Map<String,dynamic> toJson(){
    return{
      'trackId' : trackId,
      'trackUrl' : trackUrl,
      'trackName' : trackName,
      'trackImageUrl' : trackImageUrl,
      'trackAuthor' : trackAuthor,
      'difficult' : difficult,
      'description' : description,
      'trackTime' : trackTime,
      'iteration' : iteration.map((iteration){
        return iteration.toJson();
    }).toList(),
    };
  }
  factory Track.fromJson(String trackId, Map<String, dynamic> json) {
    return Track(
     trackId: trackId,
      trackUrl: json['trackUrl'],
      trackImageUrl: json['trackImageUrl'],
      trackName: json['trackName'],
      trackAuthor: json['trackAuthor'],
      difficult: json['difficult'],
      trackTime: json['trackTime'],
      iteration:  Iteration.listFromDocuments(json['iteration']),
      description: json['description'],
    );
  }

  static List<Track> listFromDocuments(List<DocumentSnapshot> documents) {
    return documents == null
        ? []
        : documents
        .map(
            (document) => Track.fromJson(document.documentID, document.data))
        .toList();
  }
}
