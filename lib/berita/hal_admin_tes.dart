import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dokar_aplikasi/daftar_admin.dart';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AdminTes extends StatefulWidget {
  AdminTes({Key key}) : super(key: key);
  @override
  _AdminTesState createState() => _AdminTesState();
}

class _AdminTesState extends State<AdminTes> {
  String username = "";
  String id = "";

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

  /*Future _cekLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("_isLoggedIn", false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new DaftarAdmin()));
  }*/

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

/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dokar_aplikasi/login_admin.dart';

class AdminTes extends StatefulWidget {
  AdminTes({Key key}) : super(key: key);
  @override
  _AdminTesState createState() => _AdminTesState();
}

class _AdminTesState extends State<AdminTes> {
  String nama = "";

  Future _cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("isLogin") == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => new Login()));
    }
  }

  Future _cekLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isLogin", false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new Login()));
  }

  Future _cekUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userName") != null) {
      setState(() {
        nama = pref.getString("userName");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cekUser();
    _cekLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Admin'),
        backgroundColor: Color(0xFFee002d),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Welcome : " + nama),
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
        onTap: () {
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
}*/
