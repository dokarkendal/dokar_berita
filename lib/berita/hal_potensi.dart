import 'package:dokar_aplikasi/berita/detail_page_potensi.dart';
import 'package:flutter/material.dart';
//import 'package:dokar_aplikasi/berita/detail_page_berita.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
//String html = '';

class Potensi extends StatefulWidget {
  @override
  _PotensiState createState() => _PotensiState();
}

class _PotensiState extends State<Potensi> {
  List dataJSON;
  GlobalKey<RefreshIndicatorState> refreshKey;
  var loading = false;

  Future<String> ambildata() async {
    http.Response hasil = await http.get(
        Uri.encodeFull("http://dokar.kendalkab.go.id/webservice/android/bid"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      dataJSON = json.decode(hasil.body);
      // if (!mounted) return;
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
              height: 160.0,
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
                            new CircleAvatar(
                              backgroundImage:
                                  NetworkImage(dataJSON[i]["inovasi_gambar"]),
                              radius: 50,
                            ),
                            Container(
                              height: 3.0,
                            ),
                            SizedBox(
                              width: 100.0,
                              child: AutoSizeText(
                                dataJSON[i]["inovasi_judul"],
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                    //fontSize: 16.0,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                              ),
                            ),
                            new Wrap(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.account_circle,
                                    size: 16, color: Colors.black45),
                                SizedBox(
                                  width: 100.0,
                                  child: AutoSizeText(
                                    dataJSON[i]["inovasi_admin"],
                                    overflow: TextOverflow.ellipsis,
                                    style: new TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                  ),
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
                                    dataJSON[i]["inovasi_gambar"]),
                                width: 110,
                                height: 100,
                              ),
                            ]),
                            Container(
                              width: 7,
                            ),
                            new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    DetailPotensi(
                                                      dGambar: dataJSON[i]
                                                          ["inovasi_gambar"],
                                                      dJudul: dataJSON[i]
                                                          ["inovasi_judul"],
                                                      dTempat: dataJSON[i]
                                                          ["inovasi_tempat"],
                                                      dAdmin: dataJSON[i]
                                                          ["inovasi_admin"],
                                                      dTanggal: dataJSON[i]
                                                          ["inovasi_tanggal"],
                                                      dHtml: dataJSON[i]
                                                          ["inovasi_isi"],
                                                    )));
                                      },
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: AutoSizeText(
                                          dataJSON[i]["inovasi_judul"],
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
                                    Icon(Icons.account_circle,
                                        size: 16, color: Colors.black45),
                                    SizedBox(
                                      width: 230.0,
                                      child: AutoSizeText(
                                        dataJSON[i]["inovasi_admin"],
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
                                    Icon(Icons.date_range,
                                        size: 16, color: Colors.black45),
                                    SizedBox(
                                      width: 230.0,
                                      child: AutoSizeText(
                                        dataJSON[i]["inovasi_waktu"],
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
