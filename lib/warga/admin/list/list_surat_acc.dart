import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../../style/styleset.dart';
import '../detail/detail_surat_acc.dart';

class HalSuratACC extends StatefulWidget {
  const HalSuratACC({super.key});

  @override
  State<HalSuratACC> createState() => _HalSuratACCState();
}

class _HalSuratACCState extends State<HalSuratACC> {
  bool loadingsuratacc = false;
  List datasuratacc = [];
  final dio = Dio();
  ScrollController _scrollController = ScrollController();
  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/surat/GetPengajuanSurat/";

  void _moreSuratACC() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (!loadingsuratacc) {
      setState(
        () {
          loadingsuratacc = true;
          print(pref.getString('IdDesa'));
        },
      );
      print(nextPage);

      final formData = FormData.fromMap({
        "id_desa": pref.getString("IdDesa"),
        "status": "1",
      });
      final response = await dio.post(nextPage, data: formData);
      print(response.toString());
      List tempList = [];
      nextPage = response.data['next'];
      for (int i = 0; i < response.data['result'].length; i++) {
        tempList.add(response.data['result'][i]);
      }
      if (mounted) {
        setState(
          () {
            loadingsuratacc = false;
            datasuratacc.addAll(tempList);
            print(tempList);
          },
        );
      }
    }
  }

  @override
  void initState() {
    this._moreSuratACC();
    super.initState();
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _moreSuratACC();
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          'SURAT ACC',
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
      body: Container(
        child: _suratACC(),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: loadingsuratacc ? 1.0 : 00,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _suratACC() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    bool notFoundDisplayed = false;
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: datasuratacc.length + 1,
      itemBuilder: (BuildContext context, int i) {
        if (i == datasuratacc.length) {
          return _buildProgressIndicator();
        } else {
          if (datasuratacc[i]["id_surat"] == "notfound") {
            if (!notFoundDisplayed) {
              notFoundDisplayed =
                  true; // Set the flag to true to prevent multiple displays
              return Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                child: Text(
                  "Tidak ada lagi surat 😁",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              );
            } else {
              return Container(); // Return an empty container for subsequent "notfound" items
            }
          } else {
            var status;
            if (datasuratacc[i]["status"] == "Surat Sudah Dibuat") {
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
            } else if (datasuratacc[i]["status"] == "Menunggu") {
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
            } else if (datasuratacc[i]["status"] == "Pengajuan di Tolak") {
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
                          builder: (context) => HalDetailSuratACC(
                            dNama: datasuratacc[i]["nama"],
                            dNik: datasuratacc[i]["nik"],
                            dStatus: datasuratacc[i]["status"],
                            dNoSurat: datasuratacc[i]["nomor"],
                            dKategori: datasuratacc[i]["kategori"],
                            dTanggal: datasuratacc[i]["tanggal_buat"],
                            dKode: datasuratacc[i]["kode"],
                            dKeterangan: datasuratacc[i]["keterangan"],
                            dIdSurat: datasuratacc[i]["id_surat"],
                            dUid: datasuratacc[i]["uid"],
                            dIdDesa: datasuratacc[i]["id_desa"],
                          ),
                        ),
                      );
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                    // top: 5.0,
                                    bottom: 5.0,
                                  ),
                                  child: new Text(
                                    datasuratacc[i]["nama"],
                                    style: new TextStyle(
                                      fontSize: 16.0,
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
                                datasuratacc[i]["kategori"],
                                //  dataJSON[i]["jenisAudit"],
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(right: 10.0, top: 5.0),
                              // child: Expanded(
                              child: new Text(
                                datasuratacc[i]["nomor"],
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 10.0, top: 5.0),
                                  child: new Text(
                                    "Kode : " + datasuratacc[i]["kode"],
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
                                    datasuratacc[i]["tanggal_buat"],
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
          }
        }
        // return Container();
      },
    );
  }
}
