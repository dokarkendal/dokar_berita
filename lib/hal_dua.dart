import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dokar_aplikasi/berita/detail_galeri.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dokar_aplikasi/hal_login_admin.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_redirect/store_redirect.dart';
import 'style/styleset.dart';

class Haldua extends StatefulWidget {
  @override
  _HalduaState createState() => _HalduaState();
}

class _HalduaState extends State<Haldua> {
//NOTE Variable
  String username = "";
  String kecamatan = "";
  String namadesa = "";
  String status = "";
  String id = "";
  String versi = "";
  String update = "";
  String newversi = "";
  String descript = "";
  bool hasThrownError = false;

//NOTE List
  List dataJSON;

//NOTE Boolean
  // ignore: unused_field
  bool _isLoggedIn = false;
  bool isLoading = false;

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

//NOTE Fungsi cek login
  Future _cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_isLoggedIn") == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DaftarAdmin()));
    }
  }

//NOTE Fungsi Cek Logout
  Future _cekLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_isLoggedIn") == null) {
      _isLoggedIn = false;
      Navigator.pushReplacementNamed(context, '/PilihAkun');
    } else {
      _isLoggedIn = true;
    }
  }

  //NOTE Fungsi Aambil Galery
  Future ambildata() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      http.Response hasil = await http.get(
          Uri.parse(
              "http://dokar.kendalkab.go.id/webservice/android/kabar/galeri/" +
                  pref.getString("IdDesa")),
          headers: {"Accept": "application/json"});

      this.setState(
        () {
          dataJSON = json.decode(hasil.body);
          isLoading = false;
        },
      );
    } catch (e) {
      if (e is SocketException) {
        setState(() {
          hasThrownError = true;
        });

        //treat SocketException
        print("Socket exception galery: ${e.toString()}");
      } else if (e is TimeoutException) {
        setState(() {
          hasThrownError = true;
        });
        //treat TimeoutException
        print("Timeout exception galery: ${e.toString()}");
      } else {
        setState(() {
          hasThrownError = true;
        });
        print("Unhandled exception galery: ${e.toString()}");
      }
    }
    return null;
  }

//NOTE Fungsi Cek User
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

  //NOTE Fungsi Cek Versi
  Future _cekVersion() async {
    setState(() {
      isLoading = true;
    });
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;
    versi = versionName + versionCode;
    print(versi);
    try {
      http.Response cekversi = await http.get(
          Uri.parse(
              "http://dokar.kendalkab.go.id/webservice/android/dashbord/androidversion"),
          headers: {"Accept": "application/json"});
      var data = json.decode(cekversi.body);

      if (data['version'] + data['versioncode'] == versi) {
        setState(() {
          update = "Updated";
          versi = data['version'];
          descript = data['description'];
          isLoading = false;
        });
        print(update);
        print(versi + data['versioncode']);
        print(descript);
      } else {
        setState(() {
          update = "NotUpdate";
          versi = data['version'];
          descript = data['description'];
          isLoading = false;
        });
        print(update);
        print(versi + data['versioncode']);
        print(descript);
      }
    } catch (e) {
      if (e is SocketException) {
        //treat SocketException
        print("Socket exception versi: ${e.toString()}");
      } else if (e is TimeoutException) {
        //treat TimeoutException
        print("Timeout exception versi: ${e.toString()}");
      } else
        print("Unhandled exception versi: ${e.toString()}");
    }
  }

//NOTE Inistate
  @override
  void initState() {
    super.initState();
    _cekVersion();
    _cekUser();
    _cekLogin();
    ambildata();
  }

  void dispose() {
    super.dispose();
  }

//NOTE Widget Update
  Widget updateNotification() {
    if (update == 'Updated') {
      return Container(
        width: 1,
        height: 1,
      );
    } else {
      return isLoading
          ? Center()
          : Padding(
              padding: EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.red,
                        onSurface: Colors.grey,
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
                          title: "Versi " + versi,
                          desc: descript,
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Update",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () {
                                //REVIEW Tombol ke playstore
                                Navigator.pop(context);
                                StoreRedirect.redirect(
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

//NOTE Widget Penulis
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
                      Dialogs.bottomMaterialDialog(
                        msg: 'Anda yakin ingin keluar aplikasi?',
                        title: "Keluar",
                        color: Colors.white,
                        lottieBuilder: Lottie.asset(
                          'assets/animation/exit2.json',
                          fit: BoxFit.contain,
                          repeat: false,
                        ),
                        // animation:'assets/logo/animation/exit.json',
                        context: context,
                        actions: [
                          IconsOutlineButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: 'Tidak',
                            iconData: Icons.cancel_outlined,
                            textStyle: const TextStyle(color: Colors.grey),
                            iconColor: Colors.grey,
                          ),
                          IconsButton(
                            onPressed: () async {
                              // SharedPreferences pref = await SharedPreferences.getInstance();
                              // pref.clear();
                              // events.clear();
                              // _cekLogout();
                              // Navigator.pop(context);
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              pref.clear();

                              int launchCount = 0;
                              pref.setInt('counter', launchCount + 1);
                              _cekLogout();
                            },
                            text: 'Exit',
                            iconData: Icons.exit_to_app,
                            color: Colors.red,
                            textStyle: const TextStyle(color: Colors.white),
                            iconColor: Colors.white,
                          ),
                        ],
                      );
                      // SharedPreferences pref =
                      //     await SharedPreferences.getInstance();
                      // pref.clear();

                      // int launchCount = 0;
                      // pref.setInt('counter', launchCount + 1);
                      // _cekLogout();
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
                    onPressed: () async {
                      Dialogs.bottomMaterialDialog(
                        msg: 'Anda yakin ingin keluar aplikasi?',
                        title: "Keluar",
                        color: Colors.white,
                        lottieBuilder: Lottie.asset(
                          'assets/animation/exit2.json',
                          fit: BoxFit.contain,
                          repeat: false,
                        ),
                        // animation:'assets/logo/animation/exit.json',
                        context: context,
                        actions: [
                          IconsOutlineButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: 'Tidak',
                            iconData: Icons.cancel_outlined,
                            textStyle: const TextStyle(color: Colors.grey),
                            iconColor: Colors.grey,
                          ),
                          IconsButton(
                            onPressed: () async {
                              // SharedPreferences pref = await SharedPreferences.getInstance();
                              // pref.clear();
                              // events.clear();
                              // _cekLogout();
                              // Navigator.pop(context);
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              pref.clear();

                              int launchCount = 0;
                              pref.setInt('counter', launchCount + 1);
                              _cekLogout();
                            },
                            text: 'Exit',
                            iconData: Icons.exit_to_app,
                            color: Colors.red,
                            textStyle: const TextStyle(color: Colors.white),
                            iconColor: Colors.white,
                          ),
                        ],
                      );
                      // SharedPreferences pref =
                      //     await SharedPreferences.getInstance();
                      // pref.clear();

                      // int launchCount = 0;
                      // pref.setInt('counter', launchCount + 1);
                      // _cekLogout();
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
          color: appbarIcon,
          iconSize: 28.0,
          onPressed: () {
            Navigator.pushNamed(context, '/HalAkun');
          },
        ),
        centerTitle: true,
        title: Text(
          "DOKAR ",
          style: TextStyle(
            color: appbarTitle,
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
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
                          SizedBox(height: 10.0),
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
                    top: mediaQueryData.size.height * 0.13,
                    left: mediaQueryData.size.height * 0.015,
                    right: mediaQueryData.size.height * 0.015,
                    // bottom: mediaQueryData.size.height * 0.03,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: mediaQueryData.size.height * 0.39,
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
                              horizontal: 40.0, vertical: 30.0),
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
                        // SizedBox(height: 5.0),
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
                                        fontSize: 14.0),
                                  ),
                                ),
                                Material(
                                  borderRadius: BorderRadius.circular(100.0),
                                  color: Colors.blueAccent.withOpacity(0.1),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                    ),
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
                      'Galeri Berita',
                      style: TextStyle(
                          color: Color(0xFF2e2e2e),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // padding: EdgeInsets.all(15.0),
                        elevation: 0,
                        primary: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // <-- Radius
                        ),
                      ),
                      // color: Colors.green,
                      // textColor: Colors.white,
                      // shape: RoundedRectangleBorder(
                      //   borderRadius:  BorderRadius.circular(15.0),
                      // ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Lihat semua  ',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[600],
                            ),
                          ),
                          Icon(Icons.arrow_forward,
                              size: 16, color: Colors.grey[600])
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
            isLoading
                ? hasThrownError == true
                    ? _errorGalery()
                    : _buildProgressIndicator()
                : Padding(
                    padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
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
                                  return Container(
                                    child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 150.0,
                                                vertical: 15.0),
                                            child: Icon(Icons.event_busy,
                                                size: 50.0,
                                                color: Colors.grey[350]),
                                          ),
                                          Text(
                                            "Belum ada gambar",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.grey[350],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    child: Container(
                                      padding: EdgeInsets.all(2.0),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  child: GestureDetector(
                                                    child: CachedNetworkImage(
                                                      imageUrl: dataJSON[i]
                                                          ["kabar_gambar"],
                                                      fit: BoxFit.cover,
                                                      height: 180.0,
                                                      width: 120.0,
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                              "assets/images/load.png",
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailGaleri(
                                                            dGambar: dataJSON[i]
                                                                [
                                                                "kabar_gambar"],
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
                                                          BorderRadius.circular(
                                                              5.0),
                                                      color: Colors.black45
                                                          .withOpacity(0.4),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    dataJSON[i][
                                                                        "data_nama"],
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      AutoSizeText(
                                                                    dataJSON[i][
                                                                        "kabar_judul"],
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12.0,
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

  Widget _errorGalery() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
        ),
        height: mediaQueryData.size.height * 0.21,
        width: mediaQueryData.size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 150.0, vertical: 20.0),
            Icon(Icons.wifi_off_rounded, size: 50.0, color: Colors.grey[350]),
            // ),
            Text(
              "Tidak dapat dijankau \natau waktu habis",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[350],
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Ulangi'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/Haldua');
              },
            )
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: <Widget>[
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10.0),
            //     color: Colors.grey[200],
            //   ),
            //   height: mediaQueryData.size.height * 0.21,
            //   width: mediaQueryData.size.width,
            //   // color: Colors.grey,
            // ),

            // Row(
            //   ],
            // ),
            // SizedBox(height: mediaQueryData.size.height * 0.01),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        highlightColor: Colors.white,
        baseColor: Colors.grey[300],
        child: Container(
          padding: EdgeInsets.only(
            left: 15.0,
            bottom: 10.0,
            right: 15,
          ),
          child: Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey,
                    ),
                    height: mediaQueryData.size.height * 0.21,
                    width: mediaQueryData.size.width,
                    // color: Colors.grey,
                  ),

                  // Row(
                ],
              ),
              // SizedBox(height: mediaQueryData.size.height * 0.01),
            ],
          ),
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
