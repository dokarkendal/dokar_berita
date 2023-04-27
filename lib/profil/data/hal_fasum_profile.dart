import 'package:dokar_aplikasi/profil/data/hal_fasum_ibadah.dart';
import 'package:dokar_aplikasi/profil/data/hal_fasum_kesehatan.dart';
import 'package:dokar_aplikasi/profil/data/hal_fasum_olahraga.dart';
import 'package:dokar_aplikasi/profil/data/hal_fasum_pendidikan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';

import '../../style/styleset.dart';

class HalFasumProfile extends StatefulWidget {
  final String idDesa, namaDesa;

  HalFasumProfile({
    required this.idDesa,
    required this.namaDesa,
  });

  @override
  _HalFasumProfileState createState() => _HalFasumProfileState();
}

class _HalFasumProfileState extends State<HalFasumProfile> {
  late List dataJSON = [];
  bool isLoading = false;

  Future<void> ambildata() async {
    setState(
      () {
        isLoading = true;
      },
    );
    http.Response hasil = await http.get(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/dashbord/jenisfasum"),
      headers: {"Accept": "application/json"},
    );

    this.setState(
      () {
        isLoading = false;
        dataJSON = json.decode(hasil.body);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    ambildata();
  }

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

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FASUM ' + "${widget.namaDesa}",
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
      ),
      body: isLoading
          ? _buildProgressIndicator()
          : SingleChildScrollView(
              child: GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 2.5),
                ),
                //+1 for progressbar
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: dataJSON.isEmpty ? 0 : dataJSON.length,
                // ignore: missing_return
                itemBuilder: (context, index) {
                  if (dataJSON[index]['id'] == '2') {
                    return new Container(
                      padding: new EdgeInsets.all(2.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HalFasumIbadah(
                                  dNama: dataJSON[index]["nama"],
                                  dId: dataJSON[index]["id"],
                                  idDesa: "${widget.idDesa}"),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFee9500),
                                  Color(0xFFe79000),
                                  Color(0xFFd68601),
                                  Color(0xFFcc8001),
                                ],
                                stops: [0.1, 0.4, 0.7, 0.9],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.mosque,
                                      color: Colors.white,
                                      size: 50.0,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: GestureDetector(
                                      child: Text(
                                        dataJSON[index]["nama"], //IBADAH
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      top: 5,
                                    ),
                                    child: Text(
                                      'Tempat umat beragama untuk beribadah menurut ajaran agama masing-masing',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (dataJSON[index]['id'] == '3') {
                    return new Container(
                      padding: new EdgeInsets.all(2.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HalFasumOlahraga(
                                  dNama: dataJSON[index]["nama"],
                                  dId: dataJSON[index]["id"],
                                  idDesa: "${widget.idDesa}"),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFee9500),
                                  Color(0xFFe79000),
                                  Color(0xFFd68601),
                                  Color(0xFFcc8001),
                                ],
                                stops: [0.1, 0.4, 0.7, 0.9],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.sports_handball_rounded,
                                      color: Colors.white,
                                      size: 50.0,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: Text(
                                      dataJSON[index]["nama"],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      top: 5,
                                    ),
                                    child: Text(
                                      'Tempat yang dimanfaatkan dalam pelaksanaan kegiatan olahraga',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (dataJSON[index]['id'] == '4') {
                    return new Container(
                      // height: mediaQueryData.size.height * 0.1,
                      padding: new EdgeInsets.all(2.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HalFasumKesehatan(
                                  dNama: dataJSON[index]["nama"],
                                  dId: dataJSON[index]["id"],
                                  idDesa: "${widget.idDesa}"),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFee9500),
                                  Color(0xFFe79000),
                                  Color(0xFFd68601),
                                  Color(0xFFcc8001),
                                ],
                                stops: [0.1, 0.4, 0.7, 0.9],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.local_hospital,
                                      color: Colors.white,
                                      size: 50.0,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: Text(
                                      dataJSON[index]["nama"],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      top: 5,
                                    ),
                                    child: Text(
                                      'tempat yang digunakan untuk menyelenggarakan upaya kesehatan',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (dataJSON[index]['id'] == '5') {
                    return new Container(
                      padding: new EdgeInsets.all(2.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HalFasumPendidikan(
                                  dNama: dataJSON[index]["nama"],
                                  dId: dataJSON[index]["id"],
                                  idDesa: "${widget.idDesa}"),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFee9500),
                                  Color(0xFFe79000),
                                  Color(0xFFd68601),
                                  Color(0xFFcc8001),
                                ],
                                stops: [0.1, 0.4, 0.7, 0.9],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.school_rounded,
                                      color: Colors.white,
                                      size: 50.0,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: GestureDetector(
                                      child: Text(
                                        dataJSON[index]["nama"],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      top: 5,
                                    ),
                                    child: Text(
                                      'fasilitas yang diperlukan dalam proses belajar mengajar, agar tercapai tujuan pendidikan',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return _buildProgressIndicator();
                },
              ),
            ),
    );
  }
}
