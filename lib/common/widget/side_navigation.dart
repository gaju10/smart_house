import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_house/auth/bloc/auth_bloc.dart';
import 'package:smart_house/auth/bloc/auth_event.dart';

class SideNavigation extends StatefulWidget {
  @override
  _SideNavigationState createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation> {
  AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            margin: EdgeInsets.zero,
            accountEmail: Text('text@gmail'),
            accountName: Text('dima'),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          Column(
              children: <Widget>[
                ListTile(
                  title: Text('Logout'),
                  onTap: () {
                    _authBloc.dispatch(
                      LogOut(),
                    );
                    Navigator.pop(context);
                  }
                ),
              ],
            ),]
          ),
    );
  }
}
