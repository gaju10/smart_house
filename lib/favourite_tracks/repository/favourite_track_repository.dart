import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_house/tracks/model/track_model.dart';

class FavouriteTrackRepository{
  Firestore _firestore = Firestore.instance;
  CollectionReference _favouriteCollection;
  FavouriteTrackRepository(){
    _favouriteCollection = _firestore.collection('userTrackInfo');
  }

  void likeTrack(String userId, Track track,)async{
    var json = track.toJson();
    print(track.trackId);
      json.addAll({'userId':userId,'favourite':true});
     var doc = await _favouriteCollection.where('userId',isEqualTo: userId).where('trackId',isEqualTo: track.trackId).getDocuments();
      if(doc.documents.isEmpty){
        print('add');
        _favouriteCollection.add(json);
      }
      else {
        print('update');
        var docID = doc.documents.first.documentID;
        _favouriteCollection.document(docID).updateData(json);
      }
  }
  void unlikeTrack(String userId, Track track,)async{
    _favouriteCollection.document(track.trackId).updateData({'favourite': false});
  }
  Stream<QuerySnapshot> getFavouriteTracks(String userId){
    return _favouriteCollection.where('userId',isEqualTo: userId).where('favourite',isEqualTo: true).snapshots();
  }


}