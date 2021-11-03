import 'package:avatar_glow/avatar_glow.dart';
import 'package:dokar_aplikasi/berita/hal_admin_tes.dart';
import 'package:dokar_aplikasi/hal_dua.dart';
import 'package:flutter/material.dart';
import 'package:dokar_aplikasi/style/delayed_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dokar_aplikasi/rflutter_alert.dart';

class PilihAKun extends StatefulWidget {
  @override
  _PilihAKunState createState() => _PilihAKunState();
}

class _PilihAKunState extends State<PilihAKun>
    with SingleTickerProviderStateMixin {
  //final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;
  String cekUser = '';

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
    _cekLogin();
  }

  Future _cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userStatus") != null) {
      setState(() {
        cekUser = pref.getString("userStatus");
      });
    } else {
      setState(() {
        cekUser = 'null';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthsize = MediaQuery.of(context).size.width * 0.75;
    final color = Colors.white;
    _scale = 1 - _controller.value;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          //key: scaffoldKey,
          backgroundColor: Color(0xFFee002d),
          body: Center(
            child: ListView(
              children: <Widget>[
                AvatarGlow(
                  endRadius: 90,
                  duration: Duration(seconds: 2),
                  glowColor: Colors.white24,
                  repeat: true,
                  repeatPauseDuration: Duration(seconds: 2),
                  startDelay: Duration(seconds: 1),
                  child: Container(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Material(
                        elevation: 8.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: Image.asset(
                            'assets/images/splashdokar.png',
                            width: 100.0,
                            height: 100.0,
                          ),
                          radius: 65.0,
                        )),
                  ),
                ),
                DelayedAnimation(
                  child: Container(
                    padding: EdgeInsets.only(top: 50.0, bottom: 5.0),
                    child: Center(
                      child: AutoSizeText(
                        "Selamat datang",
                        minFontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0,
                            color: color),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  delay: delayedAmount + 200,
                ),
                DelayedAnimation(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: Center(
                      child: AutoSizeText(
                        "Di Dokar Kendal",
                        minFontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0,
                            color: color),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  delay: delayedAmount + 700,
                ),
                DelayedAnimation(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Center(
                      child: AutoSizeText(
                        "Kamu login sebagai siapa?",
                        minFontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 20.0, color: color),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  delay: delayedAmount + 1700,
                ),
                DelayedAnimation(
                  child: Container(
                    width: widthsize,
                    padding: EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        if (cekUser == '' || cekUser == 'Warga') {
                          Navigator.pushNamed(context, '/DaftarWargaLogin');
                        } else {
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Gagal!",
                            desc: 'Anda sudah login sebagai' + cekUser,
                            buttons: [
                              DialogButton(
                                  color: Colors.red,
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'OpenSans',
                                        fontSize: 20),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })
                            ],
                          ).show();
                        }
                      },
                      child: Transform.scale(
                        scale: _scale,
                        child: _animatedButtonUI,
                      ),
                    ),
                  ),
                  delay: delayedAmount + 2700,
                ),
                DelayedAnimation(
                  child: Container(
                    width: widthsize,
                    padding: EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        if (cekUser == 'null' || cekUser == 'Admin') {
                          Navigator.pushNamed(context, '/DaftarAdmin');
                        } else {
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Gagal!",
                            desc: 'Anda sudah login sebagai' + cekUser,
                            buttons: [
                              DialogButton(
                                  color: Colors.red,
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'OpenSans',
                                        fontSize: 20),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })
                            ],
                          ).show();
                        }
                      },
                      child: Transform.scale(
                        scale: _scale,
                        child: _animatedButtonUI2,
                      ),
                    ),
                  ),
                  delay: delayedAmount + 3700,
                ),
                DelayedAnimation(
                  child: Container(
                      padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                      child: Center(
                        child: AutoSizeText(
                          "Punya akun?".toUpperCase(),
                          minFontSize: 10,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: color),
                        ),
                      )),
                  delay: delayedAmount + 4700,
                ),
              ],
            ),
          )
          //  Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Text('Tap on the Below Button',style: TextStyle(color: Colors.grey[400],fontSize: 20.0),),
          //     SizedBox(
          //       height: 20.0,
          //     ),
          //      Center(

          //   ),
          //   ],

          // ),
          ),
    );
  }

  Widget get _animatedButtonUI => Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            'Warga',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
        ),
      );

  Widget get _animatedButtonUI2 => Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            'Admin',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
        ),
      );

  /*void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }*/
}
