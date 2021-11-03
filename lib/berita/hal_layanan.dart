import 'package:flutter/material.dart';

class Layanan extends StatefulWidget {
  @override
  _LayananState createState() => _LayananState();
}

class _LayananState extends State<Layanan> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: new Column(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(100.0),
            ),
            new Text(
              "DALAM PENGEMBANGAN",
              style: new TextStyle(
                fontSize: 30.0,
                color: Colors.grey[350],
              ),
            ),
            new Padding(
              padding: new EdgeInsets.all(20.0),
            ),
            new Icon(Icons.local_convenience_store,
                size: 150.0, color: Colors.grey[350]),
          ],
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dokar_aplikasi/daftar_admin.dart';

class Layanan extends StatefulWidget {
  Layanan({Key key}) : super(key: key);
  @override
  _LayananState createState() => _LayananState();
}

class _LayananState extends State<Layanan> {
  String username = "";

  Future _cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_isLoggedIn") == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => new DaftarAdmin()));
    }
  }

  Future _cekLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("_isLoggedIn", false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new DaftarAdmin()));
  }

  Future _cekUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(() {
        username = pref.getString("userAdmin");
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
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Welcome : " + username),
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

/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dokar_aplikasi/login_admin.dart';

class Layanan extends StatefulWidget {
  Layanan({Key key}) : super(key: key);
  @override
  _LayananState createState() => _LayananState();
}

class _LayananState extends State<Layanan> {
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
