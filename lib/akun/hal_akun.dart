import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

const simplePeriodicTask = "simplePeriodicTask";
final firebaseMessaging = FirebaseMessaging();
//cek 2
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

class HalAkun extends StatefulWidget {
  @override
  _HalAkunState createState() => _HalAkunState();
}

class _HalAkunState extends State<HalAkun> {
  String nama;
  String email;
  String hp;
  String username;
  String kecamatan = "";
  String namadesa = "";
  String notifStatus = '';
  String token = '';
  static String topik = '';

  // ignore: missing_return
  Future<String> detailAkun(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
      "http://dokar.kendalkab.go.id/webservice/android/account/detail",
      body: {
        "IdAdmin": pref.getString("IdAdmin"),
      },
    );
    var detailakun = json.decode(response.body);

    setState(
      () {
        nama = detailakun['nama'];
        email = detailakun['email'];
        hp = detailakun['hp'];
        username = detailakun['username'];
        kecamatan = pref.getString("kecamatan");
        namadesa = pref.getString("desa");
      },
    );
  }

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
    detailAkun(context);
    cekNotif();
  }

  void cekNotif() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(
      () {
        notifStatus = pref.getString("NotifStatus");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Akun"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          notification(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  cardAkun(),
                  Divider(),
                  namaEdit(),
                  Divider(),
                  emailEdit(),
                  Divider(),
                  hpEdit(),
                  Divider(),
                  usernameEdit(),
                  Divider(),
                  passwordEdit(),
                  buttonEdit()
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: 300.00,
            ),
          ],
        ),
      ),
    );
  }

  Widget notification() {
    if (notifStatus == '1') {
      return IconButton(
        onPressed: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString('NotifStatus', '0');
          await Workmanager.cancelAll();
          print('Notif sudah di turn OFF');
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/HalAkun', ModalRoute.withName('/Haldua'));
        },
        icon: Icon(Icons.notifications_active),
      );
    } else {
      return IconButton(
        onPressed: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          setState(
            () {
              topik = 'Admin';
            },
          );
          pref.setString('NotifStatus', '1');
          _setNotification(topik, token);
          print('Notif sudah di turn ON');
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/HalAkun', ModalRoute.withName('/Haldua'));
        },
        icon: Icon(Icons.notifications_off),
      );
    }
  }

  Widget namaEdit() {
    return InkWell(
      onTap: () {
        /*Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => new FormBeritaDashbord(),
            ),
          );*/
      },
      child: ListTile(
        leading: Icon(
          Icons.home,
          size: 30.0,
        ),
        title: new Text(
          "Nama Orang",
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: new Text(
          "$nama",
          style: new TextStyle(
            fontSize: 14.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
        dense: true,
        /*trailing:
            Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black),*/
      ),
    );
  }

  Widget usernameEdit() {
    return InkWell(
      onTap: () {
        /*Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => new FormBeritaDashbord(),
            ),
          );*/
      },
      child: ListTile(
        leading: Icon(
          Icons.supervised_user_circle,
          size: 30.0,
        ),
        title: new Text(
          "Username",
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: new Text(
          "$username",
          style: new TextStyle(
            fontSize: 14.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
        dense: true,
        /*trailing:
            Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black),*/
      ),
    );
  }

  Widget emailEdit() {
    return InkWell(
      onTap: () {
        /*Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => new FormBeritaDashbord(),
            ),
          );*/
      },
      child: ListTile(
        leading: Icon(
          Icons.email,
          size: 30.0,
        ),
        title: new Text(
          "Email",
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: new Text(
          "$email",
          style: new TextStyle(
            fontSize: 14.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
        dense: true,
      ),
    );
  }

  Widget hpEdit() {
    return InkWell(
      onTap: () {},
      child: ListTile(
        leading: Icon(
          Icons.phone_android,
          size: 30.0,
        ),
        title: new Text(
          "No. Tlp",
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: new Text(
          "$hp",
          style: new TextStyle(
            fontSize: 14.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
        dense: true,
      ),
    );
  }

  Widget passwordEdit() {
    return InkWell(
      onTap: () {},
      child: ListTile(
        leading: Icon(
          Icons.lock,
          size: 30.0,
        ),
        title: new Text(
          "Password",
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: new Text(
          "*******",
          style: new TextStyle(
            fontSize: 14.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
        dense: true,
      ),
    );
  }

  Widget buttonEdit() {
    return Column(
      children: <Widget>[
        RaisedButton.icon(
          icon: Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
          label: Text("EDIT AKUN"),
          onPressed: () {
            Navigator.pushNamed(context, '/FormAkunEdit');
          },
          color: Colors.green,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ],
    );
  }

  Widget cardAkun() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: mediaQueryData.size.width * 1,
      height: mediaQueryData.size.height * 0.2,
      decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     Color(0xFFee002d),
        //     Color(0xFFe3002a),
        //     Color(0xFFd90028),
        //     Color(0xFFcc0025),
        //   ],
        //   stops: [0.1, 0.4, 0.7, 0.9],
        // ),
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0.0, 3.0),
              blurRadius: 15.0)
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
                  'assets/images/akun2.png',
                  width: mediaQueryData.size.width * 0.3,
                  height: mediaQueryData.size.height * 0.3,
                ),
                SizedBox(width: mediaQueryData.size.width * 0.05),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: AutoSizeText(
                        'Lihat dan Edit',
                        minFontSize: 2,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AutoSizeText(
                      '- Lihat informasi akun',
                      minFontSize: 10,
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    ),
                    AutoSizeText(
                      '- Edit informasi akun',
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
}
