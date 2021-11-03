//ANCHOR package halaman berita
import 'package:dokar_aplikasi/berita/detail_page_berita.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dokar_aplikasi/berita/detail_page_potensi.dart';
import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shimmer/shimmer.dart';

//ANCHOR StatefulWidget Berita
class Berita extends StatefulWidget {
  @override
  BeritaState createState() => BeritaState();
}

class BeritaState extends State<Berita> {
//ANCHOR variable berita
  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/kabar/loadmoreberita"; //NOTE url api load berita
  ScrollController _scrollController = new ScrollController();
  GlobalKey<RefreshIndicatorState> refreshKey;
  List databerita = new List();
  bool isLoading = false;
  final dio = new Dio();
  String dibaca;
  List dataJSON;

  void _getMoreData() async {
    //NOTE if else load more
    if (!isLoading) {
      setState(
        () {
          isLoading = true;
        },
      );

      final response = await dio.get(nextPage);
      List tempList = new List();
      nextPage = response.data['next'];
      for (int i = 0; i < response.data['result'].length; i++) {
        tempList.add(response.data['result'][i]);
      }

      setState(
        () {
          isLoading = false;
          databerita.addAll(tempList);
        },
      );
    }
  }

//ANCHOR inistate berita
  @override
  void initState() {
    this._getMoreData();
    super.initState();
    this.ambildata();
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _getMoreData();
        }
      },
    );
  }

//ANCHOR dispose
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ignore: missing_return
  Future<String> ambildata() async {
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "http://dokar.kendalkab.go.id/webservice/android/kabar/beritarekomedasi"),
        headers: {"Accept": "application/json"});

    this.setState(
      () {
        dataJSON = json.decode(hasil.body);
      },
    );
  }

//ANCHOR loading
  Widget _buildProgressIndicator() {
    SizeConfig().init(context);
    return Padding(
      padding: new EdgeInsets.all(1.0),
      child: Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        highlightColor: Colors.white,
        baseColor: Colors.grey[300],
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: SizeConfig.safeBlockVertical * 30,
                width: SizeConfig.safeBlockHorizontal * 100,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        height: SizeConfig.safeBlockVertical * 2,
                        width: SizeConfig.safeBlockHorizontal * 20,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Container(
                        height: SizeConfig.safeBlockVertical * 2,
                        width: SizeConfig.safeBlockHorizontal * 20,
                        color: Colors.grey,
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: SizeConfig.safeBlockVertical * 5,
                    width: SizeConfig.safeBlockHorizontal * 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: SizeConfig.safeBlockVertical * 2,
                        width: SizeConfig.safeBlockHorizontal * 20,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Container(
                        height: SizeConfig.safeBlockVertical * 2,
                        width: SizeConfig.safeBlockHorizontal * 20,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Container(
                        height: SizeConfig.safeBlockVertical * 2,
                        width: SizeConfig.safeBlockHorizontal * 20,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: <Widget>[
                      Container(
                        height: SizeConfig.safeBlockVertical * 30,
                        width: SizeConfig.safeBlockHorizontal * 100,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Container(
                        height: SizeConfig.safeBlockVertical * 2,
                        width: SizeConfig.safeBlockHorizontal * 20,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Container(
                        height: SizeConfig.safeBlockVertical * 2,
                        width: SizeConfig.safeBlockHorizontal * 20,
                        color: Colors.grey,
                      )
                    ],
                  ),
                  /*Container(
                    height: containerHeight,
                    width: containerWidth * 0.75,
                    color: Colors.grey,
                  )*/
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _recomended() {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: dataJSON == null ? 0 : dataJSON.length,
      itemBuilder: (context, i) {
        return new Container(
          child: new Card(
            child: new Container(
              padding: new EdgeInsets.all(6.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.network(
                            dataJSON[i]["kabar_gambar"],
                            fit: BoxFit.cover,
                            width: 100.0,
                            height: 74.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 3.0,
                  ),
                  SizedBox(
                    width: 100.0,
                    child: AutoSizeText(
                      dataJSON[i]["kabar_judul"], // NOTE api judul berita
                      overflow: TextOverflow.ellipsis,
                      style:
                          new TextStyle(fontSize: 10.0, color: Colors.black54),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

//ANCHOR listview berita
  Widget _buildList() {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: databerita.length + 1, //NOTE if else listview berita
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
            padding: new EdgeInsets.all(1.0),
            child: new Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: new Container(
                //padding: new EdgeInsets.all(10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      child: Image(
                        image:
                            new NetworkImage(databerita[index]["kabar_gambar"]),
                        fit: BoxFit.cover,
                      ),
                    ),

                    /*new Image(
                      image: new NetworkImage(
                        databerita[index]["kabar_gambar"],
                        //NOTE api gambar berita
                      ),
                    ),*/
                    Container(
                      height: 7.0,
                    ),
                    Container(
                      padding: new EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 5.0),
                      child: Row(
                        children: <Widget>[
                          new Text(
                            databerita[index]
                                ["kabar_kategori"], //NOTE api kategori berita
                            style: new TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Container(
                              height: 10,
                              child: VerticalDivider(color: Colors.grey)),
                          new Text(
                            databerita[index]
                                ["kabar_admin"], //NOTE api admin berita
                            style: new TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: new EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(
                        databerita[index]
                            ["kabar_judul"], //NOTE api judul berita
                        style: new TextStyle(
                            fontSize: 18.0,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                        //textAlign: TextAlign.justify,
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: new EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(Icons.remove_red_eye,
                              size: 16, color: Colors.grey),
                          new Text(
                            ' ' + dibaca + '  lihat', //NOTE api banyak dilihat
                            style: new TextStyle(
                              color: Colors.black45,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                              height: 10,
                              child: VerticalDivider(color: Colors.grey)),
                          Icon(Icons.date_range,
                              size: 16, color: Colors.black45),
                          new Text(
                            databerita[index]
                                ["kabar_tanggal"], //NOTE api tanggal berita
                            style: new TextStyle(
                                fontSize: 13, color: Colors.black45),
                          ),
                          Container(
                            height: 10,
                            child: VerticalDivider(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 25.0, //NOTE push detail berita
                            child: InkWell(
                              child: FlatButton(
                                color: Colors.green,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Lihat  ',
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
                                onPressed: () {
                                  print(dataJSON);
                                  if (databerita[index]
                                              ["kabar_kategori"] ==
                                          'KEGIATAN' ||
                                      databerita[index]["kabar_kategori"] ==
                                          'Kegiatan' ||
                                      databerita[index]["kabar_kategori"] ==
                                          'kegiatan') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPotensi(
                                          dKategori: databerita[index]
                                              ["kabar_kategori"],
                                          dBaca: databerita[index]["dibaca"],
                                          dId: databerita[index]["kabar_id"],
                                          dIdDesa: databerita[index]["id_desa"],
                                          dDesa: databerita[index]["data_nama"],
                                          dKecamatan: databerita[index]
                                              ["data_kecamatan"],
                                          dGambar: databerita[index]
                                              ["kabar_gambar"],
                                          dJudul: databerita[index]
                                              ["kabar_judul"],
                                          dTempat: databerita[index]
                                              ["kabar_tempat"],
                                          dAdmin: databerita[index]
                                              ["kabar_admin"],
                                          dTanggal: databerita[index]
                                              ["kabar_tanggal"],
                                          dHtml: databerita[index]["kabar_isi"],
                                          dVideo: databerita[index]
                                              ["kabar_video"],
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailBerita(
                                          dId: databerita[index]["kabar_id"],
                                          dIdDesa: databerita[index]["id_desa"],
                                          dBaca: databerita[index]["dibaca"],
                                          dDesa: databerita[index]["data_nama"],
                                          dKecamatan: databerita[index]
                                              ["data_kecamatan"],
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
                                          dHtml: databerita[index]["kabar_isi"],
                                          dVideo: databerita[index]
                                              ["kabar_video"],
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

//ANCHOR body berita
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await Future.delayed(
            Duration(seconds: 2),
            () {
              Navigator.pushReplacementNamed(context, '/HalamanBeritaadmin');
            },
          );
        },
        child: Builder(
          builder: (BuildContext context) {
            return OfflineBuilder(
              connectivityBuilder: (BuildContext context,
                  ConnectivityResult connectivity, Widget child) {
                final bool connected = connectivity != ConnectivityResult.none;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    child,
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      height: 32.0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        color: connected ? null : Colors.orange,
                        child: connected
                            ? null
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Periksa jaringan internet",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  SizedBox(
                                    width: 12.0,
                                    height: 12.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                );
              },
              child: new Container(
                child: Container(
                  padding: new EdgeInsets.all(5.0),
                  child: Column(
                    children: <Widget>[
                      new Container(
                        alignment: Alignment.centerLeft,
                        padding: new EdgeInsets.all(10.0),
                        child: Text(
                          "Berita Semua Desa",
                          style: new TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: _buildList(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
