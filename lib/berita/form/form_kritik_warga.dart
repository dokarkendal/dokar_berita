//ANCHOR package add akun
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'package:dokar_aplikasi/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:dokar_aplikasi/style/constants.dart';
import 'package:http/http.dart' as http; //api
import 'package:shared_preferences/shared_preferences.dart'; //save session
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:status_alert/status_alert.dart';

//ANCHOR class add akun
class FormKritikWarga extends StatefulWidget {
  final String idDesa;

  FormKritikWarga({
    Key key,
    this.idDesa,
  }) : super(key: key);

  //final String nama;
  //FormKritikWarga({this.nama});
  @override
  FormKritikWargaState createState() => FormKritikWargaState();
}

class FormKritikWargaState extends State<FormKritikWarga> {
//ANCHOR add akun

  bool _isInAsyncCall = false;

  String nama;
  String email;
  String judul;
  String kritik;
  // ignore: unused_field
  String _mySelection;
  String _notif;
  // ignore: unused_field
  String _kode;
  //bool _obscureText = true;

  final formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//ANCHOR controller
  TextEditingController cNama = new TextEditingController();
  TextEditingController cEmail = new TextEditingController();
  TextEditingController cjudul = new TextEditingController();
  TextEditingController ckritik = new TextEditingController();
  TextEditingController cPassword = new TextEditingController();

  // ignore: missing_return
  Future<List> _kirimkritik() async {
    setState(
      () {
        _isInAsyncCall = true;
      },
    );

    // ignore: unused_local_variable
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/kritiksaran/add"),
      body: {
        "IdDesa": "${widget.idDesa}",
        "nama": cNama.text,
        "email": cEmail.text,
        "judul": cjudul.text,
        "isi": ckritik.text,
        //"password": cPassword.text,
        //"status": _mySelection,
      },
    );
    var datauser = json.decode(response.body);
    print(datauser);

    if (datauser['Notif'] == 'Berhasil') {
      print("Succes");
      setState(
        () {
          _isInAsyncCall = false;
        },
      );

      Alert(
        context: context,
        type: AlertType.success,
        title: "Berhasil ",
        //desc: datauser["kritik_judul"],
        buttons: [
          DialogButton(
            child: Text(
              "Kembali",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () {
              //hapusberita(databerita[i]["inovasi_id"]);
              Navigator.pop(context);
            },
            color: Colors.green,
          )
        ],
      ).show();
      cNama.clear();
      cEmail.clear();
      cjudul.clear();
      ckritik.clear();
      /*Navigator.pushReplacementNamed(context, '/FormKritikSaran');
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Sukses',
        subtitle: _notif,
        configuration: IconConfiguration(icon: Icons.done),
      );*/
    } else {
      print("Failed");
      setState(
        () {
          _isInAsyncCall = false;
        },
      );
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/FormKritikSaran', ModalRoute.withName('/ProfilDesa'));
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
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Form Kritik dan Saran'),
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
                            Icons.account_circle,
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
                            Icons.alternate_email,
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
                        controller: cjudul,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.title,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Judul',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 200.0,
                      child: TextFormField(
                        controller: ckritik,
                        maxLines: null,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          //contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.library_books,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Kritik dan Saran Anda',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//NOTE tombol upload add akun
                    RaisedButton.icon(
                      icon: Icon(
                        Icons.message,
                        color: Colors.white,
                      ),
                      label: Text("KIRIM"),
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
                        } else if (cEmail.text == null || cEmail.text == '') {
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
                        } else if (cjudul.text == null || cjudul.text == '') {
                          SnackBar snackBar = SnackBar(
                            content: Text(
                              'Judul wajib di isi.',
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
                        } else if (ckritik.text == null || ckritik.text == '') {
                          SnackBar snackBar = SnackBar(
                            content: Text(
                              'Kritik wajib di isi.',
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
                          _kirimkritik();
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
