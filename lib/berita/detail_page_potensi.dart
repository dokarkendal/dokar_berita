import 'package:cached_network_image/cached_network_image.dart';
import 'package:dokar_aplikasi/akun/hal_profil_desa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html/style.dart';
import 'dart:convert';
// import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:share/share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class DetailPotensi extends StatefulWidget {
  final String dGambar,
      dJudul,
      dBaca,
      dAdmin,
      dTanggal,
      dHtml,
      dTempat,
      dUrl,
      dVideo,
      dId,
      dIdDesa,
      dDesa,
      dKecamatan,
      dKategori;

  DetailPotensi(
      {required this.dGambar,
      required this.dTempat,
      required this.dBaca,
      required this.dAdmin,
      required this.dTanggal,
      required this.dJudul,
      required this.dHtml,
      required this.dUrl,
      required this.dVideo,
      required this.dId,
      required this.dIdDesa,
      required this.dDesa,
      required this.dKecamatan,
      required this.dKategori});

  @override
  _DetailPotensiState createState() => _DetailPotensiState();
}

class _DetailPotensiState extends State<DetailPotensi> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late YoutubePlayerController youTube;
  String dibaca = '';

  Future<void> addViews() async {
    //SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/kabar/viewest"),
        body: {
          "IdDesa": "${widget.dIdDesa}",
          "Kategori": "${widget.dKategori}",
          "IdBerita": "${widget.dId}"
        });
    var kategori = json.decode(response.body);
    if (mounted) {
      setState(
        () {
          print(kategori);
          //print("${widget.dIdDesa}");
        },
      );
    }
  }

  late String? videoId;
  @override
  void initState() {
    videoId = YoutubePlayer.convertUrlToId(widget.dVideo);
    if (videoId != null) {
      youTube = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: YoutubePlayerFlags(
          mute: false,
          autoPlay: false,
        ),
      );
    }

    // youTube = YoutubePlayerController(
    //   initialVideoId: "${widget.dVideo}",
    //   flags: YoutubePlayerFlags(
    //     mute: false,
    //     autoPlay: false,
    //   ),
    // );
    super.initState();

    setState(
      () {
        if ('${widget.dBaca}' == 'null') {
          dibaca = '0';
        } else {
          dibaca = '${widget.dBaca}';
        }
      },
    );

    this.addViews();
  }

  // Widget _playYoutube(youTube) {
  //   String vid = "${widget.dVideo}";
  //   int panjang = vid.length;
  //   if ("${widget.dVideo}" == null) {
  //     return new Center(
  //       child: Chip(
  //         backgroundColor: Colors.red[400],
  //         avatar: CircleAvatar(
  //           backgroundColor: Colors.white,
  //           child: Icon(Icons.videocam_off, size: 16, color: Colors.black45),
  //         ),
  //         label: Text(
  //           'Tidak ada embed video',
  //           style: new TextStyle(
  //             color: Colors.white,
  //             fontSize: 14.0,
  //           ),
  //         ),
  //       ),
  //     );
  //   } else {
  //     if (panjang >= 12) {
  //       return new Center(
  //         child: Chip(
  //           backgroundColor: Colors.red[400],
  //           avatar: CircleAvatar(
  //             backgroundColor: Colors.white,
  //             child: Icon(Icons.videocam_off, size: 16, color: Colors.black45),
  //           ),
  //           label: Text(
  //             'Embed video hanya dari youtube',
  //             style: new TextStyle(
  //               color: Colors.white,
  //               fontSize: 14.0,
  //             ),
  //           ),
  //         ),
  //       );
  //     } else if (panjang == 0) {
  //       return new Center(
  //         child: Chip(
  //           backgroundColor: Colors.red[400],
  //           avatar: CircleAvatar(
  //             backgroundColor: Colors.white,
  //             child: Icon(Icons.videocam_off, size: 16, color: Colors.black45),
  //           ),
  //           label: Text(
  //             'Tidak ada embed video',
  //             style: new TextStyle(
  //               color: Colors.white,
  //               fontSize: 14.0,
  //             ),
  //           ),
  //         ),
  //       );
  //     } else {
  //       return new YoutubePlayer(
  //         controller: youTube,
  //         showVideoProgressIndicator: true,
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.brown[800], //change your color here
        ),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'KEGIATAN',
          style: TextStyle(
            color: Colors.brown[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    wHeader(),
                    Container(
                      padding: new EdgeInsets.only(
                        left: mediaQueryData.size.height * 0.01,
                        top: mediaQueryData.size.height * 0.3,
                        // bottom: mediaQueryData.size.height * 0.01,
                        right: mediaQueryData.size.height * 0.01,
                      ),
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  datadesa(),
                                  jam(),
                                ],
                              ),
                              judul(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  admin(),
                                  share(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //     top: 190.0,
                    //     right: 10.0,
                    //     left: 10.0,
                    //   ),
                    //   child: Card(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: Container(
                    //       padding: new EdgeInsets.all(15.0),
                    //       child: IntrinsicHeight(
                    //         child: Column(
                    //           children: <Widget>[
                    //             Expanded(
                    //               child: new Column(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: <Widget>[
                    //                   new Container(
                    //                     child: new Text(
                    //                       '${widget.dJudul}',
                    //                       style: new TextStyle(
                    //                         fontSize: 18.0,
                    //                         fontWeight: FontWeight.bold,
                    //                       ),
                    //                       maxLines: 3,
                    //                       overflow: TextOverflow.ellipsis,
                    //                     ),
                    //                   ),
                    //                   new Row(
                    //                     children: <Widget>[
                    //                       Chip(
                    //                         backgroundColor: Colors.green,
                    //                         label: Text(
                    //                           '${widget.dDesa}',
                    //                           style: new TextStyle(
                    //                             color: Colors.white,
                    //                             fontSize: 12.0,
                    //                           ),
                    //                         ),
                    //                       ),
                    //                       SizedBox(width: 5.0),
                    //                       Chip(
                    //                         backgroundColor: Colors.green,
                    //                         label: Text(
                    //                           '${widget.dKecamatan}',
                    //                           style: new TextStyle(
                    //                             color: Colors.white,
                    //                             fontSize: 12.0,
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                   new Container(
                    //                     child: new Text(
                    //                       '${widget.dTempat}',
                    //                       style: new TextStyle(
                    //                         fontSize: 12.0,
                    //                         color: Colors.grey[500],
                    //                       ),
                    //                       maxLines: 3,
                    //                       overflow: TextOverflow.ellipsis,
                    //                     ),
                    //                   ),
                    //                   SizedBox(height: 5.0),
                    //                   new Container(
                    //                     child: new Row(
                    //                       children: <Widget>[
                    //                         new Text(
                    //                           '${widget.dKategori}',
                    //                           maxLines: 3,
                    //                           style: new TextStyle(
                    //                             color: Colors.grey[500],
                    //                             fontSize: 12.0,
                    //                           ),
                    //                         ),
                    //                         SizedBox(width: 10.0),
                    //                         new Text(
                    //                           '${widget.dTanggal}',
                    //                           maxLines: 3,
                    //                           style: new TextStyle(
                    //                             color: Colors.grey[500],
                    //                             fontSize: 12.0,
                    //                           ),
                    //                         ),
                    //                         SizedBox(width: 10.0),
                    //                         Icon(
                    //                           Icons.remove_red_eye,
                    //                           size: 12,
                    //                           color: Colors.grey[500],
                    //                         ),
                    //                         new Text(
                    //                           dibaca,
                    //                           maxLines: 3,
                    //                           style: new TextStyle(
                    //                             color: Colors.grey[500],
                    //                             fontSize: 12.0,
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: mediaQueryData.size.height * 0.01,
                    // top: mediaQueryData.size.height * 0.01,
                    // bottom: mediaQueryData.size.height * 0.01,
                    right: mediaQueryData.size.height * 0.01,
                  ),
                  child: Column(
                    children: <Widget>[
                      Html(
                        style: {
                          // "p": Style(
                          //   padding: EdgeInsets.all(5.0),
                          // )
                        },
                        // padding: new EdgeInsets.all(10.0),
                        data: '${widget.dHtml}',
                        // onLaunchFail: (url) {
                        //   // optional, type Function
                        //   print("launch $url failed");
                        // },
                        // scrollable: false,
                      ),
                      //Divider(),
                      // _playYoutube(youTube),
                      videoId == null
                          ? Center(
                              child: Chip(
                                backgroundColor: Colors.red[400],
                                avatar: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.videocam_off,
                                      size: 16, color: Colors.black45),
                                ),
                                label: Text(
                                  'Tidak ada video',
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            )
                          : YoutubePlayer(
                              controller: youTube,
                              showVideoProgressIndicator: true,
                              onReady: () {
                                // Perform any actions after the video player is ready
                              },
                            ),

                      SizedBox(
                        height: 20,
                      ),
                      // wShare(),
                    ],
                  ),
                ),
                // _html(),
                // _playYoutube(youTube),
                // SizedBox(
                //   height: 40,
                // ),
                // wShare(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget jam() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: new EdgeInsets.only(
        // left: mediaQueryData.size.height * 0.02,
        // top: mediaQueryData.size.height * 0.01,
        // bottom: mediaQueryData.size.height * 0.01,
        right: mediaQueryData.size.height * 0.02,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10.0),
          Icon(
            Icons.menu_book_rounded,
            size: 14,
            color: Colors.grey[500],
          ),
          new Padding(
            padding:
                new EdgeInsets.only(right: mediaQueryData.size.height * 0.01),
          ),
          Text(
            '${widget.dKategori}',
            maxLines: 3,
            style: new TextStyle(
              color: Colors.grey[500],
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget share() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: new EdgeInsets.only(
        left: mediaQueryData.size.height * 0.02,
        // top: mediaQueryData.size.height * 0.01,
        // bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Row(
        children: [
          Icon(
            Icons.remove_red_eye,
            size: 12,
            color: Colors.grey[500],
          ),
          new Padding(
            padding:
                new EdgeInsets.only(right: mediaQueryData.size.height * 0.01),
          ),
          Text(
            '${widget.dBaca}',
            maxLines: 3,
            style: new TextStyle(
              color: Colors.grey[500],
              fontSize: 12.0,
            ),
          ),
          // new Padding(
          //   padding:
          //       new EdgeInsets.only(right: mediaQueryData.size.height * 0.01),
          // ),
          IconButton(
            // padding: EdgeInsets.all(15.0),
            icon: Icon(Icons.share),
            color: Colors.blue[800],
            iconSize: 18.0,
            onPressed: () {
              Share.share("${widget.dUrl}");
            },
          ),
          new Padding(
            padding:
                new EdgeInsets.only(right: mediaQueryData.size.height * 0.01),
          ),
          // Text(
          //   '${widget.dTanggal}',
          //   maxLines: 3,
          //   style: new TextStyle(
          //     color: Colors.grey[500],
          //     fontSize: 14.0,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget admin() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: new EdgeInsets.only(
        left: mediaQueryData.size.height * 0.02,
        // top: mediaQueryData.size.height * 0.01,
        // bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Row(
        children: [
          Icon(
            Icons.person,
            size: 12,
            color: Colors.grey[500],
          ),
          new Padding(
            padding:
                new EdgeInsets.only(right: mediaQueryData.size.height * 0.01),
          ),
          Text(
            '${widget.dAdmin}',
            maxLines: 3,
            style: new TextStyle(
              color: Colors.grey[500],
              fontSize: 12.0,
            ),
          ),
          new Padding(
            padding:
                new EdgeInsets.only(right: mediaQueryData.size.height * 0.01),
          ),
          Icon(
            Icons.date_range_rounded,
            size: 12,
            color: Colors.grey[500],
          ),
          new Padding(
            padding:
                new EdgeInsets.only(right: mediaQueryData.size.height * 0.01),
          ),
          Text(
            '${widget.dTanggal}',
            maxLines: 3,
            style: new TextStyle(
              color: Colors.grey[500],
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget judul() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: new EdgeInsets.only(
        left: mediaQueryData.size.height * 0.02,
        // top: mediaQueryData.size.height * 0.01,
        // bottom: mediaQueryData.size.height * 0.01,
        right: mediaQueryData.size.height * 0.02,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.dJudul}',
            style: new TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget datadesa() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: new EdgeInsets.only(
        left: mediaQueryData.size.height * 0.02,
        top: mediaQueryData.size.height * 0.01,
        // bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Row(
        children: [
          GestureDetector(
            child: Chip(
              backgroundColor: Colors.blue[800],
              label: Text(
                '${widget.dDesa}',
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilDesa(
                    id: "${widget.dIdDesa}",
                    desa: "${widget.dDesa}",
                    kecamatan: "${widget.dKecamatan}",
                    title: '',
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 5.0),
          Chip(
            backgroundColor: Colors.blue[800],
            label: Text(
              '${widget.dKecamatan}',
              style: new TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget wShare() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // padding: EdgeInsets.all(15.0),
                elevation: 0, backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // <-- Radius
                ),
              ),
              // color: Colors.grey,
              // textColor: Colors.white,
              // shape: RoundedRectangleBorder(
              //   borderRadius: new BorderRadius.circular(20.0),
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.contact_mail,
                    size: 20,
                    color: Colors.white,
                  ),
                  Text(
                    "  " + "Saran",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Fitur belum tersedia',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.black,
                  action: SnackBarAction(
                    label: 'ULANGI',
                    textColor: Colors.white,
                    onPressed: () {
                      print('ULANGI snackbar');
                    },
                  ),
                ));
                // scaffoldKey.currentState.showSnackBar(snackBar);
              },
            ),
          ],
        ),
        Column(
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // padding: EdgeInsets.all(15.0),
                elevation: 0, backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // <-- Radius
                ),
              ),
              // color: Colors.grey,
              // textColor: Colors.white,
              // shape: RoundedRectangleBorder(
              //   borderRadius: new BorderRadius.circular(20.0),
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.message,
                    size: 20,
                    color: Colors.white,
                  ),
                  Text(
                    "  " + "Komentar",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Fitur belum tersedia',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.black,
                  action: SnackBarAction(
                    label: 'ULANGI',
                    textColor: Colors.white,
                    onPressed: () {
                      print('ULANGI snackbar');
                    },
                  ),
                ));
                // scaffoldKey.currentState.showSnackBar(snackBar);
              },
            ),
          ],
        ),
        Column(
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // padding: EdgeInsets.all(15.0),
                elevation: 0, backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // <-- Radius
                ),
              ),
              // color: Colors.blue,
              // textColor: Colors.white,
              // shape: RoundedRectangleBorder(
              //   borderRadius: new BorderRadius.circular(20.0),
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.share,
                    size: 20,
                    color: Colors.white,
                  ),
                  Text(
                    "  " + "Share",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Share.share("${widget.dUrl}");
              },
            ),
          ],
        ),
      ],
    );
  }

  // Widget _html() {
  //   return Padding(
  //     padding: EdgeInsets.all(10.0),
  //     child: Column(
  //       children: <Widget>[
  //         Html(
  //           style: {
  //             "p": Style(
  //               padding: EdgeInsets.all(10.0),
  //             )
  //           },
  //           // padding: new EdgeInsets.all(10.0),
  //           data: '${widget.dHtml}',
  //           // onLaunchFail: (url) {
  //           //   // optional, type Function
  //           //   print("launch $url failed");
  //           // },
  //           // scrollable: false,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget wHeader() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return ClipPath(
      // clipper: ArcClipper(),
      child: CachedNetworkImage(
        imageUrl: '${widget.dGambar}',
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
        // height: mediaQueryData.size.height * 0.3,
        fit: BoxFit.cover,
      ),
      // child: Image.network(
      //   '${widget.dGambar}',
      //   width: screenWidth,
      //   height: 230.0,
      //   fit: BoxFit.cover,
      // ),
    );
  }

// class ArcClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.lineTo(0.0, size.height - 20);

//     var firstControlPoint = Offset(size.width / 4, size.height);
//     var firstPoint = Offset(size.width / 2, size.height);
//     path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
//         firstPoint.dx, firstPoint.dy);

//     var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
//     var secondPoint = Offset(size.width, size.height - 20);
//     path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
//         secondPoint.dx, secondPoint.dy);

//     path.lineTo(size.width, 0.0);
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
