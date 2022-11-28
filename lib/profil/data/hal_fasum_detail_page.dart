import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html/style.dart';
// import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../style/styleset.dart';

class HalFasumDetailPage extends StatefulWidget {
  final String dNama,
      dId,
      dJenis,
      dKategori,
      dGambar,
      dDeskripsi,
      dAlamat,
      dDesa,
      dKecamatan,
      dKoordinat;
  HalFasumDetailPage(
      {this.dNama,
      this.dId,
      this.dJenis,
      this.dKategori,
      this.dGambar,
      this.dDeskripsi,
      this.dAlamat,
      this.dDesa,
      this.dKecamatan,
      this.dKoordinat});

  @override
  _HalFasumDetailPageState createState() => _HalFasumDetailPageState();
}

class _HalFasumDetailPageState extends State<HalFasumDetailPage> {
  _launchUrl() async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not lauch URL';
    }
    print(url);
  }

  // _launchUrl() async {
  //   if (!await launchUrl(
  //     Uri.parse(
  //       url,
  //     ),
  //     mode: LaunchMode.externalApplication,
  //   )) {
  //     throw 'Could not launch $url';
  //   }
  //   print(url);
  // }
  String url = '';
  List dataJSON;
  String id = '';
  String nama = '';

  @override
  void initState() {
    super.initState();
    id = "${widget.dId}";
    nama = "${widget.dNama}";
    url = "${widget.dKoordinat}";
    print("${widget.dKoordinat}");
  }

  // ignore: missing_return
  Future<String> ambildata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    http.Response hasil = await http.get(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/dashbord/fasilitasumum/" +
                pref.getString("IdDesa") +
                "/" +
                id),
        headers: {"Accept": "application/json"});

    this.setState(
      () {
        dataJSON = json.decode(hasil.body);
        //print(id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title:
            // ignore: unnecessary_brace_in_string_interps
            Text(
          '${widget.dNama}',
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      // appBar: AppBar(
      //   title: Text('${widget.dNama}'),
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                wHeader(),
                Padding(
                  padding: EdgeInsets.only(
                      top: 170.0, right: 15.0, left: 15.0, bottom: 15),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      //padding: new EdgeInsets.all(15.0),
                      child: IntrinsicHeight(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: <Widget>[
                                  wLocation(),
                                ],
                              ),
                            ),
                            Expanded(
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Container(
                                    margin: const EdgeInsets.only(
                                        right: 10.0, top: 10.0),
                                    child: new Text(
                                      '${widget.dNama}',
                                      style: new TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  new Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: new Column(
                                      children: <Widget>[
                                        new Text(
                                          '${widget.dAlamat}',
                                          maxLines: 3,
                                          style: new TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      Transform(
                                        transform: new Matrix4.identity()
                                          ..scale(0.8),
                                        child: Chip(
                                          backgroundColor: Colors.green,
                                          label: Text(
                                            '${widget.dDesa}',
                                            style: new TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 0.1),
                                      Transform(
                                        transform: new Matrix4.identity()
                                          ..scale(0.8),
                                        child: Chip(
                                          backgroundColor: Colors.green,
                                          label: Text(
                                            '${widget.dKecamatan}',
                                            style: new TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _html(),
          ],
        ),
      ),
    );
  }

  Widget _html() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Html(
            style: {
              "p": Style(
                padding: EdgeInsets.all(10.0),
              )
            },
            // padding: new EdgeInsets.all(10.0),
            data: '${widget.dDeskripsi}',
            // onLaunchFail: (url) {
            //   // optional, type Function
            //   print("launch $url failed");
            // },
            // scrollable: false,
          ),
          // HtmlView(
          //   padding: new EdgeInsets.all(10.0),
          //   data: '${widget.dDeskripsi}',
          //   onLaunchFail: (url) {
          //     // optional, type Function
          //     print("launch $url failed");
          //   },
          //   scrollable: false,
          // ),
        ],
      ),
    );
  }

  Widget wHeader() {
    var screenWidth = MediaQuery.of(context).size.width;
    return ClipPath(
      clipper: ArcClipper(),
      child: Image.network(
        '${widget.dGambar}',
        width: screenWidth,
        height: 230.0,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget wLocation() {
    return Column(
      children: <Widget>[
        Material(
          shadowColor: Colors.red,
          borderRadius: BorderRadius.circular(100.0),
          color: Color(0xFFee002d),
          child: IconButton(
            padding: EdgeInsets.all(15.0),
            icon: Icon(Icons.location_on),
            color: Colors.white,
            iconSize: 40.0,
            onPressed: _launchUrl,
          ),
        ),
        /*SizedBox(height: 8.0),
        Text('Lokasi',
            style: TextStyle(
                fontSize: 12.0,
                color: Colors.black54,
                fontWeight: FontWeight.bold))*/
      ],
    );
  }

  Widget wTitle() {
    return Column(
      children: <Widget>[
        Text('${widget.dNama}',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.0)),
      ],
    );
  }

  Widget wAlamat() {
    return Container(
      margin: const EdgeInsets.only(right: 10.0),
      child: new Text(
        '${widget.dAlamat}',
        style: new TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
