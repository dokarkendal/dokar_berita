import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

final GoogleSignIn _googleSignIn = new GoogleSignIn();
final FirebaseAuth _fireAuth = FirebaseAuth.instance;

class GoogleAccount extends StatefulWidget {
  @override
  State createState() => GoogleAccountState();
}

class GoogleAccountState extends State<GoogleAccount> {
  User _currentUser;
  AdditionalUserInfo _addcurrentUser;

  String notifStatus = '';
  String token = '';
  static String topik = '';

  @override
  void initState() {
    firebaseMessaging.getToken().then(
          (token) => setState(
            () {
              this.token = token;
            },
          ),
        );
    super.initState();
    checkSignIGoogle();
    cekNotif();
  }

  Future<String> checkSignIGoogle() async {
    await Firebase.initializeApp();
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signInSilently();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _fireAuth.signInWithCredential(credential);
    final User user = authResult.user;
    final AdditionalUserInfo userInfo = authResult.additionalUserInfo;

    if (user != null) {
      setState(
        () {
          _currentUser = user;
          _addcurrentUser = userInfo;
        },
      );
      print(_currentUser);
      print(_addcurrentUser);
      return '$user';
    }

    return null;
  }

  Future<String> signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _fireAuth.signInWithCredential(credential);
    final User user = authResult.user;
    final AdditionalUserInfo userInfo = authResult.additionalUserInfo;

    if (user != null) {
      setState(
        () {
          _currentUser = user;
          _addcurrentUser = userInfo;
        },
      );
      print(_currentUser);
      print(_addcurrentUser);

      return '$user';
    }

    return null;
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  void cekNotif() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(
      () {
        notifStatus = pref.getString("NotifStatus");
      },
    );
  }

  Widget notification() {
    if (notifStatus == '1') {
      return IconButton(
        onPressed: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.remove("NotifStatus");
          pref.setString('NotifStatus', '0');
          await Workmanager.cancelAll();
          print('Notif sudah di turn OFF');
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/GoogleAccount',
            ModalRoute.withName('/HalamanBeritaWarga'),
          );
        },
        icon: Icon(Icons.notifications_active),
      );
    } else {
      return IconButton(
        onPressed: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          setState(
            () {
              topik = 'Warga';
            },
          );
          pref.remove("NotifStatus");
          pref.setString('NotifStatus', '1');
          await _setNotification(topik, token);
          print('Notif sudah di turn ON');
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/GoogleAccount',
            ModalRoute.withName('/HalamanBeritaWarga'),
          );
        },
        icon: Icon(Icons.notifications_off),
      );
    }
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      return Column(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0.0, 3.0),
                      blurRadius: 10.0)
                ],
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        _addcurrentUser.profile['picture'],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              left: 5,
                              top: 10,
                              bottom: 5,
                            ),
                            child: Text(
                              _addcurrentUser.profile['name'],
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 5,
                        ),
                        child: Text(
                          _addcurrentUser.profile['email'],
                          style: new TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
              /*child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                _addcurrentUser.profile['picture'],
              ),
            ),
            Column(
              children: <Widget>[
                Text(_addcurrentUser.profile['name']),
                Text(_addcurrentUser.profile['email']),
              ],
            )

            /*const Text("Signed in successfully."),
          Text("Name : " + _addcurrentUser.profile['name']),
          Text("First name : " + _addcurrentUser.profile['given_name']),
          Text("Last name : " + _addcurrentUser.profile['family_name']),
          Text("Photo URL : " + _addcurrentUser.profile['picture']),
          Text("Email : " + _addcurrentUser.profile['email']),
          Text("PhoneNumber : " + _currentUser.phoneNumber.toString()),
          Text("Created : " + _currentUser.metadata.creationTime.toString()),
          Text("Modified : " + _currentUser.metadata.lastSignInTime.toString()),
          Text("Provider : " + _addcurrentUser.providerId.toString()),
          Text("uid : " + _addcurrentUser.profile['sub']),
          Text("Locale : " + _addcurrentUser.profile['locale']),*/
          ],
        ),*/
              ),
          Padding(
            padding: EdgeInsets.all(5),
            // ignore: deprecated_member_use
            child: RaisedButton(
              onPressed: () async {
                _handleSignOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/GoogleAccount',
                  ModalRoute.withName('/HalamanBeritaWarga'),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.red,
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      );
    } else {
      return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 100.0,
              color: Colors.grey[400],
            ),
            GoogleSignInButton(
              onPressed: () async {
                signInWithGoogle();
              },
            ),
            const Text("Kamu belum signed in"),
          ],
        ),
      );
    }
  }

  Widget tombolSigninSignout() {
    if (_currentUser != null) {
      return GestureDetector(
        child: Column(
          children: <Widget>[
            Text("Logout"),
          ],
        ),
        onTap: () async {
          _handleSignOut();
        },
      );
    } else {
      return GestureDetector(
        child: Column(
          children: <Widget>[
            Text("Login"),
          ],
        ),
        onTap: () async {
          signInWithGoogle();
        },
      );
    }
  }

  Widget cardAkun() {
    return Container(
      width: SizeConfig.safeBlockHorizontal * 100,
      height: SizeConfig.safeBlockVertical * 18,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2167c1),
            Color(0xFF0d6dc4),
            Color(0xFF1686c7),
            Color(0xFF2c94cd),
          ],
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0.0, 3.0),
              blurRadius: 10.0)
        ],
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/images/penulis.png',
                  width: SizeConfig.safeBlockHorizontal * 25,
                  height: SizeConfig.safeBlockVertical * 25,
                ),
                SizedBox(width: SizeConfig.safeBlockHorizontal * 5),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 5),
                      child: AutoSizeText(
                        'Sign In google',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AutoSizeText(
                      'Untuk memberikan komentar',
                      minFontSize: 10,
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    ),
                    AutoSizeText(
                      'pada berita desa',
                      minFontSize: 10,
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFee002d),
        title: const Text('Sign In'),
        actions: <Widget>[notification()],
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  cardAkun(),
                  SizedBox(height: SizeConfig.safeBlockVertical * 1),
                  _buildBody(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
