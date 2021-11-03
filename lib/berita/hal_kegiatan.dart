//ANCHOR PACKAGE halaman potensi
import 'package:flutter/material.dart';
import 'package:dokar_aplikasi/berita/detail_page_potensi.dart';
import 'dart:async';
import 'package:dio/dio.dart';

//ANCHOR StatefulWidget Potensi
class Kegiatan extends StatefulWidget {
  Kegiatan(TabController controller);

  @override
  _KegiatanState createState() => _KegiatanState();
}

class _KegiatanState extends State<Kegiatan> {
//ANCHOR Atribut
  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/kabar/loadmorekegiatan"; //NOTE url api load berita
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
    return ListView.builder(
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
              //padding: new EdgeInsets.all(5.0),
              child: new GestureDetector(
                onTap: () {
                  // NOTE onpress container Inovasi listview
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPotensi(
                          dGambar: databerita[index]["kabar_gambar"],
                          dJudul: databerita[index]["kabar_judul"],
                          dTempat: databerita[index]["kabar_tempat"],
                          dAdmin: databerita[index]["kabar_admin"],
                          dTanggal: databerita[index]["kabar_tanggal"],
                          dHtml: databerita[index]["kabar_isi"],
                          dVideo: databerita[index]["kabar_video"]),
                    ),
                  );
                },
                child: new Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
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
                        child: Image.network(
                          databerita[index]
                              ["kabar_gambar"], // NOTE api gambar Inovasi bawah
                          fit: BoxFit.cover,
                          height: 150.0,
                          width: 110.0,
                        ),
                      ),
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        new Text(
                          databerita[index]
                              ["kabar_admin"], // NOTE api admin Inovasi bawah
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                      ],
                    ),
                    title: new Text(
                      databerita[index]
                          ["kabar_judul"], // NOTE api admin judul bawah
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: new TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14.0,
                    ),
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
                      "Kegiatan Desa",
                      style: new TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: _buildList(),
                  ),
                ]),
          )),
      resizeToAvoidBottomInset: false,
    );
  }
}
