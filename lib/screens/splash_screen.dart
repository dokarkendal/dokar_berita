//ANCHOR Selesai
import 'package:dokar_aplikasi/hal_pilih_user.dart';
// import 'package:dokar_aplikasi/hal_pilih_user.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// import 'package:dokar_aplikasi/screens/onboarding_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:package_info/package_info.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../style/styleset.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
//NOTE Variabel
  // String versi = "";

  late PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

//NOTE Fungsi cek versi aplikasi
  // Future _cekVersion() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   String versionName = packageInfo.version;
  //   setState(
  //     () {
  //       versi = versionName;
  //     },
  //   );
  // }
  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

//NOTE Inistate
  @override
  void initState() {
    super.initState();
    // _cekVersion();
    _initPackageInfo();
    startSplashScreen();
  }

//NOTE Fungsi splashscreen
  startSplashScreen() async {
    var duration = const Duration(seconds: 3);
    return Timer(
      duration,
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return PilihAKun(); //masuk halaman login
            },
          ),
        );
      },
    );
    // var duration = const Duration(seconds: 4);
    // final prefs = await SharedPreferences.getInstance();
    // if (prefs.getInt('counter') == null) {
    //   return Timer(
    //     duration,
    //     () {
    //       Navigator.of(context).pushReplacement(
    //         MaterialPageRoute(
    //           builder: (_) {
    //             return OnboardingPage();
    //           },
    //         ),
    //       );
    //     },
    //   );
    // } else {
    //   return Timer(
    //     duration,
    //     () {
    //       Navigator.of(context).pushReplacement(
    //         MaterialPageRoute(
    //           builder: (_) {
    //             return PilihAKun();
    //           },
    //         ),
    //       );
    //     },
    //   );
    // }
  }

//NOTE Scaffold
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: bgPutih,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.3),
              ),
              Image.asset(
                "assets/images/dokar.png",
                width: mediaQueryData.size.width * 0.3,
                height: mediaQueryData.size.height * 0.3,
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: mediaQueryData.size.height * 0.17),
              ),
              Text(
                "Versi " + _packageInfo.version,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: mediaQueryData.size.height * 0.07),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logos/logokendal.png',
                    width: 50.0,
                    height: 50.0,
                  ),
                  Text(
                    " Pemerintah \n Kabupaten Kendal",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
