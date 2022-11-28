import 'package:auto_size_text/auto_size_text.dart';
import 'package:dokar_aplikasi/berita/form/form_agenda.dart';
import 'package:dokar_aplikasi/berita/form/form_berita.dart';
import 'package:dokar_aplikasi/berita/form/form_bumdes.dart';
import 'package:dokar_aplikasi/berita/form/form_inovasi.dart';
import 'package:dokar_aplikasi/berita/form/form_kegiatan.dart';
import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../style/styleset.dart';
// api to json

class InputSemua extends StatefulWidget {
  @override
  _InputSemuaState createState() => _InputSemuaState();
}

class _InputSemuaState extends State<InputSemua> {
  String status = "";

  @override
  void initState() {
    super.initState();
    _cekSession();
  }

  Future _cekSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      status = pref.getString("status");
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (status == '02') {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: appbarIcon, //change your color here
          ),
          title: Text(
            'TULIS',
            style: TextStyle(
              color: appbarTitle,
              fontWeight: FontWeight.bold,
              // fontSize: 25.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: new EdgeInsets.all(10.0),
            child: new GestureDetector(
              child: Column(
                children: <Widget>[
                  cardBerita(),
                  beritaEdit(),
                  kegiatanEdit(),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: appbarIcon, //change your color here
          ),
          title: Text(
            'TULIS',
            style: TextStyle(
              color: appbarTitle,
              fontWeight: FontWeight.bold,
              // fontSize: 25.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: new EdgeInsets.all(10.0),
            child: new GestureDetector(
              child: Column(
                children: <Widget>[
                  cardBerita(),
                  beritaEdit(),
                  kegiatanEdit(),
                  inovasiEdit(),
                  bumdesEdit(),
                  eventEdit(),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget beritaEdit() {
    return new Card(
      //color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => new FormBerita(),
            ),
          );
        },
        child: ListTile(
          leading: Material(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.blue,
            child: IconButton(
              padding: EdgeInsets.all(15.0),
              icon: Icon(Icons.library_books),
              color: Colors.white,
              iconSize: 25.0,
              onPressed: () {
                //Navigator.pushNamed(context, '/HalamanBeritaadmin');
              },
            ),
          ),
          subtitle: new Text(
            "Kabar atau kejadian di desa",
            style: new TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          title: new Text(
            "Berita",
            style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          trailing: Icon(Icons.create, size: 25.0, color: Colors.black),
        ),
      ),
    );
  }

  Widget kegiatanEdit() {
    return Card(
        //color: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) => new FormKegiatan(),
              ),
            );
          },
          child: ListTile(
            leading: Material(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.orange,
              child: IconButton(
                padding: EdgeInsets.all(15.0),
                icon: Icon(Icons.directions_run),
                color: Colors.white,
                iconSize: 25.0,
                onPressed: () {
                  //Navigator.pushNamed(context, '/HalamanBeritaadmin');
                },
              ),
            ),
            subtitle: new Text(
              "Kegiatan penyerapan dana desa",
              style: new TextStyle(fontSize: 12.0, color: Colors.black54),
            ),
            title: new Text(
              "Kegiatan",
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            trailing: Icon(Icons.create, size: 25.0, color: Colors.black),
          ),
        ));
  }

  Widget inovasiEdit() {
    return Card(
      //color: Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => new FormInovasi(),
            ),
          );
        },
        child: ListTile(
          leading: Material(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.green,
            child: IconButton(
              padding: EdgeInsets.all(15.0),
              icon: Icon(Icons.store_mall_directory),
              color: Colors.white,
              iconSize: 25.0,
              onPressed: () {
                //Navigator.pushNamed(context, '/HalamanBeritaadmin');
              },
            ),
          ),
          subtitle: new Text(
            "Inovasi di desa",
            style: new TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          title: new Text(
            "Inovasi",
            style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          trailing: Icon(Icons.create, size: 25.0, color: Colors.black),
        ),
      ),
    );
  }

  Widget bumdesEdit() {
    return Card(
      //color: Colors.deepPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => new FormBumdes(),
            ),
          );
        },
        child: ListTile(
          leading: Material(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.purple,
            child: IconButton(
              padding: EdgeInsets.all(15.0),
              icon: Icon(Icons.shopping_basket),
              color: Colors.white,
              iconSize: 25.0,
              onPressed: () {
                //Navigator.pushNamed(context, '/HalamanBeritaadmin');
              },
            ),
          ),
          subtitle: new Text(
            "Badan usaha milik desa",
            style: new TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          title: new Text(
            "Bumdes",
            style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          trailing: Icon(Icons.create, size: 25.0, color: Colors.black),
        ),
      ),
    );
  }

  Widget eventEdit() {
    return Card(
      //color: Colors.deepPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => new FormAgenda(),
            ),
          );
        },
        child: ListTile(
          leading: Material(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.teal,
            child: IconButton(
              padding: EdgeInsets.all(15.0),
              icon: Icon(Icons.event),
              color: Colors.white,
              iconSize: 25.0,
              onPressed: () {
                Navigator.pushNamed(context, '/HalamanBeritaadmin');
              },
            ),
          ),
          subtitle: new Text(
            "Agenda desa dan kelurahan",
            style: new TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          title: new Text(
            "Agenda",
            style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          trailing: Icon(Icons.create, size: 25.0, color: Colors.black),
        ),
      ),
    );
  }

  Widget cardBerita() {
    return Container(
      padding: new EdgeInsets.all(5.0),
      width: SizeConfig.safeBlockHorizontal * 100,
      height: SizeConfig.safeBlockVertical * 20,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0.0, 3.0),
              blurRadius: 15.0)
        ],
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/images/tulis.png',
                  width: SizeConfig.safeBlockHorizontal * 30,
                  height: SizeConfig.safeBlockVertical * 30,
                ),
                SizedBox(width: SizeConfig.safeBlockHorizontal * 3),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AutoSizeText(
                      'Ayo.. tulis beritamu',
                      minFontSize: 16,
                      style: TextStyle(
                        color: Color(0xFF2e2e2e),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: SizeConfig.safeBlockHorizontal * 1),
                    AutoSizeText(
                      'Berikan informasi aktual',
                      minFontSize: 10,
                      style: TextStyle(
                        color: Color(0xFF2e2e2e),
                        fontSize: 14.0,
                      ),
                    ),
                    AutoSizeText(
                      'dan bermanfaat bagi warga',
                      minFontSize: 10,
                      style: TextStyle(
                        color: Color(0xFF2e2e2e),
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
