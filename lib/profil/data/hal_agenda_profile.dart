import 'package:cached_network_image/cached_network_image.dart';
import 'package:dokar_aplikasi/berita/detail_page_agenda.dart';
// import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';

//ANCHOR

import 'dart:async';
import 'package:dio/dio.dart';

import '../../style/styleset.dart';

//ANCHOR
class AgendaProfile extends StatefulWidget {
  final String idDesa, namaDesa;

  AgendaProfile({
    required this.idDesa,
    required this.namaDesa,
  });

  @override
  _AgendaProfileState createState() => _AgendaProfileState();
}

class _AgendaProfileState extends State<AgendaProfile> {
//ANCHOR Atribut
  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/dashbord/agenda"; //NOTE url api load berita
  ScrollController _scrollController = ScrollController();
  late GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  List databerita = [];
  bool isLoading = false;
  final dio = Dio();
  late String dibaca;

  void _getMoreData() async {
    //NOTE if else load more
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      final response = await dio.get(nextPage + "/${widget.idDesa}");
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
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
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
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
          if (databerita[index]["nama"] == 'NotFound') {
            return Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                    ),
                    Text(
                      "Agenda Kosong",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[350],
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.all(5.0),
                    // ),
                    Icon(Icons.notes_rounded,
                        size: 120.0, color: Colors.grey[350]),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AgendaDetail(
                        judulEvent: databerita[index]["nama"],
                        desaEvent: databerita[index]["desa"],
                        kecamatanEvent: databerita[index]["kecamatan"],
                        uraianEvent: databerita[index]["uraian"],
                        mulaiEvent: databerita[index]["waktu_mulai"],
                        selesaiEvent: databerita[index]["waktu_selesai"],
                        gambarEvent: databerita[index]["gambar"],
                        penyelenggaraEvent: databerita[index]["penyelenggara"],
                        tglmulaiEvent: databerita[index]["tanggal_mulai"],
                        tglselesaiEvent: databerita[index]["tanggal_selesai"],
                        urlEvent: databerita[index]["url"],
                        idDesa: '',
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: CachedNetworkImage(
                              imageUrl: databerita[index]["gambar"],
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
                              width: mediaQueryData.size.width,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 5.0,
                              left: 5.0,
                            ),
                            child: SizedBox(
                              height: 20.0,
                              width: 100,
                              child: InkWell(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    // padding: EdgeInsets.all(15.0),
                                    elevation: 0, backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // <-- Radius
                                    ),
                                  ),
                                  // color: Colors.green,
                                  // textColor: Colors.white,
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius:
                                  //        BorderRadius.circular(5.0),
                                  // ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        " " +
                                            databerita[index]["tanggal_mulai"],
                                        style: TextStyle(
                                          fontSize: 9,
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
                          databerita[index]["nama"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 4.0, left: 4.0),
                        child: Text(
                          databerita[index]["nama"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
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
      },
    );
  }

//ANCHOR body berita
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AGENDA ' + "${widget.namaDesa}",
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
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
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Semua Agenda",
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
