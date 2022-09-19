//ANCHOR package bumdes list
import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dokar_aplikasi/berita/edit/hal_bumdes_edit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../style/styleset.dart';

//ANCHOR class bumdes list
class HalBumdesList extends StatefulWidget {
  @override
  HalBumdesListState createState() => HalBumdesListState();
}

class HalBumdesListState extends State<HalBumdesList> {
//ANCHOR variable bumdes list

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
  List bumdesAdmin = List();
  GlobalKey<RefreshIndicatorState> refreshKey;
  final SlidableController slidableController = SlidableController();

//ANCHOR fungsi hapus berita bumdes list
  void hapusberita(bumdesAdmin) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/bumdes/delete"),
        body: {
          "IdBumdes": bumdesAdmin,
          "IdDesa": pref.getString("IdDesa"),
        });
    var deleted = json.decode(response.body);
    print(deleted);
    Navigator.pushReplacementNamed(context, '/HalBumdesList');
  }

//ANCHOR fungsi unpublish berita bumdes list
  void unpublish(bumdesAdmin) async {
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/bumdes/UnPublish"),
        body: {
          "IdBumdes": bumdesAdmin,
          //"IdDesa": pref.getString("IdDesa"),
        });
    var unpublish = json.decode(response.body);
    print(unpublish);
    Navigator.pushReplacementNamed(context, '/HalBumdesList');
  }

//ANCHOR fungsi publish berita bumdes list
  void publish(bumdesAdmin) async {
    final response = await http.post(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/bumdes/Publish"),
      body: {
        "IdBumdes": bumdesAdmin,
      },
    );
    var publish = json.decode(response.body);
    print(publish);
    Navigator.pushReplacementNamed(context, '/HalBumdesList');
  }

//ANCHOR fungsi session berita bumdes list
  // ignore: unused_element
  Future _cekSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(
        () {
          username = pref.getString("userAdmin");
        },
      );
    }
  }

//ANCHOR fungsi load berita bumdes list
  List databerita = [];
  bool isLoading = false;
  final dio = new Dio();
  List tempList = [];
  ScrollController _scrollController = new ScrollController();
  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/bumdes/list/";

  void _getMoreData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    //NOTE if else load more
    if (!isLoading) {
      setState(
        () {
          isLoading = true;
        },
      );

      final response = await dio.get(nextPage + pref.getString("IdDesa") + "/");

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
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          'List Bumdes',
          style: TextStyle(
            color: appbarTitle,
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
          await Future.delayed(Duration(seconds: 1), () {
            //redirect
          });
        },
        child: ListView.builder(
          //scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: databerita.length + 1, //NOTE if else listview berita
          // ignore: missing_return
          itemBuilder: (BuildContext context, int i) {
            if (i == databerita.length) {
              return _buildProgressIndicator();
            } else {
              if (databerita[i]["bumdes_id"] == "Notfound") {
                // return new Container(
                //   child: Center(
                //     child: new Column(
                //       children: <Widget>[
                //         new Padding(
                //           padding: new EdgeInsets.all(100.0),
                //         ),
                //         new Text(
                //           "DATA KOSONG",
                //           style: new TextStyle(
                //             fontSize: 30.0,
                //             color: Colors.grey[350],
                //             // fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //         new Padding(
                //           padding: new EdgeInsets.all(10.0),
                //         ),
                //         new Icon(
                //           Icons.list_alt_rounded,
                //           size: 150.0,
                //           color: Colors.grey[350],
                //         ),
                //       ],
                //     ),
                //   ),
                // );
              } else {
                Widget _container() {
                  if (databerita[i]["device"] == '1') {
                    // return new Container(
                    //   color: Colors.grey[100],
                    //   padding: EdgeInsets.only(
                    //     left: 5.0,
                    //     right: 5.0,
                    //   ),
                    //   child: new Card(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10.0),
                    //     ),
                    //     child: new InkWell(
                    //       onTap: () {
                    //         Navigator.of(context).push(
                    //           new MaterialPageRoute(
                    //             builder: (context) => new FormBumdesEdit(
                    //               dJudul: databerita[i]["bumdes_judul"],
                    //               dKatTempat: databerita[i]["bumdes_tempat"],
                    //               dIsi: databerita[i]["bumdes_isi"],
                    //               dGambar: databerita[i]["bumdes_gambar"],
                    //               dIdBumdes: databerita[i]["bumdes_id"],
                    //               dVideo: databerita[i]["bumdes_video"],
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //       child: ListTile(
                    //         leading: ConstrainedBox(
                    //           constraints: BoxConstraints(
                    //             minWidth: 64,
                    //             minHeight: 64,
                    //             maxWidth: 84,
                    //             maxHeight: 84,
                    //           ),
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.circular(5.0),
                    //             child: Image(
                    //               image: new NetworkImage(
                    //                   databerita[i]["bumdes_gambar"]),
                    //               fit: BoxFit.cover,
                    //               height: 150.0,
                    //               width: 110.0,
                    //             ),
                    //           ),
                    //         ),
                    //         subtitle: Row(
                    //           children: <Widget>[
                    //             new Text(
                    //               databerita[i]["bumdes_tempat"],
                    //             ),
                    //           ],
                    //         ),
                    //         title: new Text(
                    //           databerita[i]["bumdes_judul"],
                    //           style: new TextStyle(
                    //               fontSize: 14.0, fontWeight: FontWeight.bold),
                    //         ),
                    //         trailing: Icon(
                    //           Icons.phone_android,
                    //           size: 14.0,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // );
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
                                builder: (context) => new FormBumdesEdit(
                                  dJudul: databerita[i]["bumdes_judul"],
                                  dKatTempat: databerita[i]["bumdes_tempat"],
                                  dIsi: databerita[i]["bumdes_isi"],
                                  dGambar: databerita[i]["bumdes_gambar"],
                                  dIdBumdes: databerita[i]["bumdes_id"],
                                  dVideo: databerita[i]["bumdes_video"],
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
                                  imageUrl: databerita[i]["bumdes_gambar"],
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
                                        databerita[i]["bumdes_judul"],
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
                                              databerita[i]["bumdes_tempat"],
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
                                    // new Container(
                                    //   child: new Column(
                                    //     children: <Widget>[
                                    //       new Container(
                                    //         child: new Text(
                                    //           databerita[i]["kabar_kategori"],
                                    //           style: new TextStyle(
                                    //             fontSize: 11.0,
                                    //             color: Colors.grey[500],
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    // return new Container(
                    //   color: Colors.grey[100],
                    //   padding: EdgeInsets.only(
                    //     left: 5.0,
                    //     right: 5.0,
                    //   ),
                    //   child: new Card(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10.0),
                    //     ),
                    //     child: new InkWell(
                    //       onTap: () {
                    //         Alert(
                    //           context: context,
                    //           type: AlertType.warning,
                    //           style: alertStyle,
                    //           title: "Peringatan.",
                    //           desc:
                    //               "Konten di input melalui Website, Apa anda ingin melanjutkan edit.",
                    //           buttons: [
                    //             DialogButton(
                    //               child: Text(
                    //                 "Tidak",
                    //                 style: TextStyle(
                    //                     color: Colors.white, fontSize: 16),
                    //               ),
                    //               onPressed: () => Navigator.pop(context),
                    //               color: Colors.green[300],
                    //             ),
                    //             DialogButton(
                    //               child: Text(
                    //                 "Edit",
                    //                 style: TextStyle(
                    //                     color: Colors.white, fontSize: 16),
                    //               ),
                    //               onPressed: () {
                    //                 Navigator.pop(context);
                    //                 Navigator.of(context).push(
                    //                   new MaterialPageRoute(
                    //                     builder: (context) =>
                    //                         new FormBumdesEdit(
                    //                       dJudul: databerita[i]["bumdes_judul"],
                    //                       dKatTempat: databerita[i]
                    //                           ["bumdes_tempat"],
                    //                       dIsi: databerita[i]["bumdes_isi"],
                    //                       dGambar: databerita[i]
                    //                           ["bumdes_gambar"],
                    //                       dIdBumdes: databerita[i]["bumdes_id"],
                    //                       dVideo: databerita[i]["bumdes_video"],
                    //                     ),
                    //                   ),
                    //                 );
                    //               },
                    //               color: Colors.red[300],
                    //             )
                    //           ],
                    //         ).show();
                    //       },
                    //       child: ListTile(
                    //         leading: ConstrainedBox(
                    //           constraints: BoxConstraints(
                    //             minWidth: 64,
                    //             minHeight: 64,
                    //             maxWidth: 84,
                    //             maxHeight: 84,
                    //           ),
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.circular(5.0),
                    //             child: Image(
                    //               image: new NetworkImage(
                    //                   databerita[i]["bumdes_gambar"]),
                    //               fit: BoxFit.cover,
                    //               height: 150.0,
                    //               width: 110.0,
                    //             ),
                    //           ),
                    //         ),
                    //         subtitle: Row(
                    //           children: <Widget>[
                    //             new Text(
                    //               databerita[i]["bumdes_tempat"],
                    //             ),
                    //           ],
                    //         ),
                    //         title: new Text(
                    //           databerita[i]["bumdes_judul"],
                    //           style: new TextStyle(
                    //               fontSize: 14.0, fontWeight: FontWeight.bold),
                    //         ),
                    //         trailing: Icon(
                    //           Icons.computer,
                    //           size: 14.0,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // );
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
                                            new FormBumdesEdit(
                                          dJudul: databerita[i]["bumdes_judul"],
                                          dKatTempat: databerita[i]
                                              ["bumdes_tempat"],
                                          dIsi: databerita[i]["bumdes_isi"],
                                          dGambar: databerita[i]
                                              ["bumdes_gambar"],
                                          dIdBumdes: databerita[i]["bumdes_id"],
                                          dVideo: databerita[i]["bumdes_video"],
                                        ),
                                      ),
                                    );
                                  },
                                  color: Colors.red[300],
                                )
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
                                  imageUrl: databerita[i]["bumdes_gambar"],
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
                                        databerita[i]["bumdes_judul"],
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
                                              databerita[i]["bumdes_tempat"],
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
                                    // new Container(
                                    //   child: new Column(
                                    //     children: <Widget>[
                                    //       new Container(
                                    //         child: new Text(
                                    //           databerita[i]["kabar_kategori"],
                                    //           style: new TextStyle(
                                    //             fontSize: 11.0,
                                    //             color: Colors.grey[500],
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
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
                        if (databerita[i]["bumdes_publis"] == '0') {
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Unpublish",
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
                            desc: databerita[i]["bumdes_judul"],
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
                                  unpublish(databerita[i]["bumdes_id"]);
                                  Navigator.pop(context);
                                },
                                color: Colors.orange,
                              )
                            ],
                          ).show();
                        }
                        debugPrint(bumdesAdmin[i]["bumdes_id"]);
                      },
                    ),
                    IconSlideAction(
                      caption: 'Publish',
                      color: Colors.green,
                      icon: Icons.redo,
                      onTap: () {
                        if (databerita[i]["bumdes_publis"] == '1') {
                          Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "Publish",
                            desc: "Bumdes Sudah di Publish.",
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
                          print(databerita[i]["bumdes_publis"]);
                        } else {
                          Alert(
                            context: context,
                            type: AlertType.info,
                            title: "Publish? ",
                            desc: databerita[i]["bumdes_judul"],
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
                                  publish(databerita[i]["bumdes_id"]);
                                  Navigator.pop(context);
                                },
                                color: Colors.red,
                              )
                            ],
                          ).show();
                          print(databerita[i]["bumdes_publis"]);
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
                          desc: databerita[i]["bumdes_judul"],
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
                                hapusberita(databerita[i]["bumdes_id"]);
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
