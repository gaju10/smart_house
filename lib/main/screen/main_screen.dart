import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_house/auth/bloc/auth_bloc.dart';
import 'package:smart_house/auth/bloc/auth_event.dart';
import 'package:smart_house/common/widget/side_navigation.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AuthBloc _authBloc = AuthBloc();
  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNavigation(),
      appBar: AppBar(),
      body: Container(

      ),
    );
  }
}
