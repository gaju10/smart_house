import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_house/auth/bloc/auth_bloc.dart';
import 'package:smart_house/auth/bloc/auth_event.dart';
import 'package:smart_house/auth/bloc/auth_state.dart';
import 'package:smart_house/main/screen/main_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _keyboardVisibility;
  bool _isSecured;
  final KeyboardVisibilityNotification _keyboardVisibilityNotification = KeyboardVisibilityNotification();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  int _keyboardSubscriptionId;
  AuthBloc _authBloc = AuthBloc();
  StreamSubscription<AuthState> _subscription;
  @override
  void initState() {
    super.initState();
    emailController.text = '222@gmail.com';
    passwordController.text = 'qwe123321';
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _keyboardVisibility = _keyboardVisibilityNotification.isKeyboardVisible;
    _isSecured = true;
    _keyboardSubscriptionId = _keyboardVisibilityNotification.addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisibility = visible;
        });
      },
    );
     _subscription = _authBloc.state.listen((state) {
      if (state.error != null) {
        showDialog(
            context: context,
            builder: (context) {
              return ErrorDialogContent(error: state.error);
            });
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _keyboardVisibilityNotification.removeListener(_keyboardSubscriptionId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home),
        title: Text(
          'Smart drum training',
          style: TextStyle(fontSize: 20.0),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Builder(builder: (context) {
                      var _height = MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.height / 5
                          : MediaQuery.of(context).size.width / 5;
                      if (_keyboardVisibility) {
                        _height = 0.0;
                      }
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        height: _height,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                NetworkImage("https://cdn2.iconfinder.com/data/icons/the-voice/300/Drum-Set-512.png"),
                          ),
                        ),
                      );
                    }),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                          labelText: 'Login or email',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: _isSecured,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.security),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: _isSecured ? Colors.grey : Colors.blue,
                            ),
                            onPressed: () {
                              setState(() {
                                _isSecured = !_isSecured;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: RaisedButton(
                                child: Text(
                                  'Sign IN',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () =>
                                  _authBloc.dispatch(SignIn(
                                    password: passwordController.text,
                                    email: emailController.text,
                                  )),
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: RaisedButton(
                                child: Text(
                                  'Sign UP',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () =>
                                  _authBloc.dispatch(SignUp(
                                    password: passwordController.text,
                                    email: emailController.text,
                                  )),
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: RaisedButton(
                        child: Text(
                          'Sign In with google',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => _authBloc.dispatch(SignInWithGoogle()),
                        color: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      ),
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Forgot password? ",
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                          children: [
                            TextSpan(
                              text: " Recover here",
                              style:
                                  TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 18.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class ErrorDialogContent extends StatefulWidget {
  final String error;

  const ErrorDialogContent({Key key, this.error}) : super(key: key);

  @override
  _ErrorDialogContentState createState() => _ErrorDialogContentState();
}

class _ErrorDialogContentState extends State<ErrorDialogContent> {
  AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(widget.error),
      title: Text('Something went wrong'),
      actions: <Widget>[
        RaisedButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _authBloc.dispatch(CompleteError());
    super.dispose();
  }
}
