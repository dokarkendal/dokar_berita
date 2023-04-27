//ANCHOR Package berita list
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dokar_aplikasi/berita/edit/hal_berita_edit.dart';
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
// import 'package:shimmer/shimmer.dart';

// import '../../style/size_config.dart';
import '../../style/styleset.dart';

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
  late String _mySelection;
  List beritaAdmin = [];
  late GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
// final SlidableController slidableController = SlidableController();

  ScrollController _scrollController = ScrollController();
  List databerita = [];
  bool isLoading = false;
  final dio = Dio();
  late String dibaca;
  late List dataJSON = [];
  bool _isInAsyncCall = false;

//ANCHOR hapus berita berita list

  void hapusberita(beritaAdmin) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _isInAsyncCall = true;
    });
    final response = await http.post(
      Uri.parse("http://dokar.kendalkab.go.id/webservice/android/kabar/delete"),
      body: {
        "IdBerita": beritaAdmin,
        "IdDesa": pref.getString("IdDesa"),
      },
    );
    var deleted = json.decode(response.body);
    print(deleted);
    if (deleted[0]["Notif"] == "Delete Berhasil") {
      setState(
        () {
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
        },
      );
    }
    Navigator.pushReplacementNamed(context, '/FormBeritaDashbord');
  }

//ANCHOR Unpublish berita list
  void unpublish(beritaAdmin) async {
    setState(() {
      _isInAsyncCall = true;
    });
    final response = await http.post(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/kabar/UnPublish"),
      body: {
        "IdBerita": beritaAdmin,
      },
    );
    var unpublish = json.decode(response.body);
    print(unpublish);
    if (unpublish[0]["Notif"] == "UnPublish Berhasil") {
      setState(
        () {
          _isInAsyncCall = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Berita berhasil di unpublish',
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
    Navigator.pushReplacementNamed(context, '/FormBeritaDashbord');
  }

//ANCHOR Publish berita list
  void publish(beritaAdmin) async {
    setState(() {
      _isInAsyncCall = true;
    });
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/kabar/Publish"),
        body: {
          "IdBerita": beritaAdmin,
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
    Navigator.pushReplacementNamed(context, '/FormBeritaDashbord');
  }

//ANCHOR Cek session berita list
  // ignore: unused_element
  Future _cekSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(
        () {
          username = pref.getString("userAdmin")!;
          status = pref.getString("status")!;
        },
      );
    }
  }

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
          print(pref.getString("IdDesa"));
          print(pref.getString("status"));
          print(pref.getString("IdAdmin"));
        },
      );
      print(nextPage);
      final response = await dio.get(nextPage +
          "/" +
          pref.getString("IdDesa")! +
          "/" +
          pref.getString("status")! +
          "/" +
          pref.getString("IdAdmin")! +
          "/");
      List tempList = [];
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
    print(databerita);
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
    // MediaQueryData mediaQueryData = MediaQuery.of(context);
    // SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: CircularProgressIndicator(),
        ),
      ),
    );
    // return Padding(
    //   padding: EdgeInsets.all(10.0),
    //   child: Shimmer.fromColors(
    //     highlightColor: Colors.white,
    //     baseColor: Colors.grey[300],
    //     child: Container(
    //       child: Column(
    //         children: <Widget>[
    //           // Column(
    //           //   children: <Widget>[
    //           Container(
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(10.0),
    //               color: Colors.grey,
    //             ),
    //             height: mediaQueryData.size.height * 0.12,
    //             width: mediaQueryData.size.width,
    //             // color: Colors.grey,
    //           ),
    //           SizedBox(height: 10),
    //           Container(
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(10.0),
    //               color: Colors.grey,
    //             ),
    //             height: mediaQueryData.size.height * 0.12,
    //             width: mediaQueryData.size.width,
    //             // color: Colors.grey,
    //           ),
    //           SizedBox(height: 10),
    //           Container(
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(10.0),
    //               color: Colors.grey,
    //             ),
    //             height: mediaQueryData.size.height * 0.12,
    //             width: mediaQueryData.size.width,
    //             // color: Colors.grey,
    //           ),
    //           SizedBox(height: 10),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

//ANCHOR halaman berita list
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          'LIST BERITA',
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
            await Future.delayed(
              Duration(seconds: 1),
              () {},
            );
          },
          child: SlidableAutoCloseBehavior(
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: databerita.length + 1,
              // ignore: missing_return
              itemBuilder: (BuildContext context, int i) {
                var status;
                if (i < databerita.length &&
                    databerita[i]["kabar_publis"] == "1") {
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
                  if (databerita[i]["kabar_id"] == "Notfound") {
                  } else {
                    Widget _container() {
                      if (databerita[i]["device"] == '1') {
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
                                    builder: (context) => FormBeritaEdit(
                                      dJudul: databerita[i]["kabar_judul"],
                                      dKategori: databerita[i]
                                          ["kabar_kategori"],
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
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
                                            databerita[i]["kabar_judul"],
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5.0, bottom: 5.0),
                                                child: Text(
                                                  databerita[i]
                                                      ["kabar_tanggal"],
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
                                            status
                                          ],
                                        ),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  databerita[i]
                                                      ["kabar_kategori"],
                                                  style: TextStyle(
                                                    fontSize: 12.0,
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
                                //       "Konten di input melalui Website, Apa anda ingin melanjutkan edit?",
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
                                //             builder: (context) => FormBeritaEdit(
                                //               dJudul: databerita[i]["kabar_judul"],
                                //               dKategori: databerita[i]
                                //                   ["kabar_kategori"],
                                //               dIsi: databerita[i]["kabar_isi"],
                                //               dTanggal: databerita[i]
                                //                   ["kabar_tanggal"],
                                //               dGambar: databerita[i]
                                //                   ["kabar_gambar"],
                                //               dIdBerita: databerita[i]["kabar_id"],
                                //               dVideo: databerita[i]["kabar_video"],
                                //               dKomentar: databerita[i]["komentar"],
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
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FormBeritaEdit(
                                              dJudul: databerita[i]
                                                  ["kabar_judul"],
                                              dKategori: databerita[i]
                                                  ["kabar_kategori"],
                                              dIsi: databerita[i]["kabar_isi"],
                                              dTanggal: databerita[i]
                                                  ["kabar_tanggal"],
                                              dGambar: databerita[i]
                                                  ["kabar_gambar"],
                                              dIdBerita: databerita[i]
                                                  ["kabar_id"],
                                              dVideo: databerita[i]
                                                  ["kabar_video"],
                                              dKomentar: databerita[i]
                                                  ["komentar"],
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
                                            databerita[i]["kabar_judul"],
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5.0, bottom: 5.0),
                                                child: Text(
                                                  databerita[i]
                                                      ["kabar_tanggal"],
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
                                            status
                                          ],
                                        ),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  databerita[i]
                                                      ["kabar_kategori"],
                                                  style: TextStyle(
                                                    fontSize: 12.0,
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
                        key: ValueKey(0),

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
                                if (databerita[i]["kabar_publis"] == '0') {
                                  // Alert(
                                  //   context: context,
                                  //   type: AlertType.error,
                                  //   title: "Unpublish",
                                  //   desc: "Berita Sudah di Unpublish.",
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
                                    msg: 'Berita anda sudah UnPublish',
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
                                  //   desc: databerita[i]["kabar_judul"],
                                  //   buttons: [
                                  //     DialogButton(
                                  //       child: Text(
                                  //         "Tidak",
                                  //         style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 16),
                                  //       ),
                                  //       onPressed: () => Navigator.pop(context),
                                  //       color: Colors.red,
                                  //     ),
                                  //     DialogButton(
                                  //       child: Text(
                                  //         "Unpublish",
                                  //         style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 16),
                                  //       ),
                                  //       onPressed: () {
                                  //         unpublish(databerita[i]["kabar_id"]);
                                  //         Navigator.pop(context);
                                  //       },
                                  //       color: Colors.orange,
                                  //     )
                                  //   ],
                                  // ).show();
                                  Dialogs.bottomMaterialDialog(
                                    msg:
                                        'Apakah anda yakin ingin unpublish berita ini? ',
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
                                          unpublish(databerita[i]["kabar_id"]);
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
                                print(databerita[i]["kabar_id"]);
                              },
                            ),
                            SlidableAction(
                              label: 'Publish',
                              backgroundColor: Colors.green,
                              icon: Icons.redo,
                              onPressed: (context) {
                                if (databerita[i]["kabar_publis"] == '1') {
                                  // Alert(
                                  //   context: context,
                                  //   type: AlertType.warning,
                                  //   title: "Publish",
                                  //   desc: "Berita Sudah di Publish.",
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
                                    msg:
                                        'Berita anda sudah terpublish ke publk',
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
                                  print(databerita[i]["kabar_publis"]);
                                } else {
                                  // Alert(
                                  //   context: context,
                                  //   type: AlertType.info,
                                  //   title: "Publish?",
                                  //   desc: databerita[i]["kabar_judul"],
                                  //   buttons: [
                                  //     DialogButton(
                                  //       child: Text(
                                  //         "Tidak",
                                  //         style: TextStyle(
                                  //             color: Colors.white, fontSize: 16),
                                  //       ),
                                  //       onPressed: () => Navigator.pop(context),
                                  //       color: Colors.red,
                                  //     ),
                                  //     DialogButton(
                                  //       child: Text(
                                  //         "Publish",
                                  //         style: TextStyle(
                                  //             color: Colors.white, fontSize: 16),
                                  //       ),
                                  //       onPressed: () {
                                  //         publish(databerita[i]["kabar_id"]);
                                  //         Navigator.pop(context);
                                  //       },
                                  //       color: Colors.green,
                                  //     )
                                  //   ],
                                  // ).show();
                                  Dialogs.materialDialog(
                                    msg: databerita[i]["kabar_judul"],
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
                                          publish(databerita[i]["kabar_id"]);
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
                                  print(databerita[i]["kabar_publis"]);
                                }
                              },
                            ),
                          ],

                          // secondaryActions: <Widget>[
                          //   IconSlideAction(
                          //     caption: 'Hapus',
                          //     color: Colors.red,
                          //     icon: Icons.delete,
                          //     onTap: () {
                          //       //popup
                          //       Alert(
                          //         context: context,
                          //         type: AlertType.error,
                          //         title: "Hapus? ",
                          //         desc: databerita[i]["kabar_judul"],
                          //         buttons: [
                          //           DialogButton(
                          //             child: Text(
                          //               "Tidak",
                          //               style: TextStyle(
                          //                   color: Colors.white, fontSize: 16),
                          //             ),
                          //             onPressed: () => Navigator.pop(context),
                          //             color: Colors.green,
                          //           ),
                          //           DialogButton(
                          //             child: Text(
                          //               "Hapus",
                          //               style: TextStyle(
                          //                   color: Colors.white, fontSize: 16),
                          //             ),
                          //             onPressed: () {
                          //               hapusberita(databerita[i]["kabar_id"]);
                          //               Navigator.pop(context);
                          //             },
                          //             color: Colors.red,
                          //           )
                          //         ],
                          //       ).show();
                          //     },
                          //   ),
                          // ],
                        ),
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
                                    msg: databerita[i]["kabar_judul"],
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
                                              databerita[i]["kabar_id"]);
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
                                  //popup
                                  // Alert(
                                  //   context: context,
                                  //   type: AlertType.error,
                                  //   title: "Hapus? ",
                                  //   desc: databerita[i]["kabar_judul"],
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
                                  //         hapusberita(databerita[i]["kabar_id"]);
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
