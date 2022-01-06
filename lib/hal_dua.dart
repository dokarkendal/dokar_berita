import 'dart:convert';
import 'package:dokar_aplikasi/berita/detail_galeri.dart';
import 'package:flutter/material.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dokar_aplikasi/daftar_admin.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class Haldua extends StatefulWidget {
  @override
  _HalduaState createState() => _HalduaState();
}

class _HalduaState extends State<Haldua> {
  String username = "";
  String kecamatan = "";
  String namadesa = "";
  String status = "";
  String id = "";
  List dataJSON;
  String versi = "";
  String update = "";
  String newversi = "";
  String descript = "";

  final firebaseMessaging = FirebaseMessaging();
  bool isSubscribed = false;

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
  );

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
      Navigator.pushReplacementNamed(context, '/PilihAkun');
    } else {
      _isLoggedIn = true;
    }
  }

  // ignore: missing_return
  Future<String> ambildata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "http://dokar.kendalkab.go.id/webservice/android/kabar/galeri/" +
                pref.getString("IdDesa")),
        headers: {"Accept": "application/json"});

    this.setState(
      () {
        dataJSON = json.decode(hasil.body);
      },
    );
  }

  Future _cekUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(() {
        username = pref.getString("userAdmin");
        kecamatan = pref.getString("kecamatan");
        namadesa = pref.getString("data_nama");
        id = pref.getString("IdDesa");
        status = pref.getString("status");
      });
    }
  }

  // ignore: missing_return
  Future<String> _cekVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;
    versi = versionName + versionCode;
    print(versi);

    http.Response cekversi = await http.get(
        Uri.encodeFull(
            "http://dokar.kendalkab.go.id/webservice/android/dashbord/androidversion"),
        headers: {"Accept": "application/json"});
    var data = json.decode(cekversi.body);

    if (data['version'] + data['versioncode'] == versi) {
      setState(() {
        update = "Updated";
        newversi = data['version'];
        descript = data['description'];
      });
      print(update);
      print(newversi + data['versioncode']);
      print(descript);
    } else {
      setState(() {
        update = "NotUpdate";
        newversi = data['version'];
        descript = data['description'];
      });
      print(update);
      print(newversi + data['versioncode']);
      print(descript);
    }
  }

  void _cekSubscribe() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userStatus") == null ||
        pref.getString("userStatus") == "Warga") {
      firebaseMessaging.subscribeToTopic("Warga");
      setState(() {
        isSubscribed = true;
      });
    } else {
      firebaseMessaging.subscribeToTopic("Admin");
      setState(() {
        isSubscribed = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cekVersion();
    _cekUser();
    _cekLogin();
    _cekSubscribe();
    this.ambildata();
  }

  void dispose() {
    super.dispose();
  }

  Widget updateNotification() {
    if (update == 'Updated') {
      return Container(
        width: 1,
        height: 1,
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(
            top: 15.0, right: 15.0, left: 15.0), //NOTE ganti mediaquery
        child: Container(
          child: Column(
            children: <Widget>[
              FlatButton(
                color: Colors.orange[300],
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Update tersedia, klik untuk update.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Alert(
                    context: context,
                    type: AlertType.info,
                    style: alertStyle,
                    title: "Versi " + newversi,
                    desc: descript,
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Update",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          OpenAppstore.launch(
                              androidAppId: "com.dokar.kendalkab");
                        },
                        color: Colors.blue[300],
                      ),
                    ],
                  ).show();
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget penulis() {
    if (status == '02') {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.orange.withOpacity(0.1),
                  child: IconButton(
                    padding: EdgeInsets.all(15.0),
                    icon: Icon(Icons.help),
                    color: Colors.orange,
                    iconSize: 30.0,
                    onPressed: () {
                      Navigator.pushNamed(context, '/ExpansionTileSample');
                    },
                  ),
                ),
                SizedBox(height: 8.0),
                Text('Bantuan',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0))
              ],
            ),
            Column(
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.red,
                  child: IconButton(
                    padding: EdgeInsets.all(15.0),
                    icon: Icon(Icons.exit_to_app),
                    color: Colors.white,
                    iconSize: 30.0,
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.clear();
                      // _cekUser();
                      int launchCount = 0;
                      pref.setInt('counter', launchCount + 1);
                      _cekLogout();
                    },
                  ),
                ),
                SizedBox(height: 8.0),
                Text('Log Out',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0))
              ],
            ),
            Column(
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.all(15.0),
                  icon: Icon(Icons.launch),
                  color: Colors.white,
                  iconSize: 30.0,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.lightBlueAccent.withOpacity(0.1),
                  child: IconButton(
                    padding: EdgeInsets.all(15.0),
                    icon: Icon(Icons.account_box),
                    color: Colors.lightBlueAccent,
                    iconSize: 30.0,
                    onPressed: () {
                      Navigator.pushNamed(context, '/ListPenulis');
                    },
                  ),
                ),
                SizedBox(height: 8.0),
                Text('Penulis',
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold))
              ],
            ),
            Column(
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.orange.withOpacity(0.1),
                  child: IconButton(
                    padding: EdgeInsets.all(15.0),
                    icon: Icon(Icons.help),
                    color: Colors.orange,
                    iconSize: 30.0,
                    onPressed: () {
                      Navigator.pushNamed(context, '/ExpansionTileSample');
                    },
                  ),
                ),
                SizedBox(height: 8.0),
                Text('Bantuan',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0))
              ],
            ),
            Column(
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.red,
                  child: IconButton(
                    padding: EdgeInsets.all(15.0),
                    icon: Icon(Icons.exit_to_app),
                    color: Colors.white,
                    iconSize: 30.0,
                    onPressed: () {
                      Alert(
                        context: context,
                        style: alertStyle,
                        type: AlertType.warning,
                        title: "Log out?",
                        desc: "Yakin ingin keluar aplikasi?",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Kembali",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            color: Colors.green,
                          ),
                          DialogButton(
                            child: Text(
                              "Log Out",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              pref.clear();
                              // _cekUser();
                              int launchCount = 0;
                              pref.setInt('counter', launchCount + 1);
                              _cekLogout();
                            },
                            color: Colors.red,
                          )
                        ],
                      ).show();
                    },
                    // onPressed: () async {
                    //   SharedPreferences pref =
                    //       await SharedPreferences.getInstance();
                    //   pref.clear();
                    //   // _cekUser();
                    //   int launchCount = 0;
                    //   pref.setInt('counter', launchCount + 1);
                    //   _cekLogout();
                    // },
                  ),
                ),
                SizedBox(height: 8.0),
                Text('Log Out',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0))
              ],
            ),
          ],
        ),
      );
    }
  }

////////////////////////ADMIN/////
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.account_circle),
          color: Color(0xFF2e2e2e),
          iconSize: 28.0,
          onPressed: () {
            Navigator.pushNamed(context, '/HalAkun');
          },
        ),
        centerTitle: true,
        title: Text(
          "DOKAR ",
          style: TextStyle(
            color: Color(0xFF2e2e2e),
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.logout),
        //     color: Colors.white,
        //     iconSize: 28.0,
        //     onPressed: () {
        //       // Navigator.pushNamed(context, '/HalAkun');
        //     },
        //   )
        // ],
      ),
      // backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: CustomShapeClipper(),
                  child: Container(
                    height: mediaQueryData.size.height * 0.4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(mediaQueryData.size.height * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AutoSizeText(
                            "Hai " + username,
                            minFontSize: 16,
                            style: TextStyle(
                              color: Color(0xFF2e2e2e),
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Text(
                            'Desa dan Kelurahan Online Kab. Kendal',
                            style: TextStyle(
                              color: Color(0xFF2e2e2e),
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: mediaQueryData.size.height * 0.15,
                    left: mediaQueryData.size.height * 0.015,
                    right: mediaQueryData.size.height * 0.015,
                    // bottom: mediaQueryData.size.height * 0.03,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: mediaQueryData.size.height * 0.42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0.0, 3.0),
                          blurRadius: 15.0,
                        )
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Material(
                                    borderRadius: BorderRadius.circular(100.0),
                                    color: Colors.purple.withOpacity(0.1),
                                    child: IconButton(
                                      padding: EdgeInsets.all(15.0),
                                      icon: Icon(Icons.library_books),
                                      color: Colors.purple,
                                      iconSize: 30.0,
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/HalamanBeritaadmin');
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text('Beranda',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0))
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Material(
                                    borderRadius: BorderRadius.circular(100.0),
                                    color: Colors.blue.withOpacity(0.1),
                                    child: IconButton(
                                      padding: EdgeInsets.all(15.0),
                                      icon: Icon(Icons.view_agenda),
                                      color: Colors.blue,
                                      iconSize: 30.0,
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/EditSemua');
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text('Dashbord',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0))
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Material(
                                    borderRadius: BorderRadius.circular(100.0),
                                    color: Colors.green.withOpacity(0.1),
                                    child: IconButton(
                                      padding: EdgeInsets.all(15.0),
                                      icon: Icon(Icons.create),
                                      color: Colors.green,
                                      iconSize: 30.0,
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/InputSemua');
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text('Tulis',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0))
                                ],
                              )
                            ],
                          ),
                        ),
                        penulis(),
                        SizedBox(height: 15.0),
                        Divider(),
                        SizedBox(height: 5.0),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'Kritik dan saran',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 16.0),
                                  ),
                                ),
                                Material(
                                  borderRadius: BorderRadius.circular(100.0),
                                  color: Colors.blueAccent.withOpacity(0.1),
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_forward_ios),
                                    color: Colors.blueAccent,
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/KritikSaran');
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            updateNotification(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Galeri Desa',
                      style: TextStyle(
                          color: Color(0xFF2e2e2e),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: FlatButton(
                      color: Color(0xFFfecd2e),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Lihat semua  ',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2e2e2e),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: Colors.grey[600],
                          )
                        ],
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/Galeri');
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0, bottom: 20.0),
              child: Container(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(
                      height: 160.0,
                      child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: dataJSON == null ? 0 : dataJSON.length,
                        itemBuilder: (context, i) {
                          if (dataJSON[i]["status"] == 'Not Found') {
                            return new Container(
                              child: Center(
                                child: new Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 150.0, vertical: 15.0),
                                      child: new Icon(Icons.event_busy,
                                          size: 50.0, color: Colors.grey[350]),
                                    ),
                                    new Text(
                                      "Belum ada gambar",
                                      style: new TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.grey[350],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return new Container(
                              child: new Container(
                                padding: new EdgeInsets.all(2.0),
                                child: new GestureDetector(
                                  onTap: () {},
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            child: GestureDetector(
                                              child: Image.network(
                                                dataJSON[i]["kabar_gambar"],
                                                fit: BoxFit.cover,
                                                height: 180.0,
                                                width: 120.0,
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailGaleri(
                                                      dGambar: dataJSON[i]
                                                          ["kabar_gambar"],
                                                      dDesa: dataJSON[i]
                                                          ["data_nama"],
                                                      dJudul: dataJSON[i]
                                                          ["kabar_judul"],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 140.0,
                                              left: 0.0,
                                            ),
                                            child: SizedBox(
                                              height: 40.0,
                                              width: 120,
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                color: Colors.black45
                                                    .withOpacity(0.4),
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      padding:
                                                          new EdgeInsets.all(
                                                              5.0),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              dataJSON[i]
                                                                  ["data_nama"],
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: AutoSizeText(
                                                              dataJSON[i][
                                                                  "kabar_judul"],
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  new TextStyle(
                                                                fontSize: 12.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 3.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, 390.0 - 200);
    path.quadraticBezierTo(size.width / 2, 280, size.width, 390.0 - 200);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class UpcomingCard extends StatelessWidget {
  final String title;
  final double value;
  final Color color;

  UpcomingCard({this.title, this.value, this.color});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double widthsize = MediaQuery.of(context).size.width * 0.80;
    return Padding(
      padding: EdgeInsets.only(right: 15.0),
      child: Container(
        width: 120.0,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 30.0),
              Text('$value',
                  style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}
