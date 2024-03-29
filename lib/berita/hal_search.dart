import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dokar_aplikasi/akun/hal_profil_desa.dart';
import 'package:dokar_aplikasi/berita/detail_page_berita.dart';
import 'package:dokar_aplikasi/berita/detail_page_potensi.dart';
// import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'dart:convert';
import '../style/styleset.dart';
import 'package:badges/badges.dart' as badges;

// ignore: must_be_immutable
class Search extends StatefulWidget {
  String value;
  Search({this.value = 'text'});

  @override
  _SearchState createState() => _SearchState(value);
}

class _SearchState extends State<Search> {
  late List dataJSON = [];
  late List dataDesa = [];
  String value;
  bool isLoading = false;
  _SearchState(this.value);

  // ignore: missing_return
  Future<void> ambildata() async {
    setState(
      () {
        isLoading = true;
      },
    );
    http.Response hasil = await http.get(Uri.parse(
            // ignore: unnecessary_brace_in_string_interps
            "http://dokar.kendalkab.go.id/webservice/android/kabar/search?key=${value}"),
        headers: {"Accept": "application/json"});

    if (mounted) {
      setState(
        () {
          isLoading = false;
          dataJSON = json.decode(hasil.body);
          print(dataJSON);
        },
      );
    }
  }

  // ignore: missing_return
  Future<void> searchdesa() async {
    setState(
      () {
        isLoading = true;
      },
    );
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/search/desa"),
        body: {
          // ignore: unnecessary_brace_in_string_interps
          "key": "${value}",
        });
    if (mounted) {
      setState(
        () {
          isLoading = false;
          dataDesa = json.decode(response.body);
          print(dataDesa);
        },
      );
    }

    print(dataDesa);
  }

  @override
  // ignore: must_call_super
  void initState() {
    this.ambildata();
    this.searchdesa();
  }

  Widget hasilberita() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return isLoading
        ? _buildProgressIndicator()
        : ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: dataJSON.isEmpty ? 0 : dataJSON.length,
            itemBuilder: (context, i) {
              var check;
              if (dataJSON[i]["desa_id"] == "0") {
                check = Center();
              } else if (dataJSON[i]["desa_id"] == "1") {
                check = Container(
                  padding: EdgeInsets.only(
                    top: mediaQueryData.size.height * 0.001,
                    left: mediaQueryData.size.height * 0.002,
                    right: mediaQueryData.size.height * 0.002,
                    bottom: mediaQueryData.size.height * 0.001,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 241, 240, 240),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    border: Border.all(
                      color: Colors.blue,
                      width: 1.0,
                    ),
                  ),
                  // margin: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      badges.Badge(
                        position: badges.BadgePosition.center(),
                        badgeContent: Icon(
                          Icons.check,
                          size: 8,
                          color: Colors.white,
                        ),
                        badgeStyle: badges.BadgeStyle(
                          badgeColor: Colors.blue,
                          shape: badges.BadgeShape.twitter,
                        ),
                      ),
                      SizedBox(
                        width: mediaQueryData.size.height * 0.005,
                      ),
                      new Text(
                        "desa.id ",
                        style: new TextStyle(
                          color: Colors.blue,
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (dataJSON[i]["kabar_id"] == 'NotFound') {
                print(dataJSON[i]["kabar_id"]);
                return Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 30.0),
                        ),
                        Text(
                          "Tidak ada berita",
                          style: TextStyle(
                            fontSize: 25.0,
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
                  // padding:  EdgeInsets.all(2.0),
                  child: Card(
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
                                dDesaid: dataJSON[i]["desa_id"],
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
                                dWaktu: '',
                                dDesaid: dataJSON[i]["desa_id"],
                              ),
                            ),
                          );
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
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
                              errorWidget: (context, url, error) => Container(
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 5.0, bottom: 10.0),
                                      child: Text(
                                        dataJSON[i]["data_nama"],
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.black,
                                          //fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: mediaQueryData.size.width * 0.01,
                                    ),
                                    check,
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    dataJSON[i]["kabar_judul"],
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        dataJSON[i]["kabar_kategori"],
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 11.0,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          dataJSON[i]["kabar_tanggal"],
                                          style: TextStyle(
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

  Widget _buildProgressIndicator() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // SizeConfig().init(context);
    return Padding(
      padding: new EdgeInsets.all(10.0),
      child: Shimmer.fromColors(
        highlightColor: Colors.white,
        baseColor: Colors.grey[300]!,
        child: Container(
          child: Column(
            children: <Widget>[
              // Column(
              //   children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey,
                ),
                height: mediaQueryData.size.height * 0.12,
                width: mediaQueryData.size.width,
                // color: Colors.grey,
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey,
                ),
                height: mediaQueryData.size.height * 0.12,
                width: mediaQueryData.size.width,
                // color: Colors.grey,
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey,
                ),
                height: mediaQueryData.size.height * 0.12,
                width: mediaQueryData.size.width,
                // color: Colors.grey,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator1() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // SizeConfig().init(context);
    return Padding(
      padding: new EdgeInsets.all(10.0),
      child: Shimmer.fromColors(
        highlightColor: Colors.white,
        baseColor: Colors.grey[300]!,
        child: Container(
          child: Row(
            children: <Widget>[
              // Column(
              //   children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey,
                ),
                height: mediaQueryData.size.height * 0.05,
                width: mediaQueryData.size.width * 0.25,
                // color: Colors.grey,
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey,
                ),
                height: mediaQueryData.size.height * 0.05,
                width: mediaQueryData.size.width * 0.25,
                // color: Colors.grey,
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey,
                ),
                height: mediaQueryData.size.height * 0.05,
                width: mediaQueryData.size.width * 0.25,
                // color: Colors.grey,
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget hasildesa() {
    return isLoading
        ? _buildProgressIndicator1()
        : GridView.builder(
            shrinkWrap: true,
            //scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 5.5),
            ),
            itemCount: dataDesa.isEmpty ? 0 : dataDesa.length,
            itemBuilder: (context, i) {
              if (dataDesa[i]["id"] == 'NotFound') {
                return Container(
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5.0),
                        ),
                        Text(
                          "Tidak ada desa",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[350],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                var check;
                if (dataDesa[i]["desa_id"] == "0") {
                  check = Center();
                } else if (dataDesa[i]["desa_id"] == "1") {
                  check = badges.Badge(
                    position: badges.BadgePosition.center(),
                    badgeContent: Icon(
                      Icons.check,
                      size: 5,
                      color: Colors.white,
                    ),
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: Colors.blue,
                      shape: badges.BadgeShape.twitter,
                    ),
                  );
                }
                return Container(
                  padding: EdgeInsets.all(2.0),
                  child: ElevatedButton(
                    // color: Theme.of(context).primaryColor,
                    // textColor: Colors.white,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(10.0),
                    // ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(3),
                      // contentPadding: EdgeInsets.zero,
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // <-- Radius
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          // padding: EdgeInsets.only(
                          //   top: 5.0,
                          // ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                dataDesa[i]["desa"],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown[800],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              check,
                            ],
                          ),
                        ),
                        Container(
                          child: AutoSizeText(
                            'Kec.' + dataDesa[i]["kecamatan"],
                            style: TextStyle(
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
                            title: '',
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
    // SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          // ignore: unnecessary_brace_in_string_interps
          "HASIL " + "' " + "${value}" + " '",
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Hasil Desa",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            hasildesa(),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Hasil Berita",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            hasilberita(),
          ],
        ),
      ),
    );
  }
}
