////////////////////////////////PACKAGE//////////////////////////////////////
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'dart:io';
import 'package:dokar_aplikasi/berita/form/form_berita.dart';
import 'package:dokar_aplikasi/berita/hal_berita_edit.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:async/async.dart'; //upload gambar
import 'package:flutter/material.dart';
import 'package:dokar_aplikasi/style/constants.dart';
import 'package:image_picker/image_picker.dart'; //akses galeri dan camera
import 'package:http/http.dart' as http; //api
import 'package:path/path.dart'; //upload gambar path
import 'package:shared_preferences/shared_preferences.dart'; //save session

import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../main.dart';

import 'dart:math' as Math;

////////////////////////////////PROJECT///////////////////////////////////////
class FormBeritaDashbord extends StatefulWidget {
  @override
  FormBeritaDashbordState createState() => FormBeritaDashbordState();
}

class FormBeritaDashbordState extends State<FormBeritaDashbord> {
////////////////////////////////DEKLARASI////////////////////////////////////

  String username = "";
  //String id = "";
  String _mySelection;
  List beritaAdmin = List();
  GlobalKey<RefreshIndicatorState> refreshKey;
  final SlidableController slidableController = SlidableController();

  void hapusberita(beritaAdmin) async {
    //print(beritaAdmin);
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        "http://dokar.kendalkab.go.id/webservice/android/kabar/delete",
        body: {
          "IdBerita": beritaAdmin,
          "IdDesa": pref.getString("IdDesa"),
        });
    var deleted = json.decode(response.body);
    print(deleted);
  }

  void unpublish(beritaAdmin) async {
    //print(beritaAdmin);
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        "http://dokar.kendalkab.go.id/webservice/android/kabar/UnPublish",
        body: {
          "IdBerita": beritaAdmin,
          //"IdDesa": pref.getString("IdDesa"),
        });
    var unpublish = json.decode(response.body);
    print(unpublish);
  }

  void publish(beritaAdmin) async {
    //print(beritaAdmin);
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        "http://dokar.kendalkab.go.id/webservice/android/kabar/Publish",
        body: {
          "IdBerita": beritaAdmin,
          // "IdDesa": pref.getString("IdDesa"),
        });
    var publish = json.decode(response.body);
    print(publish);
  }

///////////////////////////////CEK SESSION ADMIN///////////////////////////////////
  Future _cekSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(() {
        username = pref.getString("userAdmin");
        //id = pref.getString("IdDesa");
      });
    }
  }

///////////////////////////////API KATEGORI BERITA///////////////////////////////////
  Future<String> getBerita() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "http://dokar.kendalkab.go.id/webservice/android/kabar/berita?IdDesa=" +
                pref.getString("IdDesa")),
        headers: {"Accept": "application/json"});

    this.setState(() {
      beritaAdmin = json.decode(hasil.body);
      print(beritaAdmin);
      print(pref.getString("IdDesa"));
    });
  }

  @override
  void initState() {
    super.initState();
    this.getBerita();
  }

///////////////////////////////HALAMAN UTAMA//////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Berita'),
        backgroundColor: Color(0xFFee002d),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1), () {
            setState(() {
              beritaAdmin;
            });
            getBerita();
          });
        },
        child: ListView.builder(
          //scrollDirection: Axis.horizontal,
          itemCount: beritaAdmin == null ? 0 : beritaAdmin.length,
          itemBuilder: (context, i) {
            if (beritaAdmin[i]["status"] == 'Not Found') {
              return new Container(
                child: Center(
                  child: new Column(
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.all(100.0),
                      ),
                      new Text(
                        "DATA KOSONG",
                        style: new TextStyle(
                          fontSize: 30.0,
                          color: Colors.grey[350],
                        ),
                      ),
                      new Padding(
                        padding: new EdgeInsets.all(20.0),
                      ),
                      new Icon(Icons.help_outline,
                          size: 150.0, color: Colors.grey[350]),
                    ],
                  ),
                ),
              );
            } else {
              //isi berita

              //final nDataList = dataJSON[i];
              return Slidable(
                //key: Key(itemC.title),
                controller: slidableController,
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: new Container(
                  padding: new EdgeInsets.all(5.0),
                  child: new GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => new FormBeritaEdit(
                                dJudul: beritaAdmin[i]["kabar_judul"],
                                dKategori: beritaAdmin[i]["kabar_kategori"],
                                dIsi: beritaAdmin[i]["kabar_isi"],
                                dTanggal: beritaAdmin[i]["kabar_tanggal"],
                                dGambar: beritaAdmin[i]["kabar_gambar"],
                                dIdBerita: beritaAdmin[i]["kabar_id"],
                              )));
                    },
                    child: new Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        leading: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 64,
                            minHeight: 64,
                            maxWidth: 84,
                            maxHeight: 84,
                          ),
                          child: Image(
                              image: new NetworkImage(
                                  beritaAdmin[i]["kabar_gambar"]),
                              fit: BoxFit.cover),
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            new Text(
                              beritaAdmin[i]["kabar_tanggal"],
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            new Text(
                              beritaAdmin[i]["kabar_kategori"],
                            ),
                          ],
                        ),
                        title: new Text(
                          beritaAdmin[i]["kabar_judul"],
                          style: new TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 14.0,
                        ),
                      ),
                      /*child: new Container(
                  padding: new EdgeInsets.all(10.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Image(
                        image: new NetworkImage(beritaAdmin[i]["kabar_gambar"]),
                        width: 80,
                        height: 100,
                      ),
                      Flexible(
                        child: Container(
                          padding: new EdgeInsets.all(10.0),
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  beritaAdmin[i]["kabar_judul"],

                                  //textAlign: TextAlign.justify,
                                ),
                                new Text(
                                  beritaAdmin[i]["kabar_kategori"],
                                  //textAlign: TextAlign.justify,
                                ),
                                new Text(
                                  beritaAdmin[i]["kabar_tanggal"],
                                  //textAlign: TextAlign.justify,
                                ),
                              ]),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Icon(
                          Icons.edit,
                          size: 20,
                        ),
                        padding: EdgeInsets.all(16),
                        shape: CircleBorder(),
                      ),
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.red,
                        textColor: Colors.white,
                        child: Icon(
                          Icons.delete,
                          size: 20,
                        ),
                        padding: EdgeInsets.all(16),
                        shape: CircleBorder(),
                      )
                    ],
                  ),
                ),*/
                    ),
                  ),
                ),
                actions: <Widget>[
                  IconSlideAction(
                    caption: 'Unpublish',
                    color: Colors.orange,
                    icon: Icons.undo,
                    onTap: () {
                      if (beritaAdmin[i]["kabar_publis"] == '0') {
                        Alert(
                          context: context,
                          type: AlertType.error,
                          title: "RFLUTTER ALERT",
                          desc: "Flutter is more awesome with RFlutter Alert.",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "UDAH",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                            )
                          ],
                        ).show();
                      } else {
                        Alert(
                          context: context,
                          type: AlertType.info,
                          title: "Unpublish? ",
                          desc: beritaAdmin[i]["kabar_judul"],
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Tidak",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () => Navigator.pop(context),
                              color: Colors.green,
                            ),
                            DialogButton(
                              child: Text(
                                "Unpublish",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () {
                                unpublish(beritaAdmin[i]["kabar_id"]);
                              },
                              color: Colors.red,
                            )
                          ],
                        ).show();
                      }
                      debugPrint(beritaAdmin[i]["kabar_id"]);
                    },
                  ),
                  IconSlideAction(
                    caption: 'Publish',
                    color: Colors.green,
                    icon: Icons.redo,
                    onTap: () {
                      /*if (beritaAdmin[i]["kabar_publis"] == '0') {
                        print('ok' + beritaAdmin[i]["kabar_publis"]);
                      } else {
                        print('tidak ok' + beritaAdmin[i]["kabar_publis"]);
                      }*/
                      if (beritaAdmin[i]["kabar_publis"] == '1') {
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          title: "Cek lagi coba...",
                          desc: "Berita sudah terpublish lho",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "OK",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                            )
                          ],
                        ).show();
                        print(beritaAdmin[i]["kabar_publis"]);
                      } else {
                        Alert(
                          context: context,
                          type: AlertType.info,
                          title: "Publish? ",
                          desc: beritaAdmin[i]["kabar_publis"],
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Tidak",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () => Navigator.pop(context),
                              color: Colors.green,
                            ),
                            DialogButton(
                              child: Text(
                                "Publish",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () {
                                publish(beritaAdmin[i]["kabar_id"]);
                              },
                              color: Colors.red,
                            )
                          ],
                        ).show();
                        print(beritaAdmin[i]["kabar_publis"]);
                      }

                      //debugPrint(beritaAdmin[i]["kabar_id"]);
                    },
                  ),
                  /*IconSlideAction(
                    caption: 'Share',
                    color: Colors.indigo,
                    icon: Icons.share,
                    onTap: () => ('Share'),
                  ),*/
                ],
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Hapus',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () {
                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: "Hapus? ",
                        desc: beritaAdmin[i]["kabar_judul"],
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Tidak",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () => Navigator.pop(context),
                            color: Colors.green,
                          ),
                          DialogButton(
                            child: Text(
                              "Hapus",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              hapusberita(beritaAdmin[i]["kabar_id"]);

                              /*Navigator.pushReplacementNamed(
                                  context, '/FormBeritaDashbord');
                                  Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FormBeritaDashbord()),
                                (Route<dynamic> route) => false,
                              );*/
                              Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new FormBeritaDashbord(),
                              ));
                            },
                            color: Colors.red,
                          )
                        ],
                      ).show();
                    },
                  ), /*IconSlideAction(
                    caption: 'More',
                    color: Colors.black45,
                    icon: Icons.more_horiz,
                    onTap: () => ('More'),
                  ),*/
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
