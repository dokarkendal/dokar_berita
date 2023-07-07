import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dokar_aplikasi/warga/surat/detail_surat_warga.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'style/styleset.dart';

class HalDashboardWarga extends StatefulWidget {
  const HalDashboardWarga({super.key});

  @override
  State<HalDashboardWarga> createState() => _HalDashboardWargaState();
}

class _HalDashboardWargaState extends State<HalDashboardWarga> {
  String nama = "";
  String namadesa = "";
  String datadiri = "";
  String dokumen = "";
  String status = "";
  String kelamin = "";
  // ignore: unused_field
  bool _isLoggedIn = false;
  TextEditingController uID = TextEditingController();

  Future _cekKelengkapan() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = true;
    });
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/account/DatawargabyUid"),
        body: {
          "uid": pref.getString("uid")!,
        });
    var cekData = json.decode(response.body);
    print(cekData);
    setState(() {
      _isLoggedIn = false;
      status = cekData["Status"];
      datadiri = cekData["datadiri"];
      dokumen = cekData["datadukung"];
      kelamin = cekData["Data"]["kelamin_id"];
    });
    // if (cekData["Status"] == "Lengkap") {
    //   setState(() {
    //     _isLoggedIn = false;
    //     datadiri = cekData["datadiri"];
    //     dokumen = cekData["datadukung"];
    //   });
    // } else {
    //   setState(() {
    //     _isLoggedIn = false;
    //   });
    // }
  }

  Future _cekUserWarga() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getString("uid") != null) {
      setState(() {
        nama = pref.getString("nama")!;
        namadesa = pref.getString("nama_desa")!;
      });
    }
  }

  //NOTE Fungsi Cek Logout
  Future _cekLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_isLoggedIn") == null) {
      _isLoggedIn = false;
      // Navigator.pushReplacementNamed(context, '/PilihAkun');
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/PilihAkun',
        (Route<dynamic> route) => false,
      );
    } else {
      _isLoggedIn = true;
    }
  }

  bool hasThrownError = false;
  late List data5Surat = [];
  void suratPengajuan5() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/surat/GetLimaSuratByUid"),
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
              _isLoggedIn = false;
              data5Surat = parsedData;
            });
            print('Data 5 Surat: $data5Surat');
          } else {
            setState(() {
              _isLoggedIn = false;
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
    // TODO: implement initState
    super.initState();
    _cekUserWarga();
    _cekKelengkapan();
    suratPengajuan5();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      floatingActionButton: status == "Lengkap"
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/PengajuanSurat');
              },
              label: const Text(
                'Surat',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Colors.green,
            )
          : null,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.account_circle),
          color: appbarIcon,
          iconSize: 25.0,
          onPressed: () {
            Navigator.pushNamed(context, '/HalEditWarga')
                .then((value) => _cekKelengkapan());
          },
        ),
        centerTitle: true,
        title: Text(
          "DOKAR ",
          style: TextStyle(
            color: appbarTitle,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            iconSize: 25.0,
            onPressed: () async {
              // Navigator.pushNamed(context, '/MyEditor');
              Dialogs.bottomMaterialDialog(
                msg: 'Anda yakin ingin keluar aplikasi?',
                title: "Keluar",
                color: Colors.white,
                lottieBuilder: Lottie.asset(
                  'assets/animation/exit2.json',
                  fit: BoxFit.contain,
                  repeat: false,
                ),
                // animation:'assets/logo/animation/exit.json',
                context: context,
                actions: [
                  IconsOutlineButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: 'Tidak',
                    iconData: Icons.cancel_outlined,
                    textStyle: const TextStyle(color: Colors.grey),
                    iconColor: Colors.grey,
                  ),
                  IconsButton(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.clear();

                      // int launchCount = 0;
                      // pref.setInt('counter', launchCount + 1);
                      _cekLogout();
                    },
                    text: 'Exit',
                    iconData: Icons.exit_to_app,
                    color: Colors.red,
                    textStyle: const TextStyle(color: Colors.white),
                    iconColor: Colors.white,
                  ),
                ],
              );
            },
          )
        ],
      ),
      body: _isLoggedIn == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                _header(),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    children: [
                      status == "Lengkap"
                          ? Column(
                              children: [
                                _cardlengkap(),
                                _paddingTop1(),
                                _riwayatSurat(),
                              ],
                            )
                          : Column(
                              children: [
                                datadiri == "1"
                                    ? Center()
                                    : _cardbelumlengkapData(),
                                _paddingTop1(),
                                dokumen == "1"
                                    ? Center()
                                    : _cardbelumlengkapDokumen(),
                              ],
                            ),
                      // _paddingTop1(),
                      // _riwayatSurat(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _cardbelumlengkapData() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.all(15.0),
      height: mediaQueryData.size.height * 0.2,
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0.0, 5.0),
              blurRadius: 7.0),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Silahkan lengkapi data diri",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
              )
            ],
          ),
          _paddingTop1(),
          Text(
            "Untuk dapat menggunakan layanan surat, anda harus melengkapi data diri dan informasi terkait identitas anda",
            style: TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          _paddingTop1(),
          _paddingTop1(),

          _buttonDataDiri(),
          // _buttonDokumen(),
        ],
      ),
    );
  }

  Widget _cardbelumlengkapDokumen() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.all(15.0),
      height: mediaQueryData.size.height * 0.2,
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0.0, 5.0),
              blurRadius: 7.0),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Silahkan lengkapi Dokumen",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
              )
            ],
          ),
          _paddingTop1(),
          Text(
            "Untuk dapat menggunakan layanan surat, anda harus melengkapi Dokumen berupa KTP, Foto dll",
            style: TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          _paddingTop1(),
          _paddingTop1(),

          // _buttonDataDiri(),
          _buttonDokumen(),
        ],
      ),
    );
  }

  Widget _cardlengkap() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/HalProfilWarga');
      },
      child: Container(
        padding: EdgeInsets.all(15.0),
        height: mediaQueryData.size.height * 0.07,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0.0, 5.0),
                blurRadius: 7.0),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Data diri lengkap",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Icon(
                  Icons.more_vert_sharp,
                  color: Colors.white,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _riwayatSurat() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '/HalProfilWarga');
      },
      child: Container(
        padding: EdgeInsets.all(15.0),
        // height: mediaQueryData.size.height * 0.07,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0.0, 5.0),
                blurRadius: 7.0),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Riwayat Surat",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/HalSemuaSurat');
                  },
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            _paddingTop1(),
            _suratPengajuan(),
          ],
        ),
      ),
    );
  }

  Widget _buttonDataDiri() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: mediaQueryData.size.width,
      height: mediaQueryData.size.height * 0.06,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/HalLengkapiDataWarga').then(
            (value) => _cekKelengkapan(),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(15.0),
          backgroundColor: Colors.white,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),
        child: Text(
          'LENGKAPI DATA DIRI',
          style: TextStyle(
            color: Colors.deepOrange,
            letterSpacing: 1.5,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buttonDokumen() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: mediaQueryData.size.width,
      height: mediaQueryData.size.height * 0.06,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/HalLengkapiDokumenWarga')
              .then((value) => _cekKelengkapan());
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(15.0),
          backgroundColor: Colors.white,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),
        child: Text(
          'LENGKAPI DOKUMEN',
          style: TextStyle(
            color: Colors.deepOrange,
            letterSpacing: 1.5,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _paddingTop1() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
    );
  }

  Widget _header() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        // boxShadow: [
        //   BoxShadow(
        //       color: Colors.black.withOpacity(0.1),
        //       offset: const Offset(0.0, 1.0),
        //       blurRadius: 3.0),
        // ],
      ),
      child: Stack(
        // clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: mediaQueryData.size.width,
            height: mediaQueryData.size.height * 0.1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: mediaQueryData.size.height * 0.045,
              horizontal: mediaQueryData.size.width * 0.07,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  "Hai " + nama,
                  minFontSize: 14,
                  style: TextStyle(
                    color: Color(0xFF2e2e2e),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AutoSizeText(
                  namadesa,
                  minFontSize: 14,
                  style: TextStyle(
                    color: Color(0xFF2e2e2e),
                    fontSize: 18.0,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //   // top: mediaQueryData.size.height * 0.05,
          //   left: mediaQueryData.size.height * 0.32,
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.mail,
          //       color: Colors.white,
          //       size: 90,
          //     ),
          //     onPressed: () {
          //       // Navigator.pushNamed(context, '/HalNotifikasi');
          //     },
          //   ),
          // child: kelamin == "1"
          //     ? Image.asset(
          //         'assets/images/orang3.png',
          //         width: mediaQueryData.size.height * 0.35,
          //         height: mediaQueryData.size.width * 0.35,
          //       )
          //     : Image.asset(
          //         'assets/images/orang2.png',
          //         width: mediaQueryData.size.height * 0.35,
          //         height: mediaQueryData.size.width * 0.35,
          //       ),
          // ),
        ],
      ),
    );
  }

  Widget _suratPengajuan() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return data5Surat.isEmpty
        ? Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  new Icon(
                    Icons.mail_outline_outlined,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  Text(
                    "Belum ada pengajuan surat",
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
            itemCount: data5Surat.isEmpty ? 0 : data5Surat.length,
            itemBuilder: (BuildContext context, int i) {
              var status;
              if (data5Surat[i]["status"] == "Surat Sudah Dibuat") {
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
              } else if (data5Surat[i]["status"] == "Menunggu") {
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
              }
              return Container(
                padding: EdgeInsets.only(
                  top: mediaQueryData.size.height * 0.005,
                  // left: mediaQueryData.size.height * 0.01,
                  // right: mediaQueryData.size.height * 0.01,
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
                          offset: Offset(0.0, 2.0),
                          blurRadius: 2.0),
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
                              dNama: data5Surat[i]["nama"],
                              dNik: data5Surat[i]["nik"],
                              dStatus: data5Surat[i]["status"],
                              dNoSurat: data5Surat[i]["nomor"],
                              dKategori: data5Surat[i]["kategori"],
                              dTanggal: data5Surat[i]["tanggal_buat"],
                              dKode: data5Surat[i]["kode"],
                              dKeterangan: data5Surat[i]["keterangan"],
                              dIdSurat: data5Surat[i]["id_surat"],
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      // top: 5.0,
                                      bottom: 5.0,
                                    ),
                                    child: new Text(
                                      data5Surat[i]["kategori"],
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
                                  data5Surat[i]["keterangan"],
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
                                  data5Surat[i]["nomor"],
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
                                      "Kode : " + data5Surat[i]["kode"],
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
                                      data5Surat[i]["tanggal_buat"],
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
                suratPengajuan5();
              },
            )
          ],
        ),
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, 390.0 - 200);
    path.quadraticBezierTo(size.width / 2, 280, size.width, 390.0 - 200);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
