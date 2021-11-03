import 'dart:ffi';

import 'package:dokar_aplikasi/berita/hal_berita.dart';
import 'package:dokar_aplikasi/bottom-bar.dart';
import 'package:flutter/material.dart';
import 'package:dokar_aplikasi/berita/detail_page_berita.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Search extends StatefulWidget {
  String value;
  Search({Key key, this.value = 'text'}) : super(key: key);

  @override
  _SearchState createState() => _SearchState(value);
}

class _SearchState extends State<Search> {
  List dataJSON;
  String value;
  _SearchState(this.value);

  Future<String> ambildata() async {
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "http://dokar.kendalkab.go.id/webservice/android/searchkabar?search=${value}"),
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
        appBar: AppBar(
          title: new Text("Cari Berita"),
          backgroundColor: Color(0xFFee002d),
        ),
        body: ListView.builder(
          //scrollDirection: Axis.horizontal,

          itemCount: dataJSON == null ? 0 : dataJSON.length,
          itemBuilder: (context, i) {
            //final nDataList = dataJSON[i];
            return new Container(
              padding: new EdgeInsets.all(5.0),
              child: new Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: new Container(
                  padding: new EdgeInsets.all(10.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /* new Image(
                    image: new NetworkImage(dataJSON[i]["kabar_gambar"]),
                    width: 100,
                  ),
                  Container(
                    height: 7.0,
                  ),
                  new Text(
                    dataJSON[i]["kabar_kategori"],
                    style: new TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  new Text(dataJSON[i]["kabar_tanggal"]),*/

                      FlatButton(
                        padding: EdgeInsets.all(0.0),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailBerita(
                                        dGambar: dataJSON[i]["kabar_gambar"],
                                        dKategori: dataJSON[i]
                                            ["kabar_kategori"],
                                        dJudul: dataJSON[i]["kabar_judul"],
                                        dAdmin: dataJSON[i]["kabar_admin"],
                                        dTanggal: dataJSON[i]["kabar_tanggal"],
                                        dHtml: dataJSON[i]["kabar_isi"],
                                      )));
                        },
                        child: Text(
                          dataJSON[i]["kabar_judul"],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.red[300],
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      /*new Text(
                    dataJSON[i]["kabar_judul"],

                    style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold),
                    //textAlign: TextAlign.justify,
                  ),*/
                      Divider(),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.account_circle,
                              size: 16, color: Colors.black45),
                          new Text(
                            dataJSON[i]["kabar_admin"],
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                            ),
                          ),
                          Container(
                              height: 10,
                              child: VerticalDivider(color: Colors.red)),
                          Icon(Icons.date_range,
                              size: 16, color: Colors.black45),
                          new Text(
                            dataJSON[i]["kabar_tanggal"],
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                          /*Container(
                          height: 10,
                          child: VerticalDivider(color: Colors.red)),*/
                          /*SizedBox(
                          height: 25.0,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailUser(
                                            dGambar: dataJSON[i]
                                                ["kabar_gambar"],
                                            dKategori: dataJSON[i]
                                                ["kabar_kategori"],
                                            dJudul: dataJSON[i]["kabar_judul"],
                                            dAdmin: dataJSON[i]["kabar_admin"],
                                            dTanggal: dataJSON[i]
                                                ["kabar_tanggal"],
                                            dHtml: dataJSON[i]["kabar_isi"],
                                          )));
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            color: Colors.green,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Lihat',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          )),*/
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
