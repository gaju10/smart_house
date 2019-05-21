import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_house/tracks/model/iteration_model.dart';

class SessionRepository{
  Firestore firestore = Firestore.instance;
  CollectionReference _collectionReference ;
  SessionRepository() {
    _collectionReference = firestore.collection('sessionInstrument');
  }

  Stream<QuerySnapshot> checkSession(){
    return _collectionReference.snapshots();
  }
  void clearSession(String instrument) async {
    var documentSnapshot = await _collectionReference
        .where('instrumentId', isEqualTo: '3224')
        .getDocuments();
    var doc = documentSnapshot.documents.first;
    _collectionReference.document(doc.documentID).delete();
  }
  void setStatus(String userId,String status, List<Iteration> iterations,int trackDuration) async {
    var snapshot = await _collectionReference.where('userId',isEqualTo: userId).getDocuments();
    if(snapshot.documents.isEmpty){
      _collectionReference.add({
        'userId' : userId,
        'statusMap' : {'status' : status},
        'duration' : trackDuration,
        'instrumentId' : '3224',
        'iteration' : iterations.map((iteration){
      return iteration.toJson();
      }).toList(),
      });
    }
    else{
      var docID = snapshot.documents.first.documentID;
      _collectionReference.document(docID).updateData(({
        'statusMap' : {'status' : status},
      }));
    }
  }
  void setPauseStatus(String userId, List<Iteration> iterations,int trackDuration,int curDuration) async {
    var snapshot = await _collectionReference.where('userId',isEqualTo: userId).getDocuments();
    if(snapshot.documents.isEmpty){
      _collectionReference.add({
        'userId' : userId,
        'statusMap' : {'status' : 'pause'},
        'duration' : trackDuration,
        'instrumentId' : '3224',
        'curDuration' : curDuration,
        'iteration' : iterations.map((iteration){
          return iteration.toJson();
        }).toList(),
      });
    }
    else{
      var docID = snapshot.documents.first.documentID;
      _collectionReference.document(docID).updateData(({
        'statusMap' : {'status' : 'pause'},
        'curDuration' : curDuration,
      }));
    }
  }
}