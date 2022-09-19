import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html/style.dart';
// import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';

class HalProfilDesa extends StatefulWidget {
  final String idDesa;

  HalProfilDesa({this.idDesa});

  @override
  _HalProfilDesaState createState() => _HalProfilDesaState();
}

class _HalProfilDesaState extends State<HalProfilDesa> {
  List dataJSON;
  String profile = '';
  String gambar = '';

  // ignore: missing_return
  Future<String> ambildata() async {
    http.Response hasil = await http.get(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/dashbord/profile/" +
                "${widget.idDesa}"),
        headers: {"Accept": "application/json"});
    var dataJSON = json.decode(hasil.body);
    this.setState(
      () {
        profile = dataJSON['profile'];
        gambar = dataJSON['gambar'];
      },
    );
  }

  @override
  void initState() {
    super.initState();
    ambildata();
  }

  Widget _profile() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    if (profile == 'NotFound') {
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
          Container(
            padding: EdgeInsets.all(10.0),
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: gambar.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: gambar,
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/load.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      width: mediaQueryData.size.width,
                      height: mediaQueryData.size.height * 0.3,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          Html(
            style: {
              "p": Style(
                padding: EdgeInsets.all(10.0),
              )
            },
            // padding: new EdgeInsets.all(10.0),
            data: profile,
            // onLaunchFail: (url) {
            //   // optional, type Function
            //   print("launch $url failed");
            // },
            // scrollable: false,
          ),
          // HtmlView(
          //   padding: new EdgeInsets.all(15.0),
          //   data: profile,
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
        title: Text('PROFIL'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: _profile(),
      ),
    );
  }
}
