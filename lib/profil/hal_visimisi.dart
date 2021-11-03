import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';

class HalVisiDesa extends StatefulWidget {
  final String idDesa;

  HalVisiDesa({this.idDesa});

  @override
  _HalVisiDesaState createState() => _HalVisiDesaState();
}

class _HalVisiDesaState extends State<HalVisiDesa> {
  List dataJSON;
  String visi = '';
  String misi = '';

  // ignore: missing_return
  Future<String> ambildata() async {
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "http://dokar.kendalkab.go.id/webservice/android/dashbord/visimisi/" +
                "${widget.idDesa}"),
        headers: {"Accept": "application/json"});
    var dataJSON = json.decode(hasil.body);
    this.setState(
      () {
        visi = dataJSON['visi'];
        misi = dataJSON['misi'];
      },
    );
  }

  @override
  void initState() {
    super.initState();
    ambildata();
  }

  Widget _visimisi() {
    if (visi == 'NotFound') {
      return new Container(
        child: Center(
          child: new Column(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 150.0, vertical: 15.0),
                child:
                    new Icon(Icons.flag, size: 50.0, color: Colors.grey[350]),
              ),
              new Text(
                "Belum ada profile",
                style: new TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey[350],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          Padding(
            padding: new EdgeInsets.only(top: 10),
            child: Text(
              'Visi',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
          ),
          HtmlView(
            padding: new EdgeInsets.all(15.0),
            data: visi,
            onLaunchFail: (url) {
              // optional, type Function
              print("launch $url failed");
            },
            scrollable: false,
          ),
          Text(
            'Misi',
            style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          ),
          HtmlView(
            padding: new EdgeInsets.all(15.0),
            data: misi,
            onLaunchFail: (url) {
              // optional, type Function
              print("launch $url failed");
            },
            scrollable: false,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visi Misi'),
        backgroundColor: Color(0xFFee002d),
      ),
      body: SingleChildScrollView(
        child: _visimisi(),
      ),
    );
  }
}
