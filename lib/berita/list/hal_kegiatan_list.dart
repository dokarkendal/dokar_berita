////////////////////////////////PACKAGE//////////////////////////////////////
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dokar_aplikasi/berita/edit/hal_kegiatan_edit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //api
import 'package:shared_preferences/shared_preferences.dart'; //save session
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

////////////////////////////////PROJECT///////////////////////////////////////
class HalKegiatanList extends StatefulWidget {
  @override
  HalKegiatanListState createState() => HalKegiatanListState();
}

class HalKegiatanListState extends State<HalKegiatanList> {
////////////////////////////////DEKLARASI////////////////////////////////////
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
  );

  String username = "";

  // ignore: unused_field
  String _mySelection;
  List kegiatanAdmin = List();
  GlobalKey<RefreshIndicatorState> refreshKey;
  final SlidableController slidableController = SlidableController();

  void hapusberita(kegiatanAdmin) async {
    //print(beritaAdmin);
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        "http://dokar.kendalkab.go.id/webservice/android/kabar/delete",
        body: {
          "IdBerita": kegiatanAdmin,
          "IdDesa": pref.getString("IdDesa"),
        });
    var deleted = json.decode(response.body);
    print(deleted);
    Navigator.pushReplacementNamed(context, '/HalKegiatanList');
  }

  void unpublish(kegiatanAdmin) async {
    //print(beritaAdmin);
    //SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        "http://dokar.kendalkab.go.id/webservice/android/kabar/UnPublish",
        body: {
          "IdBerita": kegiatanAdmin,
          //"IdDesa": pref.getString("IdDesa"),
        });
    var unpublish = json.decode(response.body);
    print(unpublish);
    Navigator.pushReplacementNamed(context, '/HalKegiatanList');
  }

  void publish(kegiatanAdmin) async {
    //print(beritaAdmin);
    //SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        "http://dokar.kendalkab.go.id/webservice/android/kabar/Publish",
        body: {
          "IdBerita": kegiatanAdmin,
          // "IdDesa": pref.getString("IdDesa"),
        });
    var publish = json.decode(response.body);
    print(publish);
    Navigator.pushReplacementNamed(context, '/HalKegiatanList');
  }

///////////////////////////////CEK SESSION ADMIN///////////////////////////////////
  // ignore: unused_element
  Future _cekSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(() {
        username = pref.getString("userAdmin");
        //id = pref.getString("IdDesa");
      });
    }
  }

  //NOTE url api load berita
  List databerita = new List();
  bool isLoading = false;
  final dio = new Dio();
  List tempList = new List();
  ScrollController _scrollController = new ScrollController();

  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/kabar/newkegiatan";

  void _getMoreData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    //NOTE if else load more
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      final response = await dio.get(nextPage +
          "/" +
          pref.getString("IdDesa") +
          "/" +
          pref.getString("status") +
          "/" +
          pref.getString("IdAdmin") +
          "/");
      List tempList = new List();
      nextPage = response.data['next'];

      for (int i = 0; i < response.data['result'].length; i++) {
        tempList.add(response.data['result'][i]);
      }
      setState(() {
        isLoading = false;
        databerita.addAll(tempList);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //this.getBerita();
    this._getMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

///////////////////////////////HALAMAN UTAMA//////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Kegiatan',
          style: TextStyle(
            color: Color(0xFF2e2e2e),
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1), () {});
        },
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: databerita.length + 1, //NOTE if else listview berita
          // ignore: missing_return
          itemBuilder: (BuildContext context, int i) {
            if (i == databerita.length) {
              return _buildProgressIndicator();
            } else {
              if (databerita[i]["kabar_id"] == 'Notfound') {
              } else {
                Widget _container() {
                  if (databerita[i]["device"] == '1') {
                    return Container(
                      child: new Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        elevation: 1.0,
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                builder: (context) => new FormKegiatanEdit(
                                  dJudul: databerita[i]["kabar_judul"],
                                  dKatTempat: databerita[i]["kabar_tempat"],
                                  dIsi: databerita[i]["kabar_isi"],
                                  dTanggal: databerita[i]["kabar_tanggal"],
                                  dGambar: databerita[i]["kabar_gambar"],
                                  dIdKegiatan: databerita[i]["kabar_id"],
                                  dVideo: databerita[i]["kabar_video"],
                                ),
                              ),
                            );
                          },
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(right: 15.0),
                                width: 120.0,
                                height: 100.0,
                                child: CachedNetworkImage(
                                  imageUrl: databerita[i]["kabar_gambar"],
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
                              new Expanded(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Container(
                                      margin: const EdgeInsets.only(
                                        right: 10.0,
                                        top: 5.0,
                                      ),
                                      child: new Text(
                                        databerita[i]["kabar_judul"],
                                        style: new TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        new Expanded(
                                          child: new Container(
                                            margin: const EdgeInsets.only(
                                                top: 5.0, bottom: 10.0),
                                            child: new Text(
                                              databerita[i]["kabar_tanggal"],
                                              style: new TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
                                                //fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                        new Container(
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Icon(
                                            Icons.phone_android,
                                            size: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    new Container(
                                      child: new Column(
                                        children: <Widget>[
                                          new Container(
                                            child: new Text(
                                              databerita[i]["kabar_tempat"],
                                              style: new TextStyle(
                                                fontSize: 11.0,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      child: new Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        elevation: 1.0,
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            Alert(
                              context: context,
                              type: AlertType.warning,
                              // style: alertStyle,
                              title: "Peringatan.",
                              desc:
                                  "Konten di input melalui Website, Apa anda ingin melanjutkan edit.",
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
                                      "Edit",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                        new MaterialPageRoute(
                                          builder: (context) =>
                                              new FormKegiatanEdit(
                                            dJudul: databerita[i]
                                                ["kabar_judul"],
                                            dKatTempat: databerita[i]
                                                ["kabar_tempat"],
                                            dIsi: databerita[i]["kabar_isi"],
                                            dTanggal: databerita[i]
                                                ["kabar_tanggal"],
                                            dGambar: databerita[i]
                                                ["kabar_gambar"],
                                            dIdKegiatan: databerita[i]
                                                ["kabar_id"],
                                            dVideo: databerita[i]
                                                ["kabar_video"],
                                          ),
                                        ),
                                      );
                                    },
                                    color: Colors.red)
                              ],
                            ).show();
                          },
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(right: 15.0),
                                width: 120.0,
                                height: 100.0,
                                child: CachedNetworkImage(
                                  imageUrl: databerita[i]["kabar_gambar"],
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
                              new Expanded(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Container(
                                      margin: const EdgeInsets.only(
                                        right: 10.0,
                                        top: 5.0,
                                      ),
                                      child: new Text(
                                        databerita[i]["kabar_judul"],
                                        style: new TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        new Expanded(
                                          child: new Container(
                                            margin: const EdgeInsets.only(
                                                top: 5.0, bottom: 10.0),
                                            child: new Text(
                                              databerita[i]["kabar_tanggal"],
                                              style: new TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
                                                //fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                        new Container(
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Icon(
                                            Icons.laptop,
                                            color: Colors.blue,
                                            size: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    new Container(
                                      child: new Column(
                                        children: <Widget>[
                                          new Container(
                                            child: new Text(
                                              databerita[i]["kabar_tempat"],
                                              style: new TextStyle(
                                                fontSize: 11.0,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }

                return Slidable(
                  controller: slidableController,
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: _container(),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Unpublish',
                      color: Colors.blue,
                      icon: Icons.undo,
                      onTap: () {
                        if (databerita[i]["kabar_publis"] == '0') {
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Unpubllish",
                            desc: "Berita Sudah di Unpublish",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Ok",
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
                            desc: databerita[i]["kabar_judul"],
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
                                  unpublish(databerita[i]["kabar_id"]);
                                  Navigator.pop(context);
                                },
                                color: Colors.orange,
                              )
                            ],
                          ).show();
                        }
                        debugPrint(kegiatanAdmin[i]["kabar_id"]);
                      },
                    ),
                    //FIXME publish
                    IconSlideAction(
                      caption: 'Publish',
                      color: Colors.green,
                      icon: Icons.redo,
                      onTap: () {
                        if (databerita[i]["kabar_publis"] == '1') {
                          Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "Warning",
                            desc: "Kegiatan Sudah di Publish.",
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
                          print(databerita[i]["kabar_publis"]);
                        } else {
                          Alert(
                            context: context,
                            type: AlertType.info,
                            title: "Publish? ",
                            desc: databerita[i]["kabar_judul"],
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
                                  publish(databerita[i]["kabar_id"]);
                                  Navigator.pop(context);
                                },
                                color: Colors.red,
                              )
                            ],
                          ).show();
                          print(databerita[i]["kabar_publis"]);
                        }
                      },
                    ),
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
                          desc: databerita[i]["kabar_judul"],
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
                                "Hapus",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () {
                                hapusberita(databerita[i]["kabar_id"]);
                                Navigator.pop(context);
                              },
                              color: Colors.red,
                            )
                          ],
                        ).show();
                      },
                    ),
                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }
}
