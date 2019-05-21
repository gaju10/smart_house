import 'package:cloud_firestore/cloud_firestore.dart';

class TrackRepository{
  Firestore _firestore = Firestore.instance;
  CollectionReference _collectionReference;
  TrackRepository(){
    _collectionReference =  _firestore.collection('tracks');
  }

  Stream<QuerySnapshot> getTracks (){
    return _collectionReference.snapshots();
  }

}