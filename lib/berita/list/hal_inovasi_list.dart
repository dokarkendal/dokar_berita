////////////////////////////////PACKAGE//////////////////////////////////////
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dokar_aplikasi/berita/edit/hal_inovasi_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http; //api
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart'; //save session
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../style/styleset.dart';

////////////////////////////////PROJECT///////////////////////////////////////
class HalInovasiList extends StatefulWidget {
  @override
  HalInovasiListState createState() => HalInovasiListState();
}

class HalInovasiListState extends State<HalInovasiList> {
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
  //String id = "";
  // ignore: unused_field
  late String _mySelection;
  List inovasiAdmin = [];
  bool _isInAsyncCall = false;
  late GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  // final SlidableController slidableController = SlidableController();

  void hapusberita(inovasiAdmin) async {
    setState(() {
      _isInAsyncCall = true;
    });
    //print(beritaAdmin);
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse("http://dokar.kendalkab.go.id/webservice/android/bid/delete"),
        body: {
          "IdInovasi": inovasiAdmin,
          "IdDesa": pref.getString("IdDesa"),
        });
    var deleted = json.decode(response.body);
    print(deleted);
    if (deleted[0]["Notif"] == "Delete Berhasil") {
      setState(() {
        _isInAsyncCall = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Berita berhasil di hapus',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              print('ULANGI snackbar');
            },
          ),
        ));
      });
    }

    Navigator.pushReplacementNamed(context, '/HalInovasiList');
  }

  void unpublish(inovasiAdmin) async {
    setState(() {
      _isInAsyncCall = true;
    });
    //print(beritaAdmin);
    //SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/bid/unpublish"),
        body: {
          "IdInovasi": inovasiAdmin,
          //"IdDesa": pref.getString("IdDesa"),
        });
    var unpublish = json.decode(response.body);
    print(unpublish);
    if (unpublish[0]["Notif"] == "UnPublish Berhasil") {
      setState(
        () {
          _isInAsyncCall = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Inovasi berhasil di unpublish',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {
                  print('ULANGI snackbar');
                },
              ),
            ),
          );
        },
      );
    }
    Navigator.pushReplacementNamed(context, '/HalInovasiList');
  }

  void publish(inovasiAdmin) async {
    setState(() {
      _isInAsyncCall = true;
    });
    //print(beritaAdmin);
    //SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/bid/publish"),
        body: {
          "IdInovasi": inovasiAdmin,
          // "IdDesa": pref.getString("IdDesa"),
        });
    var publish = json.decode(response.body);
    print(publish);
    if (publish[0]["Notif"] == "Publish Berhasil") {
      setState(
        () {
          _isInAsyncCall = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Berita berhasil di publish',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {
                  print('ULANGI snackbar');
                },
              ),
            ),
          );
        },
      );
    }
    Navigator.pushReplacementNamed(context, '/HalInovasiList');
  }

///////////////////////////////CEK SESSION ADMIN///////////////////////////////////
  // ignore: unused_element
  Future _cekSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(
        () {
          username = pref.getString("userAdmin")!;
        },
      );
    }
  }

  //NOTE url api load berita
  List databerita = [];
  bool isLoading = false;
  final dio = Dio();
  List tempList = [];
  ScrollController _scrollController = ScrollController();
  String nextPage = "http://dokar.kendalkab.go.id/webservice/android/bid/list/";

  void _getMoreData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    //NOTE if else load more
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      final response =
          await dio.get(nextPage + pref.getString("IdDesa")! + "/");

      nextPage = response.data['next'];

      for (int i = 0; i < response.data['result'].length; i++) {
        tempList.add(response.data['result'][i]);
      }

      setState(() {
        isLoading = false;
        databerita.addAll(tempList);
        //print(databerita);
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

///////////////////////////////HALAMAN UTAMA//////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          'LIST INOVASI',
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
            // fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 1,
        color: Theme.of(context).primaryColor,
        progressIndicator: Padding(
          padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.4),
          child: Column(
            children: [
              SpinKitThreeBounce(color: Color(0xFF2e2e2e)),
              SizedBox(height: mediaQueryData.size.height * 0.05),
              Text(
                'Sedang memproses..',
                style: TextStyle(
                    color: Color(0xFF2e2e2e),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )
            ],
          ),
        ),
        child: RefreshIndicator(
          key: refreshKey,
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1), () {
              //redirect
            });
          },
          child: SlidableAutoCloseBehavior(
            child: ListView.builder(
              //scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: databerita.length + 1, //NOTE if else listview berita
              // ignore: missing_return
              itemBuilder: (BuildContext context, int i) {
                var status;
                if (i < databerita.length &&
                    databerita[i]["inovasi_publis"] == "1") {
                  status = Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 14.0,
                      color: Colors.green,
                    ),
                  );
                } else {
                  status = Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    child: Icon(
                      Icons.undo,
                      size: 14.0,
                      color: Colors.orange,
                    ),
                  );
                }
                if (i == databerita.length) {
                  return Container(
                    child: _buildProgressIndicator(),
                  );
                } else {
                  if (databerita[i]["inovasi_id"] == 'Notfound') {
                    // return Center(
                    //   child:  Column(
                    //     children: <Widget>[
                    //        Padding(
                    //         padding:  EdgeInsets.all(100.0),
                    //       ),
                    //        Text(
                    //         "DATA KOSONG",
                    //         style:  TextStyle(
                    //           fontSize: 30.0,
                    //           color: Colors.grey[350],
                    //         ),
                    //       ),
                    //        Padding(
                    //         padding:  EdgeInsets.all(20.0),
                    //       ),
                    //        Icon(Icons.help_outline,
                    //           size: 150.0, color: Colors.grey[350]),
                    //     ],
                    //   ),
                    // );
                  } else {
                    Widget _container() {
                      if (databerita[i]["device"] == '1') {
                        // return  Container(
                        //   color: Colors.grey[100],
                        //   padding: EdgeInsets.only(
                        //     left: 5.0,
                        //     right: 5.0,
                        //   ),
                        //   child:  Card(
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //     ),
                        //     child:  InkWell(
                        //       onTap: () {
                        //         Navigator.of(context).push(
                        //            MaterialPageRoute(
                        //             builder: (context) =>  FormInovasiEdit(
                        //               dJudul: databerita[i]["inovasi_judul"],
                        //               dKategori: databerita[i]["inovasi_kategori"],
                        //               dIsi: databerita[i]["inovasi_isi"],
                        //               dTanggal: databerita[i]["inovasi_tanggal"],
                        //               dGambar: databerita[i]["inovasi_gambar"],
                        //               dIdBerita: databerita[i]["inovasi_id"],
                        //               dVideo: databerita[i]["inovasi_video"],
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
                        //               image:  NetworkImage(
                        //                   databerita[i]["inovasi_gambar"]),
                        //               fit: BoxFit.cover,
                        //               height: 150.0,
                        //               width: 110.0,
                        //             ),
                        //           ),
                        //         ),
                        //         subtitle: Row(
                        //           children: <Widget>[
                        //              Text(
                        //               databerita[i]["inovasi_tanggal"],
                        //             ),
                        //             SizedBox(
                        //               width: 16.0,
                        //             ),
                        //           ],
                        //         ),
                        //         title:  Text(
                        //           databerita[i]["inovasi_judul"],
                        //           maxLines: 2,
                        //           overflow: TextOverflow.ellipsis,
                        //           style:  TextStyle(
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
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 1.0,
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FormInovasiEdit(
                                      dJudul: databerita[i]["inovasi_judul"],
                                      dKategori: databerita[i]
                                          ["inovasi_kategori"],
                                      dIsi: databerita[i]["inovasi_isi"],
                                      dTanggal: databerita[i]
                                          ["inovasi_tanggal"],
                                      dGambar: databerita[i]["inovasi_gambar"],
                                      dIdBerita: databerita[i]["inovasi_id"],
                                      dVideo: databerita[i]["inovasi_video"],
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(right: 15.0),
                                    width: 120.0,
                                    height: 100.0,
                                    child: CachedNetworkImage(
                                      imageUrl: databerita[i]["inovasi_gambar"],
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(
                                            right: 10.0,
                                            top: 5.0,
                                          ),
                                          child: Text(
                                            databerita[i]["inovasi_judul"],
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5.0, bottom: 10.0),
                                                child: Text(
                                                  databerita[i]
                                                      ["inovasi_tanggal"],
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey,
                                                    //fontWeight: FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: Icon(
                                                Icons.phone_android,
                                                size: 14.0,
                                              ),
                                            ),
                                            status
                                          ],
                                        ),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  databerita[i]
                                                      ["inovasi_kategori"],
                                                  style: TextStyle(
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
                        // return  Container(
                        //   color: Colors.grey[100],
                        //   padding: EdgeInsets.only(
                        //     left: 5.0,
                        //     right: 5.0,
                        //   ),
                        //   child:  Card(
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //     ),
                        //     child:  InkWell(
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
                        //                    MaterialPageRoute(
                        //                     builder: (context) =>
                        //                          FormInovasiEdit(
                        //                       dJudul: databerita[i]
                        //                           ["inovasi_judul"],
                        //                       dKategori: databerita[i]
                        //                           ["inovasi_kategori"],
                        //                       dIsi: databerita[i]["inovasi_isi"],
                        //                       dTanggal: databerita[i]
                        //                           ["inovasi_tanggal"],
                        //                       dGambar: databerita[i]
                        //                           ["inovasi_gambar"],
                        //                       dIdBerita: databerita[i]
                        //                           ["inovasi_id"],
                        //                       dVideo: databerita[i]
                        //                           ["inovasi_video"],
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
                        //               image:  NetworkImage(
                        //                   databerita[i]["inovasi_gambar"]),
                        //               fit: BoxFit.cover,
                        //               height: 150.0,
                        //               width: 110.0,
                        //             ),
                        //           ),
                        //         ),
                        //         subtitle: Row(
                        //           children: <Widget>[
                        //              Text(
                        //               databerita[i]["inovasi_tanggal"],
                        //             ),
                        //             SizedBox(
                        //               width: 16.0,
                        //             ),
                        //           ],
                        //         ),
                        //         title:  Text(
                        //           databerita[i]["inovasi_judul"],
                        //           maxLines: 2,
                        //           overflow: TextOverflow.ellipsis,
                        //           style:  TextStyle(
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
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 1.0,
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                // Alert(
                                //   context: context,
                                //   type: AlertType.warning,
                                //   // style: alertStyle,
                                //   title: "Peringatan.",
                                //   desc:
                                //       "Konten di input melalui Website, Apa anda ingin melanjutkan edit.",
                                //   buttons: [
                                //     DialogButton(
                                //       child: Text(
                                //         "Tidak",
                                //         style: TextStyle(
                                //             color: Colors.white, fontSize: 16),
                                //       ),
                                //       onPressed: () => Navigator.pop(context),
                                //       color: Colors.green,
                                //     ),
                                //     DialogButton(
                                //       child: Text(
                                //         "Edit",
                                //         style: TextStyle(
                                //             color: Colors.white, fontSize: 16),
                                //       ),
                                //       onPressed: () {
                                //         Navigator.pop(context);
                                //         Navigator.of(context).push(
                                //           MaterialPageRoute(
                                //             builder: (context) =>
                                //                 FormInovasiEdit(
                                //               dJudul: databerita[i]
                                //                   ["inovasi_judul"],
                                //               dKategori: databerita[i]
                                //                   ["inovasi_kategori"],
                                //               dIsi: databerita[i]
                                //                   ["inovasi_isi"],
                                //               dTanggal: databerita[i]
                                //                   ["inovasi_tanggal"],
                                //               dGambar: databerita[i]
                                //                   ["inovasi_gambar"],
                                //               dIdBerita: databerita[i]
                                //                   ["inovasi_id"],
                                //               dVideo: databerita[i]
                                //                   ["inovasi_video"],
                                //             ),
                                //           ),
                                //         );
                                //       },
                                //       color: Colors.red,
                                //     )
                                //   ],
                                // ).show();
                                Dialogs.bottomMaterialDialog(
                                  msg:
                                      'Konten ini di input lewat website, tag html akan terbaca, apakah akan lanjut mengedit? ',
                                  title: "EDIT INOVASI",
                                  color: Colors.white,
                                  lottieBuilder: Lottie.asset(
                                    'assets/animation/edit2.json',
                                    fit: BoxFit.contain,
                                    repeat: true,
                                  ),
                                  // animation:'assets/logo/animation/exit.json',
                                  context: context,
                                  actions: [
                                    IconsOutlineButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      text: 'Batal',
                                      iconData: Icons.cancel_outlined,
                                      textStyle:
                                          const TextStyle(color: Colors.grey),
                                      iconColor: Colors.grey,
                                    ),
                                    IconsButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FormInovasiEdit(
                                              dJudul: databerita[i]
                                                  ["inovasi_judul"],
                                              dKategori: databerita[i]
                                                  ["inovasi_kategori"],
                                              dIsi: databerita[i]
                                                  ["inovasi_isi"],
                                              dTanggal: databerita[i]
                                                  ["inovasi_tanggal"],
                                              dGambar: databerita[i]
                                                  ["inovasi_gambar"],
                                              dIdBerita: databerita[i]
                                                  ["inovasi_id"],
                                              dVideo: databerita[i]
                                                  ["inovasi_video"],
                                            ),
                                          ),
                                        );
                                      },
                                      // onPressed: () async {
                                      //   Navigator.pop(context);
                                      //   Navigator.of(context).push(
                                      //     MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           FormBeritaEdit(
                                      //         dJudul: databerita[i]
                                      //             ["kabar_judul"],
                                      //         dKategori: databerita[i]
                                      //             ["kabar_kategori"],
                                      //         dIsi: databerita[i]["kabar_isi"],
                                      //         dTanggal: databerita[i]
                                      //             ["kabar_tanggal"],
                                      //         dGambar: databerita[i]
                                      //             ["kabar_gambar"],
                                      //         dIdBerita: databerita[i]
                                      //             ["kabar_id"],
                                      //         dVideo: databerita[i]
                                      //             ["kabar_video"],
                                      //         dKomentar: databerita[i]
                                      //             ["komentar"],
                                      //       ),
                                      //     ),
                                      //   );
                                      // },
                                      text: 'EDIT',
                                      iconData: Icons.edit,
                                      color: Colors.red,
                                      textStyle:
                                          const TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                    ),
                                  ],
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(right: 15.0),
                                    width: 120.0,
                                    height: 100.0,
                                    child: CachedNetworkImage(
                                      imageUrl: databerita[i]["inovasi_gambar"],
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(
                                            right: 10.0,
                                            top: 5.0,
                                          ),
                                          child: Text(
                                            databerita[i]["inovasi_judul"],
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5.0, bottom: 10.0),
                                                child: Text(
                                                  databerita[i]
                                                      ["inovasi_tanggal"],
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey,
                                                    //fontWeight: FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: Icon(
                                                Icons.laptop,
                                                color: Colors.blue,
                                                size: 14.0,
                                              ),
                                            ),
                                            status,
                                          ],
                                        ),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  databerita[i]
                                                      ["inovasi_kategori"],
                                                  style: TextStyle(
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
                      child: _container(),
                      // controller: slidableController,
                      startActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        extentRatio: 0.5,
                        children: [
                          SlidableAction(
                            label: 'Unpublish',
                            backgroundColor: Colors.blue,
                            icon: Icons.undo,
                            onPressed: (context) {
                              if (databerita[i]["inovasi_publis"] == '0') {
                                // Alert(
                                //   context: context,
                                //   type: AlertType.error,
                                //   title: "Warning",
                                //   desc: "Berita Sudah di Unpublish",
                                //   buttons: [
                                //     DialogButton(
                                //       child: Text(
                                //         "Ok",
                                //         style: TextStyle(
                                //             color: Colors.white, fontSize: 20),
                                //       ),
                                //       onPressed: () => Navigator.pop(context),
                                //       width: 120,
                                //     )
                                //   ],
                                // ).show();
                                Dialogs.materialDialog(
                                  msg: 'Inovasi anda sudah UnPublish',
                                  title: "Sudah UnPublish",
                                  color: Colors.white,
                                  lottieBuilder: Lottie.asset(
                                    'assets/animation/check.json',
                                    fit: BoxFit.contain,
                                    repeat: true,
                                  ),
                                  // animation:'assets/logo/animation/exit.json',
                                  context: context,
                                  actions: [
                                    // IconsOutlineButton(
                                    //   onPressed: () {
                                    //     if (mounted) {
                                    //       // Navigator.pop(context);
                                    //       Navigator.of(
                                    //               refreshKey.currentContext!)
                                    //           .pop();
                                    //     }
                                    //   },
                                    //   text: 'Baik',
                                    //   iconData: Icons.check,
                                    //   textStyle:
                                    //       const TextStyle(color: Colors.grey),
                                    //   iconColor: Colors.grey,
                                    // ),
                                    IconsButton(
                                      onPressed: () async {
                                        // hapusberita(databerita[i]["kabar_id"]);
                                        Navigator.of(refreshKey.currentContext!)
                                            .pop();
                                      },
                                      text: 'Baik',
                                      iconData: Icons.check,
                                      color: Colors.blue,
                                      textStyle:
                                          const TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                    ),
                                  ],
                                );
                              } else {
                                // Alert(
                                //   context: context,
                                //   type: AlertType.info,
                                //   title: "Unpublish? ",
                                //   desc: databerita[i]["inovasi_judul"],
                                //   buttons: [
                                //     DialogButton(
                                //       child: Text(
                                //         "Tidak",
                                //         style: TextStyle(
                                //             color: Colors.white, fontSize: 16),
                                //       ),
                                //       onPressed: () => Navigator.pop(context),
                                //       color: Colors.green,
                                //     ),
                                //     DialogButton(
                                //       child: Text(
                                //         "Unpublish",
                                //         style: TextStyle(
                                //             color: Colors.white, fontSize: 16),
                                //       ),
                                //       onPressed: () {
                                //         unpublish(databerita[i]["inovasi_id"]);
                                //         Navigator.pop(context);
                                //       },
                                //       color: Colors.orange,
                                //     )
                                //   ],
                                // ).show();
                                Dialogs.bottomMaterialDialog(
                                  msg: databerita[i]["inovasi_judul"],
                                  title: "Unpublish berita",
                                  color: Colors.white,
                                  lottieBuilder: Lottie.asset(
                                    'assets/animation/archive.json',
                                    fit: BoxFit.contain,
                                    repeat: true,
                                  ),
                                  // animation:'assets/logo/animation/exit.json',
                                  context: context,
                                  actions: [
                                    IconsOutlineButton(
                                      onPressed: () {
                                        if (mounted) {
                                          // Navigator.pop(context);
                                          Navigator.of(
                                                  refreshKey.currentContext!)
                                              .pop();
                                        }
                                      },
                                      text: 'Batal',
                                      iconData: Icons.cancel_outlined,
                                      textStyle:
                                          const TextStyle(color: Colors.grey),
                                      iconColor: Colors.grey,
                                    ),
                                    IconsButton(
                                      onPressed: () async {
                                        unpublish(databerita[i]["inovasi_id"]);
                                        Navigator.of(refreshKey.currentContext!)
                                            .pop();
                                      },
                                      text: 'Unpublish',
                                      iconData: Icons.undo,
                                      color: Colors.red,
                                      textStyle:
                                          const TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                    ),
                                  ],
                                );
                              }
                              print(databerita[i]["inovasi_id"]);
                            },
                          ),
                          SlidableAction(
                            label: 'Publish',
                            backgroundColor: Colors.green,
                            icon: Icons.redo,
                            onPressed: (context) {
                              if (databerita[i]["inovasi_publis"] == '1') {
                                // Alert(
                                //   context: context,
                                //   type: AlertType.warning,
                                //   title: "Warning",
                                //   desc: "Kegiatan Sudah di Publish.",
                                //   buttons: [
                                //     DialogButton(
                                //       child: Text(
                                //         "OK",
                                //         style: TextStyle(
                                //             color: Colors.white, fontSize: 20),
                                //       ),
                                //       onPressed: () => Navigator.pop(context),
                                //       width: 120,
                                //     )
                                //   ],
                                // ).show();
                                Dialogs.materialDialog(
                                  msg: 'Inovasi anda sudah terpublish ke publk',
                                  title: "Sudah Publish",
                                  color: Colors.white,
                                  lottieBuilder: Lottie.asset(
                                    'assets/animation/check.json',
                                    fit: BoxFit.contain,
                                    repeat: true,
                                  ),
                                  // animation:'assets/logo/animation/exit.json',
                                  context: context,
                                  actions: [
                                    // IconsOutlineButton(
                                    //   onPressed: () {
                                    //     if (mounted) {
                                    //       // Navigator.pop(context);
                                    //       Navigator.of(
                                    //               refreshKey.currentContext!)
                                    //           .pop();
                                    //     }
                                    //   },
                                    //   text: 'Baik',
                                    //   iconData: Icons.check,
                                    //   textStyle:
                                    //       const TextStyle(color: Colors.grey),
                                    //   iconColor: Colors.grey,
                                    // ),
                                    IconsButton(
                                      onPressed: () async {
                                        // hapusberita(databerita[i]["kabar_id"]);
                                        Navigator.of(refreshKey.currentContext!)
                                            .pop();
                                      },
                                      text: 'Baik',
                                      iconData: Icons.check,
                                      color: Colors.blue,
                                      textStyle:
                                          const TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                    ),
                                  ],
                                );
                                print(databerita[i]["inovasi_publis"]);
                              } else {
                                Dialogs.materialDialog(
                                  msg: databerita[i]["inovasi_judul"],
                                  title: "Publish",
                                  color: Colors.white,
                                  lottieBuilder: Lottie.asset(
                                    'assets/animation/uploadberita.json',
                                    fit: BoxFit.contain,
                                    repeat: true,
                                  ),
                                  // animation:'assets/logo/animation/exit.json',
                                  context: context,
                                  actions: [
                                    IconsOutlineButton(
                                      onPressed: () {
                                        if (mounted) {
                                          // Navigator.pop(context);
                                          Navigator.of(
                                                  refreshKey.currentContext!)
                                              .pop();
                                        }
                                      },
                                      text: 'Kembali',
                                      iconData: Icons.close,
                                      textStyle:
                                          const TextStyle(color: Colors.grey),
                                      iconColor: Colors.grey,
                                    ),
                                    IconsButton(
                                      onPressed: () async {
                                        publish(databerita[i]["inovasi_id"]);
                                        Navigator.of(refreshKey.currentContext!)
                                            .pop();
                                      },
                                      text: 'Publish',
                                      iconData: Icons.send,
                                      color: Colors.green,
                                      textStyle:
                                          const TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                    ),
                                  ],
                                );
                                // Alert(
                                //   context: context,
                                //   type: AlertType.info,
                                //   title: "Publish? ",
                                //   desc: databerita[i]["inovasi_judul"],
                                //   buttons: [
                                //     DialogButton(
                                //       child: Text(
                                //         "Tidak",
                                //         style: TextStyle(
                                //             color: Colors.white, fontSize: 16),
                                //       ),
                                //       onPressed: () => Navigator.pop(context),
                                //       color: Colors.green,
                                //     ),
                                //     DialogButton(
                                //       child: Text(
                                //         "Publish",
                                //         style: TextStyle(
                                //             color: Colors.white, fontSize: 16),
                                //       ),
                                //       onPressed: () {
                                //         publish(databerita[i]["inovasi_id"]);
                                //         Navigator.pop(context);
                                //       },
                                //       color: Colors.red,
                                //     )
                                //   ],
                                // ).show();
                                print(databerita[i]["inovasi_publis"]);
                              }
                            },
                          ),
                        ],
                      ),
                      // actionExtentRatio: 0.25,
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        extentRatio: 0.25,
                        children: [
                          SlidableAction(
                            label: 'Hapus',
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            onPressed: (context) {
                              // Alert(
                              //   context: context,
                              //   type: AlertType.error,
                              //   title: "Hapus? ",
                              //   desc: databerita[i]["inovasi_judul"],
                              //   buttons: [
                              //     DialogButton(
                              //       child: Text(
                              //         "Tidak",
                              //         style: TextStyle(
                              //             color: Colors.white, fontSize: 16),
                              //       ),
                              //       onPressed: () => Navigator.pop(context),
                              //       color: Colors.green,
                              //     ),
                              //     DialogButton(
                              //       child: Text(
                              //         "Hapus",
                              //         style: TextStyle(
                              //             color: Colors.white, fontSize: 16),
                              //       ),
                              //       onPressed: () {
                              //         hapusberita(databerita[i]["inovasi_id"]);
                              //         Navigator.pop(context);
                              //       },
                              //       color: Colors.red,
                              //     )
                              //   ],
                              // ).show();
                              Dialogs.bottomMaterialDialog(
                                msg: databerita[i]["inovasi_judul"],
                                title: "Hapus Berita?",
                                color: Colors.white,
                                lottieBuilder: Lottie.asset(
                                  'assets/animation/delete.json',
                                  fit: BoxFit.contain,
                                  repeat: true,
                                ),
                                // animation:'assets/logo/animation/exit.json',
                                context: context,
                                actions: [
                                  IconsOutlineButton(
                                    onPressed: () {
                                      if (mounted) {
                                        // Navigator.pop(context);
                                        Navigator.of(refreshKey.currentContext!)
                                            .pop();
                                      }
                                    },
                                    text: 'Batal',
                                    iconData: Icons.cancel_outlined,
                                    textStyle:
                                        const TextStyle(color: Colors.grey),
                                    iconColor: Colors.grey,
                                  ),
                                  IconsButton(
                                    onPressed: () async {
                                      hapusberita(databerita[i]["inovasi_id"]);
                                      Navigator.of(refreshKey.currentContext!)
                                          .pop();
                                    },
                                    text: 'HAPUS',
                                    iconData: Icons.edit,
                                    color: Colors.red,
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                    iconColor: Colors.white,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
