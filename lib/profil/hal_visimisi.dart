import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html/style.dart';
// import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';

import '../style/styleset.dart';

class HalVisiDesa extends StatefulWidget {
  final String idDesa;

  HalVisiDesa({required this.idDesa});

  @override
  _HalVisiDesaState createState() => _HalVisiDesaState();
}

class _HalVisiDesaState extends State<HalVisiDesa> {
  late List dataJSON;
  String visi = '';
  String misi = '';
  bool isLoading = false;

  // ignore: missing_return
  Future<String> ambildata() async {
    setState(
      () {
        isLoading = true;
      },
    );
    http.Response hasil = await http.get(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/dashbord/visimisi/" +
                "${widget.idDesa}"),
        headers: {"Accept": "application/json"});
    var dataJSON = json.decode(hasil.body);
    this.setState(
      () {
        isLoading = false;
        visi = dataJSON['visi'];
        misi = dataJSON['misi'];
      },
    );
    return '';
  }

  @override
  void initState() {
    super.initState();
    ambildata();
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: CircularProgressIndicator(),
        ),
      ),
    );
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
          Html(
            style: {
              "p": Style(
                padding: EdgeInsets.all(10.0),
              )
            },
            // padding: new EdgeInsets.all(10.0),
            data: visi,
            // onLaunchFail: (url) {
            //   // optional, type Function
            //   print("launch $url failed");
            // },
            // scrollable: false,
          ),
          // HtmlView(
          //   padding: new EdgeInsets.all(15.0),
          //   data: visi,
          //   onLaunchFail: (url) {
          //     // optional, type Function
          //     print("launch $url failed");
          //   },
          //   scrollable: false,
          // ),
          Text(
            'Misi',
            style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          ),
          Html(
            style: {
              "p": Style(
                padding: EdgeInsets.all(10.0),
              )
            },
            // padding: new EdgeInsets.all(10.0),
            data: misi,
            // onLaunchFail: (url) {
            //   // optional, type Function
            //   print("launch $url failed");
            // },
            // scrollable: false,
          ),
          // HtmlView(
          //   padding: new EdgeInsets.all(15.0),
          //   data: misi,
          //   onLaunchFail: (url) {
          //     // optional, type Function
          //     print("launch $url failed");
          //   },
          //   scrollable: false,
          // ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VISI MISI',
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: _buildProgressIndicator(),
                ),
              )
            : _visimisi(),
      ),
    );
  }
}
