import 'package:cached_network_image/cached_network_image.dart';
import 'package:dokar_aplikasi/berita/detail_page_agenda.dart';
// import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';

//ANCHOR PACKAGE halaman potensi

import 'dart:async';
import 'package:dio/dio.dart';

//ANCHOR StatefulWidget Potensi
class Agenda extends StatefulWidget {
  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
//ANCHOR Atribut
  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/agenda/allevent"; //NOTE url api load berita
  ScrollController _scrollController = new ScrollController();
  late GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  List databerita = [];
  bool isLoading = false;
  final dio = new Dio();
  late String dibaca;
  late List dataJSON;

  void _getMoreData() async {
    //NOTE if else load more
    if (!isLoading) {
      setState(
        () {
          isLoading = true;
        },
      );

      final response = await dio.get(nextPage);
      List tempList = [];
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

//ANCHOR listview berita
  Widget _buildList() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1.1),
      ),
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: databerita.length + 1, //NOTE if else listview berita
      // ignore: missing_return
      itemBuilder: (BuildContext context, int index) {
        if (index == databerita.length) {
          return _buildProgressIndicator();
        } else {
          if (databerita[index]["id_agenda"] == 'Notfound') {
          } else {
            return new Container(
              child: new GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (context) => new AgendaDetail(
                        idDesa: databerita[index]["id_desa"],
                        desaEvent: databerita[index]["data_nama"],
                        kecamatanEvent: databerita[index]["data_kecamatan"],
                        judulEvent: databerita[index]["judul_agenda"],
                        uraianEvent: databerita[index]["uraian_agenda"],
                        mulaiEvent: databerita[index]["jam_mulai"],
                        selesaiEvent: databerita[index]["jam_selesai"],
                        gambarEvent: databerita[index]["gambar_agenda"],
                        penyelenggaraEvent: databerita[index]["penyelenggara"],
                        tglmulaiEvent: databerita[index]["tglmulai_agenda"],
                        tglselesaiEvent: databerita[index]["tglselesai_agenda"],
                        urlEvent: databerita[index]["url"],
                      ),
                    ),
                  );
                },
                child: new Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: CachedNetworkImage(
                              imageUrl: databerita[index]["gambar_agenda"],
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
                              fit: BoxFit.cover,
                              height: mediaQueryData.size.height * 0.2,
                              // width: mediaQueryData.size.width * 0.1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 5.0,
                              left: 5.0,
                            ),
                            child: SizedBox(
                              height: 25.0,
                              width: 110,
                              child: InkWell(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    // primary: Colors.white,
                                    backgroundColor: Colors.green,
                                    disabledForegroundColor:
                                        Colors.grey.withOpacity(0.38),
                                  ),
                                  // color: Colors.green,
                                  // textColor: Colors.white,
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius:
                                  //       new BorderRadius.circular(5.0),
                                  // ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        " " +
                                            databerita[index]
                                                ["tglmulai_agenda"],
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          databerita[index]["judul_agenda"],
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 4.0, left: 4.0),
                        child: Text(
                          databerita[index]["data_nama"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                              fontSize: 10.0,
                              // fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
        return Container();
      },
    );
  }

//ANCHOR body berita
  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    return Scaffold(
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await Future.delayed(
            Duration(seconds: 2),
            () {
              //Navigator.pushReplacementNamed(context, '/Agenda');
            },
          );
        },
        child: new Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                padding: new EdgeInsets.all(10.0),
                child: Text(
                  "AGENDA",
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
