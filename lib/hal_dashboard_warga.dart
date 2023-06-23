import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'style/styleset.dart';

class HalDashboardWarga extends StatefulWidget {
  const HalDashboardWarga({super.key});

  @override
  State<HalDashboardWarga> createState() => _HalDashboardWargaState();
}

class _HalDashboardWargaState extends State<HalDashboardWarga> {
  String nama = "";
  String namadesa = "";
  String lengkap = "";
  // ignore: unused_field
  bool _isLoggedIn = false;
  TextEditingController uID = TextEditingController();

  Future _cekKelengkapan() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = true;
    });
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/account/DatawargabyUid"),
        body: {
          "uid": pref.getString("uid")!,
        });
    var cekData = json.decode(response.body);
    print(cekData);
    if (cekData["Status"] == "Lengkap") {
      setState(() {
        _isLoggedIn = false;
        lengkap = cekData["Status"];
      });
    } else {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  Future _cekUserWarga() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getString("uid") != null) {
      setState(() {
        nama = pref.getString("nama")!;
        namadesa = pref.getString("nama_desa")!;
      });
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cekUserWarga();
    _cekKelengkapan();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.account_circle),
          color: appbarIcon,
          iconSize: 25.0,
          onPressed: () {
            // Navigator.pushNamed(context, '/HalAkun');
          },
        ),
        centerTitle: true,
        title: Text(
          "DOKAR ",
          style: TextStyle(
            color: appbarTitle,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
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
            },
          )
        ],
      ),
      body: _isLoggedIn == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                _header(),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: lengkap == "Lengkap"
                        ? _cardlengkap()
                        : _cardbelumlengkap()),
              ],
              // child: Column(
              //   children: [
              //     Stack(
              //       children: <Widget>[
              //         ClipPath(
              //           clipper: CustomShapeClipper(),
              //           child: Container(
              //             height: mediaQueryData.size.height * 0.4,
              //             decoration: BoxDecoration(
              //               color: Theme.of(context).primaryColor,
              //             ),
              //           ),
              //         ),
              //         Padding(
              //           padding: EdgeInsets.all(mediaQueryData.size.height * 0.03),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: <Widget>[
              //               Column(
              //                 mainAxisSize: MainAxisSize.min,
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: <Widget>[
              //                   Row(
              //                     children: [
              //                       AutoSizeText(
              //                         "Hai " + nama,
              //                         minFontSize: 14,
              //                         style: TextStyle(
              //                           color: Color(0xFF2e2e2e),
              //                           fontSize: 22.0,
              //                           fontWeight: FontWeight.bold,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                   // SizedBox(height: 10.0),
              //                   Text(
              //                     nip,
              //                     style: TextStyle(
              //                       color: Color(0xFF2e2e2e),
              //                       fontSize: 18.0,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     )
              //   ],
              // ),
            ),
    );
  }

  Widget _cardbelumlengkap() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.all(15.0),
      height: mediaQueryData.size.height * 0.2,
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0.0, 5.0),
              blurRadius: 7.0),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Silahkan lengkapi data diri Anda",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
              )
            ],
          ),
          _paddingTop1(),
          Text(
            "Untuk dapat menggunakan layanan surat, anda harus melengkapi data diri dan informasi terkait identitas anda",
            style: TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          _paddingTop1(),
          _paddingTop1(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buttonDataDiri(),
              _buttonDokumen(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardlengkap() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.all(15.0),
      height: mediaQueryData.size.height * 0.07,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0.0, 5.0),
              blurRadius: 7.0),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Data anda lengkap",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Icon(
                Icons.check_circle_sharp,
                color: Colors.white,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttonDataDiri() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: mediaQueryData.size.width * 0.42,
      height: mediaQueryData.size.height * 0.06,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/HalLengkapiDataWarga');
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(15.0),
          backgroundColor: Colors.white,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),
        child: Text(
          'DATA DIRI',
          style: TextStyle(
            color: Colors.deepOrange,
            letterSpacing: 1.5,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buttonDokumen() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: mediaQueryData.size.width * 0.42,
      height: mediaQueryData.size.height * 0.06,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/HalLengkapiDokumenWarga');
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(15.0),
          backgroundColor: Colors.white,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),
        child: Text(
          'DOKUMEN',
          style: TextStyle(
            color: Colors.deepOrange,
            letterSpacing: 1.5,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _paddingTop1() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
    );
  }

  Widget _header() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        // boxShadow: [
        //   BoxShadow(
        //       color: Colors.black.withOpacity(0.1),
        //       offset: const Offset(0.0, 1.0),
        //       blurRadius: 3.0),
        // ],
      ),
      child: Stack(
        // clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: mediaQueryData.size.width,
            height: mediaQueryData.size.height * 0.1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: mediaQueryData.size.height * 0.045,
              horizontal: mediaQueryData.size.width * 0.07,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  "Hai " + nama,
                  minFontSize: 14,
                  style: TextStyle(
                    color: Color(0xFF2e2e2e),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AutoSizeText(
                  namadesa,
                  minFontSize: 14,
                  style: TextStyle(
                    color: Color(0xFF2e2e2e),
                    fontSize: 18.0,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            // top: mediaQueryData.size.height * 0.05,
            left: mediaQueryData.size.height * 0.2,
            child: Image.asset(
              'assets/images/orang1.png',
              width: mediaQueryData.size.height * 0.35,
              height: mediaQueryData.size.width * 0.35,
            ),
          ),
        ],
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
