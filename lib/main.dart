import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_house/auth/bloc/auth_bloc.dart';
import 'package:smart_house/auth/bloc/auth_state.dart';
import 'package:smart_house/auth/screen/auth_screen.dart';
import 'package:smart_house/main/screen/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final AuthBloc authBloc = AuthBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: authBloc,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          buttonTheme: ButtonThemeData(
            height: 45.0,
          )
        ),
        home: BlocBuilder(bloc: authBloc, builder: (context,AuthState state){
          if(state.firebaseUser!=null){
            return MainScreen();
          }
          else {
            return AuthScreen();
          }
        }),
      ),
    );
  }
}
