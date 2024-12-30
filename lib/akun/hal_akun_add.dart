//ANCHOR package add akun
// ignore_for_file: deprecated_member_use

import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //api
import 'package:shared_preferences/shared_preferences.dart'; //save session
import '../style/styleset.dart';

//ANCHOR class add akun
class FormAddAkun extends StatefulWidget {
  final String nama;
  FormAddAkun({required this.nama});
  @override
  FormAddAkunState createState() => FormAddAkunState();
}

class FormAddAkunState extends State<FormAddAkun> {
//ANCHOR add akun

  late String nama;
  late String email;
  late String hp;
  late String username;
  var _mySelection;
  late String _notif;
  late String _kode;
  bool _obscureText = true;
  bool _loadingberita = false;

  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//ANCHOR controller
  TextEditingController cNama = TextEditingController();
  TextEditingController cEmail = TextEditingController();
  TextEditingController cHp = TextEditingController();
  TextEditingController cUsername = TextEditingController();
  TextEditingController cPassword = TextEditingController();

//NOTE Toogle password hide
  void _toggle() {
    setState(
      () {
        _obscureText = !_obscureText;
      },
    );
  }

  Future<void> _login() async {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    setState(
      () {
        _loadingberita = true;
      },
    );
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/account/tambahpenulisadmin"),
        headers: {
          "Key": "VmZNRWVGTjhFeVptSUFJcjdURDlaQT09"
        },
        body: {
          "IdDesa": pref.getString("IdDesa"),
          "uid": pref.getString("IdAdmin"),
          "nama": cNama.text,
          "email": cEmail.text,
          "hp": cHp.text,
          "username": cUsername.text,
          "password": cPassword.text,
          "status": _mySelection,
        });
    var datauser = json.decode(response.body);
    print(datauser);
    setState(
      () {
        _notif = datauser['Notif'];
        _kode = datauser['Status'];
      },
    );

    if (_kode == 'Sukses') {
      print("Succes");
      setState(
        () {
          _loadingberita = false;
          // _isInAsyncCall = false;
        },
      );
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          elevation: 6.0,
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.done,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(
                width: mediaQueryData.size.width * 0.02,
              ),
              Flexible(
                child: Text(
                  _notif,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              // Navigator.pushReplacementNamed(context, '/HalDashboard');
            },
          ),
        ),
      );
      await Future.delayed(
        Duration(seconds: 2),
        () {
          Navigator.pop(this.context);
        },
      );
    } else {
      print("Failed");
      setState(
        () {
          _loadingberita = false;
          // _isInAsyncCall = false;
        },
      );
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          elevation: 6.0,
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.done,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(
                width: mediaQueryData.size.width * 0.02,
              ),
              Flexible(
                child: Text(
                  _notif,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'ULANGI',
            textColor: Colors.white,
            onPressed: () {
              // Navigator.pushReplacementNamed(context, '/HalDashboard');
            },
          ),
        ),
      );
    }
  }

//ANCHOR Controller add akun
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

//ANCHOR Body add akun
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: _appbartambahpenulis(),
      body: ListView(
        children: <Widget>[
          Container(
            padding: paddingall10,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _namapengelola(),
                  _padding10(),
                  _nohp(),
                  _padding10(),
                  _email(),
                  _padding10(),
                  _username(),
                  _padding10(),
                  _password(),
                  _padding10(),
                  _pilihuser(),
                  _padding20(),
                  _loadingberita ? _buttonloading() : _buttontambahuser()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _padding10() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
    );
  }

  Widget _padding20() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
    );
  }

  PreferredSizeWidget _appbartambahpenulis() {
    return AppBar(
      iconTheme: IconThemeData(
        color: appbarIcon,
      ),
      title: Text(
        'TAMBAH PENULIS',
        style: TextStyle(
          color: appbarTitle,
          fontWeight: FontWeight.bold,
          // fontSize: 25.0,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buttonloading() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Column(
      children: [
        SizedBox(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height * 0.07,
          child: ElevatedButton(
            onPressed: () async {},
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                color: titleText,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttontambahuser() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: mediaQueryData.size.width,
      height: mediaQueryData.size.height * 0.07,
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          "TAMBAH USER",
          style: TextStyle(color: subtitle),
        ),
        onPressed: () async {
          if (cNama.text.isEmpty || cNama.text == '') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Nama wajib di isi.',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.orange[700],
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('ULANGI snackbar');
                },
              ),
            ));
            // scaffoldKey.currentState.showSnackBar(snackBar);
          } else if (cUsername.text.isEmpty || cUsername.text == '') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Username wajib di isi.',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.orange[700],
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('ULANGI snackbar');
                },
              ),
            ));
            // scaffoldKey.currentState.showSnackBar(snackBar);
          } else if (cPassword.text.isEmpty || cPassword.text == '') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Password wajib di isi.',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.orange[700],
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('ULANGI snackbar');
                },
              ),
            ));
            // scaffoldKey.currentState.showSnackBar(snackBar);
          } else if (_mySelection == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Pilih Status wajib di isi.',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.orange[700],
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  print('ULANGI snackbar');
                },
              ),
            ));
            // scaffoldKey.currentState.showSnackBar(snackBar);
          } else {
            _login();
          }
        },
        style: ElevatedButton.styleFrom(
          // padding: EdgeInsets.all(15.0),
          elevation: 0, backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),
      ),
    );
  }

  Widget _namapengelola() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: decorationTextField,
      // height: 60.0,
      child: TextFormField(
        controller: cNama,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'OpenSans',
        ),
        decoration: InputDecoration(
          border: decorationBorder,
          // contentPadding: EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            Icons.text_fields,
            color: Colors.grey,
          ),
          hintText: "Nama Pengelola",
          hintStyle: decorationHint,
        ),
      ),
    );
  }

  Widget _nohp() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: decorationTextField,
      // height: 60.0,
      child: TextFormField(
        controller: cHp,
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'OpenSans',
        ),
        decoration: InputDecoration(
          border: decorationBorder,
          // contentPadding: EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            Icons.phone_android,
            color: Colors.grey,
          ),
          hintText: 'No.Hp',
          hintStyle: decorationHint,
        ),
      ),
    );
  }

  Widget _email() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: decorationTextField,
      // height: 60.0,
      child: TextFormField(
        controller: cEmail,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'OpenSans',
        ),
        decoration: InputDecoration(
          border: decorationBorder,
          // contentPadding: EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            Icons.mail,
            color: Colors.grey,
          ),
          hintText: 'Email',
          hintStyle: decorationHint,
        ),
      ),
    );
  }

  Widget _username() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: decorationTextField,
      // height: 60.0,
      child: TextFormField(
        controller: cUsername,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'OpenSans',
        ),
        decoration: InputDecoration(
          border: decorationBorder,
          // contentPadding: EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            Icons.person_outline,
            color: Colors.grey,
          ),
          hintText: 'Username',
          hintStyle: decorationHint,
        ),
      ),
    );
  }

  Widget _password() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: decorationTextField,
      // height: 60.0,
      child: TextFormField(
        controller: cPassword,
        obscureText: _obscureText,
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'OpenSans',
        ),
        decoration: InputDecoration(
          border: decorationBorder,
          // contentPadding: EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.remove_red_eye),
            color: Colors.grey,
            iconSize: 20.0,
            onPressed: _toggle,
          ),
          hintText: 'Password',
          hintStyle: decorationHint,
        ),
      ),
    );
  }

  Widget _pilihuser() {
    return Column(
      children: <Widget>[
        Container(
          // padding: EdgeInsets.only(left: 20.0),
          // alignment: Alignment.centerLeft,
          decoration: decorationTextField,
          // height: 60.0,
          child: DropdownButtonFormField(
            //icon: Icon(Icons.accessibility_),
            // underline: SizedBox(),
            isDense: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.account_circle),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
              // hintText: 'Judul Berita',
              hintStyle: TextStyle(
                fontSize: 15,
                color: Colors.grey[400],
              ),
              // prefixIcon: Icon(
              //   Icons.text_fields,
              //   color: Colors.grey,
              // ),
            ),
            hint: Text('Pilih User'),
            items: <String>[
              'Admin',
              'Penulis',
            ].map(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
            onChanged: (val) {
              setState(
                () {
                  _mySelection = val as String;
                },
              );
            },
            value: _mySelection,
          ),
        )
      ],
    );
  }
}
