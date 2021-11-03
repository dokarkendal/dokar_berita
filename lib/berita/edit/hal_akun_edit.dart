//ANCHOR package edit berita
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'package:flutter/material.dart';
import 'package:dokar_aplikasi/style/constants.dart';
import 'package:http/http.dart' as http; //api
import 'package:path/path.dart'; //upload gambar path
import 'package:shared_preferences/shared_preferences.dart'; //save session
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:status_alert/status_alert.dart';

//ANCHOR class form berita edit
class FormAkunEdit extends StatefulWidget {
  final String nama;
  FormAkunEdit({this.nama});
  @override
  FormAkunEditState createState() => FormAkunEditState();
}

class FormAkunEditState extends State<FormAkunEdit> {
//ANCHOR variable

  bool _isInAsyncCall = false;

  String nama;
  String email;
  String hp;
  String username;
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
  Future<List> _editakun() async {
    setState(
      () {
        _isInAsyncCall = true;
      },
    );

    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
      "http://dokar.kendalkab.go.id/webservice/android/account/edit",
      body: {
        "IdAdmin": pref.getString("IdAdmin"),
        "nama": cNama.text,
        "email": cEmail.text,
        "hp": cHp.text,
        "username": cUsername.text,
        "password": cPassword.text,
      },
    );
    var datauser = json.decode(response.body);
    print(datauser);
    if (response.statusCode == 200) {
      pref.clear();
      int launchCount = 0;
      pref.setInt('counter', launchCount + 1);
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/PilihAkun', ModalRoute.withName('/DaftarAdmin'));
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Sukses',
        subtitle: "Akun berhasil di edit.",
        configuration: IconConfiguration(icon: Icons.check),
      );
    } else {
      print("Failed");
      setState(
        () {
          _isInAsyncCall = false;
        },
      );
      Navigator.of(this.context)
          .pushNamedAndRemoveUntil('/HalAkun', ModalRoute.withName('/Haldua'));
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Failed',
        subtitle: "Edit Gagal.",
        configuration: IconConfiguration(icon: Icons.cancel),
      );
    }
  }

  // ignore: missing_return
  Future<String> detailAkun(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        "http://dokar.kendalkab.go.id/webservice/android/account/detail",
        body: {
          "IdAdmin": pref.getString("IdAdmin"),
        });
    var detailakun = json.decode(response.body);

    setState(
      () {
        cNama = new TextEditingController(text: detailakun['nama']);
        cEmail = new TextEditingController(text: detailakun['email']);
        cHp = new TextEditingController(text: detailakun['hp']);
        cUsername = new TextEditingController(text: detailakun['username']);
      },
    );

    print(detailakun);
  }

//ANCHOR Controller edit berita
  @override
  void initState() {
    super.initState();
    detailAkun(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

//ANCHOR Body edit berita
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Form edit akun'),
        backgroundColor: Color(0xFFee002d),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
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
//ANCHOR judul berita edit
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
                          hintText: "Username",
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
                        keyboardType: TextInputType.emailAddress,
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
//NOTE tombol upload edit berita
                    RaisedButton.icon(
                      icon: Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      label: Text("SIMPAN"),
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
                        } else {
                          _editakun();
                        }
                      },
                      color: Colors.green,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17.0),
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
