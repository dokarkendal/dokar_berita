import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../../style/styleset.dart';

class HalEditWarga extends StatefulWidget {
  const HalEditWarga({super.key});

  @override
  State<HalEditWarga> createState() => _HalEditWargaState();
}

class _HalEditWargaState extends State<HalEditWarga> {
  String? nama = "";
  String? email = "";
  String? hp = "";
  String? username = "";

  bool loadingdata = false;

  Future<void> detailAkunWarga() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      loadingdata = true;
    });
    final response = await http.post(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/account/detail"),
      body: {
        "IdAdmin": pref.getString("uid")!,
      },
    );
    var detailakunwarga = json.decode(response.body);
    if (mounted) {
      setState(
        () {
          loadingdata = false;
          nama = detailakunwarga['nama']!;
          email = detailakunwarga['email'];
          hp = detailakunwarga['hp'];
          username = detailakunwarga['username'];
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    detailAkunWarga();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          "AKUN",
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
            // fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            iconSize: 23.0,
            onPressed: () async {
              Navigator.pushNamed(context, '/Version');
            },
          )
        ],
      ),
      body: loadingdata
          ? _buildProgressIndicator()
          : Container(
              color: Colors.grey.shade200,
              child: ListView(
                children: [
                  _akun(),
                  // _buttoneditAkun(),
                ],
              ),
            ),
    );
  }

  Widget _buttoneditAkun() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return SizedBox(
      width: mediaQueryData.size.width,
      height: mediaQueryData.size.height * 0.07,
      child: ElevatedButton(
        onPressed: () async {},
        child: const Text(
          'EDIT',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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

  Widget _akun() {
    return Container(
      padding: const EdgeInsets.all(3),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _akunText(),
                      _dividerHeight1(),
                      _namaAkun(),
                      _dividerHeight1(),
                      _emailAkun(),
                      _dividerHeight1(),
                      _hpAkun(),
                      _dividerHeight1(),
                      _usernameAkun(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _akunText() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(
        "Akun",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _dividerHeight1() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _namaAkun() {
    return ListTile(
      // dense: true,
      // visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Nama",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: nama == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$nama",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget _emailAkun() {
    return ListTile(
      // dense: true,
      // visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.mail,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Email",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: nama == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$email",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget _hpAkun() {
    return ListTile(
      // dense: true,
      // visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.phone_android,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Hp",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: nama == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$hp",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget _usernameAkun() {
    return ListTile(
      // dense: true,
      // visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Username",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: nama == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$username",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
    );
  }
}
