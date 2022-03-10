//ANCHOR package add akun
// ignore_for_file: deprecated_member_use

import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'package:flutter/material.dart';
import 'package:dokar_aplikasi/style/constants.dart';
import 'package:http/http.dart' as http; //api
import 'package:shared_preferences/shared_preferences.dart'; //save session
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:status_alert/status_alert.dart';

//ANCHOR class add akun
class FormAddAkun extends StatefulWidget {
  final String nama;
  FormAddAkun({this.nama});
  @override
  FormAddAkunState createState() => FormAddAkunState();
}

class FormAddAkunState extends State<FormAddAkun> {
//ANCHOR add akun

  bool _isInAsyncCall = false;

  String nama;
  String email;
  String hp;
  String username;
  String _mySelection;
  String _notif;
  String _kode;
  bool _obscureText = true;

  final formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//ANCHOR controller
  TextEditingController cNama = new TextEditingController();
  TextEditingController cEmail = new TextEditingController();
  TextEditingController cHp = new TextEditingController();
  TextEditingController cUsername = new TextEditingController();
  TextEditingController cPassword = new TextEditingController();

  // ignore: missing_return
  Future<List> _login() async {
    setState(
      () {
        _isInAsyncCall = true;
      },
    );

    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        "http://dokar.kendalkab.go.id/webservice/android/account/tambahpenulis",
        body: {
          "IdDesa": pref.getString("IdDesa"),
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
        _kode = datauser['Kode'];
      },
    );

    if (_kode == 'Success') {
      print("Succes");
      setState(
        () {
          _isInAsyncCall = false;
        },
      );
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/ListPenulis', ModalRoute.withName('/Haldua'));
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Sukses',
        subtitle: _notif,
        configuration: IconConfiguration(icon: Icons.done),
      );
    } else {
      print("Failed");
      setState(
        () {
          _isInAsyncCall = false;
        },
      );
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/ListPenulis', ModalRoute.withName('/Haldua'));
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Failed',
        subtitle: _notif,
        configuration: IconConfiguration(icon: Icons.cancel),
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
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Tambah penulis',
          style: TextStyle(
            color: Color(0xFF2e2e2e),
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.5,
        progressIndicator:
            CircularProgressIndicator(backgroundColor: Colors.red),
        child: ListView(
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR nama add akun
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: TextFormField(
                        controller: cNama,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.text_fields,
                            color: Colors.grey[600],
                          ),
                          hintText: "Nama",
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: TextFormField(
                        controller: cHp,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Hp',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: TextFormField(
                        controller: cEmail,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Email',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: TextFormField(
                        controller: cUsername,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Username',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: TextFormField(
                        controller: cPassword,
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Password',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
                    new Column(
                      children: <Widget>[
                        Container(
                          padding: new EdgeInsets.only(left: 20.0),
                          alignment: Alignment.centerLeft,
                          decoration: kBoxDecorationStyle2,
                          height: 60.0,
                          child: DropdownButton<String>(
                            //icon: Icon(Icons.accessibility_new),
                            underline: SizedBox(),
                            hint: Text('Pilih status'),
                            isExpanded: true,
                            items: <String>[
                              'Admin',
                              'Penulis',
                            ].map(
                              (String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              },
                            ).toList(),
                            onChanged: (newVal) {
                              setState(
                                () {
                                  _mySelection = newVal;
                                },
                              );
                            },
                            value: _mySelection,
                          ),
                        )
                      ],
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//NOTE tombol upload add akun
                    Container(
                      width: mediaQueryData.size.width,
                      height: mediaQueryData.size.height * 0.07,
                      child: RaisedButton.icon(
                        icon: Icon(
                          Icons.person_add,
                          color: Colors.white,
                        ),
                        label: Text("TAMBAH"),
                        onPressed: () async {
                          if (cNama.text == null || cNama.text == '') {
                            SnackBar snackBar = SnackBar(
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
                            );
                            scaffoldKey.currentState.showSnackBar(snackBar);
                          } else if (cUsername.text == null ||
                              cUsername.text == '') {
                            SnackBar snackBar = SnackBar(
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
                            );
                            scaffoldKey.currentState.showSnackBar(snackBar);
                          } else if (cPassword.text == null ||
                              cPassword.text == '') {
                            SnackBar snackBar = SnackBar(
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
                            );
                            scaffoldKey.currentState.showSnackBar(snackBar);
                          } else if (_mySelection == null) {
                            SnackBar snackBar = SnackBar(
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
                            );
                            scaffoldKey.currentState.showSnackBar(snackBar);
                          } else {
                            _login();
                          }
                        },
                        color: Colors.green,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17.0),
                        ),
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
