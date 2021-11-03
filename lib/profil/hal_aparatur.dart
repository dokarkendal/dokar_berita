import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';

class HalAparaturDesa extends StatefulWidget {
  final String idDesa;

  HalAparaturDesa({this.idDesa});

  @override
  _HalAparaturDesaState createState() => _HalAparaturDesaState();
}

class _HalAparaturDesaState extends State<HalAparaturDesa> {
  //List dataJSON;
  String jabatan = '';
  String foto = '';
  String nama = '';
  List databerita = new List();

  // ignore: missing_return
  Future<String> ambildata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "http://dokar.kendalkab.go.id/webservice/android/dashbord/aparatur/" +
                "${widget.idDesa}"),
        headers: {"Accept": "application/json"});
    //var databerita = json.decode(hasil.body);
    this.setState(
      () {
        databerita = json.decode(hasil.body);
      },
    );
    print(pref.getString("IdDesa"));
  }

  @override
  void initState() {
    super.initState();
    ambildata();
  }

  Widget _aparatur() {
    return GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1.6),
      ),
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: databerita == null
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.network(
                          databerita[i]["foto"],
                          fit: BoxFit.cover,
                          height: 200.0,
                          width: 200.0,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aparatur Desa'),
        backgroundColor: Color(0xFFee002d),
      ),
      body: SingleChildScrollView(
        child: _aparatur(),
      ),
    );
  }
}
