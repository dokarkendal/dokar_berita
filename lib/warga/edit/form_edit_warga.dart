import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';

import '../../style/styleset.dart'; // api to json

class FormEditWarga extends StatefulWidget {
  const FormEditWarga({super.key});

  @override
  State<FormEditWarga> createState() => _FormEditWargaState();
}

class _FormEditWargaState extends State<FormEditWarga> {
  bool loadingdata = false;
  bool loadingdataedit = false;
  late String nama;
  late String email;
  late String hp;
  late String username;

  TextEditingController cNama = TextEditingController();
  TextEditingController cEmail = TextEditingController();
  TextEditingController cHp = TextEditingController();
  TextEditingController cUsername = TextEditingController();
  TextEditingController cPassword = TextEditingController();

  Future<void> detailAkun() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      loadingdata = true;
    });
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/account/detail"),
        body: {
          "IdAdmin": pref.getString("uid")!,
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

  Future<void> _editakun() async {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    setState(
      () {
        loadingdataedit = true;
      },
    );
    SharedPreferences pref = await SharedPreferences.getInstance();
    Future.delayed(Duration(seconds: 1), () async {
      final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/account/editwarga"),
        body: {
          "uid": pref.getString("uid"),
          "nama": cNama.text,
          "email": cEmail.text,
          "hp": cHp.text,
          "username": cUsername.text,
          "password": cPassword.text,
          "id_desa": pref.getString("id_desa"),
        },
      );
      var datauser = json.decode(response.body);
      print(datauser);
      if (datauser['Status'] == "Sukses") {
        setState(() {
          loadingdataedit = false;
        });
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
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
                    datauser['Notif'],
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
                // Navigator.pop(context);
              },
            ),
          ),
        );
        Navigator.pop(context);
      } else {
        print("Failed");
        setState(
          () {
            loadingdataedit = false;
          },
        );
        // Navigator.of(this.context)
        //     .pushNamedAndRemoveUntil('/HalAkun', ModalRoute.withName('/Haldua'));
        // StatusAlert.show(
        //   this.context,
        //   duration: Duration(seconds: 2),
        //   title: 'Failed',
        //   subtitle: "Edit Gagal.",
        //   configuration: IconConfiguration(icon: Icons.cancel),
        // );
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
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
                    datauser['Notif'],
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
      }
    });
  }

  @override
  void initState() {
    detailAkun();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          "EDIT AKUN WARGA",
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
          : ListView(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        formNama(),
                        _paddingTop2(),
                        formEmail(),
                        _paddingTop2(),
                        formHp(),
                        _paddingTop2(),
                        formUsername(),
                        _paddingTop2(),
                        formPassword(),
                        _paddingTop2(),
                        _paddingTop2(),
                        _buttoneditAkunWarga(),
                      ],
                    ))
              ],
            ),
    );
  }

  Widget _buttoneditAkunWarga() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return loadingdataedit
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
        : SizedBox(
            width: mediaQueryData.size.width,
            height: mediaQueryData.size.height * 0.07,
            child: ElevatedButton(
              onPressed: () async {
                _editakun();
              },
              child: const Text(
                'SIMPAN',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
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
          );
  }

  Widget _paddingTop2() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
    );
  }

  Widget formNama() {
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
              controller: cNama,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
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
                hintText: loadingdata ? "Memuat.." : "Nama",
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

  Widget formEmail() {
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
              controller: cEmail,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.mail,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Email",
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

  Widget formUsername() {
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
              controller: cUsername,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.account_circle,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Username",
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

  Widget formHp() {
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
              controller: cHp,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Hp",
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

  Widget formPassword() {
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
              controller: cPassword,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
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
                hintText: loadingdata ? "Memuat.." : "Password",
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
}
