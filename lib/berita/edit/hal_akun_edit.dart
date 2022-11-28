//ANCHOR package edit berita
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'package:flutter/material.dart';
import 'package:dokar_aplikasi/style/constants.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http; //api
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:path/path.dart'; //upload gambar path
import 'package:shared_preferences/shared_preferences.dart'; //save session
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:status_alert/status_alert.dart';
import '../../style/styleset.dart';

//ANCHOR class form berita edit
class FormAkunEdit extends StatefulWidget {
  final String nama;
  FormAkunEdit({this.nama});
  @override
  FormAkunEditState createState() => FormAkunEditState();
}

class FormAkunEditState extends State<FormAkunEdit> {
//ANCHOR variable
  final FocusNode _focusNode = FocusNode();
  bool _isInAsyncCall = false;
  bool loadingdata = false;
  String nama;
  String email;
  String hp;
  String username;
  bool _obscureText = true;
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//ANCHOR controller
  TextEditingController cNama = TextEditingController();
  TextEditingController cEmail = TextEditingController();
  TextEditingController cHp = TextEditingController();
  TextEditingController cUsername = TextEditingController();
  TextEditingController cPassword = TextEditingController();

  // ignore: missing_return
  Future<List> _editakun() async {
    setState(
      () {
        _isInAsyncCall = true;
      },
    );
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse("http://dokar.kendalkab.go.id/webservice/android/account/edit"),
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
    setState(() {
      loadingdata = true;
    });
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/account/detail"),
        body: {
          "IdAdmin": pref.getString("IdAdmin"),
        });
    var detailakun = json.decode(response.body);

    if (mounted) {
      setState(
        () {
          setState(() {
            loadingdata = false;
          });
          cNama = TextEditingController(text: detailakun['nama']);
          cEmail = TextEditingController(text: detailakun['email']);
          cHp = TextEditingController(text: detailakun['hp']);
          cUsername = TextEditingController(text: detailakun['username']);
        },
      );
    }

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

//ANCHOR loading
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

//ANCHOR Body edit berita
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          "EDIT AKUN",
          style: TextStyle(
            color: appbarTitle,
            // fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: loadingdata
          ? _buildProgressIndicator()
          : ModalProgressHUD(
              inAsyncCall: _isInAsyncCall,
              opacity: 0.5,
              progressIndicator: CircularProgressIndicator(),
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
//ANCHOR judul berita edit
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: kBoxDecorationStyle2,
                            height: 60.0,
                            child: TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
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
                                hintText: loadingdata ? "Memuat.." : "Username",
                                hintStyle: kHintTextStyle2,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: kBoxDecorationStyle2,
                            height: 60.0,
                            child: TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(13)
                              ],
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
                                hintText: loadingdata ? "Memuat.." : 'Hp',
                                hintStyle: kHintTextStyle2,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
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
                                hintText: loadingdata ? "Memuat.." : 'Email',
                                hintStyle: kHintTextStyle2,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
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
                                hintText: loadingdata ? "Memuat.." : 'Username',
                                hintStyle: kHintTextStyle2,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
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
                                hintText: loadingdata ? "Memuat.." : 'Password',
                                hintStyle: kHintTextStyle2,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            width: mediaQueryData.size.width,
                            height: mediaQueryData.size.height * 0.03,
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0.0, 3.0),
                                    blurRadius: 15.0)
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "* Kosongi 'Password' jika tidak ingin mengubahnya",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
//NOTE tombol upload edit berita
                          loadingdata
                              ? Container()
                              : Container(
                                  width: mediaQueryData.size.width,
                                  child: ElevatedButton.icon(
                                    icon: Icon(
                                      Icons.sync,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      "SIMPAN",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    onPressed: () async {
                                      // if (cNama.text == null || cNama.text == '') {
                                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      //     content: Text(
                                      //       'Nama wajib di isi.',
                                      //       style: TextStyle(color: Colors.white),
                                      //     ),
                                      //     backgroundColor: Colors.orange[700],
                                      //     action: SnackBarAction(
                                      //       label: 'ULANGI',
                                      //       textColor: Colors.white,
                                      //       onPressed: () {
                                      //         print('ULANGI snackbar');
                                      //       },
                                      //     ),
                                      //   ));
                                      //   // SnackBar snackBar =
                                      //   //     scaffoldKey.currentState.showSnackBar(snackBar);
                                      // } else if (cUsername.text == null ||
                                      //     cUsername.text == '') {
                                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      //     content: Text(
                                      //       'Username wajib di isi.',
                                      //       style: TextStyle(color: Colors.white),
                                      //     ),
                                      //     backgroundColor: Colors.orange[700],
                                      //     action: SnackBarAction(
                                      //       label: 'ULANGI',
                                      //       textColor: Colors.white,
                                      //       onPressed: () {
                                      //         print('ULANGI snackbar');
                                      //       },
                                      //     ),
                                      //   ));

                                      //   // scaffoldKey.currentState.showSnackBar(snackBar);
                                      // } else {
                                      //   _editakun();
                                      // }
                                      FocusScope.of(context).unfocus();
                                      Dialogs.bottomMaterialDialog(
                                        msg:
                                            "Anda akan logout dan harus login kembali",
                                        title: "UPDATE DATA USER?",
                                        color: Colors.white,
                                        lottieBuilder: Lottie.asset(
                                          'assets/animation/akun.json',
                                          fit: BoxFit.contain,
                                          // repeat: false,
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
                                            textStyle: const TextStyle(
                                                color: Colors.grey),
                                            iconColor: Colors.grey,
                                          ),
                                          IconsButton(
                                            onPressed: () async {
                                              if (cNama.text == null ||
                                                  cNama.text == '') {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                    'Nama wajib di isi.',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor:
                                                      Colors.orange[700],
                                                  action: SnackBarAction(
                                                    label: 'ULANGI',
                                                    textColor: Colors.white,
                                                    onPressed: () {
                                                      print('ULANGI snackbar');
                                                    },
                                                  ),
                                                ));
                                                // SnackBar snackBar =
                                                //     scaffoldKey.currentState.showSnackBar(snackBar);
                                              } else if (cUsername.text ==
                                                      null ||
                                                  cUsername.text == '') {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                    'Username wajib di isi.',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor:
                                                      Colors.orange[700],
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
                                                Navigator.pop(context);
                                                _editakun();
                                              }
                                            },
                                            text: 'Simpan',
                                            iconData: Icons.sync,
                                            color: Colors.green,
                                            textStyle: const TextStyle(
                                                color: Colors.white),
                                            iconColor: Colors.white,
                                          ),
                                        ],
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(15.0),
                                      backgroundColor: Colors.green,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // <-- Radius
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
            ),
    );
  }
}
