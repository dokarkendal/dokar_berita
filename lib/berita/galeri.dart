//import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dokar_aplikasi/berita/detail_galeri.dart';
// import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';

//ANCHOR PACKAGE halaman potensi

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../style/styleset.dart';

//ANCHOR StatefulWidget Potensi
class Galeri extends StatefulWidget {
  @override
  _GaleriState createState() => _GaleriState();
}

class _GaleriState extends State<Galeri> {
//ANCHOR Atribut

  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/kabar/newloadmoregaleri"; //NOTE url api load berita
  ScrollController _scrollController = ScrollController();
  late GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  // ignore: deprecated_member_use
  List databerita = [];
  bool isLoading = false;
  final dio = Dio();
  late String dibaca;
  late List dataJSON;

  void _getMoreData() async {
    //NOTE if else load more
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (!isLoading) {
      setState(
        () {
          isLoading = true;
        },
      );

      final response =
          await dio.get(nextPage + "/" + pref.getString("IdDesa")! + "/");
      // ignore: deprecated_member_use
      List tempList = [];
      nextPage = response.data['next'];

      for (int i = 0; i < response.data['result'].length; i++) {
        tempList.add(response.data['result'][i]);
      }

      setState(
        () {
          isLoading = false;
          databerita.addAll(tempList);
          print(tempList);
          print(pref.getString("IdDesa"));
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

//ANCHOR listview berita
  Widget _buildList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
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
          } else {
            return Container(
              //padding:  EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1,
                      //borderRadius: BorderRadius.circular(5.0),
                      child: GestureDetector(
                        child: CachedNetworkImage(
                          imageUrl: databerita[index]["kabar_gambar"],
                          fit: BoxFit.cover,
                          // height: SizeConfig.safeBlockVertical * 20,
                          // width: SizeConfig.safeBlockHorizontal * 32,
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
    // SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          'GALERI PROFIL',
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
            // fontSize: 25.0,
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
              Navigator.pushReplacementNamed(context, '/Galeri');
            },
          );
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Semua Gambar",
                  style: TextStyle(
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
