import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final FirebaseUser firebaseUser;
  final String error;

  AuthState({this.error, this.firebaseUser});

  AuthState copyWith({
    FirebaseUser firebaseUser,
    String error
  }) {
    return AuthState(
        firebaseUser: firebaseUser ?? this.firebaseUser,
        error: error,
    );
  }
}
