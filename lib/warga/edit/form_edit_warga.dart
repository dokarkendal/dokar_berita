import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert'; // api to json

class FormEditWarga extends StatefulWidget {
  const FormEditWarga({super.key});

  @override
  State<FormEditWarga> createState() => _FormEditWargaState();
}

class _FormEditWargaState extends State<FormEditWarga> {
  bool loadingdata = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
