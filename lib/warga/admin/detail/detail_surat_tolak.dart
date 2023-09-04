import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dokar_aplikasi/warga/detail_galeri_warga.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:timeline_tile/timeline_tile.dart';

class HalDetailSuratTolak extends StatefulWidget {
  final String dNama,
      dNik,
      dStatus,
      dNoSurat,
      dKategori,
      dTanggal,
      dKode,
      dKeterangan,
      dIdSurat,
      dUid;
  HalDetailSuratTolak({
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
  });

  @override
  State<HalDetailSuratTolak> createState() => _HalDetailSuratTolakState();
}

class _HalDetailSuratTolakState extends State<HalDetailSuratTolak> {
  bool loadingdata = false;
  bool loadingdatadukung = false;
  bool loadingdataTambahan = false;
  bool loadingactivity = false;
  late List dataDukungJSON = [];
  String extractDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  String extractTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

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

  @override
  void initState() {
    detailDataDukung();
    detailDataTambah();
    activityadmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            icon: Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: "${widget.dKode}"));
              // Show a snackbar or any other notification to indicate that the value has been copied
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Copied "${widget.dKode}"')),
              );
            },
          ),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red,
      ),
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
            Colors.red,
            Colors.red.shade200,
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
                        : widget.dStatus == 'Pengajuan di Tolak'
                            ? Colors.red
                            : Colors.green,
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
                            : widget.dStatus == 'Pengajuan di Tolak'
                                ? Icons.cancel
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
            Text(
              "No.Surat :",
              style: TextStyle(
                fontSize: 14,
                // fontWeight: FontWeight.w700,
                color: Colors.grey[600],
              ),
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
                    Text(
                      "${widget.dKode}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
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
        ],
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
                    // return
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
                  }),
        ],
      ),
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

// q: apa itu statefulwidget?
// a: statefulwidget adalah widget yang bisa diubah state nya
// q: apa bedanya dengan statelesswidget?
// a: statelesswidget adalah widget yang tidak bisa diubah state nya

/// cretae elevated button
