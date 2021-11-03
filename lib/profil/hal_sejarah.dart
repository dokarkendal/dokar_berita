import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';

class HalSejarahDesa extends StatefulWidget {
  final String idDesa;

  HalSejarahDesa({this.idDesa});

  @override
  _HalSejarahDesaState createState() => _HalSejarahDesaState();
}

class _HalSejarahDesaState extends State<HalSejarahDesa> {
  List dataJSON;
  String sejarah = '';
  String gambar = '';

  // ignore: missing_return
  Future<String> ambildata() async {
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "http://dokar.kendalkab.go.id/webservice/android/dashbord/sejarah/" +
                "${widget.idDesa}"),
        headers: {"Accept": "application/json"});
    var dataJSON = json.decode(hasil.body);
    this.setState(
      () {
        sejarah = dataJSON['sejarah'];
        gambar = dataJSON['gambar'];
      },
    );
  }

  @override
  void initState() {
    super.initState();
    ambildata();
  }

  Widget _sejarah() {
    if (sejarah == 'NotFound') {
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
                "Belum ada sejarah",
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
          Image.network(
            gambar,
            fit: BoxFit.cover,
          ),
          HtmlView(
            padding: new EdgeInsets.all(15.0),
            data: sejarah,
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
        title: Text('Sejarah Desa'),
        backgroundColor: Color(0xFFee002d),
      ),
      body: SingleChildScrollView(
        child: _sejarah(),
      ),
    );
  }
}
