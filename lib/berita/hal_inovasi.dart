//ANCHOR PACKAGE halaman potensi
import 'package:dokar_aplikasi/berita/detail_page_inovasi.dart';
import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shimmer/shimmer.dart';

//ANCHOR StatefulWidget Potensi
class Inovasi extends StatefulWidget {
  Inovasi(TabController controller);

  @override
  _InovasiState createState() => _InovasiState();
}

class _InovasiState extends State<Inovasi> {
//ANCHOR Atribut

  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/bid/loadmorebid"; //NOTE url api load berita
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

//ANCHOR loading
  Widget _buildProgressIndicator() {
    SizeConfig().init(context);
    return Padding(
      padding: new EdgeInsets.all(10.0),
      child: Shimmer.fromColors(
        highlightColor: Colors.white,
        baseColor: Colors.grey[300],
        child: Container(
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: SizeConfig.safeBlockVertical * 10,
                    width: SizeConfig.safeBlockHorizontal * 30,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: SizeConfig.safeBlockVertical * 10,
                    width: SizeConfig.safeBlockHorizontal * 30,
                    color: Colors.grey,
                  ),
                ],
              ),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: SizeConfig.safeBlockVertical * 2,
                    width: SizeConfig.safeBlockHorizontal * 30,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: SizeConfig.safeBlockVertical * 5,
                    width: SizeConfig.safeBlockHorizontal * 60,
                    color: Colors.grey,
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
                        width: SizeConfig.safeBlockHorizontal * 40,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: SizeConfig.safeBlockVertical * 2,
                    width: SizeConfig.safeBlockHorizontal * 30,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: SizeConfig.safeBlockVertical * 5,
                    width: SizeConfig.safeBlockHorizontal * 60,
                    color: Colors.grey,
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
                        width: SizeConfig.safeBlockHorizontal * 40,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

//ANCHOR listview berita
  Widget _buildList() {
    return ListView.builder(
      //scrollDirection: Axis.horizontal,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: databerita.length + 1, //NOTE if else listview berita
      // ignore: missing_return
      itemBuilder: (BuildContext context, int index) {
        if (index == databerita.length) {
          return _buildProgressIndicator();
        } else {
          if (databerita[index]["inovasi_id"] == 'Notfound') {
          } else {
            return new Container(
              padding: new EdgeInsets.all(2.0),
              child: new Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 1.0,
                color: Colors.white,
                margin:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailInovasi(
                          idDesa: databerita[index]["id_desa"],
                          dDesa: databerita[index]["data_nama"],
                          dTanggal: databerita[index]["inovasi_tanggal"],
                          dKecamatan: databerita[index]["data_kecamatan"],
                          dGambar: databerita[index]["inovasi_gambar"],
                          dJudul: databerita[index]["inovasi_judul"],
                          dKategori: databerita[index]["inovasi_kategori"],
                          dAdmin: databerita[index]["inovasi_admin"],
                          dHtml: databerita[index]["inovasi_isi"],
                          dVideo: databerita[index]["inovasi_video"],
                          dUrl: databerita[index]["url"],
                        ),
                      ),
                    );
                  },
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(right: 15.0),
                        width: 120.0,
                        height: 100.0,
                        child: Image(
                          image: new NetworkImage(
                              databerita[index]["inovasi_gambar"]),
                          fit: BoxFit.cover,
                          height: 150.0,
                          width: 110.0,
                        ),
                      ),
                      new Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Expanded(
                                  child: new Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0, bottom: 10.0),
                                    child: new Text(
                                      databerita[index]["data_nama"],
                                      style: new TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                        //fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            new Container(
                              margin: const EdgeInsets.only(right: 10.0),
                              child: new Text(
                                databerita[index]["inovasi_judul"],
                                style: new TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            new Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              child: new Row(
                                children: <Widget>[
                                  new Container(
                                    margin: const EdgeInsets.only(right: 5.0),
                                    child: new Text(
                                      databerita[index]["inovasi_tanggal"],
                                      style: new TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      databerita[index]["inovasi_kategori"],
                                      style: new TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 11.0,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
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
          await Future.delayed(Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, '/HalamanBeritaadmin');
          });
        },
        child: new Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                padding: new EdgeInsets.all(10.0),
                child: Text(
                  "Bursa Inovasi Desa",
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
      resizeToAvoidBottomInset: false,
    );
  }
}
