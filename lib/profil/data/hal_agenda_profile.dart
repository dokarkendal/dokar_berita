import 'package:cached_network_image/cached_network_image.dart';
import 'package:dokar_aplikasi/berita/detail_page_agenda.dart';
import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';

//ANCHOR

import 'dart:async';
import 'package:dio/dio.dart';

//ANCHOR
class AgendaProfile extends StatefulWidget {
  final String idDesa;

  AgendaProfile({this.idDesa});

  @override
  _AgendaProfileState createState() => _AgendaProfileState();
}

class _AgendaProfileState extends State<AgendaProfile> {
//ANCHOR Atribut
  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/dashbord/agenda"; //NOTE url api load berita
  ScrollController _scrollController = new ScrollController();
  GlobalKey<RefreshIndicatorState> refreshKey;
  List databerita = [];
  bool isLoading = false;
  final dio = new Dio();
  String dibaca;

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
          if (databerita[index]["nama"] == 'NotFound') {
          } else {
            return new Container(
              child: new GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (context) => new AgendaDetail(
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
                              height: SizeConfig.safeBlockVertical * 20,
                              width: SizeConfig.safeBlockHorizontal * 100,
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
                                child: FlatButton(
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                  ),
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
                          databerita[index]["nama"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
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
        title: Text('AGENDA'),
        centerTitle: true,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                padding: new EdgeInsets.all(10.0),
                child: Text(
                  "Semua Agenda",
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
