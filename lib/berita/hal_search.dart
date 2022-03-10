import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dokar_aplikasi/akun/hal_profil_desa.dart';
import 'package:dokar_aplikasi/berita/detail_page_berita.dart';
import 'package:dokar_aplikasi/berita/detail_page_potensi.dart';
import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// ignore: must_be_immutable
class Search extends StatefulWidget {
  String value;
  Search({Key key, this.value = 'text'}) : super(key: key);

  @override
  _SearchState createState() => _SearchState(value);
}

class _SearchState extends State<Search> {
  List dataJSON;
  List dataDesa;
  String value;

  _SearchState(this.value);

  // ignore: missing_return
  Future<String> ambildata() async {
    http.Response hasil = await http.get(Uri.encodeFull(
            // ignore: unnecessary_brace_in_string_interps
            "http://dokar.kendalkab.go.id/webservice/android/kabar/search?key=${value}"),
        headers: {"Accept": "application/json"});

    this.setState(
      () {
        dataJSON = json.decode(hasil.body);
      },
    );
  }

  // ignore: missing_return
  Future<String> searchdesa() async {
    final response = await http.post(
        "http://dokar.kendalkab.go.id/webservice/android/search/desa",
        body: {
          // ignore: unnecessary_brace_in_string_interps
          "key": "${value}",
        });
    this.setState(
      () {
        dataDesa = json.decode(response.body);
      },
    );
    print(dataDesa);
  }

  @override
  // ignore: must_call_super
  void initState() {
    this.ambildata();
    this.searchdesa();
  }

  Widget hasilberita() {
    return ListView.builder(
      //scrollDirection: Axis.horizontal,
      itemCount: dataJSON == null ? 0 : dataJSON.length,
      itemBuilder: (context, i) {
        if (dataJSON[i]["kabar_id"] == 'NotFound') {
          print(dataJSON[i]["kabar_id"]);
          return new Container(
            child: new Center(
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.all(100.0),
                  ),
                  new Text(
                    "Ops.. Berita tidak ada",
                    style: new TextStyle(
                      fontSize: 25.0,
                      color: Colors.grey[350],
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(20.0),
                  ),
                  new Icon(Icons.event_note,
                      size: 150.0, color: Colors.grey[350]),
                ],
              ),
            ),
          );
        } else {
          return new Container(
            // padding: new EdgeInsets.all(2.0),
            child: new Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 1.0,
              color: Colors.white,
              // margin:
              //     const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
              child: InkWell(
                onTap: () {
                  if (dataJSON[i]["kabar_kategori"] == 'Kegiatan' ||
                      dataJSON[i]["kabar_kategori"] == 'KEGIATAN' ||
                      dataJSON[i]["kabar_kategori"] == 'kegiatan') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPotensi(
                          dId: dataJSON[i]["kabar_id"],
                          dIdDesa: dataJSON[i]["id_desa"],
                          dGambar: dataJSON[i]["kabar_gambar"],
                          dKategori: dataJSON[i]["kabar_kategori"],
                          dJudul: dataJSON[i]["kabar_judul"],
                          dAdmin: dataJSON[i]["kabar_admin"],
                          dTanggal: dataJSON[i]["kabar_tanggal"],
                          dHtml: dataJSON[i]["kabar_isi"],
                          dVideo: dataJSON[i]["kabar_video"],
                          dBaca: dataJSON[i]["dibaca"],
                          dKecamatan: dataJSON[i]["data_kecamatan"],
                          dDesa: dataJSON[i]["data_nama"],
                          dTempat: dataJSON[i]["kabar_tempat"],
                          dUrl: dataJSON[i]["url"],
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailBerita(
                          dId: dataJSON[i]["kabar_id"],
                          dIdDesa: dataJSON[i]["id_desa"],
                          dGambar: dataJSON[i]["kabar_gambar"],
                          dKategori: dataJSON[i]["kabar_kategori"],
                          dJudul: dataJSON[i]["kabar_judul"],
                          dAdmin: dataJSON[i]["kabar_admin"],
                          dTanggal: dataJSON[i]["kabar_tanggal"],
                          dHtml: dataJSON[i]["kabar_isi"],
                          dVideo: dataJSON[i]["kabar_video"],
                          dBaca: dataJSON[i]["dibaca"],
                          dKecamatan: dataJSON[i]["data_kecamatan"],
                          dDesa: dataJSON[i]["data_nama"],
                          dUrl: dataJSON[i]["url"],
                        ),
                      ),
                    );
                  }
                },
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      margin: const EdgeInsets.only(right: 15.0),
                      width: 120.0,
                      height: 100.0,
                      child: CachedNetworkImage(
                        imageUrl: dataJSON[i]["kabar_gambar"],
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
                                    dataJSON[i]["data_nama"],
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
                              dataJSON[i]["kabar_judul"],
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
                                  dataJSON[i]["kabar_kategori"],
                                  style: new TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 11.0,
                                  ),
                                ),
                                new Container(
                                  margin: const EdgeInsets.only(left: 5.0),
                                  child: new Text(
                                    dataJSON[i]["kabar_tanggal"],
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
      },
    );
  }

  Widget hasildesa() {
    return GridView.builder(
      shrinkWrap: true,
      //scrollDirection: Axis.horizontal,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 5.5),
      ),
      itemCount: dataDesa == null ? 0 : dataDesa.length,
      itemBuilder: (context, i) {
        if (dataDesa[i]["id"] == 'NotFound') {
          return new Container(
            child: new Center(
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.all(5.0),
                  ),
                  new Text(
                    "Desa tidak ada..",
                    style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[350],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.all(3.0),
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    // padding: EdgeInsets.only(
                    //   top: 5.0,
                    // ),
                    child: Text(
                      dataDesa[i]["desa"],
                      style: new TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    child: AutoSizeText(
                      'Kec.' + dataDesa[i]["kecamatan"],
                      style: new TextStyle(
                        fontSize: 10,
                        color: Colors.brown[800],
                      ),
                      minFontSize: 5,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilDesa(
                      id: dataDesa[i]["id"],
                      desa: dataDesa[i]["desa"],
                      kecamatan: dataDesa[i]["kecamatan"],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      appBar: AppBar(
        title: new Text("PENCARIAN"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.all(10.0),
            child: Text(
              "Hasil Profil",
              style: new TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),
          ),
          hasildesa(),
          new Container(
            padding: new EdgeInsets.all(10.0),
            child: Text(
              "Hasil Berita",
              style: new TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),
          ),
          Expanded(child: hasilberita()),
        ],
      ),
    );
  }
}
