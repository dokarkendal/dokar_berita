import 'package:dokar_aplikasi/pilih_akun.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dokar_aplikasi/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  String versi = "";

  // ignore: missing_return
  Future<String> _cekVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    setState(
      () {
        versi = versionName;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _cekVersion();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 4);
    final prefs = await SharedPreferences.getInstance();
    //print(prefs.getInt('counter'));
    if (prefs.getInt('counter') == null) {
      return Timer(
        duration,
        () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) {
                return OnboardingPage();
              },
            ),
          );
        },
      );
    } else {
      return Timer(
        duration,
        () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) {
                return PilihAKun();
              },
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFffffff), //WARNA API
      body: Container(
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Padding(
                padding:
                    new EdgeInsets.only(top: mediaQueryData.size.height * 0.3),
              ),
              Image.asset(
                "assets/images/dokar.png",
                width: mediaQueryData.size.width * 0.3,
                height: mediaQueryData.size.height * 0.3,
              ),
              new Padding(
                padding:
                    new EdgeInsets.only(top: mediaQueryData.size.height * 0.3),
              ),
              new Text(
                "Versi " + versi,
                style: new TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
