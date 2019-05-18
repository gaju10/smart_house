import 'package:smart_house/auth/bloc/auth_event.dart';
import 'package:smart_house/auth/bloc/auth_state.dart';
import 'package:bloc/bloc.dart';
import 'package:smart_house/auth/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();

  @override
  // TODO: implement initialState
  AuthState get initialState => AuthState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignIn) {
        await _authRepository.signInWithCredentials(event.email, event.password).catchError((e){
          dispatch(Error(
            error: e.message,
          ));
        });
      var user = await _authRepository.getUser();
      yield currentState.copyWith(firebaseUser: user);
    } else if (event is SignUp) {
      await _authRepository.signUp(email: event.email, password: event.password).catchError((e){
        dispatch(Error(
          error: e.message,
        ));
      });
      var user = await _authRepository.getUser();
      yield currentState.copyWith(firebaseUser: user);
    } else if (event is SignInWithGoogle) {
      await _authRepository.signInWithGoogle();
      var user = await _authRepository.getUser();
      yield currentState.copyWith(firebaseUser: user);
    } else if (event is LogOut) {
      _authRepository.signOut();
      var user = await _authRepository.getUser();
      yield AuthState(firebaseUser: user);
    } else if (event is Error) {
      yield currentState.copyWith(error: event.error);
    } else if (event is CompleteError) {
      yield currentState.copyWith(error: null);
    }
  }
}
