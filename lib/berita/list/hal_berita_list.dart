//ANCHOR Package berita list
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'package:dio/dio.dart';
import 'package:dokar_aplikasi/berita/edit/hal_berita_edit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //api
import 'package:shared_preferences/shared_preferences.dart'; //save session
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

//ANCHOR Class berita list
class FormBeritaDashbord extends StatefulWidget {
  @override
  FormBeritaDashbordState createState() => FormBeritaDashbordState();
}

class FormBeritaDashbordState extends State<FormBeritaDashbord> {
//ANCHOR variabel berita list

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
  String status = "";
  // ignore: unused_field
  String _mySelection;
  List beritaAdmin = List();
  GlobalKey<RefreshIndicatorState> refreshKey;
  final SlidableController slidableController = SlidableController();

//ANCHOR hapus berita berita list

  void hapusberita(beritaAdmin) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
      "http://dokar.kendalkab.go.id/webservice/android/kabar/delete",
      body: {
        "IdBerita": beritaAdmin,
        "IdDesa": pref.getString("IdDesa"),
      },
    );
    var deleted = json.decode(response.body);
    print(deleted);
    Navigator.pushReplacementNamed(context, '/FormBeritaDashbord');
  }

//ANCHOR Unpublish berita list
  void unpublish(beritaAdmin) async {
    final response = await http.post(
      "http://dokar.kendalkab.go.id/webservice/android/kabar/UnPublish",
      body: {
        "IdBerita": beritaAdmin,
      },
    );
    var unpublish = json.decode(response.body);
    print(unpublish);
    Navigator.pushReplacementNamed(context, '/FormBeritaDashbord');
  }

//ANCHOR Publish berita list
  void publish(beritaAdmin) async {
    final response = await http.post(
        "http://dokar.kendalkab.go.id/webservice/android/kabar/Publish",
        body: {
          "IdBerita": beritaAdmin,
          // "IdDesa": pref.getString("IdDesa"),
        });
    var publish = json.decode(response.body);
    print(publish);
    Navigator.pushReplacementNamed(context, '/FormBeritaDashbord');
  }

//ANCHOR Cek session berita list
  // ignore: unused_element
  Future _cekSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(
        () {
          username = pref.getString("userAdmin");
          status = pref.getString("status");
        },
      );
    }
  }

  ScrollController _scrollController = new ScrollController();
  List databerita = new List();
  bool isLoading = false;
  final dio = new Dio();
  String dibaca;
  List dataJSON;

//ANCHOR Get more berita list
  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/kabar/newberita";

  void _getMoreData() async {
    //NOTE if else load more
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (!isLoading) {
      setState(
        () {
          isLoading = true;
        },
      );
      print(nextPage);
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
      setState(
        () {
          isLoading = false;
          databerita.addAll(tempList);
        },
      );
    }
  }

  @override
  void initState() {
    //this.getBerita();
    this._getMoreData();
    super.initState();
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _getMoreData();
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

//ANCHOR loading berita list
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

//ANCHOR halaman berita list
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
          await Future.delayed(
            Duration(seconds: 1),
            () {},
          );
        },
//ANCHOR listview berita list
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: databerita.length + 1,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int i) {
            if (i == databerita.length) {
              return _buildProgressIndicator();
            } else {
              if (databerita[i]["kabar_id"] == 'Notfound') {
              } else {
                Widget _container() {
                  if (databerita[i]["device"] == '1') {
                    return new Container(
                      color: Colors.grey[100],
                      padding: EdgeInsets.only(
                        left: 5.0,
                        right: 5.0,
                      ),
                      child: new Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                builder: (context) => new FormBeritaEdit(
                                  dJudul: databerita[i]["kabar_judul"],
                                  dKategori: databerita[i]["kabar_kategori"],
                                  dIsi: databerita[i]["kabar_isi"],
                                  dTanggal: databerita[i]["kabar_tanggal"],
                                  dGambar: databerita[i]["kabar_gambar"],
                                  dIdBerita: databerita[i]["kabar_id"],
                                  dVideo: databerita[i]["kabar_video"],
                                  dKomentar: databerita[i]["komentar"],
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 64,
                                minHeight: 64,
                                maxWidth: 84,
                                maxHeight: 84,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Image(
                                  image: new NetworkImage(
                                      databerita[i]["kabar_gambar"]),
                                  fit: BoxFit.cover,
                                  height: 150.0,
                                  width: 110.0,
                                ),
                              ),
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                new Text(
                                  databerita[i]["kabar_tanggal"],
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                new Text(
                                  databerita[i]["kabar_kategori"],
                                ),
                              ],
                            ),
                            title: new Text(
                              databerita[i]["kabar_judul"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(
                              Icons.phone_android,
                              size: 14.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return new Container(
                      color: Colors.grey[100],
                      padding: EdgeInsets.only(
                        left: 5.0,
                        right: 5.0,
                      ),
                      child: new Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            Alert(
                              context: context,
                              type: AlertType.warning,
                              style: alertStyle,
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
                                  color: Colors.green[300],
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
                                            new FormBeritaEdit(
                                          dJudul: databerita[i]["kabar_judul"],
                                          dKategori: databerita[i]
                                              ["kabar_kategori"],
                                          dIsi: databerita[i]["kabar_isi"],
                                          dTanggal: databerita[i]
                                              ["kabar_tanggal"],
                                          dGambar: databerita[i]
                                              ["kabar_gambar"],
                                          dIdBerita: databerita[i]["kabar_id"],
                                          dVideo: databerita[i]["kabar_video"],
                                          dKomentar: databerita[i]["komentar"],
                                        ),
                                      ),
                                    );
                                  },
                                  color: Colors.red[300],
                                )
                              ],
                            ).show();
                          },
                          child: ListTile(
                            leading: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 64,
                                minHeight: 64,
                                maxWidth: 84,
                                maxHeight: 84,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Image(
                                  image: new NetworkImage(
                                      databerita[i]["kabar_gambar"]),
                                  fit: BoxFit.cover,
                                  height: 150.0,
                                  width: 110.0,
                                ),
                              ),
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                new Text(
                                  databerita[i]["kabar_tanggal"],
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Flexible(
                                  child: Text(
                                    databerita[i]["kabar_kategori"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            title: new Text(
                              databerita[i]["kabar_judul"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(
                              Icons.computer,
                              size: 14.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }

                return Slidable(
                  //key: Key(itemC.title),
                  controller: slidableController,
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: _container(),
                  actions: <Widget>[
//ANCHOR unpublish berita list
                    IconSlideAction(
                      caption: 'Unpublish',
                      color: Colors.blue,
                      icon: Icons.undo,
                      onTap: () {
                        if (databerita[i]["kabar_publis"] == '0') {
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Warning",
                            desc: "Berita Sudah di Unpublish.",
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
                                color: Colors.red,
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
                        debugPrint(beritaAdmin[i]["kabar_id"]);
                      },
                    ),
//ANCHOR publish berita list
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
                            desc: "Berita Sudah di Publish.",
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
                            title: "Publish?",
                            desc: databerita[i]["kabar_judul"],
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Tidak",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                onPressed: () => Navigator.pop(context),
                                color: Colors.red,
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
                                color: Colors.green,
                              )
                            ],
                          ).show();
                          print(databerita[i]["kabar_publis"]);
                        }
                      },
                    ),
                  ],
//ANCHOR hapus berita list
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
