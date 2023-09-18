import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../../style/styleset.dart';
// import '../detail/detail_surat_acc.dart';
import '../detail/detail_surat_ajukan.dart';

class HalSuratAjukan extends StatefulWidget {
  const HalSuratAjukan({super.key});

  @override
  State<HalSuratAjukan> createState() => _HalSuratAjukanState();
}

class _HalSuratAjukanState extends State<HalSuratAjukan> {
  bool loadingsuratajukan = false;
  List datasuratajukan = [];
  final dio = Dio();
  ScrollController _scrollController = ScrollController();
  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/surat/GetPengajuanSurat/";

  void _moreSuratAjukan() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (!loadingsuratajukan) {
      setState(
        () {
          loadingsuratajukan = true;
          print(pref.getString('IdDesa'));
        },
      );
      print(nextPage);

      final formData = FormData.fromMap({
        "id_desa": pref.getString("IdDesa"),
        "status": "3",
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
            loadingsuratajukan = false;
            datasuratajukan.addAll(tempList);
            print(tempList);
          },
        );
      }
    }
  }

  @override
  void initState() {
    this._moreSuratAjukan();
    super.initState();
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _moreSuratAjukan();
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
          'SURAT AJUKAN',
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
          opacity: loadingsuratajukan ? 1.0 : 00,
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
      itemCount: datasuratajukan.length + 1,
      itemBuilder: (BuildContext context, int i) {
        if (i == datasuratajukan.length) {
          return _buildProgressIndicator();
        } else {
          if (datasuratajukan[i]["id_surat"] == "notfound") {
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
            if (datasuratajukan[i]["status"] == "Surat Sudah Dibuat") {
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
            } else if (datasuratajukan[i]["status"] == "Menunggu") {
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
            } else if (datasuratajukan[i]["status"] == "Pengajuan di Tolak") {
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
            } else if (datasuratajukan[i]["status"] == "Surat Diajukan") {
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
                          builder: (context) => HalDetailSuratAjukan(
                            dNama: datasuratajukan[i]["nama"],
                            dNik: datasuratajukan[i]["nik"],
                            dStatus: datasuratajukan[i]["status"],
                            dNoSurat: datasuratajukan[i]["nomor"],
                            dKategori: datasuratajukan[i]["kategori"],
                            dTanggal: datasuratajukan[i]["tanggal_buat"],
                            dKode: datasuratajukan[i]["kode"],
                            dKeterangan: datasuratajukan[i]["keterangan"],
                            dIdSurat: datasuratajukan[i]["id_surat"],
                            dUid: datasuratajukan[i]["uid"],
                            dIdDesa: datasuratajukan[i]["id_desa"],
                            dPembuatan: datasuratajukan[i]["pembuatan"],
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
                                    datasuratajukan[i]["nama"],
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
                                datasuratajukan[i]["kategori"],
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
                                datasuratajukan[i]["nomor"],
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
                                    "Kode : " + datasuratajukan[i]["kode"],
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
                                    datasuratajukan[i]["tanggal_buat"],
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
