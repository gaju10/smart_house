abstract class AuthEvent{}

class SignIn extends AuthEvent{
  final String email;
  final String password;

  SignIn({this.email, this.password});
}
class SignUp extends AuthEvent{
  final String email;
  final String password;

  SignUp({this.email, this.password});
}

class SignInWithGoogle extends AuthEvent{

}
class LogOut extends AuthEvent{

}
class Error extends AuthEvent{
  final String error;

  Error({this.error});
}
class CompleteError extends AuthEvent{

}