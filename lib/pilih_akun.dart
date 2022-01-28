import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const simplePeriodicTask = "simplePeriodicTask";
final firebaseMessaging = FirebaseMessaging();

Future<void> _setNotification([String topik, String token]) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager.initialize(callbackDispatcher,
      isInDebugMode:
          false); //to true if still in testing lev turn it to false whenever you are launching the app
  await Workmanager.registerPeriodicTask(
    "5", simplePeriodicTask,
    inputData: <String, dynamic>{'topik': topik, 'token': token},
    existingWorkPolicy: ExistingWorkPolicy.replace,
    frequency: Duration(minutes: 15), //when should it check the link
    initialDelay:
        Duration(seconds: 5), //duration before showing the notification
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
}

void callbackDispatcher() {
  Workmanager.executeTask(
    (task, inputData) async {
      var response = await http.post(
          "http://dokar.kendalkab.go.id/webservice/android/fcm",
          body: {"topik": inputData['topik'], "token": inputData['token']});
      var convert = json.decode(response.body);
      print(convert);
      return Future.value(true);
    },
  );
}

class PilihAKun extends StatefulWidget {
  @override
  _PilihAKunState createState() => _PilihAKunState();
}

class _PilihAKunState extends State<PilihAKun> {
  /*firebase konfiguration*/
  final firebaseMessaging = FirebaseMessaging();
  bool isSubscribed = false;
  String token = '';
  static String dataPage = '';
  static String topik = '';

  static Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) {
    debugPrint('onBackgroundMessage: $message');
    if (message.containsKey('data')) {
      String page = '';
      var data = message['data'];
      page = data['screen'];
      dataPage = page;
      debugPrint('onBackgroundMessage: $dataPage');
    }
    return null;
  }

  void _cekSubscribe() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userStatus") == null) {
      firebaseMessaging.subscribeToTopic("Warga");
      setState(
        () {
          isSubscribed = true;
        },
      );
    } else {
      firebaseMessaging.subscribeToTopic("Admin");
      setState(() {
        isSubscribed = true;
      });
    }
  }

  void getDataFcm(Map<String, dynamic> message) {
    String page = '';

    var data = message['data'];
    page = data['screen'];

    if (page.isNotEmpty) {
      setState(
        () {
          dataPage = page;
        },
      );
    }
  }
  //end firebase configuration

  @override
  void initState() {
    //firebase konfiguration
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        debugPrint('onMessage: $message');
        getDataFcm(message);
      },
      onBackgroundMessage: onBackgroundMessage,
      onResume: (Map<String, dynamic> message) async {
        debugPrint('onResume: $message');
        getDataFcm(message);
        if (dataPage.isNotEmpty) {
          Navigator.pushNamed(context, '$dataPage');
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        debugPrint('onLaunch: $message');
        getDataFcm(message);
        if (dataPage.isNotEmpty) {
          Navigator.pushNamed(context, '$dataPage');
        }
      },
    );
    firebaseMessaging.getToken().then((token) => setState(() {
          this.token = token;
        }));

    //end firebase konfiguration
    super.initState();
    _cekLogin();
    _cekSubscribe();
  }

  // ignore: missing_return
  Future<String> _cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userStatus") == 'Admin') {
      if (pref.getString("NotifStatus") == null) {
        pref.setString('NotifStatus', '1');
        setState(() {
          topik = 'Admin';
        });
        _setNotification(topik, token);
      }
      Navigator.pushReplacementNamed(context, '/Haldua');
    } else if (pref.getString("userStatus") == 'Warga') {
      Navigator.pushReplacementNamed(context, '/HalamanBeritaWarga');
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      // backgroundColor: Color(0xFFee002d),
      body: Center(
        child: Stack(
          children: <Widget>[
            _logo(),
            Padding(
              padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
              child: _textjudul(),
            ),
            Padding(
              padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.3),
              child: _text(),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(mediaQueryData.size.height * 0.04),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.03),
                      ),
                      _animatedButtonUII(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.03),
                      ),
                      _animatedButtonUI(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.02),
                      ),
                      _privacy(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.11),
                      ),
                      _daftar(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _logo() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              "assets/images/gold2.png",
            ),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter),
      ),
    );
  }

  Widget _textjudul() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
          left: mediaQueryData.size.height * 0.03,
          right: mediaQueryData.size.height * 0.03,
          bottom: mediaQueryData.size.height * 0.03,
          top: mediaQueryData.size.height * 0.010,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AutoSizeText(
              "Selamat datang",
              minFontSize: 16,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                  color: Colors.brown[800]),
              maxLines: 1,
            ),
            AutoSizeText(
              "Di DOKAR",
              minFontSize: 16,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                  color: Colors.brown[800]),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _text() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: mediaQueryData.size.height * 0.03,
          right: mediaQueryData.size.height * 0.03,
          bottom: mediaQueryData.size.height * 0.03,
          top: mediaQueryData.size.height * 0.07,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AutoSizeText(
              "Portal Berita Desa dan Kelurahan",
              minFontSize: 16,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  color: Colors.white),
              maxLines: 1,
            ),
            AutoSizeText(
              "Kabupaten Kendal",
              minFontSize: 16,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  color: Colors.white),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedButtonUI() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      //height: SizeConfig.safeBlockVertical * 7, //10 for example
      width: mediaQueryData.size.width,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          setState(() {
            topik = 'Warga';
          });
          if (pref.getString("NotifStatus") == null) {
            pref.setString('NotifStatus', '1');
            _setNotification(topik, token);
          }
          Navigator.pushNamed(context, '/HalamanBeritaWarga');
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.orange[300],
        child: Text(
          'Warga',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _animatedButtonUII() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      //height: SizeConfig.safeBlockVertical * 7, //10 for example
      width: mediaQueryData.size.width,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          setState(() {
            topik = 'Admin';
          });
          if (pref.getString("NotifStatus") == null) {
            pref.setString('NotifStatus', '1');
            _setNotification(topik, token);
          }
          Navigator.pushNamed(context, '/DaftarAdmin');
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.blue[800],
        child: Text(
          'Admin',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _daftar() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Info tentang dokar?"),
          GestureDetector(
            onTap: () async {
              const url =
                  'https://www.youtube.com/watch?v=Aa7eKzqp3PA&list=PLkNaCvRUXZ8f3Kta00_Ks_hGMa_hlpyyy';

              if (await canLaunch(url)) {
                await launch(url, forceSafariVC: false);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text(
              "  Lihat",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _privacy() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Text("Info tentang dokar?"),
          GestureDetector(
            onTap: () async {
              const url = 'https://dokar.kendalkab.go.id/privacy';

              if (await canLaunch(url)) {
                await launch(url, forceSafariVC: false);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text(
              "Syarat & Ketentuan",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          )
        ],
      ),
    );
  }
}
