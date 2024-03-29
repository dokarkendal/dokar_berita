import 'package:dokar_aplikasi/berita/list/hal_berita_list.dart';
import 'package:dokar_aplikasi/berita/list/hal_bumdes_list.dart';
import 'package:dokar_aplikasi/berita/list/hal_event_list.dart';
import 'package:dokar_aplikasi/berita/list/hal_inovasi_list.dart';
import 'package:dokar_aplikasi/berita/list/hal_kegiatan_list.dart';
import 'package:dokar_aplikasi/berita/list/hal_penulis_list.dart';
// import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';

// import 'package:shimmer/shimmer.dart';

import '../style/styleset.dart'; // api to json

class EditSemua extends StatefulWidget {
  @override
  _EditSemuaState createState() => _EditSemuaState();
}

class _EditSemuaState extends State<EditSemua> {
  bool isLoading = false;
  String username = "";
  String kecamatan = "";
  String namadesa = "";
  String status = "";
  late int jumlah;
  late int jumlahkeg;
  late int jumlahB;
  late int jumlahBum;
  late int jumlahAgen;

  Future<void> jumlahAgenda() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/dashbord/jumlahdata"),
      body: {
        "IdDesa": pref.getString("IdDesa"),
      },
    );
    var jumlahagenda = json.decode(response.body);
    print(jumlahagenda);
    setState(
      () {
        jumlah = jumlahagenda['kabar'];
        jumlahkeg = jumlahagenda['kegiatan'];
        jumlahB = jumlahagenda['bid'];
        jumlahBum = jumlahagenda['bumdes'];
        jumlahAgen = jumlahagenda['agenda'];
        isLoading = false;
        print(pref.getString("IdDesa"));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    if (status == '02') {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: appbarIcon, //change your color here
          ),
          title: Text(
            'DASHBOARD',
            style: TextStyle(
              color: appbarTitle,
              fontWeight: FontWeight.bold,
              // fontSize: 25.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: GestureDetector(
              child: Column(
                children: <Widget>[
                  cardBerita(),
                  beritaEdit(),
                  kegiatanEdit(),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: appbarIcon, //change your color here
          ),
          title: Text(
            'DASHBOARD',
            style: TextStyle(
              color: appbarTitle,
              fontWeight: FontWeight.bold,
              // fontSize: 25.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: isLoading
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: _buildProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  child: GestureDetector(
                    child: Column(
                      children: <Widget>[
                        cardBerita(),
                        beritaEdit(),
                        kegiatanEdit(),
                        bidEdit(),
                        bumdesEdit(),
                        eventEdit(),
                        // penulisEdit(),
                      ],
                    ),
                  ),
                ),
              ),
      );
    }
  }

  Future _cekUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(() {
        username = pref.getString("userAdmin")!;
        kecamatan = pref.getString("kecamatan")!;
        namadesa = pref.getString("desa")!;
        status = pref.getString("status")!;
        print(pref.getString("desa"));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cekUser();
    jumlahAgenda();
  }

  Widget beritaEdit() {
    return Card(
      //color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FormBeritaDashbord(),
            ),
          );
          /*Navigator.of(context).push(
             MaterialPageRoute(
              builder: (context) =>  FormBeritaDashbord(),
            ),
          );*/
        },
        child: ListTile(
          leading: Material(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.blue,
            child: IconButton(
              padding: EdgeInsets.all(15.0),
              icon: Icon(Icons.library_books),
              color: Colors.white,
              iconSize: 25.0,
              onPressed: () {
                //Navigator.pushNamed(context, '/HalamanBeritaadmin');
              },
            ),
          ),
          subtitle: Text(
            "Lihat detail",
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          title: Text(
            "Berita",
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          trailing:
              Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black),
        ),
      ),
    );
  }

  Widget kegiatanEdit() {
    return Card(
        //color: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HalKegiatanList(),
              ),
            );
          },
          child: ListTile(
            leading: Material(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.orange,
              child: IconButton(
                padding: EdgeInsets.all(15.0),
                icon: Icon(Icons.directions_run),
                color: Colors.white,
                iconSize: 25.0,
                onPressed: () {
                  //Navigator.pushNamed(context, '/HalamanBeritaadmin');
                },
              ),
            ),
            subtitle: Text(
              "Lihat detail",
              style: TextStyle(fontSize: 12.0, color: Colors.black54),
            ),
            title: Text(
              "Kegiatan",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            trailing:
                Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black),
          ),
        ));
  }

  Widget bidEdit() {
    return Card(
        //color: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HalInovasiList(),
              ),
            );
          },
          child: ListTile(
            leading: Material(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.green,
              child: IconButton(
                padding: EdgeInsets.all(15.0),
                icon: Icon(Icons.store_mall_directory),
                color: Colors.white,
                iconSize: 25.0,
                onPressed: () {
                  //Navigator.pushNamed(context, '/HalamanBeritaadmin');
                },
              ),
            ),
            subtitle: Text(
              "Lihat detail",
              style: TextStyle(fontSize: 12.0, color: Colors.black54),
            ),
            title: Text(
              "Inovasi",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            trailing:
                Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black),
          ),
        ));
  }

  Widget bumdesEdit() {
    return Card(
        //color: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HalBumdesList(),
              ),
            );
          },
          child: ListTile(
            leading: Material(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.purple,
              child: IconButton(
                padding: EdgeInsets.all(15.0),
                icon: Icon(Icons.shopping_basket),
                color: Colors.white,
                iconSize: 25.0,
                onPressed: () {
                  //Navigator.pushNamed(context, '/HalamanBeritaadmin');
                },
              ),
            ),
            subtitle: Text(
              "Lihat detail",
              style: TextStyle(fontSize: 12.0, color: Colors.black54),
            ),
            title: Text(
              "Bumdes",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            trailing:
                Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black),
          ),
        ));
  }

  Widget eventEdit() {
    return Card(
        //color: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HalEventList(),
              ),
            );
          },
          child: ListTile(
            leading: Material(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.teal,
              child: IconButton(
                padding: EdgeInsets.all(15.0),
                icon: Icon(Icons.event),
                color: Colors.white,
                iconSize: 25.0,
                onPressed: () {
                  Navigator.pushNamed(context, '/HalamanBeritaadmin');
                },
              ),
            ),
            subtitle: Text(
              "Lihat detail",
              style: TextStyle(fontSize: 12.0, color: Colors.black54),
            ),
            title: Text(
              "Agenda",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            trailing:
                Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black),
          ),
        ));
  }

  Widget penulisEdit() {
    return Card(
      //color: Colors.deepPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ListPenulis(),
            ),
          );
        },
        child: ListTile(
          leading: Material(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.indigo,
            child: IconButton(
              padding: EdgeInsets.all(15.0),
              icon: Icon(Icons.people),
              color: Colors.white,
              iconSize: 25.0,
              onPressed: () {
                // Navigator.pushNamed(context, '/ListPenulis');
              },
            ),
          ),
          subtitle: Text(
            "Lihat detail",
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          title: Text(
            "Penulis",
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          trailing:
              Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black),
        ),
      ),
    );
  }

  Widget cardBerita() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    if (status == '02') {
      return isLoading
          ? _buildProgressIndicator()
          : Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    width: double.infinity,
                    height: mediaQueryData.size.height * 0.23,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0.0, 3.0),
                            blurRadius: 15.0)
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 15.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                'assets/logos/logokendal.png',
                                width: 70.0,
                                height: 70.0,
                              ),
                              SizedBox(width: 20.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Desa ' + namadesa,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Kec. ' + kecamatan,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0),
                                  ),
                                  Text(
                                    'Kab. Kendal',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
    } else {
      return isLoading
          ? _buildProgressIndicator()
          : Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    width: double.infinity,
                    height: mediaQueryData.size.height * 0.23,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0.0, 3.0),
                            blurRadius: 15.0)
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 15.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                'assets/logos/logokendal.png',
                                width: 70.0,
                                height: 70.0,
                              ),
                              SizedBox(width: 20.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Desa ' + namadesa,
                                    style: TextStyle(
                                      color: Color(0xFF2e2e2e),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Kec. ' + kecamatan,
                                    style: TextStyle(
                                      color: Color(0xFF2e2e2e),
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    'Kab. Kendal',
                                    style: TextStyle(
                                      color: Color(0xFF2e2e2e),
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    "$jumlah",
                                    style: TextStyle(
                                      color: Color(0xFF2e2e2e),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Berita',
                                    style: TextStyle(
                                      color: Color(0xFF2e2e2e),
                                      fontSize: 13.0,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "$jumlahkeg",
                                    style: TextStyle(
                                        color: Color(0xFF2e2e2e),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Kegiatan',
                                    style: TextStyle(
                                      color: Color(0xFF2e2e2e),
                                      fontSize: 13.0,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "$jumlahB",
                                    style: TextStyle(
                                        color: Color(0xFF2e2e2e),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Inovasi',
                                    style: TextStyle(
                                      color: Color(0xFF2e2e2e),
                                      fontSize: 13.0,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "$jumlahBum",
                                    style: TextStyle(
                                        color: Color(0xFF2e2e2e),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Bumdes',
                                    style: TextStyle(
                                      color: Color(0xFF2e2e2e),
                                      fontSize: 13.0,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "$jumlahAgen",
                                    style: TextStyle(
                                        color: Color(0xFF2e2e2e),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Agenda',
                                    style: TextStyle(
                                      color: Color(0xFF2e2e2e),
                                      fontSize: 13.0,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
    }
  }

  Widget _buildProgressIndicator() {
    // MediaQueryData mediaQueryData = MediaQuery.of(context);
    // SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: CircularProgressIndicator(),
        ),
      ),
    );
    // return Padding(
    //   padding: EdgeInsets.all(1.0),
    //   child: Shimmer.fromColors(
    //     direction: ShimmerDirection.ltr,
    //     highlightColor: Colors.white,
    //     baseColor: Colors.grey[300],
    //     child: Container(
    //       padding: EdgeInsets.all(5.0),
    //       child: Column(
    //         children: <Widget>[
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: <Widget>[
    //               Container(
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(10.0),
    //                   color: Colors.grey,
    //                 ),
    //                 height: mediaQueryData.size.height * 0.23,
    //                 width: mediaQueryData.size.width,
    //                 // color: Colors.grey,
    //               ),

    //               // Row(
    //             ],
    //           ),
    //           SizedBox(height: mediaQueryData.size.height * 0.01),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
