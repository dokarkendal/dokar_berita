/*
import 'package:dokar_aplikasi/berita/detail_page_berita.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//String html = '';

class Berita extends StatefulWidget {
  @override
  _BeritaState createState() => _BeritaState();
}

class _BeritaState extends State<Berita> {
  List dataJSON;
  GlobalKey<RefreshIndicatorState> refreshKey;
  var loading = false;

  Future<String> ambildata() async {
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "http://dokar.kendalkab.go.id/webservice/android/kabar/berita"),
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
        body: RefreshIndicator(
            key: refreshKey,
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 1), () {
                setState(() {
                  dataJSON;
                });
                ambildata();
              });
            },
            child: ListView.builder(
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
                          new Image(
                            image:
                                new NetworkImage(dataJSON[i]["kabar_gambar"]),
                          ),
                          Container(
                            height: 7.0,
                          ),
                          new Text(
                            dataJSON[i]["kabar_kategori"],
                            style: new TextStyle(fontWeight: FontWeight.bold),
                          ),
                          new Text(
                            dataJSON[i]["kabar_judul"],
                            style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold),
                            //textAlign: TextAlign.justify,
                          ),
                          Divider(),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(Icons.account_circle,
                                  size: 16, color: Colors.black45),
                              new Text(
                                dataJSON[i]["kabar_admin"],
                                style: new TextStyle(
                                  fontSize: 13,
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
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45),
                              ),
                              Container(
                                  height: 10,
                                  child: VerticalDivider(color: Colors.red)),
                              SizedBox(
                                  height: 25.0,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailBerita(
                                                    dGambar: dataJSON[i]
                                                        ["kabar_gambar"],
                                                    dKategori: dataJSON[i]
                                                        ["kabar_kategori"],
                                                    dJudul: dataJSON[i]
                                                        ["kabar_judul"],
                                                    dAdmin: dataJSON[i]
                                                        ["kabar_admin"],
                                                    dTanggal: dataJSON[i]
                                                        ["kabar_tanggal"],
                                                    dHtml: dataJSON[i]
                                                        ["kabar_isi"],
                                                  )));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )));
  }
} */
import 'package:dokar_aplikasi/berita/detail_page_berita.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Berita extends StatefulWidget {
  @override
  BeritaState createState() => BeritaState();
}

class BeritaState extends State<Berita> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/kabar/loadmoreberita";

  ScrollController _scrollController = new ScrollController();

  bool isLoading = false;
  List databerita = new List();
  final dio = new Dio();
  String dibaca;

  void _getMoreData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      final response = await dio.get(nextPage);
      List tempList = new List();
      nextPage = response.data['next'];
      for (int i = 0; i < response.data['result'].length; i++) {
        tempList.add(response.data['result'][i]);
      }

      setState(() {
        isLoading = false;
        databerita.addAll(tempList);
      });
    }
  }

  @override
  void initState() {
    this._getMoreData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      //+1 for progressbar
      controller: _scrollController,
      itemCount: databerita.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == databerita.length) {
          return _buildProgressIndicator();
        } else {
          if (databerita[index]["dibaca"] == null) {
            dibaca = '0';
          } else {
            dibaca = databerita[index]["dibaca"];
          }
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
                          new Image(
                            image: new NetworkImage(
                                databerita[index]["kabar_gambar"]),
                          ),
                          Container(
                            height: 7.0,
                          ),
                          Row(
                            children: <Widget>[
                              new Text(
                                databerita[index]["kabar_admin"],
                                style: new TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              /*new Text(
                                databerita[index]["kabar_kategori"],
                                style:
                                    new TextStyle(fontWeight: FontWeight.bold),
                              ),*/
                              /*Container(
                                  height: 10,
                                  child: VerticalDivider(color: Colors.grey)),
                              Icon(Icons.remove_red_eye,
                                  size: 16, color: Colors.grey),
                              new Text(
                                ' ' + databerita[index]["dibaca"] + '  lihat',
                                style: new TextStyle(color: Colors.grey),
                              ),*/
                            ],
                          ),
                          new Text(
                            databerita[index]["kabar_judul"],
                            style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold),
                            //textAlign: TextAlign.justify,
                          ),
                          Divider(),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(Icons.account_circle,
                                  size: 16, color: Colors.black45),
                              new Text(
                                databerita[index]["kabar_kategori"],
                                style: new TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
                                ),
                              ),
                              Container(
                                  height: 10,
                                  child: VerticalDivider(color: Colors.grey)),
                              Icon(Icons.remove_red_eye,
                                  size: 16, color: Colors.grey),
                              new Text(
                                ' ' + dibaca + '  lihat',
                                style: new TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                  height: 10,
                                  child: VerticalDivider(color: Colors.grey)),
                              Icon(Icons.date_range,
                                  size: 16, color: Colors.black45),
                              new Text(
                                databerita[index]["kabar_tanggal"],
                                style: new TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45),
                              ),
                              Container(
                                  height: 10,
                                  child: VerticalDivider(color: Colors.grey)),
                              SizedBox(
                                  height: 25.0,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailBerita(
                                                    dGambar: databerita[index]
                                                        ["kabar_gambar"],
                                                    dKategori: databerita[index]
                                                        ["kabar_kategori"],
                                                    dJudul: databerita[index]
                                                        ["kabar_judul"],
                                                    dAdmin: databerita[index]
                                                        ["kabar_admin"],
                                                    dTanggal: databerita[index]
                                                        ["kabar_tanggal"],
                                                    dHtml: databerita[index]
                                                        ["kabar_isi"],
                                                    dUrl: databerita[index]
                                                        ["url"],
                                                    dId: databerita[index]
                                                        ["kabar_id"],
                                                    dIdDesa: databerita[index]
                                                        ["id_desa"],
                                                  )));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ))));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, '/HalamanBeritaadmin');
            /*setState(() {
              databerita;
            });
            _getMoreData();*/
          });
        },
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}

/*import 'package:dokar_aplikasi/berita/detail_page_berita.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//String html = '';

class Berita extends StatefulWidget {
  @override
  _BeritaState createState() => _BeritaState();
}

class _BeritaState extends State<Berita> {
  List dataJSON;
  GlobalKey<RefreshIndicatorState> refreshKey;
  var loading = false;

  Future<String> ambildata() async {
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "http://dokar.kendalkab.go.id/webservice/android/kabar/berita"),
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
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1), () {
            setState(() {
              dataJSON;
            });
            ambildata();
          });
        },
        child: ListView.builder(
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
                      new Image(
                        image: new NetworkImage(dataJSON[i]["kabar_gambar"]),
                      ),
                      Container(
                        height: 7.0,
                      ),
                      new Text(
                        dataJSON[i]["kabar_kategori"],
                        style: new TextStyle(fontWeight: FontWeight.bold),
                      ),
                      /*Divider(),
                  new Text(dataJSON[i]["kabar_tanggal"]),*/
                      new Text(
                        dataJSON[i]["kabar_judul"],
                        style: new TextStyle(
                            fontSize: 20.0,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                        //textAlign: TextAlign.justify,
                      ),
                      Divider(),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(Icons.account_circle,
                              size: 16, color: Colors.black45),
                          new Text(
                            dataJSON[i]["kabar_admin"],
                            style: new TextStyle(
                              fontSize: 13,
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
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                          Container(
                              height: 10,
                              child: VerticalDivider(color: Colors.red)),
                          SizedBox(
                              height: 25.0,
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailBerita(
                                                dGambar: dataJSON[i]
                                                    ["kabar_gambar"],
                                                dKategori: dataJSON[i]
                                                    ["kabar_kategori"],
                                                dJudul: dataJSON[i]
                                                    ["kabar_judul"],
                                                dAdmin: dataJSON[i]
                                                    ["kabar_admin"],
                                                dTanggal: dataJSON[i]
                                                    ["kabar_tanggal"],
                                                dHtml: dataJSON[i]["kabar_isi"],
                                              )));
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                color: Colors.green,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                              )),
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
    );
  }
}
*/
