//ANCHOR package bumdes list
import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dokar_aplikasi/berita/edit/hal_bumdes_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
  List bumdesAdmin = [];
  late GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  // final SlidableController slidableController = SlidableController();
  bool _isInAsyncCall = false;

//ANCHOR fungsi hapus berita bumdes list
  void hapusberita(bumdesAdmin) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _isInAsyncCall = true;
    });
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/bumdes/delete"),
        body: {
          "IdBumdes": bumdesAdmin,
          "IdDesa": pref.getString("IdDesa"),
        });
    var deleted = json.decode(response.body);
    print(deleted);
    if (deleted[0]["Notif"] == "Delete Berhasil") {
      setState(() {
        _isInAsyncCall = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Bumdes berhasil di hapus',
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
    Navigator.pushReplacementNamed(context, '/HalBumdesList');
  }

//ANCHOR fungsi unpublish berita bumdes list
  void unpublish(bumdesAdmin) async {
    setState(() {
      _isInAsyncCall = true;
    });
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/bumdes/UnPublish"),
        body: {
          "IdBumdes": bumdesAdmin,
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
                'Bumdes berhasil di unpublish',
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
    Navigator.pushReplacementNamed(context, '/HalBumdesList');
  }

//ANCHOR fungsi publish berita bumdes list
  void publish(bumdesAdmin) async {
    setState(() {
      _isInAsyncCall = true;
    });
    final response = await http.post(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/bumdes/Publish"),
      body: {
        "IdBumdes": bumdesAdmin,
      },
    );
    var publish = json.decode(response.body);
    print(publish);
    if (publish[0]["Notif"] == "Publish Berhasil") {
      setState(
        () {
          _isInAsyncCall = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Bumdes berhasil di publish',
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
    Navigator.pushReplacementNamed(context, '/HalBumdesList');
  }

//ANCHOR fungsi session berita bumdes list
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

//ANCHOR fungsi load berita bumdes list
  List databerita = [];
  bool isLoading = false;
  final dio = Dio();
  List tempList = [];
  ScrollController _scrollController = ScrollController();
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

      final response =
          await dio.get(nextPage + pref.getString("IdDesa")! + "/");

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
          'LIST BUMDES',
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
                    databerita[i]["bumdes_publis"] == "1") {
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
                  if (databerita[i]["bumdes_id"] == "Notfound") {
                    // return  Container(
                    //   child: Center(
                    //     child:  Column(
                    //       children: <Widget>[
                    //          Padding(
                    //           padding:  EdgeInsets.all(100.0),
                    //         ),
                    //          Text(
                    //           "DATA KOSONG",
                    //           style:  TextStyle(
                    //             fontSize: 30.0,
                    //             color: Colors.grey[350],
                    //             // fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //          Padding(
                    //           padding:  EdgeInsets.all(10.0),
                    //         ),
                    //          Icon(
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
                        //             builder: (context) =>  FormBumdesEdit(
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
                        //               image:  NetworkImage(
                        //                   databerita[i]["bumdes_gambar"]),
                        //               fit: BoxFit.cover,
                        //               height: 150.0,
                        //               width: 110.0,
                        //             ),
                        //           ),
                        //         ),
                        //         subtitle: Row(
                        //           children: <Widget>[
                        //              Text(
                        //               databerita[i]["bumdes_tempat"],
                        //             ),
                        //           ],
                        //         ),
                        //         title:  Text(
                        //           databerita[i]["bumdes_judul"],
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
                                    builder: (context) => FormBumdesEdit(
                                      dJudul: databerita[i]["bumdes_judul"],
                                      dKatTempat: databerita[i]
                                          ["bumdes_tempat"],
                                      dIsi: databerita[i]["bumdes_isi"],
                                      dGambar: databerita[i]["bumdes_gambar"],
                                      dIdBumdes: databerita[i]["bumdes_id"],
                                      dVideo: databerita[i]["bumdes_video"],
                                      dTanggal: '',
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
                                    height: 101.0,
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
                                            databerita[i]["bumdes_judul"],
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
                                                      ["bumdes_tempat"],
                                                  style: TextStyle(
                                                    fontSize: 13.0,
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
                                            status,
                                          ],
                                        ),
                                        //  Container(
                                        //   child:  Column(
                                        //     children: <Widget>[
                                        //        Container(
                                        //         child:  Text(
                                        //           databerita[i]["kabar_kategori"],
                                        //           style:  TextStyle(
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
                        //                          FormBumdesEdit(
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
                        //               image:  NetworkImage(
                        //                   databerita[i]["bumdes_gambar"]),
                        //               fit: BoxFit.cover,
                        //               height: 150.0,
                        //               width: 110.0,
                        //             ),
                        //           ),
                        //         ),
                        //         subtitle: Row(
                        //           children: <Widget>[
                        //              Text(
                        //               databerita[i]["bumdes_tempat"],
                        //             ),
                        //           ],
                        //         ),
                        //         title:  Text(
                        //           databerita[i]["bumdes_judul"],
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
                                //                 FormBumdesEdit(
                                //               dJudul: databerita[i]
                                //                   ["bumdes_judul"],
                                //               dKatTempat: databerita[i]
                                //                   ["bumdes_tempat"],
                                //               dIsi: databerita[i]["bumdes_isi"],
                                //               dGambar: databerita[i]
                                //                   ["bumdes_gambar"],
                                //               dIdBumdes: databerita[i]
                                //                   ["bumdes_id"],
                                //               dVideo: databerita[i]
                                //                   ["bumdes_video"],
                                //               dTanggal: '',
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
                                      'Konten ini di input lewat website, apakah akan lanjut mengedit? ',
                                  title: "EDIT BERITA",
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
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FormBumdesEdit(
                                              dJudul: databerita[i]
                                                  ["bumdes_judul"],
                                              dKatTempat: databerita[i]
                                                  ["bumdes_tempat"],
                                              dIsi: databerita[i]["bumdes_isi"],
                                              dGambar: databerita[i]
                                                  ["bumdes_gambar"],
                                              dIdBumdes: databerita[i]
                                                  ["bumdes_id"],
                                              dVideo: databerita[i]
                                                  ["bumdes_video"],
                                              dTanggal: '',
                                            ),
                                          ),
                                        );
                                      },
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
                                            databerita[i]["bumdes_judul"],
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
                                                      ["bumdes_tempat"],
                                                  style: TextStyle(
                                                    fontSize: 13.0,
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
                                                size: 14.0,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            status,
                                          ],
                                        ),
                                        //  Container(
                                        //   child:  Column(
                                        //     children: <Widget>[
                                        //        Container(
                                        //         child:  Text(
                                        //           databerita[i]["kabar_kategori"],
                                        //           style:  TextStyle(
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
                                  if (databerita[i]["bumdes_publis"] == '0') {
                                    // Alert(
                                    //   context: context,
                                    //   type: AlertType.error,
                                    //   title: "Unpublish",
                                    //   desc: "Berita Sudah di Unpublish",
                                    //   buttons: [
                                    //     DialogButton(
                                    //       child: Text(
                                    //         "Ok",
                                    //         style: TextStyle(
                                    //             color: Colors.white,
                                    //             fontSize: 20),
                                    //       ),
                                    //       onPressed: () => Navigator.pop(context),
                                    //       width: 120,
                                    //     )
                                    //   ],
                                    // ).show();
                                    Dialogs.materialDialog(
                                      msg: 'Bumdes anda sudah UnPublish',
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
                                            Navigator.of(
                                                    refreshKey.currentContext!)
                                                .pop();
                                          },
                                          text: 'Baik',
                                          iconData: Icons.check,
                                          color: Colors.blue,
                                          textStyle: const TextStyle(
                                              color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ],
                                    );
                                  } else {
                                    // Alert(
                                    //   context: context,
                                    //   type: AlertType.info,
                                    //   title: "Unpublish? ",
                                    //   desc: databerita[i]["bumdes_judul"],
                                    //   buttons: [
                                    //     DialogButton(
                                    //       child: Text(
                                    //         "Tidak",
                                    //         style: TextStyle(
                                    //             color: Colors.white,
                                    //             fontSize: 16),
                                    //       ),
                                    //       onPressed: () => Navigator.pop(context),
                                    //       color: Colors.green,
                                    //     ),
                                    //     DialogButton(
                                    //       child: Text(
                                    //         "Unpublish",
                                    //         style: TextStyle(
                                    //             color: Colors.white,
                                    //             fontSize: 16),
                                    //       ),
                                    //       onPressed: () {
                                    //         unpublish(databerita[i]["bumdes_id"]);
                                    //         Navigator.pop(context);
                                    //       },
                                    //       color: Colors.orange,
                                    //     )
                                    //   ],
                                    // ).show();
                                    Dialogs.bottomMaterialDialog(
                                      msg: databerita[i]["bumdes_judul"],
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
                                              Navigator.of(refreshKey
                                                      .currentContext!)
                                                  .pop();
                                            }
                                          },
                                          text: 'Batal',
                                          iconData: Icons.cancel_outlined,
                                          textStyle: const TextStyle(
                                              color: Colors.grey),
                                          iconColor: Colors.grey,
                                        ),
                                        IconsButton(
                                          onPressed: () async {
                                            unpublish(
                                                databerita[i]["bumdes_id"]);
                                            Navigator.of(
                                                    refreshKey.currentContext!)
                                                .pop();
                                          },
                                          text: 'Unpublish',
                                          iconData: Icons.undo,
                                          color: Colors.red,
                                          textStyle: const TextStyle(
                                              color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ],
                                    );
                                  }
                                  print(databerita[i]["bumdes_id"]);
                                },
                              ),
                              SlidableAction(
                                label: 'Publish',
                                backgroundColor: Colors.green,
                                icon: Icons.redo,
                                onPressed: (context) {
                                  if (databerita[i]["bumdes_publis"] == '1') {
                                    // Alert(
                                    //   context: context,
                                    //   type: AlertType.warning,
                                    //   title: "Publish",
                                    //   desc: "Bumdes Sudah di Publish.",
                                    //   buttons: [
                                    //     DialogButton(
                                    //       child: Text(
                                    //         "OK",
                                    //         style: TextStyle(
                                    //             color: Colors.white,
                                    //             fontSize: 20),
                                    //       ),
                                    //       onPressed: () => Navigator.pop(context),
                                    //       width: 120,
                                    //     )
                                    //   ],
                                    // ).show();
                                    Dialogs.materialDialog(
                                      msg:
                                          'Bumdes anda sudah terpublish ke publk',
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
                                            Navigator.of(
                                                    refreshKey.currentContext!)
                                                .pop();
                                          },
                                          text: 'Baik',
                                          iconData: Icons.check,
                                          color: Colors.blue,
                                          textStyle: const TextStyle(
                                              color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ],
                                    );
                                    print(databerita[i]["bumdes_publis"]);
                                  } else {
                                    // Alert(
                                    //   context: context,
                                    //   type: AlertType.info,
                                    //   title: "Publish? ",
                                    //   desc: databerita[i]["bumdes_judul"],
                                    //   buttons: [
                                    //     DialogButton(
                                    //       child: Text(
                                    //         "Tidak",
                                    //         style: TextStyle(
                                    //             color: Colors.white,
                                    //             fontSize: 16),
                                    //       ),
                                    //       onPressed: () => Navigator.pop(context),
                                    //       color: Colors.green,
                                    //     ),
                                    //     DialogButton(
                                    //       child: Text(
                                    //         "Publish",
                                    //         style: TextStyle(
                                    //             color: Colors.white,
                                    //             fontSize: 16),
                                    //       ),
                                    //       onPressed: () {
                                    //         publish(databerita[i]["bumdes_id"]);
                                    //         Navigator.pop(context);
                                    //       },
                                    //       color: Colors.red,
                                    //     )
                                    //   ],
                                    // ).show();
                                    Dialogs.materialDialog(
                                      msg: databerita[i]["bumdes_judul"],
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
                                              Navigator.of(refreshKey
                                                      .currentContext!)
                                                  .pop();
                                            }
                                          },
                                          text: 'Kembali',
                                          iconData: Icons.close,
                                          textStyle: const TextStyle(
                                              color: Colors.grey),
                                          iconColor: Colors.grey,
                                        ),
                                        IconsButton(
                                          onPressed: () async {
                                            publish(databerita[i]["bumdes_id"]);
                                            Navigator.of(
                                                    refreshKey.currentContext!)
                                                .pop();
                                          },
                                          text: 'Publish',
                                          iconData: Icons.send,
                                          color: Colors.green,
                                          textStyle: const TextStyle(
                                              color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ],
                                    );
                                    print(databerita[i]["bumdes_publis"]);
                                  }
                                },
                              ),
                            ]),
                        endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.25,
                            children: [
                              SlidableAction(
                                label: 'Hapus',
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                onPressed: (context) {
                                  Dialogs.bottomMaterialDialog(
                                    msg: databerita[i]["bumdes_judul"],
                                    title: "Hapus Bumdes?",
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
                                          hapusberita(
                                              databerita[i]["bumdes_id"]);
                                          Navigator.of(
                                                  refreshKey.currentContext!)
                                              .pop();
                                        },
                                        text: 'HAPUS',
                                        iconData: Icons.edit,
                                        color: Colors.red,
                                        textStyle: const TextStyle(
                                            color: Colors.white),
                                        iconColor: Colors.white,
                                      ),
                                    ],
                                  );
                                  // Alert(
                                  //   context: context,
                                  //   type: AlertType.error,
                                  //   title: "Hapus? ",
                                  //   desc: databerita[i]["bumdes_judul"],
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
                                  //         hapusberita(databerita[i]["bumdes_id"]);
                                  //         Navigator.pop(context);
                                  //       },
                                  //       color: Colors.red,
                                  //     )
                                  //   ],
                                  // ).show();
                                },
                              ),
                            ]));
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
