//ANCHOR package akun edit semua
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:dokar_aplikasi/style/constants.dart';
import 'package:http/http.dart' as http; //api
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart'; //save session
import 'package:status_alert/status_alert.dart';

//ANCHOR class akun edit semua
class FormAkunEditSemua extends StatefulWidget {
  final String dIdAdmin, dNama, dHp, dEmail, dUsername, dPassword, dStatus;

  FormAkunEditSemua({
    this.dIdAdmin,
    this.dNama,
    this.dHp,
    this.dEmail,
    this.dUsername,
    this.dPassword,
    this.dStatus,
  });
  @override
  FormAkunEditSemuaState createState() => FormAkunEditSemuaState();
}

class FormAkunEditSemuaState extends State<FormAkunEditSemua> {
//ANCHOR variable akun edit semua

  String username = "";
  String dIdAdmin = "";
  String _mySelection;
  bool _obscureText = true;
  bool _isInAsyncCall = false;
  List kategoriAkun = [];
  final format = DateFormat("yyyy-MM-dd");
  final formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//ANCHOR controller akun edit semua
  TextEditingController dNama = new TextEditingController();
  TextEditingController dHp = new TextEditingController();
  TextEditingController dEmail = new TextEditingController();
  TextEditingController dUsername = new TextEditingController();
  TextEditingController dStatus = new TextEditingController();
  TextEditingController dPassword = new TextEditingController();

//ANCHOR session akun edit semua
  // ignore: unused_element
  Future _cekSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(
        () {
          username = pref.getString("userAdmin");
        },
      );
    }
  }

//ANCHOR Controller akun edit semua
  @override
  void initState() {
    //_editakun();
    dNama = new TextEditingController(text: "${widget.dNama}");
    dHp = new TextEditingController(text: "${widget.dHp}");
    dEmail = new TextEditingController(text: "${widget.dEmail}");
    dUsername = new TextEditingController(text: "${widget.dUsername}");
    dStatus = new TextEditingController(text: "${widget.dStatus}");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ignore: missing_return
  Future<String> _editakun() async {
    setState(
      () {
        _isInAsyncCall = true;
      },
    );
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/account/editpenulis"),
      body: {
        "IdAdmin": "${widget.dIdAdmin}",
        "nama": dNama.text,
        "email": dEmail.text,
        "hp": dHp.text,
        "username": dUsername.text,
        "password": dPassword.text,
        "status": dStatus.text,
        "IdAdminSession": pref.getString("IdAdmin"),
      },
    );
    var detailakun = json.decode(response.body);
    print(detailakun);
    if (response.statusCode == 200) {
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
        subtitle: "Edit Berhasil",
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
        subtitle: "Edit Gagal.",
        configuration: IconConfiguration(icon: Icons.cancel),
      );
    }
  }

//ANCHOR Body akun edit semua
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Form Edit'),
        backgroundColor: Color(0xFFee002d),
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
//ANCHOR judul akun edit semua
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: TextFormField(
                        controller: dNama,
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
                          hintText: 'Nama',
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
                        controller: dHp,
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
//ANCHOR input link youtube akun edit semua
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: TextFormField(
                        controller: dEmail,
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
//ANCHOR gambar berita edit akun edit semua
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: TextFormField(
                        controller: dUsername,
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
//NOTE tombol upload edit berita akun edit semua
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: TextFormField(
                        controller: dPassword,
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
                            hint: Text("${widget.dStatus}"),
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
                    RaisedButton.icon(
                      icon: Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      label: Text("SIMPAN"),
                      onPressed: () async {
                        if (dNama.text == null || dNama.text == '') {
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
                        } else if (dHp.text == null || dHp.text == '') {
                          SnackBar snackBar = SnackBar(
                            content: Text(
                              'Hp wajib di isi.',
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
                        } else if (dEmail.text == null || dEmail.text == '') {
                          SnackBar snackBar = SnackBar(
                            content: Text(
                              'Email wajib di isi.',
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
                        } else if (dUsername.text == null ||
                            dUsername.text == '') {
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
