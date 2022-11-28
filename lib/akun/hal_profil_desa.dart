import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dokar_aplikasi/berita/detail_galeri.dart';
// import 'package:dokar_aplikasi/berita/form/hal_kritik_warga.dart';
// import 'package:dokar_aplikasi/berita/hal_siskeudes.dart';
import 'package:dokar_aplikasi/profil/data/hal_agenda_profile.dart';
import 'package:dokar_aplikasi/profil/data/hal_berita_profile.dart';
import 'package:dokar_aplikasi/profil/data/hal_bid_profile.dart';
import 'package:dokar_aplikasi/profil/data/hal_bumdes_profile.dart';
import 'package:dokar_aplikasi/profil/data/hal_fasum_profile.dart';
import 'package:dokar_aplikasi/profil/data/hal_galeri_profile.dart';
import 'package:dokar_aplikasi/profil/data/hal_kegiatan_profile.dart';
import 'package:dokar_aplikasi/profil/data/hal_potensi_profile.dart';
import 'package:dokar_aplikasi/profil/hal_aparatur.dart';
import 'package:dokar_aplikasi/profil/hal_profil.dart';
import 'package:dokar_aplikasi/profil/hal_sejarah.dart';
import 'package:dokar_aplikasi/profil/hal_visimisi.dart';
import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';

import 'package:shimmer/shimmer.dart'; // api to json

class ProfilDesa extends StatefulWidget {
  final String title, id, desa, kecamatan;

  ProfilDesa({Key key, this.title, this.id, this.desa, this.kecamatan})
      : super(key: key);

  @override
  _ProfilDesaState createState() => _ProfilDesaState();
}

class _ProfilDesaState extends State<ProfilDesa> {
  String username = "";
  String kecamatan = "";
  String namadesa = "";
  String status = "";
  String kode = "";
  int jumlah;
  int jumlahkeg;
  int jumlahB;
  int jumlahBum;
  int jumlahAgen;
  List dataJSON;
  bool isLoading = false;

  Future jumlahAgenda() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/dashbord/jumlahdata"),
        body: {
          "IdDesa": "${widget.id}",
        });
    var jumlahagenda = json.decode(response.body);
    print(jumlahagenda);
    if (mounted) {
      setState(
        () {
          jumlah = jumlahagenda['kabar'];
          jumlahkeg = jumlahagenda['kegiatan'];
          jumlahB = jumlahagenda['bid'];
          jumlahBum = jumlahagenda['bumdes'];
          jumlahAgen = jumlahagenda['agenda'];
          kode = jumlahagenda['kode'];
          isLoading = false;
        },
      );
    }
  }

  // ignore: unused_element
  Future _cekUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(
        () {
          username = pref.getString("userAdmin");
          kecamatan = pref.getString("kecamatan");
          namadesa = pref.getString("desa");
          status = pref.getString("status");
        },
      );
    }
  }

  // ignore: missing_return
  Future<String> ambildata() async {
    setState(() {
      isLoading = true;
    });
    http.Response hasil = await http.get(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/dashbord/galeri/" +
                "${widget.id}"),
        headers: {"Accept": "application/json"});

    this.setState(
      () {
        dataJSON = json.decode(hasil.body);
        isLoading = false;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    //_cekUser();
    jumlahAgenda();
    ambildata();
  }

  final Color red = Color(0xFFee002d);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.brown[800], //change your color here
        ),
        title: Text(
          'PROFIL',
          style: TextStyle(
            color: Colors.brown[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.message),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => FormKritikSaran(idDesa: "${widget.id}"),
          //       ),
          //     );
          //   },
          // )
        ],
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        'assets/logos/logokendal.png',
                        width: 100.0,
                        height: 100.0,
                      ),
                      SizedBox(width: 5.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              "Desa ${widget.desa}",
                              minFontSize: 10,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.brown[800],
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "KEC. ${widget.kecamatan}",
                              style: TextStyle(
                                color: Colors.brown[800],
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              'KAB. KENDAL',
                              style: TextStyle(
                                color: Colors.brown[800],
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 25,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HalProfilDesa(idDesa: "${widget.id}"),
                              ),
                            );
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.account_circle,
                                color: Colors.brown[800],
                              ),
                              Text(
                                'Profil',
                                style: TextStyle(
                                  color: Colors.brown[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HalVisiDesa(idDesa: "${widget.id}"),
                              ),
                            );
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.account_balance,
                                color: Colors.brown[800],
                              ),
                              Text(
                                'Visi Misi',
                                style: TextStyle(
                                  color: Colors.brown[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HalSejarahDesa(idDesa: "${widget.id}"),
                              ),
                            );
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.assistant_photo,
                                color: Colors.brown[800],
                              ),
                              Text(
                                'Sejarah',
                                style: TextStyle(
                                  color: Colors.brown[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HalAparaturDesa(idDesa: "${widget.id}"),
                              ),
                            );
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.people,
                                color: Colors.brown[800],
                              ),
                              Text(
                                'Aparatur',
                                style: TextStyle(
                                  color: Colors.brown[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: isLoading
                  ? _buildProgressIndicator()
                  : Stack(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            width: double.infinity,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: Colors.blue[800],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0.0, 3.0),
                                    blurRadius: 15.0)
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 5.0),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          jumlah == null
                                              ? Text(
                                                  "0",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                  ),
                                                )
                                              : Text(
                                                  "$jumlah",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                          SizedBox(height: 8.0),
                                          Text('Berita',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.0))
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          jumlahkeg == null
                                              ? Text("0",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0))
                                              : Text("$jumlahkeg",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0)),
                                          SizedBox(height: 8.0),
                                          Text('Kegiatan',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.0))
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          jumlahB == null
                                              ? Text("0",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0))
                                              : Text("$jumlahB",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0)),
                                          SizedBox(height: 8.0),
                                          Text('Inovasi',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.0))
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          jumlahBum == null
                                              ? Text("0",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0))
                                              : Text("$jumlahBum",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0)),
                                          SizedBox(height: 8.0),
                                          Text('Bumdes',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.0))
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          jumlahAgen == null
                                              ? Text("0",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0))
                                              : Text("$jumlahAgen",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0)),
                                          SizedBox(height: 8.0),
                                          Text('Agenda',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.0))
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
                    ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Galeri Desa',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              // padding: EdgeInsets.all(15.0),
                              elevation: 0, backgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(15), // <-- Radius
                              ),
                            ),
                            // color: Colors.grey[300],
                            // textColor: Colors.white,
                            // shape: RoundedRectangleBorder(
                            //   borderRadius:  BorderRadius.circular(15.0),
                            // ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Lihat semua  ',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.brown[800],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: Colors.brown[800],
                                )
                              ],
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GaleriProfile(idDesa: "${widget.id}"),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  isLoading
                      ? _buildProgressIndicator()
                      : Padding(
                          padding: EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Container(
                            height: 130,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                SizedBox(
                                  height: 100.0,
                                  child: ListView.builder(
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        dataJSON == null ? 0 : dataJSON.length,
                                    itemBuilder: (context, i) {
                                      if (dataJSON[i]["gambar"] == 'NotFound') {
                                        return Container(
                                          child: Center(
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 150.0,
                                                      vertical: 15.0),
                                                  child: Icon(Icons.event_busy,
                                                      size: 50.0,
                                                      color: Colors.grey[350]),
                                                ),
                                                Text(
                                                  "Belum ada gambar",
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
                                          child: Container(
                                            padding: EdgeInsets.all(2.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailGaleri(
                                                      dGambar: dataJSON[i]
                                                          ["gambar"],
                                                      dDesa: dataJSON[i]
                                                          ["desa"],
                                                      dJudul: dataJSON[i]
                                                          ["judul"],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Stack(
                                                    children: <Widget>[
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          // child: Image.network(
                                                          //   dataJSON[i]["gambar"],
                                                          fit: BoxFit.cover,
                                                          width: 160.0,
                                                          height: 120.0,
                                                          // ),
                                                          imageUrl: dataJSON[i]
                                                              ["gambar"],
                                                          //  NetworkImage(databerita[index]["kabar_gambar"]),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    AssetImage(
                                                                  "assets/images/load.png",
                                                                ),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 80.0,
                                                          left: 0.0,
                                                        ),
                                                        child: SizedBox(
                                                          height: 40.0,
                                                          width: 160,
                                                          child: Material(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                            color: Colors
                                                                .black45
                                                                .withOpacity(
                                                                    0.6),
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5.0),
                                                                  child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Text(
                                                                          dataJSON[i]
                                                                              [
                                                                              "desa"],
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            AutoSizeText(
                                                                          dataJSON[i]
                                                                              [
                                                                              "judul"],
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                12.0,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          maxLines:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
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
                                ),
                              ],
                            ),
                          ),
                        )
                ],
              ),
            ),
            Container(
              //height: SizeConfig.safeBlockVertical * 35, //10 for example
              width: SizeConfig.safeBlockHorizontal * 100,
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          IconButton(
                            padding: EdgeInsets.all(15.0),
                            icon: Icon(Icons.library_books),
                            color: Colors.purple[400],
                            iconSize: 30.0,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HalberitaProfile(idDesa: "${widget.id}"),
                                ),
                              );
                            },
                          ),
                          //SizedBox(height: 8.0),
                          Text(
                            'Berita',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            padding: EdgeInsets.all(15.0),
                            icon: Icon(Icons.directions_run),
                            color: Colors.red[400],
                            iconSize: 30.0,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HalKegiatanProfile(
                                      idDesa: "${widget.id}"),
                                ),
                              );
                            },
                          ),
                          //SizedBox(height: 8.0),
                          Text('Kegiatan',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0))
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            padding: EdgeInsets.all(15.0),
                            icon: Icon(Icons.widgets),
                            color: Colors.blueAccent[400],
                            iconSize: 30.0,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HalPotensiProfile(idDesa: "${widget.id}"),
                                ),
                              );
                            },
                          ),
                          Text(
                            'Potensi',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            padding: EdgeInsets.all(15.0),
                            icon: Icon(Icons.assessment),
                            color: Colors.green[400],
                            iconSize: 30.0,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HalBIDProfile(idDesa: "${widget.id}"),
                                ),
                              );
                            },
                          ),
                          Text('Inovasi',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0))
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.safeBlockVertical * 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          IconButton(
                            padding: EdgeInsets.all(15.0),
                            icon: Icon(Icons.event),
                            color: Colors.lightBlue[400],
                            iconSize: 30.0,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AgendaProfile(idDesa: "${widget.id}"),
                                ),
                              );
                            },
                          ),
                          Text('Agenda',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0))
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            padding: EdgeInsets.all(15.0),
                            icon: Icon(Icons.shopping_basket),
                            color: Colors.brown[400],
                            iconSize: 30.0,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HalbumdesProfile(idDesa: "${widget.id}"),
                                ),
                              );
                            },
                          ),
                          Text(
                            'Bumdes',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            padding: EdgeInsets.all(15.0),
                            icon: Icon(Icons.my_location),
                            color: Colors.orange[400],
                            iconSize: 30.0,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HalFasumProfile(idDesa: "${widget.id}"),
                                ),
                              );
                            },
                          ),
                          Text('Fasum',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0))
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                              padding: EdgeInsets.all(15.0),
                              icon: Icon(
                                Icons.check_box_outline_blank_outlined,
                                color: Colors.white.withOpacity(0.1),
                              ),
                              // color: Colors.white.withOpacity(0.1),
                              iconSize: 30.0,
                              onPressed: null
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => SimplePieChart(
                              //         idDesa: "${widget.id}",
                              //         kodeDesa: "$kode"),
                              //   ),
                              // );

                              ),

                          // Text("Siskeudes",
                          //     style: TextStyle(
                          //         color: Colors.white,
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 12.0))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        highlightColor: Colors.white,
        baseColor: Colors.grey[300],
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey,
                    ),
                    height: mediaQueryData.size.height * 0.1,
                    width: mediaQueryData.size.width,
                    // color: Colors.grey,
                  ),

                  // Row(
                ],
              ),
              SizedBox(height: mediaQueryData.size.height * 0.01),
            ],
          ),
        ),
      ),
    );
  }
}
