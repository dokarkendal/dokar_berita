import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../style/styleset.dart';
import 'dart:convert';

import 'detail_surat_warga.dart';

class HalSemuaSurat extends StatefulWidget {
  const HalSemuaSurat({super.key});

  @override
  State<HalSemuaSurat> createState() => _HalSemuaSuratState();
}

class _HalSemuaSuratState extends State<HalSemuaSurat> {
  bool isloading = true;
  bool hasThrownError = false;
  late List dataSurat = [];
  void suratPengajuan() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isloading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/surat/ByUid"),
        body: {
          "uid": pref.getString("uid")!,
          // "uid": "6533",
        },
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        print('Response body: $responseBody');

        try {
          final parsedData = jsonDecode(responseBody)["Data"];

          if (parsedData is List<dynamic>) {
            setState(() {
              isloading = false;
              dataSurat = parsedData;
            });
            print('Data: $dataSurat');
          } else {
            setState(() {
              isloading = false;
            });
            print('Error: Data is not a List<dynamic>');
          }
        } catch (e) {
          print('Error decoding response body: $e');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        setState(() {
          hasThrownError = true;
        });

        //treat SocketException
        print("Socket exception galery: ${e.toString()}");
      } else if (e is TimeoutException) {
        setState(() {
          hasThrownError = true;
        });
        //treat TimeoutException
        print("Timeout exception galery: ${e.toString()}");
      } else {
        setState(() {
          hasThrownError = true;
        });
        print("Unhandled exception galery: ${e.toString()}");
      }
    }
  }

  @override
  void initState() {
    suratPengajuan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          'SURAT',
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
      body: isloading
          ? hasThrownError == true
              ? _errorGalery()
              : Center(
                  child: CircularProgressIndicator(),
                )
          : Container(
              child: ListView(
                physics: ClampingScrollPhysics(),
                children: [
                  _text(),
                  _suratPengajuan(),
                ],
              ),
            ),
    );
  }

  Widget _text() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.all(
        mediaQueryData.size.height * 0.02,
      ),
      child: Text(
        "Surat Pengajuan",
        style: new TextStyle(
            fontSize: 18.0,
            color: Colors.grey[800],
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _suratPengajuan() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return dataSurat.isEmpty
        ? Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  new Icon(
                    Icons.mail_outline_outlined,
                    size: 150,
                    color: Colors.grey[300],
                  ),
                  Text(
                    "Tidak ada Surat",
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[300],
                    ),
                  )
                ],
              ),
            ),
          )
        : ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: dataSurat.isEmpty ? 0 : dataSurat.length,
            itemBuilder: (BuildContext context, int i) {
              var status;
              if (dataSurat[i]["status"] == "Surat Sudah Dibuat") {
                status = Material(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.green[800],
                  child: Column(
                    children: [
                      IconButton(
                        padding: EdgeInsets.only(
                          left: mediaQueryData.size.height * 0.012,
                          right: mediaQueryData.size.height * 0.012,
                          // bottom: mediaQueryData.size.height * 0.01,
                          top: mediaQueryData.size.height * 0.011,
                        ),
                        icon: Icon(Icons.mark_email_read),
                        color: Colors.white,
                        iconSize: 50.0,
                        onPressed: () {
                          // Navigator.pushNamed(context, '/DetailSurat');
                        },
                      ),
                      Text(
                        "Dibuat",
                        style: new TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          //fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (dataSurat[i]["status"] == "Menunggu") {
                status = Material(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey[800],
                  child: Column(
                    children: [
                      IconButton(
                        padding: EdgeInsets.only(
                          left: mediaQueryData.size.height * 0.012,
                          right: mediaQueryData.size.height * 0.012,
                          // bottom: mediaQueryData.size.height * 0.01,
                          top: mediaQueryData.size.height * 0.011,
                        ),
                        icon: Icon(Icons.mark_email_unread),
                        color: Colors.white,
                        iconSize: 50.0,
                        onPressed: () {
                          // Navigator.pushNamed(context, '/DetailSurat');
                        },
                      ),
                      Text(
                        "Menunggu",
                        style: new TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          //fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (dataSurat[i]["status"] == "Pengajuan di Tolak") {
                status = Material(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.red[800],
                  child: Column(
                    children: [
                      IconButton(
                        padding: EdgeInsets.only(
                          left: mediaQueryData.size.height * 0.012,
                          right: mediaQueryData.size.height * 0.012,
                          // bottom: mediaQueryData.size.height * 0.01,
                          top: mediaQueryData.size.height * 0.011,
                        ),
                        icon: Icon(Icons.unsubscribe),
                        color: Colors.white,
                        iconSize: 50.0,
                        onPressed: () {
                          // Navigator.pushNamed(context, '/DetailSurat');
                        },
                      ),
                      Text(
                        "Ditolak",
                        style: new TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          //fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (dataSurat[i]["status"] == "Surat Diajukan") {
                status = Material(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.blue[800],
                  child: Column(
                    children: [
                      IconButton(
                        padding: EdgeInsets.only(
                          left: mediaQueryData.size.height * 0.012,
                          right: mediaQueryData.size.height * 0.012,
                          // bottom: mediaQueryData.size.height * 0.01,
                          top: mediaQueryData.size.height * 0.011,
                        ),
                        icon: Icon(Icons.outgoing_mail),
                        color: Colors.white,
                        iconSize: 50.0,
                        onPressed: () {
                          // Navigator.pushNamed(context, '/DetailSurat');
                        },
                      ),
                      Text(
                        "Diajukan",
                        style: new TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          //fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container(
                padding: EdgeInsets.only(
                  top: mediaQueryData.size.height * 0.005,
                  left: mediaQueryData.size.height * 0.01,
                  right: mediaQueryData.size.height * 0.01,
                  // bottom: mediaQueryData.size.height * 0.02,
                ),
                child: Container(
                  // clipBehavior: Clip.antiAliasWithSaveLayer,
                  // elevation: 1.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0.0, 3.0),
                          blurRadius: 5.0),
                    ],
                  ),
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HalDetailSurat(
                              dNama: dataSurat[i]["nama"],
                              dNik: dataSurat[i]["nik"],
                              dStatus: dataSurat[i]["status"],
                              dNoSurat: dataSurat[i]["nomor"],
                              dKategori: dataSurat[i]["kategori"],
                              dTanggal: dataSurat[i]["tanggal_buat"],
                              dKode: dataSurat[i]["kode"],
                              dKeterangan: dataSurat[i]["keterangan"],
                              dIdSurat: dataSurat[i]["id_surat"],
                              dFile: dataSurat[i]["file"],
                            ),
                          ),
                        ).then((value) => suratPengajuan());
                      },
                      child: Row(
                        children: [
                          Container(
                              height: mediaQueryData.size.height * 0.11,
                              child: status),
                          SizedBox(
                            width: mediaQueryData.size.width * 0.02,
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      // top: 5.0,
                                      bottom: 5.0,
                                    ),
                                    child: new Text(
                                      dataSurat[i]["kategori"],
                                      style: new TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.blue[800],
                                        fontWeight: FontWeight.bold,
                                        //fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10.0),
                                // child: Expanded(
                                child: new Text(
                                  dataSurat[i]["keterangan"],
                                  //  dataJSON[i]["jenisAudit"],
                                  style: new TextStyle(
                                    fontSize: 13.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    right: 10.0, top: 5.0),
                                // child: Expanded(
                                child: new Text(
                                  dataSurat[i]["nomor"],
                                  //  dataJSON[i]["jenisAudit"],
                                  style: new TextStyle(
                                    color: Colors.green[800],
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        right: 10.0, top: 5.0),
                                    child: new Text(
                                      "Kode : " + dataSurat[i]["kode"],
                                      style: new TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black,
                                        // color: Colors.blueAccent[100],
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        right: 10.0, top: 5.0),
                                    child: new Text(
                                      dataSurat[i]["tanggal_buat"],
                                      style: new TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black,
                                        // color: Colors.blueAccent[100],
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget _errorGalery() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
        ),
        height: mediaQueryData.size.height * 0.21,
        width: mediaQueryData.size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 150.0, vertical: 20.0),
            Icon(Icons.wifi_off_rounded, size: 50.0, color: Colors.grey[350]),
            // ),
            Text(
              "Tidak dapat dijankau \natau waktu habis",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[350],
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Ulangi'),
              onPressed: () {
                suratPengajuan();
              },
            )
          ],
        ),
      ),
    );
  }
}
