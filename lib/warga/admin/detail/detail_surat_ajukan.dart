import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dokar_aplikasi/warga/detail_galeri_warga.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';

class HalDetailSuratAjukan extends StatefulWidget {
  final String dNama,
      dNik,
      dStatus,
      dNoSurat,
      dKategori,
      dTanggal,
      dKode,
      dKeterangan,
      dIdSurat,
      dUid,
      dIdDesa,
      dPembuatan;
  HalDetailSuratAjukan({
    required this.dNama,
    required this.dNik,
    required this.dStatus,
    required this.dNoSurat,
    required this.dKategori,
    required this.dTanggal,
    required this.dKode,
    required this.dKeterangan,
    required this.dIdSurat,
    required this.dUid,
    required this.dIdDesa,
    required this.dPembuatan,
  });

  @override
  State<HalDetailSuratAjukan> createState() => _HalDetailSuratAjukanState();
}

class _HalDetailSuratAjukanState extends State<HalDetailSuratAjukan> {
  bool loadingdata = false;
  bool loadingdatadukung = false;
  bool loadingdataTambahan = false;
  bool loadingtolaksurat = false;
  bool loadingbuat = false;
  bool loadingbuatsurat = false;
  bool loadingactivity = false;
  var _mySelection;
  // List masterSurat = [];
  List<Map<String, dynamic>> jenissurat = [
    {"value": "1", "nama": "Dokar"},
    {"value": "2", "nama": "Srikandi"},
  ];

  final format = DateFormat("yyyy-MM-dd");
  late List dataDukungJSON = [];
  TextEditingController cMulai = TextEditingController();
  TextEditingController cSampai = TextEditingController();
  void detailDataDukung() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      loadingdatadukung = true;
    });
    final response = await http.post(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/account/DataDukungByUid"),
      body: {
        "uid": '${widget.dUid}',
      },
    );
    if (mounted) {
      this.setState(
        () {
          loadingdatadukung = false;
          dataDukungJSON = json.decode(response.body)["Data"];
          print(dataDukungJSON);
        },
      );
    }
  }

  String? cNIK = "";
  String? cTempatlahir = "";
  String? cTanggallahir = "";
  String? cAlamat = "";
  String? cKota = "";
  String? cKecamatan = "";
  String? cDesa = "";
  String? cRT = "";
  String? cRW = "";
  String? cKelamin = "";
  String? cStatusKawin = "";
  String? cAgama = "";
  String? cPekerjaan = "";

  Future _detailWarga() async {
    setState(() {
      loadingdata = true;
    });
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/surat/GetDetailSurat"),
        body: {
          "id_surat": '${widget.dIdSurat}',
          "id_desa": '${widget.dIdDesa}',
        });

    if (mounted) {
      if (response.statusCode == 200) {
        var detailWargaJSON = json.decode(response.body)["Data"];
        print(detailWargaJSON);
        setState(() {
          loadingdata = false;
          cTempatlahir = detailWargaJSON['tmp_lahir'];
          cTanggallahir = detailWargaJSON['tgl_lahir'];
          cAlamat = detailWargaJSON['alamat'];
          cKota = detailWargaJSON['kota'];
          cKecamatan = detailWargaJSON['kecamatan'];
          cDesa = detailWargaJSON['desa'];
          cPekerjaan = detailWargaJSON['pekerjaan'];
          cRT = detailWargaJSON['rt'];
          cRW = detailWargaJSON['rw'];
          cKelamin = detailWargaJSON['kelamin'];
          cStatusKawin = detailWargaJSON['kawin'];
          cAgama = detailWargaJSON['agama'];
        });
      } else {
        setState(() {
          loadingdata = false;
        });
      }
    }
  }

  String extractDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  String extractTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  late List activityJSON = [];
  void activityadmin() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      loadingactivity = true;
    });
    final response = await http.post(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/surat/Aktivity"),
      body: {
        "id_surat": '${widget.dIdSurat}',
      },
    );
    final decodedData = json.decode(response.body)["Data"];

    if (decodedData is List) {
      // "Data" is an array of objects
      this.setState(() {
        loadingactivity = false;
        activityJSON = decodedData;
        print(activityJSON);
      });
    } else if (decodedData is String &&
        decodedData.toLowerCase() == "notfound") {
      // "Data" is a string with value "notfound"
      // Handle the case where the data is not found
      // For example, you can show an error message or set activityJSON to an empty list
      this.setState(() {
        loadingactivity = false;
        activityJSON = [];
        print("Data not found");
      });
    } else {
      // Handle any other unexpected cases
      // For example, you can show an error message or set activityJSON to an empty list
      this.setState(() {
        loadingactivity = false;
        activityJSON = [];
        print("Unexpected data format");
      });
    }
  }

  late List dataTambahJSON = [];
  void detailDataTambah() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      loadingdataTambahan = true;
    });
    final response = await http.post(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/surat/GetDtDukungPengajuanByIdSurat"),
      body: {
        "id_surat": "${widget.dIdSurat}",
      },
    );
    if (mounted) {
      final decodedResponse = json.decode(response.body);
      final responseData = decodedResponse["Data"];

      if (responseData is List) {
        this.setState(() {
          loadingdataTambahan = false;
          dataTambahJSON = responseData;
          print(dataTambahJSON);
        });
      } else {
        // Handle case when "Data" field is "notfound"
        // For example, you can display an error message
        setState(() {
          loadingdataTambahan = false;
        });
        print("Data not found");
      }
    }
  }

  void tolakSurat(pUid, pIdDesa) async {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    setState(
      () {
        loadingtolaksurat = true;
      },
    );
    SharedPreferences pref = await SharedPreferences.getInstance();
    Future.delayed(Duration(seconds: 3), () async {
      final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/surat/TolakSurat"),
        body: {
          "uid": pUid.toString(),
          "id_surat": pIdDesa.toString(),
          "username": pref.getString("userAdmin").toString(),
          "keterangan": cKeterangan.text
        },
      );
      var datauser = json.decode(response.body);
      print(pUid.toString());
      print(pIdDesa.toString());
      print(pref.getString("userAdmin").toString());
      print(datauser);
      if (datauser['Status'] == "Sukses") {
        setState(() {
          loadingtolaksurat = false;
        });
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            elevation: 6.0,
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.done,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  width: mediaQueryData.size.width * 0.02,
                ),
                Flexible(
                  child: Text(
                    datauser['Notif'],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                // Navigator.pushReplacementNamed(context, '/HalDashboard');
                // Navigator.pop(context);
              },
            ),
          ),
        );
        // Navigator.pop(context);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => HalSuratMenunggu()),
        // );
        Navigator.popUntil(context, ModalRoute.withName('/HalSuratAdmin'));
        // Navigator.pushReplacementNamed(context, '/HalSuratMenunggu');
      } else {
        print("Failed");
        setState(
          () {
            loadingtolaksurat = false;
          },
        );

        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            elevation: 6.0,
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  width: mediaQueryData.size.width * 0.02,
                ),
                Flexible(
                  child: Text(
                    datauser['Notif'],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            action: SnackBarAction(
              label: 'ULANGI',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    });
  }

  TextEditingController _nomorSuratController = TextEditingController();
  void getnomor() async {
    final response = await http.post(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/surat/GetNomorSurat"),
      body: {
        "id_surat": '${widget.dIdSurat}',
        "id_desa": '${widget.dIdDesa}',
      },
    );
    if (mounted) {
      this.setState(
        () {
          var nomorSurat = json.decode(response.body)["No"];
          _nomorSuratController.text = nomorSurat;
          print(nomorSurat);
        },
      );
    }
  }

  void buatSurat() async {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    setState(
      () {
        loadingbuatsurat = true;
      },
    );
    // SharedPreferences pref = await SharedPreferences.getInstance();
    Future.delayed(Duration(seconds: 3), () async {
      final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/surat/BuatSurat"),
        body: {
          "id_surat": '${widget.dIdSurat}',
          "id_desa": '${widget.dIdDesa}',
          "uid": '${widget.dUid}',
          "username": '${widget.dNama}',
          "nomor": _nomorSuratController.text,
          "mulai": cMulai.text,
          "sampai": cSampai.text,
          "pembuatan": _mySelection,
          "keterangan": cTujuan.text
        },
      );
      var datauser = json.decode(response.body);
      print('${widget.dIdSurat}');
      print('${widget.dIdDesa}');
      print('${widget.dUid}');
      print('${widget.dNama}');
      print(_nomorSuratController.text);
      print(cMulai.text);
      print(cSampai.text);
      print(cTujuan.text);
      print(datauser);
      print(_mySelection);
      if (datauser['Status'] == "Sukses") {
        setState(() {
          loadingbuatsurat = false;
        });
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            elevation: 6.0,
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.done,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  width: mediaQueryData.size.width * 0.02,
                ),
                Flexible(
                  child: Text(
                    datauser['Notif'],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                // Navigator.pushReplacementNamed(context, '/HalDashboard');
                // Navigator.pop(context);
              },
            ),
          ),
        );
        // Navigator.pop(context);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => HalSuratMenunggu()),
        // );
        Navigator.popUntil(context, ModalRoute.withName('/HalSuratAdmin'));
        // Navigator.pushReplacementNamed(context, '/HalSuratMenunggu');
      } else {
        print("Failed");
        setState(
          () {
            loadingbuatsurat = false;
          },
        );

        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            elevation: 6.0,
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  width: mediaQueryData.size.width * 0.02,
                ),
                Flexible(
                  child: Text(
                    datauser['Notif'],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            action: SnackBarAction(
              label: 'ULANGI',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    detailDataDukung();
    detailDataTambah();
    getnomor();
    activityadmin();
    _detailWarga();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text(
            "${widget.dKode}",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              // fontSize: 25.0,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                showMaterialModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  context: context,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                      left: mediaQueryData.size.height * 0.02,
                      right: mediaQueryData.size.height * 0.02,
                      // bottom: mediaQueryData.size.height * 0.03,
                      // top: mediaQueryData.size.height * 0.03,
                    ),
                    child: SizedBox(
                      height: mediaQueryData.size.height * 0.8,
                      child: ListView(
                        children: <Widget>[
                          Text(
                            "Info Warga",
                            style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold),
                          ),
                          _paddingtop01(),
                          _paddingtop01(),
                          Text(
                            "Tempat/Tgl lahir :",
                            style: TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.w700,
                              color: Colors.grey[600],
                            ),
                          ),
                          _paddingtop01(),
                          Row(
                            children: [
                              Text(
                                cTempatlahir.toString() + ", ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Text(
                                cTanggallahir.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Text(
                            "Alamat:",
                            style: TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.w700,
                              color: Colors.grey[600],
                            ),
                          ),
                          _paddingtop01(),
                          Text(
                            cAlamat.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                          Divider(),
                          Text(
                            "RT/RW:",
                            style: TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.w700,
                              color: Colors.grey[600],
                            ),
                          ),
                          _paddingtop01(),
                          Text(
                            cRT.toString() + "/" + cRW.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                          Divider(),
                          Text(
                            "Kota",
                            style: TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.w700,
                              color: Colors.grey[600],
                            ),
                          ),
                          _paddingtop01(),
                          Text(
                            cKota.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                          Divider(),
                          Text(
                            "Kecamatan",
                            style: TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.w700,
                              color: Colors.grey[600],
                            ),
                          ),
                          _paddingtop01(),
                          Text(
                            cKecamatan.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                          Divider(),
                          Text(
                            "Desa",
                            style: TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.w700,
                              color: Colors.grey[600],
                            ),
                          ),
                          _paddingtop01(),
                          Text(
                            cDesa.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                          Divider(),
                          Text(
                            "Pekerjaan",
                            style: TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.w700,
                              color: Colors.grey[600],
                            ),
                          ),
                          _paddingtop01(),
                          Text(
                            cPekerjaan.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                          Divider(),
                          Text(
                            "Kelamin",
                            style: TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.w700,
                              color: Colors.grey[600],
                            ),
                          ),
                          _paddingtop01(),
                          Text(
                            cKelamin.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                          Divider(),
                          Text(
                            "Status",
                            style: TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.w700,
                              color: Colors.grey[600],
                            ),
                          ),
                          _paddingtop01(),
                          Text(
                            cStatusKawin.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.blueAccent),
      body: ListView(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  _headerWarga(),
                  detailSuratdata(),
                  cardWargaDetail(),
                  _listDataDukung(),
                  // _listDataTambahan(),
                ],
              )
            ],
          ),

          // _headerWarga(),
          // CardWargaDetail(),
        ],
      ),
    );
  }

  Widget _headerWarga() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      height: mediaQueryData.size.height * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueAccent,
            Colors.blueAccent.shade200,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        // borderRadius: BorderRadius.circular(5),
      ),
      // child: Stack(
      //   children: [
      //     SizedBox(
      //       width: mediaQueryData.size.width,
      //       height: mediaQueryData.size.height * 0.3,
      //     ),
      //     Padding(
      //       padding: EdgeInsets.symmetric(
      //         vertical: mediaQueryData.size.height * 0.03,
      //         horizontal: mediaQueryData.size.width * 0.07,
      //       ),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           AutoSizeText(
      //             '${widget.dNama}',
      //             minFontSize: 14,
      //             style: TextStyle(
      //               color: Color(0xFF2e2e2e),
      //               fontSize: 20.0,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //           _paddingtop01(),
      //           Row(
      //             children: [
      //               AutoSizeText(
      //                 '${widget.dNik}',
      //                 minFontSize: 14,
      //                 style: TextStyle(
      //                   color: Color(0xFF2e2e2e),
      //                   fontSize: 16.0,
      //                   // fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //               _paddingleft01(),
      //               SizedBox(
      //                 width: mediaQueryData.size.width * 0.3,
      //                 height: 25,
      //                 child: ElevatedButton(
      //                   style: ElevatedButton.styleFrom(
      //                     // padding: EdgeInsets.all(15.0),
      //                     elevation: 0,
      //                     backgroundColor: Colors.grey,
      //                   ),
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       Text(
      //                         '${widget.dStatus}',
      //                         style: TextStyle(
      //                           fontSize: 12,
      //                           fontWeight: FontWeight.w700,
      //                           color: Colors.white,
      //                         ),
      //                       ),
      //                       Icon(
      //                         Icons.access_time,
      //                         size: 14,
      //                         color: Colors.white,
      //                       )
      //                     ],
      //                   ),
      //                   onPressed: () {},
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget detailSuratdata() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.all(mediaQueryData.size.height * 0.03),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            '${widget.dNama}',
            minFontSize: 14,
            style: TextStyle(
              color: Color(0xFF2e2e2e),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          _paddingtop01(),
          Row(
            children: [
              AutoSizeText(
                '${widget.dNik}',
                minFontSize: 14,
                style: TextStyle(
                  color: Color(0xFF2e2e2e),
                  fontSize: 16.0,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              _paddingleft01(),
              SizedBox(
                // width: mediaQueryData.size.width * 0.5,
                height: 25,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15.0), // Adjust the value as per your preference
                    ),
                    elevation: 0,
                    backgroundColor: widget.dStatus == 'Menunggu'
                        ? Colors.grey[600]
                        : Colors.blue[800],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.dStatus}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      _paddingleft01(),
                      Icon(
                        widget.dStatus == 'Menunggu'
                            ? Icons.access_time
                            : Icons.check,
                        size: 14,
                        color: Colors.white,
                      )
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget cardWargaDetail() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.13,
        left: mediaQueryData.size.height * 0.015,
        right: mediaQueryData.size.height * 0.015,
        // bottom: mediaQueryData.size.height * 0.03,
      ),
      child: Container(
        padding: EdgeInsets.all(mediaQueryData.size.height * 0.02),
        width: double.infinity,
        height: mediaQueryData.size.height * 0.36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0.0, 3.0),
              blurRadius: 15.0,
            )
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
                  "No.Surat :",
                  style: TextStyle(
                    fontSize: 14,
                    // fontWeight: FontWeight.w700,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(
                  // width: mediaQueryData.size.width * 0.5,
                  height: 23,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            15.0), // Adjust the value as per your preference
                      ),
                      elevation: 0,
                      backgroundColor: widget.dPembuatan == 'Dokar'
                          ? Colors.red[600]
                          : Colors.blue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.dPembuatan}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        _paddingleft01(),
                        Icon(
                          Icons.mail,
                          size: 14,
                          color: Colors.white,
                        )
                      ],
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            _paddingtop01(),
            Text(
              "${widget.dNoSurat}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.blue[800],
              ),
            ),
            _paddingtop01(),
            Divider(
              color: Colors.grey[600],
            ),
            Text(
              "Kategori :",
              style: TextStyle(
                fontSize: 14,
                // fontWeight: FontWeight.w700,
                color: Colors.grey[600],
              ),
            ),
            _paddingtop01(),
            Text(
              "${widget.dKategori}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
            _paddingtop01(),
            _paddingtop01(),
            // Divider(
            //   color: Colors.grey[600],
            // ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dibuat :",
                      style: TextStyle(
                        fontSize: 14,
                        // fontWeight: FontWeight.w700,
                        color: Colors.grey[600],
                      ),
                    ),
                    _paddingtop01(),
                    Text(
                      "${widget.dTanggal}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.2)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kode :",
                      style: TextStyle(
                        fontSize: 14,
                        // fontWeight: FontWeight.w700,
                        color: Colors.grey[600],
                      ),
                    ),
                    _paddingtop01(),
                    Row(
                      children: [
                        Text(
                          "${widget.dKode}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                        Container(
                          width: 40, // Set your desired width
                          // height: 40, // Set your desired height
                          child: GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: "${widget.dKode}"));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Copied "${widget.dKode}"')),
                              );
                            },
                            child: Center(
                              child: Icon(
                                Icons.copy,
                                size: 20, // Set your desired icon size
                                color:
                                    Colors.grey, // Set your desired icon color
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            _paddingtop01(),
            Divider(
              color: Colors.grey[600],
            ),
            Text(
              "Keterangan :",
              style: TextStyle(
                fontSize: 14,
                // fontWeight: FontWeight.w700,
                color: Colors.grey[600],
              ),
            ),
            _paddingtop01(),
            Text(
              "${widget.dKeterangan}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listDataDukung() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.51,
        left: mediaQueryData.size.height * 0.015,
        right: mediaQueryData.size.height * 0.015,
        // bottom: mediaQueryData.size.height * 0.03,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Data Dukung",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          loadingdatadukung
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dataDukungJSON.isEmpty ? 0 : dataDukungJSON.length,
                  itemBuilder: (context, i) {
                    if (dataDukungJSON[i]["Data"] == "notfound") {
                      return Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 150.0, vertical: 15.0),
                                child: Icon(
                                  Icons.event_busy,
                                  size: 50.0,
                                  color: Colors.grey[350],
                                ),
                              ),
                              Text(
                                "Belum ada data",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.grey[350],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          elevation: 1.0,
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailGaleriWarga(
                                    dGambar: dataDukungJSON[i]["file"],
                                    dJudul: dataDukungJSON[i]["nama"],
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 15.0),
                                  width: 70.0,
                                  height: 50.0,
                                  child: CachedNetworkImage(
                                    imageUrl: dataDukungJSON[i]["file"],
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
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                        right: 10.0,
                                        // top: 5.0,
                                      ),
                                      child: Text(
                                        dataDukungJSON[i]["nama"],
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              "Klik untuk melihat",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
          _listDataTambahan(),
        ],
      ),
    );
  }

  Widget _listDataTambahan() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        // top: mediaQueryData.size.height * 0.78,
        // left: mediaQueryData.size.height * 0.015,
        // right: mediaQueryData.size.height * 0.015,
        bottom: mediaQueryData.size.height * 0.03,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Data Tambahan",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              // IconButton(
              //   icon: Icon(Icons.add_box_rounded),
              //   color: Colors.brown[800],
              //   iconSize: 25.0,
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => HalDataDukungSurat(
              //           dIdTambah: "${widget.dIdSurat}",
              //         ),
              //       ),
              //     ).then((value) => detailDataTambah());
              //     // Navigator.pushNamed(context, '/HalDataDukungSurat');
              //   },
              // ),
            ],
          ),
          loadingdataTambahan
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      dataTambahJSON.length > 0 ? dataTambahJSON.length : 1,
                  itemBuilder: (context, i) {
                    if (dataTambahJSON.length <= 0) {
                      return Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 150.0, vertical: 15.0),
                                child: Icon(
                                  Icons.document_scanner,
                                  size: 50.0,
                                  color: Colors.grey[350],
                                ),
                              ),
                              Text(
                                "Belum ada data tambahan",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.grey[350],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          elevation: 1.0,
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailGaleriWarga(
                                    dGambar: dataTambahJSON[i]["file"],
                                    dJudul: dataTambahJSON[i]["nama"],
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 15.0),
                                  width: 70.0,
                                  height: 50.0,
                                  child: CachedNetworkImage(
                                    imageUrl: dataTambahJSON[i]["file"],
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
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                        right: 10.0,
                                        // top: 5.0,
                                      ),
                                      child: Text(
                                        dataTambahJSON[i]["nama"],
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              "Klik untuk melihat",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
          _listActivity(),
          _paddingtop01(),
          _paddingtop01(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _tolakSurat(),
              _accSurat(),
            ],
          )
        ],
      ),
    );
  }

  TextEditingController cKeterangan = TextEditingController();
  Widget _tolakSurat() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return loadingtolaksurat == true
        ? Container(
            width: mediaQueryData.size.width * 0.45,
            height: mediaQueryData.size.height * 0.06,
            child: ElevatedButton(
              onPressed: () {
                // tolakSurat(widget.dUid, widget.dIdSurat);
              },
              style: ElevatedButton.styleFrom(
                // padding: EdgeInsets.all(15.0),
                backgroundColor: Colors.red[600],
                // elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // <-- Radius
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Container(
            width: mediaQueryData.size.width * 0.45,
            height: mediaQueryData.size.height * 0.06,
            child: ElevatedButton(
              onPressed: () {
                showMaterialModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  context: context,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                      left: mediaQueryData.size.height * 0.02,
                      right: mediaQueryData.size.height * 0.02,
                      // bottom: mediaQueryData.size.height * 0.03,
                      // top: mediaQueryData.size.height * 0.03,
                    ),
                    child: SizedBox(
                      height: mediaQueryData.size.height * 0.7,
                      child: ListView(
                        children: <Widget>[
                          Text(
                            "Tolak Surat",
                            style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold),
                          ),
                          _paddingtop01(),
                          _paddingtop01(),
                          _formKeterangan(),
                          _paddingtop01(),
                          _paddingtop01(),
                          _tombolTolakSurat(),
                        ],
                      ),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15.0),
                backgroundColor: Colors.red,
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // <-- Radius
                ),
              ),
              child: Text(
                'TOLAK',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          );
  }

  Widget _formKeterangan() {
    return Container(
      // padding: EdgeInsets.all(3),
      width: MediaQuery.of(this.context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              maxLines: null,
              controller: cKeterangan,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(200),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.my_library_books_rounded,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Keterangan",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Keterangan tidak boleh kosong';
                }
                return null; // Return null if the validation passes
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _formTujuan() {
    return Container(
      // padding: EdgeInsets.all(3),
      width: MediaQuery.of(this.context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              maxLines: null,
              controller: cTujuan,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(200),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.my_library_books_rounded,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Tujuan",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Keterangan tidak boleh kosong';
                }
                return null; // Return null if the validation passes
              },
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController cTujuan = TextEditingController();
  Widget _accSurat() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return loadingbuatsurat == true
        ? Container(
            width: mediaQueryData.size.width * 0.45,
            height: mediaQueryData.size.height * 0.06,
            child: ElevatedButton(
              onPressed: () {
                // tolakSurat(widget.dUid, widget.dIdSurat);
              },
              style: ElevatedButton.styleFrom(
                // padding: EdgeInsets.all(15.0),
                backgroundColor: Colors.green[600],
                // elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // <-- Radius
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Container(
            width: mediaQueryData.size.width * 0.45,
            height: mediaQueryData.size.height * 0.06,
            child: ElevatedButton(
              onPressed: () {
                showMaterialModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  context: context,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                      left: mediaQueryData.size.height * 0.02,
                      right: mediaQueryData.size.height * 0.02,
                      // bottom: mediaQueryData.size.height * 0.03,
                      // top: mediaQueryData.size.height * 0.03,
                    ),
                    child: SizedBox(
                      height: mediaQueryData.size.height * 0.9,
                      child: ListView(
                        children: <Widget>[
                          Text(
                            "Buat Surat",
                            style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold),
                          ),
                          _paddingtop01(),
                          _paddingtop01(),
                          _paddingtop01(),
                          _formNomor(),
                          _paddingtop01(),
                          _formTglMulai(),
                          _paddingtop01(),
                          _formTglSampai(),
                          _paddingtop01(),
                          _pilihSurat(),
                          _paddingtop01(),
                          _formTujuan(),
                          _paddingtop01(),
                          _tombolBuatSurat(),
                        ],
                      ),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15.0),
                backgroundColor: Colors.green[600],
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // <-- Radius
                ),
              ),
              child: Text(
                'BUAT SURAT',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          );
  }

  Widget _formNomor() {
    return Container(
      // padding: EdgeInsets.all(3),
      width: MediaQuery.of(this.context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              enabled: false,
              // maxLines: null,
              controller: _nomorSuratController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(200),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.numbers_rounded,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Nomor",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formTglMulai() {
    return Container(
      alignment: Alignment.centerLeft,
      // decoration: kBoxDecorationStyle2,
      // height: 60.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: DateTimeField(
        controller: cMulai,
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
        decoration: InputDecoration(
          // border: InputBorder.none,
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          prefixIcon: Icon(
            Icons.date_range,
            color: Colors.brown[800],
          ),
          hintText: loadingdata ? "Memuat.." : "Mulai",
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _formTglSampai() {
    return Container(
      alignment: Alignment.centerLeft,
      // decoration: kBoxDecorationStyle2,
      // height: 60.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: DateTimeField(
        controller: cSampai,
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
        decoration: InputDecoration(
          // border: InputBorder.none,
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          prefixIcon: Icon(
            Icons.date_range,
            color: Colors.brown[800],
          ),
          hintText: loadingdata ? "Memuat.." : "Sampai",
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _tombolTolakSurat() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return loadingtolaksurat == true
        ? Container(
            // width: mediaQueryData.size.width * 0.45,
            height: mediaQueryData.size.height * 0.06,
            child: ElevatedButton(
              onPressed: () {
                // tolakSurat(widget.dUid, widget.dIdSurat);
              },
              style: ElevatedButton.styleFrom(
                // padding: EdgeInsets.all(15.0),
                backgroundColor: Colors.red[600],
                // elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // <-- Radius
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Container(
            // width: mediaQueryData.size.width * 0.45,
            height: mediaQueryData.size.height * 0.06,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (cKeterangan.text == "" || cKeterangan.text.isEmpty) {
                  Container();
                } else {
                  tolakSurat(widget.dUid, widget.dIdSurat);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15.0),
                backgroundColor: Colors.red[600],
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // <-- Radius
                ),
              ),
              child: Text(
                'TOLAK SURAT',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          );
  }

  Widget _tombolBuatSurat() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return loadingtolaksurat == true
        ? Container(
            // width: mediaQueryData.size.width * 0.45,
            height: mediaQueryData.size.height * 0.06,
            child: ElevatedButton(
              onPressed: () {
                // tolakSurat(widget.dUid, widget.dIdSurat);
              },
              style: ElevatedButton.styleFrom(
                // padding: EdgeInsets.all(15.0),
                backgroundColor: Colors.green[600],
                // elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // <-- Radius
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Container(
            // width: mediaQueryData.size.width * 0.45,
            height: mediaQueryData.size.height * 0.06,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (cTujuan.text == "" || cTujuan.text.isEmpty) {
                  Container();
                } else if (_mySelection == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Pilih jenis surat',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.orange[700],
                    action: SnackBarAction(
                      label: 'ULANGI',
                      textColor: Colors.white,
                      onPressed: () {
                        print('ULANGI snackbar');
                      },
                    ),
                  ));
                  // scaffoldKey.currentState.showSnackBar(snackBar);
                } else {
                  buatSurat();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15.0),
                backgroundColor: Colors.green[600],
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // <-- Radius
                ),
              ),
              child: Text(
                'BUAT SURAT',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          );
  }

  Widget _listActivity() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        // top: mediaQueryData.size.height * 0.78,
        // left: mediaQueryData.size.height * 0.015,
        // right: mediaQueryData.size.height * 0.015,
        bottom: mediaQueryData.size.height * 0.03,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Activity",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
          ),
          loadingactivity
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: activityJSON.length > 0 ? activityJSON.length : 1,
                  itemBuilder: (context, i) {
                    if (activityJSON.length <= 0) {
                      return Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 150.0, vertical: 15.0),
                                child: Icon(
                                  Icons.trending_up_rounded,
                                  size: 50.0,
                                  color: Colors.grey[350],
                                ),
                              ),
                              Text(
                                "Belum ada aktivitas",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.grey[350],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      final event = activityJSON[i];
                      final indicatorNumber =
                          (activityJSON.length - i).toString();
                      return TimelineTile(
                        alignment: TimelineAlign.center,
                        axis: TimelineAxis.vertical, // Set the axis to vertical
                        isFirst: i == 0,
                        isLast: i == activityJSON.length - 1,

                        indicatorStyle: IndicatorStyle(
                          height: 20,
                          width: 20,
                          color: Colors.grey,
                          // padding: EdgeInsets.only(
                          //   left: 5,
                          // ),
                          indicator: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                indicatorNumber,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        beforeLineStyle: LineStyle(
                          color: Colors.grey,
                          thickness: 2,
                        ),
                        startChild: Center(
                            child: Text(
                          extractDate('${event["waktu"]}'),
                        )),
                        endChild: SizedBox(
                          height: mediaQueryData.size.height * 0.07,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Transform.translate(
                              offset: Offset(10, 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${event["keterangan_log"]}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    extractTime('${event["waktu"]}'),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    // Container(
                    //   child: Card(
                    //     clipBehavior: Clip.antiAliasWithSaveLayer,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(5.0),
                    //     ),
                    //     elevation: 1.0,
                    //     color: Colors.white,
                    //     child: InkWell(
                    //       onTap: () {},
                    //       child: ListTile(
                    //         dense: true,
                    //         leading: Icon(
                    //           Icons
                    //               .error_outline_rounded, // Replace with the desired icon
                    //           color: Colors.red,
                    //           size:
                    //               35.0, // Replace with the desired icon size
                    //         ),
                    //         title: Text(
                    //           activityJSON[i]["keterangan_log"],
                    //           style: TextStyle(
                    //             fontSize: 13.0,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //           maxLines: 2,
                    //           overflow: TextOverflow.ellipsis,
                    //         ),
                    //         subtitle: Text(
                    //           activityJSON[i]["waktu"],
                    //           style: TextStyle(
                    //             fontSize: 12.0,
                    //             color: Colors.grey[500],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // );
                  },
                ),
        ],
      ),
    );
  }

  Widget _pilihSurat() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: DropdownButtonFormField(
            //icon: Icon(Icons.accessibility_),
            // underline: SizedBox(),
            isDense: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.mail),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
              // hintText: 'Judul Berita',
              hintStyle: TextStyle(
                fontSize: 15,
                color: Colors.brown[800],
              ),
              // prefixIcon: Icon(
              //   Icons.text_fields,
              //   color: Colors.grey,
              // ),
            ),
            hint: Text('Pilih Jenis Surat'),
            items: jenissurat.map((item) {
              return DropdownMenuItem(
                child: Text(item['nama']),
                value: item['value'],
              );
            }).toList(),
            onChanged: (selectedItem) {
              _mySelection = selectedItem as String;
              // print(val);
              if (kDebugMode) {
                print(_mySelection);
              }
            },
            value: _mySelection,
          ),
        )
      ],
    );
  }

  Widget _paddingleft01() {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.height * 0.01,
      ),
    );
  }

  Widget _paddingtop01() {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.01,
      ),
    );
  }
}
