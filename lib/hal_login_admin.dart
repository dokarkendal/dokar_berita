//ANCHOR Selesai
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DaftarAdmin extends StatefulWidget {
  // DaftarAdmin({Key key}) : super(key: key);
  @override
  _DaftarAdminState createState() => _DaftarAdminState();
}

class _DaftarAdminState extends State<DaftarAdmin> {
//NOTE Controller
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

//NOTE Variable
  String username = '';
  String userStatus = '';

//NOTE Boolean
  // ignore: unused_field
  bool _isLoggedIn = false;
  bool _isInAsyncCall = false;
  bool _obscureText = true;

//NOTE Inistate
  @override
  void initState() {
    super.initState();
    _cekLogin();
  }

//NOTE Toogle password hide
  void _toggle() {
    setState(
      () {
        _obscureText = !_obscureText;
      },
    );
  }

//NOTE Fungsi Cek Login
  Future _cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_isLoggedIn") == true) {
      _isLoggedIn = true;
      setState(
        () {
          _isInAsyncCall = true;
        },
      );
      Navigator.pushReplacementNamed(context, '/Haldua');
    } else {
      _isLoggedIn = false;
    }
  }

//NOTE Fungsi Login
  Future _login() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(
      () {
        _isInAsyncCall = true;
      },
    );

    Future.delayed(
      Duration(seconds: 1),
      () async {
        final response = await http.post(
            Uri.parse("http://dokar.kendalkab.go.id/webservice/android/login"),
            body: {
              "username": user.text,
              "password": pass.text,
            });
        var datauser = json.decode(response.body);
        if (datauser[0]['notif'] == 'Empty') {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool("_isLoggedIn", false);
          setState(() {
            _isInAsyncCall = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'User dan password perlu diisi',
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
        } else if (datauser[0]['notif'] == 'NoUser') {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool("_isLoggedIn", false);
          setState(
            () {
              _isInAsyncCall = false;
            },
          );
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Username anda salah',
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
          ));
        } else if (datauser[0]['notif'] == 'NoPassword') {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool("_isLoggedIn", false);
          setState(
            () {
              _isInAsyncCall = false;
            },
          );
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Password anda salah',
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
          ));
        } else if (datauser[0]["active"] == "1") {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool("_isLoggedIn", true);
          String userStatus = 'Admin';
          setState(
            () {
              _isInAsyncCall = false;
            },
          );
          setState(
            () {
              pref.setString('userStatus', userStatus);
              pref.setString('userAdmin', datauser[0]['user_name']);
              pref.setString('status', datauser[0]['status']);
              pref.setString('IdAdmin', datauser[0]['no']);
              pref.setString('IdDesa', datauser[0]['id_desa']);
              pref.setString('kecamatan', datauser[0]['data_kecamatan']);
              pref.setString('desa', datauser[0]['data_nama']);
              pref.setString('nama', datauser[0]['nama']);
              pref.setString('hp', datauser[0]['hp']);
              pref.setString('email', datauser[0]['email']);
              pref.setString('active', datauser[0]['active']);
              pref.setString('website', datauser[0]['alamat_website']);
              pref.setString('expired', datauser[0]['expired']);
              pref.setString('desaid', datauser[0]['desa_id']);
              username = datauser[0]['user_name'];
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/Haldua', ModalRoute.withName('/Haldua'));
            },
          );
          print(datauser[0]);
        } else {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool("_isLoggedIn", false);
          setState(
            () {
              _isInAsyncCall = false;
            },
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Akun anda telah nonaktif',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.grey,
              action: SnackBarAction(
                label: 'NON AKTIF',
                textColor: Colors.white,
                onPressed: () {
                  print('ULANGI snackbar');
                },
              ),
            ),
          );
        }
      },
    );
  }

//NOTE Form Username
  Widget _formUsername() {
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
              controller: user,
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

//NOTE Form Password
  Widget _formPassword() {
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
              controller: pass,
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

//NOTE Lupa Password
  Widget _tombolLupaPassword() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () async {
          //LINK Whatsapp Link
          final Uri url = Uri.parse(
              'https://api.whatsapp.com/send?phone=6285726926557&text=Kecamatan%20%3A%0ADesa%20%3A%0A%0AHai%20Admin%2C%20Saya%20lupa%20password%20Dokar');
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

//NOTE Tombol Login
  Widget _tombolLogin() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: mediaQueryData.size.height * 0.07,
      child: ElevatedButton(
        onPressed: () {
          _login();
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

//NOTE Scaffold
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
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
                'Sedang memuat, sabar ya.',
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
            children: <Widget>[
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
                        _formUsername(),
                        Padding(
                          padding: EdgeInsets.only(
                              top: mediaQueryData.size.height * 0.03),
                        ),
                        _formPassword(),
                        _tombolLupaPassword(),
                        Padding(
                          padding: EdgeInsets.only(
                              top: mediaQueryData.size.height * 0.02),
                        ),
                        _tombolLogin(),
                        Padding(
                          padding: EdgeInsets.only(
                              top: mediaQueryData.size.height * 0.02),
                        ),
                        _privacy(),
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

//NOTE Tombol Provacy DOKAR
  Widget _privacy() {
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

//NOTE Header Dokar
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

//NOTE Judul
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
              "Login Admin",
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
