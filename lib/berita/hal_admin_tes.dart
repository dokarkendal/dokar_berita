import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dokar_aplikasi/daftar_admin.dart';
import 'dart:async';

class AdminTes extends StatefulWidget {
  AdminTes({Key key}) : super(key: key);
  @override
  _AdminTesState createState() => _AdminTesState();
}

class _AdminTesState extends State<AdminTes> {
  String username = "";
  String id = "";

  // ignore: unused_field
  bool _isLoggedIn = false;
  Future _cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_isLoggedIn") == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => new DaftarAdmin()));
    }
  }

  Future _cekLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_isLoggedIn") == null) {
      _isLoggedIn = false;
      Navigator.pushReplacementNamed(context, '/DaftarAdmin');
    } else {
      _isLoggedIn = true;
    }
  }

  Future _cekUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(() {
        username = pref.getString("userAdmin");
        id = pref.getString("IdDesa");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cekUser();
    _cekLogin();
    //_cekLogout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Welcome : " + username),
            Text("Welcome : " + id),
            _buttonLogout(context),
          ],
        ),
      ),
    );
  }

  Widget _buttonLogout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.clear();

          // _cekUser();
          _cekLogout();
        },
        child: new Container(
          height: 50.0,
          decoration: new BoxDecoration(
            color: Colors.red,
            borderRadius: new BorderRadius.circular(10.0),
          ),
          child: new Center(
            child: new Text(
              'Logout',
              style: new TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
