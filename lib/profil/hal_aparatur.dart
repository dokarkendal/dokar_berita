import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';

import '../style/styleset.dart';

class HalAparaturDesa extends StatefulWidget {
  final String idDesa;

  HalAparaturDesa({required this.idDesa});

  @override
  _HalAparaturDesaState createState() => _HalAparaturDesaState();
}

class _HalAparaturDesaState extends State<HalAparaturDesa> {
  //List dataJSON;
  String jabatan = '';
  String foto = '';
  String nama = '';
  List databerita = [];
  bool isLoading = false;

  // ignore: missing_return
  Future<String> ambildata() async {
    setState(
      () {
        isLoading = true;
      },
    );
    SharedPreferences pref = await SharedPreferences.getInstance();
    http.Response hasil = await http.get(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/dashbord/aparatur/" +
                "${widget.idDesa}"),
        headers: {"Accept": "application/json"});
    //var databerita = json.decode(hasil.body);
    this.setState(
      () {
        isLoading = false;
        databerita = json.decode(hasil.body);
      },
    );
    return '';
    // print(pref.getString("IdDesa"));
  }

  @override
  void initState() {
    super.initState();
    ambildata();
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _aparatur() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1.6),
      ),
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: databerita.isEmpty
          ? 0
          : databerita.length, //NOTE if else listview berita
      // ignore: missing_return
      itemBuilder: (context, i) {
        if (databerita[i]["nama"] == 'NotFound') {
          print(databerita[i]["nama"]);
        } else {
          return new Container(
            child: Padding(
              padding: EdgeInsets.only(right: 4.0, left: 4.0),
              child: new GestureDetector(
                onTap: () {
                  /*Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (context) => new AgendaDetail(
                        judulEvent: databerita[index]["nama"],
                        uraianEvent: databerita[index]["uraian"],
                        mulaiEvent: databerita[index]["waktu_mulai"],
                        selesaiEvent: databerita[index]["waktu_selesai"],
                        gambarEvent: databerita[index]["gambar"],
                        penyelenggaraEvent: databerita[index]["penyelenggara"],
                        tglmulaiEvent: databerita[index]["tanggal_mulai"],
                        tglselesaiEvent: databerita[index]["tanggal_selesai"],
                        urlEvent: databerita[index]["url"],
                      ),
                    ),
                  );*/
                },
                child: new Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: new Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(5.0),
                      //   child: Image.network(
                      //     databerita[i]["foto"],
                      //     fit: BoxFit.cover,
                      //     height: 180.0,
                      //     width: 200.0,
                      //   ),
                      // ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: CachedNetworkImage(
                          imageUrl: databerita[i]["foto"],
                          // new NetworkImage(databerita[index]["kabar_gambar"]),
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
                          width: mediaQueryData.size.width,
                          height: mediaQueryData.size.height * 0.23,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            databerita[i]["nama"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            databerita[i]["jabatan"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
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
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'APARATUR',
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: _buildProgressIndicator(),
                ),
              )
            : _aparatur(),
      ),
    );
  }
}
