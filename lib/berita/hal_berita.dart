//ANCHOR package halaman berita
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dokar_aplikasi/berita/detail_page_berita.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dokar_aplikasi/berita/detail_page_potensi.dart';
import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_html_view/flutter_html_view.dart';
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
  int maxLines;

  BeritaState({this.maxLines});
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
        print(dataJSON);
      },
    );
  }

//ANCHOR loading
  Widget _buildProgressIndicator() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    SizeConfig().init(context);
    return Padding(
      padding: new EdgeInsets.all(1.0),
      child: Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        highlightColor: Colors.white,
        baseColor: Colors.grey[300],
        child: Container(
          padding: new EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey,
                ),
                height: mediaQueryData.size.height * 0.3,
                width: mediaQueryData.size.width,
              ),
              SizedBox(height: mediaQueryData.size.height * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey,
                    ),
                    height: mediaQueryData.size.height * 0.05,
                    width: mediaQueryData.size.width,
                    // color: Colors.grey,
                  ),
                  SizedBox(height: mediaQueryData.size.height * 0.01),
                  Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: SizeConfig.safeBlockVertical * 2,
                        width: SizeConfig.safeBlockHorizontal * 20,
                        // color: Colors.grey,
                      ),
                      SizedBox(width: mediaQueryData.size.width * 0.35),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: SizeConfig.safeBlockVertical * 2,
                        width: SizeConfig.safeBlockHorizontal * 20,
                        // color: Colors.grey,
                      ),
                      SizedBox(width: mediaQueryData.size.width * 0.01),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: SizeConfig.safeBlockVertical * 2,
                        width: SizeConfig.safeBlockHorizontal * 20,
                        // color: Colors.grey,
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: mediaQueryData.size.height * 0.01),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey,
                ),
                height: mediaQueryData.size.height * 0.3,
                width: mediaQueryData.size.width,
              ),
              SizedBox(height: mediaQueryData.size.height * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey,
                    ),
                    height: mediaQueryData.size.height * 0.05,
                    width: mediaQueryData.size.width,
                    // color: Colors.grey,
                  ),
                  SizedBox(height: mediaQueryData.size.height * 0.01),
                  Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: SizeConfig.safeBlockVertical * 2,
                        width: SizeConfig.safeBlockHorizontal * 20,
                        // color: Colors.grey,
                      ),
                      SizedBox(width: mediaQueryData.size.width * 0.35),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: SizeConfig.safeBlockVertical * 2,
                        width: SizeConfig.safeBlockHorizontal * 20,
                        // color: Colors.grey,
                      ),
                      SizedBox(width: mediaQueryData.size.width * 0.01),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: SizeConfig.safeBlockVertical * 2,
                        width: SizeConfig.safeBlockHorizontal * 20,
                        // color: Colors.grey,
                      )
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
    MediaQueryData mediaQueryData = MediaQuery.of(context);
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
            // child: new Card(
            //   clipBehavior: Clip.antiAliasWithSaveLayer,
            //   elevation: 0,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10.0),
            //   ),
            child: Material(
              child: InkWell(
                onTap: () {
                  print("tekan");
                  print(dataJSON);
                  if (databerita[index]["kabar_kategori"] == 'KEGIATAN' ||
                      databerita[index]["kabar_kategori"] == 'Kegiatan' ||
                      databerita[index]["kabar_kategori"] == 'kegiatan') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPotensi(
                          dKategori: databerita[index]["kabar_kategori"],
                          dBaca: databerita[index]["dibaca"],
                          dId: databerita[index]["kabar_id"],
                          dIdDesa: databerita[index]["id_desa"],
                          dDesa: databerita[index]["data_nama"],
                          dKecamatan: databerita[index]["data_kecamatan"],
                          dGambar: databerita[index]["kabar_gambar"],
                          dJudul: databerita[index]["kabar_judul"],
                          dTempat: databerita[index]["kabar_tempat"],
                          dAdmin: databerita[index]["kabar_admin"],
                          dTanggal: databerita[index]["kabar_tanggal"],
                          dHtml: databerita[index]["kabar_isi"],
                          dVideo: databerita[index]["kabar_video"],
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
                          dKecamatan: databerita[index]["data_kecamatan"],
                          dGambar: databerita[index]["kabar_gambar"],
                          dKategori: databerita[index]["kabar_kategori"],
                          dJudul: databerita[index]["kabar_judul"],
                          dAdmin: databerita[index]["kabar_admin"],
                          dTanggal: databerita[index]["kabar_tanggal"],
                          dHtml: databerita[index]["kabar_isi"],
                          dVideo: databerita[index]["kabar_video"],
                          dUrl: databerita[index]["url"],
                          dWaktu: databerita[index]["kabar_waktu"],
                        ),
                      ),
                    );
                  }
                },
                child: new Container(
                  //padding: new EdgeInsets.all(10.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        //    new Container(
                        child: CachedNetworkImage(
                          imageUrl: databerita[index]["kabar_gambar"],
                          // new NetworkImage(databerita[index]["kabar_gambar"]),
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
                        ),
                        // ),
                        // child: Image(
                        //   image:
                        //       new NetworkImage(databerita[index]["kabar_gambar"]),
                        //   fit: BoxFit.cover,
                        // ),
                      ),

                      /*new Image(
                          image: new NetworkImage(
                            databerita[index]["kabar_gambar"],
                            //NOTE api gambar berita
                          ),
                        ),*/
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.01),
                      ),
                      // Container(
                      //   padding: new EdgeInsets.only(
                      //       left: 10.0, right: 10.0, bottom: 5.0),
                      //   child: Row(
                      //     children: <Widget>[
                      //       new Text(
                      //         databerita[index]["kabar_kategori"]
                      //             .toUpperCase(), //NOTE api kategori berita
                      //         style: new TextStyle(
                      //           fontSize: 13,
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.black87,
                      //         ),
                      //       ),
                      //       Container(
                      //           height: 10,
                      //           child: VerticalDivider(color: Colors.grey)),
                      //       new Text(
                      //         databerita[index]["kabar_admin"][0]
                      //                 .toUpperCase() +
                      //             databerita[index]["kabar_admin"]
                      //                 .substring(1), //NOTE api admin berita
                      //         style: new TextStyle(
                      //           fontSize: 13,
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.black87,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: new EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text(
                          databerita[index]
                              ["kabar_judul"], //NOTE api judul berita
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                          //textAlign: TextAlign.justify,
                        ),
                      ),

                      // HtmlView(
                      //   // stylingOptions: ,
                      //   padding: new EdgeInsets.all(10.0),
                      //   data: databerita[index]["kabar_isi"].substring(0, 200),
                      //   onLaunchFail: (url) {
                      //     // optional, type Function
                      //     print("launch $url failed");
                      //   },
                      //   scrollable: false,
                      // ),
                      // Divider(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.01),
                      ),
                      Container(
                        padding: new EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: [
                                new Text(
                                  databerita[index]["kabar_kategori"]
                                      .toUpperCase(), //NOTE api kategori berita
                                  style: new TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown[800],
                                  ),
                                ),
                                Container(
                                    height: 10,
                                    child: VerticalDivider(color: Colors.grey)),
                                new Text(
                                  databerita[index]["data_nama"]
                                      .toUpperCase(), //NOTE api kategori berita
                                  style: new TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown[800],
                                  ),
                                ),
                              ],
                            ),

                            // Container(
                            //     height: 10,
                            //     child: VerticalDivider(color: Colors.grey)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.date_range,
                                  size: 16,
                                  color: Colors.brown[800],
                                ),
                                new Padding(
                                  padding: new EdgeInsets.only(
                                      right: mediaQueryData.size.height * 0.01),
                                ),
                                new Text(
                                  databerita[index][
                                      "kabar_tanggal"], //NOTE api tanggal berita
                                  style: new TextStyle(
                                    fontSize: 13,
                                    color: Colors.brown[800],
                                  ),
                                ),
                                // Container(
                                //   height: 10,
                                //   child: VerticalDivider(color: Colors.grey),
                                // ),
                                new Padding(
                                  padding: new EdgeInsets.only(
                                      right: mediaQueryData.size.height * 0.01),
                                ),
                                Icon(
                                  Icons.remove_red_eye,
                                  size: 16,
                                  color: Colors.brown[800],
                                ),
                                new Padding(
                                  padding: new EdgeInsets.only(
                                      right: mediaQueryData.size.height * 0.01),
                                ),
                                new Text(
                                  dibaca, //NOTE api banyak dilihat
                                  style: new TextStyle(
                                    color: Colors.brown[800],
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                                new Padding(
                                  padding: new EdgeInsets.only(
                                      right: mediaQueryData.size.height * 0.01),
                                ),
                              ],
                            )

                            // SizedBox(
                            //   height: 25.0, //NOTE push detail berita
                            //   child: InkWell(
                            //     child: FlatButton(
                            //       color: Colors.green,
                            //       textColor: Colors.white,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius:
                            //             new BorderRadius.circular(15.0),
                            //       ),
                            //       child: Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: <Widget>[
                            //           Text(
                            //             'Lihat  ',
                            //             style: TextStyle(
                            //               fontSize: 10,
                            //               fontWeight: FontWeight.w700,
                            //               color: Colors.white,
                            //             ),
                            //           ),
                            //           Icon(
                            //             Icons.arrow_forward,
                            //             size: 16,
                            //             color: Colors.white,
                            //           )
                            //         ],
                            //       ),
                            //       onPressed: () {
                            //         print(dataJSON);
                            //         if (databerita[index]
                            //                     ["kabar_kategori"] ==
                            //                 'KEGIATAN' ||
                            //             databerita[index]["kabar_kategori"] ==
                            //                 'Kegiatan' ||
                            //             databerita[index]["kabar_kategori"] ==
                            //                 'kegiatan') {
                            //           Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //               builder: (context) => DetailPotensi(
                            //                 dKategori: databerita[index]
                            //                     ["kabar_kategori"],
                            //                 dBaca: databerita[index]
                            //                     ["dibaca"],
                            //                 dId: databerita[index]
                            //                     ["kabar_id"],
                            //                 dIdDesa: databerita[index]
                            //                     ["id_desa"],
                            //                 dDesa: databerita[index]
                            //                     ["data_nama"],
                            //                 dKecamatan: databerita[index]
                            //                     ["data_kecamatan"],
                            //                 dGambar: databerita[index]
                            //                     ["kabar_gambar"],
                            //                 dJudul: databerita[index]
                            //                     ["kabar_judul"],
                            //                 dTempat: databerita[index]
                            //                     ["kabar_tempat"],
                            //                 dAdmin: databerita[index]
                            //                     ["kabar_admin"],
                            //                 dTanggal: databerita[index]
                            //                     ["kabar_tanggal"],
                            //                 dHtml: databerita[index]
                            //                     ["kabar_isi"],
                            //                 dVideo: databerita[index]
                            //                     ["kabar_video"],
                            //               ),
                            //             ),
                            //           );
                            //         } else {
                            //           Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //               builder: (context) => DetailBerita(
                            //                 dId: databerita[index]
                            //                     ["kabar_id"],
                            //                 dIdDesa: databerita[index]
                            //                     ["id_desa"],
                            //                 dBaca: databerita[index]
                            //                     ["dibaca"],
                            //                 dDesa: databerita[index]
                            //                     ["data_nama"],
                            //                 dKecamatan: databerita[index]
                            //                     ["data_kecamatan"],
                            //                 dGambar: databerita[index]
                            //                     ["kabar_gambar"],
                            //                 dKategori: databerita[index]
                            //                     ["kabar_kategori"],
                            //                 dJudul: databerita[index]
                            //                     ["kabar_judul"],
                            //                 dAdmin: databerita[index]
                            //                     ["kabar_admin"],
                            //                 dTanggal: databerita[index]
                            //                     ["kabar_tanggal"],
                            //                 dHtml: databerita[index]
                            //                     ["kabar_isi"],
                            //                 dVideo: databerita[index]
                            //                     ["kabar_video"],
                            //               ),
                            //             ),
                            //           );
                            //         }
                            //       },
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
            ),
            // ),
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
              Navigator.pushReplacementNamed(context, '/HalamanBeritaWarga');
            },
          );
        },
        child: Builder(
          builder: (BuildContext context) {
            // return OfflineBuilder(
            //   connectivityBuilder: (BuildContext context,
            //       ConnectivityResult connectivity, Widget child) {
            //     final bool connected = connectivity != ConnectivityResult.none;
            //     return Stack(
            //       fit: StackFit.expand,
            //       children: [
            //         child,
            //         Positioned(
            //           left: 0.0,
            //           right: 0.0,
            //           height: 32.0,
            //           child: AnimatedContainer(
            //             duration: const Duration(milliseconds: 300),
            //             color: connected ? null : Colors.orange,
            //             child: connected
            //                 ? null
            //                 : Row(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: <Widget>[
            //                       Text(
            //                         "Periksa jaringan internet",
            //                         style: TextStyle(color: Colors.white),
            //                       ),
            //                       SizedBox(
            //                         width: 8.0,
            //                       ),
            //                       SizedBox(
            //                         width: 12.0,
            //                         height: 12.0,
            //                         child: CircularProgressIndicator(
            //                           strokeWidth: 2.0,
            //                           valueColor: AlwaysStoppedAnimation<Color>(
            //                               Colors.white),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //           ),
            //         ),
            //       ],
            //     );
            //   },
            //   child: new Container(
            return Container(
              padding: new EdgeInsets.all(1.0),
              child: Column(
                children: <Widget>[
                  new Container(
                    alignment: Alignment.centerLeft,
                    padding: new EdgeInsets.all(10.0),
                    child: Text(
                      "Semua Berita",
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
            );
            // ),
            // );
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
