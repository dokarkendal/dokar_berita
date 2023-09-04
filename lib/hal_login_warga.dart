import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HalDaftarWarga extends StatefulWidget {
  const HalDaftarWarga({super.key});

  @override
  State<HalDaftarWarga> createState() => _HalDaftarWargaState();
}

class _HalDaftarWargaState extends State<HalDaftarWarga> {
  Future _loginWarga() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(
      () {
        _isInAsyncCall = true;
      },
    );
    Future.delayed(Duration(seconds: 1), () async {
      final response = await http.post(
          Uri.parse(
              "http://dokar.kendalkab.go.id/webservice/android/login/warga"),
          body: {
            "username": userwarga.text,
            "password": passwarga.text,
          });
      var loginwargaJSON = json.decode(response.body);
      if (loginwargaJSON[0]['notif'] == 'Sukses') {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool("_isLoggedIn", true);
        String userStatus = 'Warga';
        setState(() {
          _isInAsyncCall = false;
          pref.setString('userStatus', userStatus);
          pref.setString("uid", loginwargaJSON[0]["uid"]);
          pref.setString("nama", loginwargaJSON[0]["nama"]);
          pref.setString("hp", loginwargaJSON[0]["hp"]);
          pref.setString("email", loginwargaJSON[0]["email"]);
          pref.setString("user_name", loginwargaJSON[0]["user_name"]);
          pref.setString("status", loginwargaJSON[0]["status"]);
          pref.setString("id_desa", loginwargaJSON[0]["id_desa"]);
          pref.setString("nama_desa", loginwargaJSON[0]["nama_desa"]);
          pref.setString("kode_kecamatan", loginwargaJSON[0]["kode_kecamatan"]);
          pref.setString("nama_kecamatan", loginwargaJSON[0]["nama_kecamatan"]);
          pref.setString("kode_kota", loginwargaJSON[0]["kode_kota"]);
          pref.setString("nama_kota", loginwargaJSON[0]["nama_kota"]);
          pref.setString("active", loginwargaJSON[0]["active"]);
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/HalDashboardWarga', ModalRoute.withName('/HalDashboardWarga'));
        });
        print(loginwargaJSON);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       loginwargaJSON[0]['notif'],
        //       style: TextStyle(color: Colors.white),
        //     ),
        //     backgroundColor: Colors.green,
        //     action: SnackBarAction(
        //       label: 'OK',
        //       textColor: Colors.white,
        //       onPressed: () {
        //         print('ULANGI snackbar');
        //       },
        //     ),
        //   ),
        // );
      } else {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool("_isLoggedIn", false);
        setState(() {
          _isInAsyncCall = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              loginwargaJSON[0]['notif'],
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'ULANGI',
              textColor: Colors.white,
              onPressed: () {
                print('ULANGI snackbar');
              },
            ),
          ),
        );
      }
    });
  }

  //NOTE Toogle password hide
  void _toggle() {
    setState(
      () {
        _obscureText = !_obscureText;
      },
    );
  }

  TextEditingController userwarga = TextEditingController();
  TextEditingController passwarga = TextEditingController();
//NOTE Boolean
// ignore: unused_field
  bool _isLoggedIn = false;
  bool _isInAsyncCall = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 1,
        color: Theme.of(context).primaryColor,
        progressIndicator: Padding(
          padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.4),
          child: Column(
            children: [
              SpinKitThreeBounce(color: Color(0xFF2e2e2e)),
              SizedBox(height: mediaQueryData.size.height * 0.05),
              Text(
                "Sedang diproses. Harap bersabar ya",
                style: TextStyle(
                    color: Color(0xFF2e2e2e),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )
            ],
          ),
        ),
        child: Center(
          child: Stack(
            children: [
              _logo(),
              Padding(
                padding:
                    EdgeInsets.only(top: mediaQueryData.size.height * 0.15),
                child: _textjudul(),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[50],
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: mediaQueryData.size.height * 0.02,
                    right: mediaQueryData.size.height * 0.02,
                    bottom: mediaQueryData.size.height * 0.04,
                    // top: mediaQueryData.size.height * 0.01,
                  ),
                  child: Container(
                    child: ListView(
                      children: [
                        _formUsernameWarga(),
                        _paddingtop02(),
                        _formPasswordWarga(),
                        _tombolLupaPassword(),
                        _paddingtop01(),
                        _tombolLoginWarga(),
                        _paddingtop02(),
                        _privacyWarga(),
                        _paddingtop02(),
                        _paddingtop02(),
                        _paddingtop02(),
                        _daftarWarga(),
                        _paddingtop02(),
                        _lanjutWarga(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _daftarWarga() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Belum punya akun? "),
          Padding(
            padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.01),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/HalLoginWarga');
            },
            child: Text(
              "Daftar",
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

  Widget _lanjutWarga() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Lanjut tanpa mendaftar "),
          Padding(
            padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.01),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/HalamanBeritaWarga');
            },
            child: Icon(
              Icons.arrow_circle_right_outlined,
              color: Colors.blue[800],
            ),
          )
        ],
      ),
    );
  }

  Widget _privacyWarga() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Dengan login, saya menyetujui"),
          Padding(
            padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.01),
          ),
          GestureDetector(
            onTap: () async {
              //LINK Privacy dokar
              final Uri url =
                  Uri.parse('https://dokar.kendalkab.go.id/privacy');
              if (!await launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              )) {
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

  Widget _tombolLoginWarga() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: mediaQueryData.size.height * 0.07,
      child: ElevatedButton(
        onPressed: () {
          _loginWarga();
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(15.0),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.brown[800],
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _tombolLupaPassword() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () async {
          //LINK Whatsapp Link
          final Uri url = Uri.parse('https://t.me/c/1836747029/60');
          if (!await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          )) {
            throw 'Could not launch $url';
          }
        },
        child: Text(
          'Lupa Password?',
          style: TextStyle(
            color: Colors.brown[800],
          ),
        ),
      ),
    );
  }

  Widget _formPasswordWarga() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextFormField(
              controller: passwarga,
              obscureText: _obscureText,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.brown[800],
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  color: Colors.brown[800],
                  iconSize: 20.0,
                  onPressed: _toggle,
                ),
                hintText: 'Masukan Password',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paddingtop02() {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.02,
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

  Widget _formUsernameWarga() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: userwarga,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.brown[800],
                ),
                hintText: 'Masukan Username',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
        ],
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
          // top: mediaQueryData.size.height * 0.010,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AutoSizeText(
              "Login Warga",
              minFontSize: 16,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
                color: Colors.brown[800],
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
