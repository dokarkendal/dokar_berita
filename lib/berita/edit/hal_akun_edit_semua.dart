//ANCHOR package akun edit semua
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
// import 'package:dokar_aplikasi/style/constants.dart';
import 'package:http/http.dart' as http; //api
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart'; //save session
// import 'package:status_alert/status_alert.dart';

import '../../style/styleset.dart';

//ANCHOR class akun edit semua
class FormAkunEditSemua extends StatefulWidget {
  final String dIdAdmin, dNama, dHp, dEmail, dUsername, dPassword, dStatus;

  FormAkunEditSemua({
    required this.dIdAdmin,
    required this.dNama,
    required this.dHp,
    required this.dEmail,
    required this.dUsername,
    required this.dPassword,
    required this.dStatus,
  });
  @override
  FormAkunEditSemuaState createState() => FormAkunEditSemuaState();
}

class FormAkunEditSemuaState extends State<FormAkunEditSemua> {
//ANCHOR variable akun edit semua

  String username = "";
  String dIdAdmin = "";
  var _mySelection;
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
          username = pref.getString("userAdmin")!;
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
  Future<void> _editakun() async {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    setState(
      () {
        _isInAsyncCall = true;
      },
    );
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/account/editpenulisadmin"),
      headers: {
        "Key": "VmZNRWVGTjhFeVptSUFJcjdURDlaQT09",
      },
      body: {
        "IdAdmin": "${widget.dIdAdmin}",
        "IdDesa": pref.getString("IdDesa"),
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
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
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
                  "Edit pengguna sukses",
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
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/ListPenulis', ModalRoute.withName('/Haldua'));
      // StatusAlert.show(
      //   this.context,
      //   duration: Duration(seconds: 2),
      //   title: 'Sukses',
      //   subtitle: "Edit Berhasil",
      //   configuration: IconConfiguration(icon: Icons.done),
      // );
    } else {
      print("Failed");
      setState(
        () {
          _isInAsyncCall = false;
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
                Icons.warning,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(
                width: mediaQueryData.size.width * 0.02,
              ),
              Flexible(
                child: Text(
                  "Edit gagal",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'ULANGI',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/ListPenulis', ModalRoute.withName('/Haldua'));
      // StatusAlert.show(
      //   this.context,
      //   duration: Duration(seconds: 2),
      //   title: 'Failed',
      //   subtitle: "Edit Gagal.",
      //   configuration: IconConfiguration(icon: Icons.cancel),
      // );
    }
  }

//ANCHOR Body akun edit semua
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          'EDIT PENGELOLA',
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
            // fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
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
                    // decoration: kBoxDecorationStyle2,
                    decoration: decorationTextField,
                    // height: 60.0,
                    child: TextFormField(
                      maxLines: null,
                      controller: dNama,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.black,
                        // fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        border: decorationBorder,
                        // contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: Icon(
                          Icons.text_fields,
                          color: Colors.grey[600],
                        ),
                        hintText: 'Nama',
                        hintStyle: decorationHint,
                      ),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 10.0),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: decorationTextField,
                    // height: 60.0,
                    child: TextFormField(
                      controller: dHp,
                      maxLines: null,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: Colors.black,
                        // fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        border: decorationBorder,
                        // contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: Icon(
                          Icons.phone_android,
                          color: Colors.grey[600],
                        ),
                        hintText: 'Hp',
                        hintStyle: decorationHint,
                      ),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 10.0),
                  ),
//ANCHOR input link youtube akun edit semua
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: decorationTextField,
                    // height: 60.0,
                    child: TextFormField(
                      controller: dEmail,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.black,
                        // fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        border: decorationBorder,
                        // contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Colors.grey[600],
                        ),
                        hintText: 'Email',
                        hintStyle: decorationHint,
                      ),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 10.0),
                  ),
//ANCHOR gambar berita edit akun edit semua
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: decorationTextField,
                    // height: 60.0,
                    child: TextFormField(
                      controller: dUsername,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.black,
                        // fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        border: decorationBorder,
                        // contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.grey[600],
                        ),
                        hintText: 'Username',
                        hintStyle: decorationHint,
                      ),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 10.0),
                  ),
//NOTE tombol upload edit berita akun edit semua
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: decorationTextField,
                    // height: 60.0,
                    child: TextFormField(
                      controller: dPassword,
                      obscureText: _obscureText,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.black,
                        // fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        border: decorationBorder,
                        // contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.grey[600],
                        ),
                        hintText: 'Password',
                        hintStyle: decorationHint,
                      ),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 10.0),
                  ),
                  new Column(
                    children: <Widget>[
                      Container(
                        // padding: new EdgeInsets.only(left: 20.0),
                        // alignment: Alignment.centerLeft,
                        decoration: decorationTextField,
                        // height: 60.0,
                        child: DropdownButtonFormField(
                          isDense: true,
                          //icon: Icon(Icons.accessibility_new),
                          // underline: SizedBox(),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.admin_panel_settings),
                            border: new OutlineInputBorder(
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
                                _mySelection = newVal as String;
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
                  _isInAsyncCall
                      ? Column(
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
                        )
                      : Container(
                          width: mediaQueryData.size.width,
                          height: mediaQueryData.size.height * 0.07,
                          child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            label: Text(
                              "EDIT PENGGUNA",
                              style: const TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (dNama.text.isEmpty || dNama.text == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                              } else if (dHp.text.isEmpty || dHp.text == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                                ));
                                // scaffoldKey.currentState.showSnackBar(snackBar);
                              } else if (dEmail.text.isEmpty ||
                                  dEmail.text == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                                ));
                                // scaffoldKey.currentState.showSnackBar(snackBar);
                              } else if (dUsername.text.isEmpty ||
                                  dUsername.text == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                              } else {
                                _editakun();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              // padding: EdgeInsets.all(15.0),
                              elevation: 0, backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10), // <-- Radius
                              ),
                            ),
                            // color: Colors.green,
                            // textColor: Colors.white,
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(17.0),
                            // ),
                          ),
                        ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
