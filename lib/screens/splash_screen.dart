import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dokar_aplikasi/screens/onboarding_screen.dart';
import 'package:dokar_aplikasi/screens/intro_view.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return OnboardingPage();
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      body: Container(
        child: new Center(
            child: new Column(
          children: <Widget>[
            Align(),
            new Padding(
              padding: new EdgeInsets.all(100.0),
            ),
            Image.asset(
              "assets/images/splashdokar.png",
              width: 200.0,
              height: 200.0,
            ),
            new Padding(
              padding: new EdgeInsets.all(200.0),
            ),
            new Text(
              "Versi 0.0.1",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ],
        )),
      ),
      /*body: Center(
        child: Image.asset(
          "assets/images/splashdokar.png",
          width: 200.0,
          height: 200.0,
        ),
      ),*/
    );
  }
}
