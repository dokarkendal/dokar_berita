import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dokar_aplikasi/warga/detail_galeri_warga.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../../style/styleset.dart';

class HalEditWarga extends StatefulWidget {
  const HalEditWarga({super.key});

  @override
  State<HalEditWarga> createState() => _HalEditWargaState();
}

class _HalEditWargaState extends State<HalEditWarga> {
  String? nama = "";
  String? email = "";
  String? hp = "";
  String? username = "";
  // ignore: unused_field
  bool _isLoggedIn = false;
  bool loadingdata = false;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );
  Future _cekLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_isLoggedIn") == null) {
      _isLoggedIn = false;
      // Navigator.pushReplacementNamed(context, '/PilihAkun');
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/PilihAkun',
        (Route<dynamic> route) => false,
      );
    } else {
      _isLoggedIn = true;
    }
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> detailAkunWarga() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      loadingdata = true;
    });
    final response = await http.post(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/account/detail"),
      body: {
        "IdAdmin": pref.getString("uid")!,
      },
    );
    var detailakunwarga = json.decode(response.body);
    if (mounted) {
      setState(
        () {
          loadingdata = false;
          nama = detailakunwarga['nama']!;
          email = detailakunwarga['email'];
          hp = detailakunwarga['hp'];
          username = detailakunwarga['username'];
        },
      );
    }
  }

  late List dataDukungJSON = [];
  void detailDataDukung() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      loadingdata = true;
    });
    final response = await http.post(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/account/DataDukungByUid"),
      body: {
        "uid": pref.getString("uid")!,
      },
    );
    // if (mounted) {
    //   this.setState(
    //     () {
    //       loadingdata = false;
    //       dataDukungJSON = json.decode(response.body)["Data"];
    //       print(dataDukungJSON);
    //     },
    //   );
    // }
    if (mounted) {
      final decodedResponse = json.decode(response.body);
      final responseData = decodedResponse["Data"];

      if (responseData is List) {
        this.setState(() {
          loadingdata = false;
          dataDukungJSON = responseData;
          print(dataDukungJSON);
        });
      } else {
        setState(() {
          loadingdata = false;
        });
        // Handle case when "Data" field is "notfound"
        // For example, you can display an error message
        print("Data not found");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    detailAkunWarga();
    detailDataDukung();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          "AKUN",
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
            // fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.edit),
          //   iconSize: 23.0,
          //   onPressed: () async {
          //     Navigator.pushNamed(context, '/FormEditWarga')
          //         .then((value) => detailAkunWarga());
          //   },
          // )
          IconButton(
            icon: Icon(Icons.logout),
            iconSize: 25.0,
            onPressed: () async {
              // Navigator.pushNamed(context, '/MyEditor');
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
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.clear();

                      // int launchCount = 0;
                      // pref.setInt('counter', launchCount + 1);
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
            },
          ),
        ],
      ),
      body: loadingdata
          ? _buildProgressIndicator()
          : Container(
              color: Colors.grey.shade200,
              child: ListView(
                children: [
                  _akun(),

                  _dataDukung(),
                  _version(),
                  // _buttoneditAkun(),
                ],
              ),
            ),
    );
  }

  Widget _version() {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _versiontext(),
              _listversion(),
              // _dividerHeight1(),
              // _nipatasan(),
              // _dividerHeight1(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listversion() {
    return ListTile(
      onLongPress: () {
        Navigator.pushNamed(context, '/Version');
      },
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.numbers,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Versi Aplikasi",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: Text(
        _packageInfo.version.toString(),
        style: const TextStyle(
          fontSize: 14,
          // fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _versiontext() {
    return Container(
      padding: const EdgeInsets.only(
        top: 10.0,
        bottom: 0.0,
        left: 10.0,
        right: 10.0,
      ),
      child: const Text(
        "Info Aplikasi",
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _paddingtop01() {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.01,
      ),
    );
  }

  Widget _listDataDukung() {
    return SizedBox(
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: dataDukungJSON.length > 0 ? dataDukungJSON.length : 1,
        itemBuilder: (context, i) {
          if (dataDukungJSON.length <= 0) {
            return Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 150.0, vertical: 15.0),
                      child: Icon(Icons.post_add,
                          size: 50.0, color: Colors.grey[350]),
                    ),
                    Text(
                      "Belum ada data dukung",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey[350],
                      ),
                    ),
                    _paddingtop01(),
                    _paddingtop01(),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 1.0,
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailGaleriWarga(
                          dGambar: dataDukungJSON[i]["file"],
                          dJudul: dataDukungJSON[i]["nama"],
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 15.0),
                        width: 90.0,
                        height: 70.0,
                        child: CachedNetworkImage(
                          imageUrl: dataDukungJSON[i]["file"],
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/load.png",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          fit: BoxFit.cover,
                          height: 150.0,
                          width: 110.0,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(
                              right: 10.0,
                              // top: 5.0,
                            ),
                            child: Text(
                              dataDukungJSON[i]["nama"],
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "Klik untuk melihat",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ],
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
        },
      ),
    );
  }

  // Widget _buttoneditAkun() {
  //   MediaQueryData mediaQueryData = MediaQuery.of(this.context);
  //   return SizedBox(
  //     width: mediaQueryData.size.width,
  //     height: mediaQueryData.size.height * 0.07,
  //     child: ElevatedButton(
  //       onPressed: () async {},
  //       child: const Text(
  //         'EDIT',
  //         style: TextStyle(
  //             fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
  //       ),
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.green,
  //         elevation: 0,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         textStyle: const TextStyle(
  //           color: titleText,
  //           fontSize: 30,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: loadingdata ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _akun() {
    return Container(
      padding: const EdgeInsets.all(3),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _akunText(),
                      _dividerHeight1(),
                      _namaAkun(),
                      _dividerHeight1(),
                      _emailAkun(),
                      _dividerHeight1(),
                      _hpAkun(),
                      _dividerHeight1(),
                      _usernameAkun(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dataDukung() {
    return Container(
      padding: const EdgeInsets.all(3),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _dataDukungText(),
                      _dividerHeight1(),
                      _listDataDukung(),
                      // _namaAkun(),
                      // _dividerHeight1(),
                      // _emailAkun(),
                      // _dividerHeight1(),
                      // _hpAkun(),
                      // _dividerHeight1(),
                      // _usernameAkun(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _akunText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Akun",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          iconSize: 23.0,
          onPressed: () async {
            Navigator.pushNamed(context, '/FormEditWarga')
                .then((value) => detailAkunWarga());
          },
        )
      ],
    );
  }

  Widget _dataDukungText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Data Dukung",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add_box_rounded),
          color: Colors.brown[800],
          iconSize: 25.0,
          onPressed: () {
            Navigator.pushNamed(context, '/HalLengkapiDokumenWarga')
                .then((value) => detailDataDukung());
          },
        ),
      ],
    );
  }

  Widget _dividerHeight1() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _namaAkun() {
    return ListTile(
      // dense: true,
      // visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Nama",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: nama == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$nama",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget _emailAkun() {
    return ListTile(
      // dense: true,
      // visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.mail,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Email",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: nama == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$email",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget _hpAkun() {
    return ListTile(
      // dense: true,
      // visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.phone_android,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Hp",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: nama == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$hp",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget _usernameAkun() {
    return ListTile(
      // dense: true,
      // visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Username",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: nama == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$username",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
    );
  }
}
