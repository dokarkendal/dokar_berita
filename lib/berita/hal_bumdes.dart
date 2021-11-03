import 'package:dokar_aplikasi/berita/detail_page_bumdes.dart';
import 'package:flutter/material.dart';
//import 'package:dokar_aplikasi/berita/detail_page_berita.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
//String html = '';

class Bumdes extends StatefulWidget {
  @override
  _BumdesState createState() => _BumdesState();
}

class _BumdesState extends State<Bumdes> {
  List dataJSON;
  GlobalKey<RefreshIndicatorState> refreshKey;
  var loading = false;

  Future<String> ambildata() async {
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "http://dokar.kendalkab.go.id/webservice/android/bumdes"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      dataJSON = json.decode(hasil.body);
    });
  }

  //String html = "";
  @override
  void initState() {
    this.ambildata();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text(
              'Rekomendasi',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 230.0,
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: dataJSON == null ? 0 : dataJSON.length,
                itemBuilder: (context, i) {
                  return new Container(
                    child: new Card(
                        child: new Container(
                      padding: new EdgeInsets.all(5.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Image(
                            image:
                                new NetworkImage(dataJSON[i]["bumdes_gambar"]),
                            width: 300,
                            height: 150,
                          ),
                          Container(
                            height: 3.0,
                          ),
                          SizedBox(
                            width: 200.0,
                            child: AutoSizeText(
                              dataJSON[i]["bumdes_judul"],
                              style: new TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold),
                              maxLines: 2,
                            ),
                          ),
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.account_circle,
                                  size: 16, color: Colors.black45),
                              SizedBox(
                                width: 230.0,
                                child: AutoSizeText(
                                  dataJSON[i]["bumdes_admin"],
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Berita terkait',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              //height: 200.0,
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: dataJSON == null ? 0 : dataJSON.length,
                itemBuilder: (context, i) {
                  return new Container(
                    padding: new EdgeInsets.all(3.0),
                    child: new Card(
                      child: new Container(
                        padding: new EdgeInsets.all(5.0),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Column(children: <Widget>[
                              new Image(
                                image: new NetworkImage(
                                    dataJSON[i]["bumdes_gambar"]),
                                width: 110,
                                height: 100,
                              ),
                            ]),
                            Container(
                              width: 7,
                            ),
                            new Column(
                              children: <Widget>[
                                SizedBox(
                                  width: 250.0,
                                  child: FlatButton(
                                      padding: EdgeInsets.all(0.0),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailBumdes(
                                                      dGambar: dataJSON[i]
                                                          ["bumdes_gambar"],
                                                      dJudul: dataJSON[i]
                                                          ["bumdes_judul"],
                                                      dTempat: dataJSON[i]
                                                          ["bumdes_tempat"],
                                                      dAdmin: dataJSON[i]
                                                          ["bumdes_admin"],
                                                      dHtml: dataJSON[i]
                                                          ["bumdes_isi"],
                                                    )));
                                      },
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: AutoSizeText(
                                          dataJSON[i]["bumdes_judul"],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.red[300],
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                        ),
                                      )),
                                ),
                                Divider(),
                                new Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 10,
                                    ),
                                    Icon(Icons.account_circle,
                                        size: 16, color: Colors.black45),
                                    SizedBox(
                                      width: 230.0,
                                      child: AutoSizeText(
                                        dataJSON[i]["bumdes_admin"],
                                        style: new TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                new Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 10,
                                    ),
                                    Icon(Icons.location_on,
                                        size: 16, color: Colors.black45),
                                    SizedBox(
                                      width: 230.0,
                                      child: AutoSizeText(
                                        dataJSON[i]["bumdes_tempat"],
                                        style: new TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*new HtmlView(
                    data: html,
                    onLaunchFail: (url) {
                      // optional, type Function
                      print("launch $url failed");
                    },
                    scrollable:
                        false, //false to use MarksownBody and true to use Marksown
                  )*/
//String html = dataJSON[i]["kabar_isi"]
//new Text(dataJSON[i]["kabar_admin"]),
//new Text(dataJSON[i]["kabar_tanggal"]),
//new Text(dataJSON[i]["kabar_isi"]),
