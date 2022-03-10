////////////////////////////////PACKAGE//////////////////////////////////////
import 'dart:async'; // api syn
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dokar_aplikasi/berita/detail_page_berita.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; //save session
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

////////////////////////////////PROJECT///////////////////////////////////////
class HalPotensiProfile extends StatefulWidget {
  final String idDesa;

  HalPotensiProfile({this.idDesa});

  @override
  HalPotensiProfileState createState() => HalPotensiProfileState();
}

class HalPotensiProfileState extends State<HalPotensiProfile> {
////////////////////////////////DEKLARASI////////////////////////////////////

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
  );

  String username = "";
  String namadesa = "";
  String status = "";
  // ignore: unused_field
  String _mySelection;

  List beritaAdmin = List();
  GlobalKey<RefreshIndicatorState> refreshKey;
  final SlidableController slidableController = SlidableController();

///////////////////////////////CEK SESSION ADMIN///////////////////////////////////
  // ignore: unused_element
  Future _cekSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(() {
        username = pref.getString("userAdmin");
        status = pref.getString("status");
        namadesa = pref.getString("data_nama");
      });
    }
  }

  //NOTE url api load berita
  //NOTE url api load berita
  ScrollController _scrollController = new ScrollController();
  List databerita = new List();
  bool isLoading = false;
  final dio = new Dio();
  String dibaca;
  List dataJSON;

  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/dashbord/potensi";

  void _getMoreData() async {
    //NOTE if else load more
    //SharedPreferences pref = await SharedPreferences.getInstance();

    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      print(nextPage);
      final response = await dio.get(nextPage + "/${widget.idDesa}/");
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
    //this.getBerita();
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

///////////////////////////////HALAMAN UTAMA//////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('POTENSI'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1), () {});
        },
        child: ListView.builder(
          //scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: databerita.length + 1, //NOTE if else listview berita
          // ignore: missing_return
          itemBuilder: (BuildContext context, int i) {
            if (i == databerita.length) {
              return _buildProgressIndicator();
            } else {
              if (databerita[i]["judul"] == 'NotFound') {
              } else {
                if (databerita[i]["dibaca"] == null) {
                  dibaca = '0';
                } else {
                  dibaca = databerita[i]["dibaca"];
                }
                return new Container(
                  // padding: new EdgeInsets.all(2.0),
                  child: new Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 1.0,
                    color: Colors.white,
                    // margin: const EdgeInsets.symmetric(
                    //     vertical: 5.0, horizontal: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailBerita(
                                dBaca: dibaca,
                                dDesa: databerita[i]["desa"],
                                dKecamatan: databerita[i]["kecamatan"],
                                dGambar: databerita[i]["gambar"],
                                dKategori: databerita[i]["kategori"],
                                dJudul: databerita[i]["judul"],
                                dAdmin: databerita[i]["admin"],
                                dTanggal: databerita[i]["tanggal"],
                                dHtml: databerita[i]["isi"],
                                dUrl: databerita[i]["url"],
                                dId: databerita[i]["id"],
                                dIdDesa: databerita[i]["id_desa"],
                                dVideo: databerita[i]["video"]),
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
                            child: CachedNetworkImage(
                              imageUrl: databerita[i]["gambar"],
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
                                          databerita[i]["desa"],
                                          style: new TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                            //fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    new Container(
                                      margin:
                                          const EdgeInsets.only(right: 10.0),
                                      child: new Text(
                                        dibaca + ' lihat',
                                        style: new TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey[600]),
                                      ),
                                    ),
                                  ],
                                ),
                                new Container(
                                  margin: const EdgeInsets.only(right: 10.0),
                                  child: new Text(
                                    databerita[i]["judul"],
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
                                      new Text(
                                        databerita[i]["kategori"],
                                        style: new TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 11.0,
                                        ),
                                      ),
                                      new Container(
                                        margin:
                                            const EdgeInsets.only(left: 5.0),
                                        child: new Text(
                                          databerita[i]["tanggal"],
                                          style: new TextStyle(
                                            fontSize: 11.0,
                                            color: Colors.grey[500],
                                          ),
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
        ),
      ),
    );
  }
}

/*
color: Colors.grey[100],
                  padding: EdgeInsets.only(
                    left: 5.0,
                    right: 5.0,
                  ),
                  child: new Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        /*Navigator.of(context).push(
                          new MaterialPageRoute(
                            builder: (context) => new FormBeritaEdit(
                              dJudul: databerita[i]["kabar_judul"],
                              dKategori: databerita[i]["kabar_kategori"],
                              dIsi: databerita[i]["kabar_isi"],
                              dTanggal: databerita[i]["kabar_tanggal"],
                              dGambar: databerita[i]["kabar_gambar"],
                              dIdBerita: databerita[i]["kabar_id"],
                              dVideo: databerita[i]["kabar_video"],
                              dKomentar: databerita[i]["komentar"],
                            ),
                          ),
                        );*/
                      },
                      child: ListTile(
                        leading: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 64,
                            minHeight: 64,
                            maxWidth: 84,
                            maxHeight: 84,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image(
                              image: new NetworkImage(
                                  databerita[i]["kabar_gambar"]),
                              fit: BoxFit.cover,
                              height: 150.0,
                              width: 110.0,
                            ),
                          ),
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            new Text(
                              databerita[i]["kabar_tanggal"],
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            new Text(
                              databerita[i]["kabar_kategori"],
                            ),
                          ],
                        ),
                        title: new Text(
                          databerita[i]["kabar_judul"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
*/
