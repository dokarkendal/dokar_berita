import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html/style.dart';
// import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';

import '../style/styleset.dart';

class HalProfilDesa extends StatefulWidget {
  final String idDesa;

  HalProfilDesa({required this.idDesa});

  @override
  _HalProfilDesaState createState() => _HalProfilDesaState();
}

class _HalProfilDesaState extends State<HalProfilDesa> {
  late List dataJSON;
  String profile = '';
  String gambar = '';
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
            "http://dokar.kendalkab.go.id/webservice/android/dashbord/profile/" +
                "${widget.idDesa}"),
        headers: {"Accept": "application/json"});
    var dataJSON = json.decode(hasil.body);
    this.setState(
      () {
        isLoading = false;
        profile = dataJSON['profile'];
        gambar = dataJSON['gambar'];
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

  Widget _profile() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    if (profile == 'NotFound') {
      return Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 150.0, vertical: 15.0),
                child: Icon(Icons.flag, size: 50.0, color: Colors.grey[350]),
              ),
              Text(
                "Belum ada profile",
                style: TextStyle(
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
            // padding:  EdgeInsets.all(10.0),
            data: profile,
            // onLaunchFail: (url) {
            //   // optional, type Function
            //   print("launch $url failed");
            // },
            // scrollable: false,
          ),
          // HtmlView(
          //   padding:  EdgeInsets.all(15.0),
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
        title: Text(
          'PROFIL',
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
            : _profile(),
      ),
    );
  }
}
