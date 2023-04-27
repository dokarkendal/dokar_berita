//ANCHOR PACKAGE halaman potensi

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dokar_aplikasi/berita/detail_galeri.dart';
// import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';

import '../../style/styleset.dart';

//ANCHOR StatefulWidget Potensi
class GaleriProfile extends StatefulWidget {
  final String idDesa, namaDesa;

  GaleriProfile({
    required this.idDesa,
    required this.namaDesa,
  });

  @override
  _GaleriProfileState createState() => _GaleriProfileState();
}

class _GaleriProfileState extends State<GaleriProfile> {
//ANCHOR Atribut

  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/kabar/newloadmoregaleri"; //NOTE url api load berita
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
    //SharedPreferences pref = await SharedPreferences.getInstance();
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      final response = await dio.get(nextPage + "/" + "${widget.idDesa}/");
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
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        // childAspectRatio: 1,
        crossAxisCount: 3,
        // childAspectRatio: MediaQuery.of(context).size.width /
        //     (MediaQuery.of(context).size.height / 1.65),
      ),
      //+1 for progressbar
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: databerita.length + 1, //NOTE if else listview berita
      // ignore: missing_return
      itemBuilder: (BuildContext context, int index) {
        if (index == databerita.length) {
          return _buildProgressIndicator();
        } else {
          if (databerita[index]["kabar_id"] == 'Notfound') {
            /*
            return new Container(
              child: ListTile(
                title: new Text(
                  databerita[index]["inovasi_id"], // NOTE api admin judul bawah
                  overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent),
                ),
              ),
            );*/
          } else {
            return new Container(
              child: new GestureDetector(
                onTap: () {},
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1,
                      //borderRadius: BorderRadius.circular(5.0),
                      child: GestureDetector(
                        child: CachedNetworkImage(
                          imageUrl: databerita[index]["kabar_gambar"],
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
                          width: mediaQueryData.size.width * 0.35,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailGaleri(
                                dGambar: databerita[index]["kabar_gambar"],
                                dDesa: databerita[index]["data_nama"],
                                dJudul: databerita[index]["kabar_judul"],
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
        return Container();
      },
    );
  }

//ANCHOR body berita
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          "DESA ${widget.namaDesa}",
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await Future.delayed(
            Duration(seconds: 2),
            () {
              Navigator.pushReplacementNamed(context, '/Agenda');
            },
          );
        },
        child: new Container(
          padding: new EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // new Container(
              //   padding: new EdgeInsets.all(10.0),
              //   child: Text(
              //     "Gambar desa",
              //     style: new TextStyle(
              //         fontSize: 16,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.black),
              //   ),
              // ),
              Expanded(
                child: _buildList(),
              ),
            ],
          ),
        ),
      ),
      // resizeToAvoidBottomInset: false,
    );
  }
}
