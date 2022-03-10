//ANCHOR package detail agenda
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dokar_aplikasi/akun/hal_profil_desa.dart';
// import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html/style.dart';
import 'package:share/share.dart';

//ANCHOR class
class AgendaDetail extends StatefulWidget {
  final String idDesa,
      judulEvent,
      desaEvent,
      kecamatanEvent,
      uraianEvent,
      mulaiEvent,
      selesaiEvent,
      gambarEvent,
      tglmulaiEvent,
      tglselesaiEvent,
      penyelenggaraEvent,
      urlEvent;
  AgendaDetail(
      {this.idDesa,
      this.judulEvent,
      this.desaEvent,
      this.kecamatanEvent,
      this.uraianEvent,
      this.mulaiEvent,
      this.selesaiEvent,
      this.gambarEvent,
      this.tglmulaiEvent,
      this.tglselesaiEvent,
      this.urlEvent,
      this.penyelenggaraEvent});

  @override
  _AgendaDetailState createState() => _AgendaDetailState();
}

//ANCHOR body
class _AgendaDetailState extends State<AgendaDetail> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('AGENDA'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    wHeader(),
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
                    //             _card(),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
                                  share(),
                                  // jam(),
                                ],
                              ),
                              judul(),
                              alamat(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // admin(),
                                  // share(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                        data: '${widget.uraianEvent}',
                        // onLaunchFail: (url) {
                        //   // optional, type Function
                        //   print("launch $url failed");
                        // },
                        // scrollable: false,
                      ),
                      // Divider(),
                      // _playYoutube(youTube),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // wShare(),
                    ],
                  ),
                ),
                // _html(),
                _jam(),
                // wShare(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget share() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    // if ('${widget.dBaca}' == null) {
    //   dibaca = '0';
    // } else {
    //   dibaca = '${widget.dBaca}';
    // }
    return Container(
      padding: new EdgeInsets.only(
        left: mediaQueryData.size.height * 0.02,
        // top: mediaQueryData.size.height * 0.01,
        // bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Row(
        children: [
          // Icon(
          //   Icons.remove_red_eye,
          //   size: 14,
          //   color: Colors.grey[500],
          // ),
          // new Padding(
          //   padding:
          //       new EdgeInsets.only(right: mediaQueryData.size.height * 0.01),
          // ),
          // Text(
          //   '${widget.dBaca}',
          //   maxLines: 3,
          //   style: new TextStyle(
          //     color: Colors.grey[500],
          //     fontSize: 14.0,
          //   ),
          // ),
          // new Padding(
          //   padding:
          //       new EdgeInsets.only(right: mediaQueryData.size.height * 0.01),
          // ),
          IconButton(
            // padding: EdgeInsets.all(15.0),
            icon: Icon(Icons.share),
            color: Colors.blue[800],
            iconSize: 20.0,
            onPressed: () {
              Share.share("${widget.urlEvent}");
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
            '${widget.judulEvent}',
            style: new TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget alamat() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: new EdgeInsets.only(
        left: mediaQueryData.size.height * 0.01,
        top: mediaQueryData.size.height * 0.01,
        bottom: mediaQueryData.size.height * 0.02,
        right: mediaQueryData.size.height * 0.02,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 10.0),
          Icon(
            Icons.location_on,
            size: 14,
            color: Colors.grey[500],
          ),
          new Padding(
            padding:
                new EdgeInsets.only(right: mediaQueryData.size.height * 0.01),
          ),
          Container(
            child: Expanded(
              child: Text(
                '${widget.penyelenggaraEvent}',
                maxLines: 3,
                style: new TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14.0,
                ),
              ),
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
                '${widget.desaEvent}',
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
                    id: "${widget.idDesa}",
                    desa: "${widget.desaEvent}",
                    kecamatan: "${widget.kecamatanEvent}",
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 5.0),
          Chip(
            backgroundColor: Colors.blue[800],
            label: Text(
              '${widget.kecamatanEvent}',
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

  // Widget _card() {
  //   return Expanded(
  //     child: new Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         new Container(
  //           child: new Text(
  //             '${widget.judulEvent}',
  //             style: new TextStyle(
  //               fontSize: 20.0,
  //               fontWeight: FontWeight.bold,
  //             ),
  //             maxLines: 3,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ),
  //         new Row(
  //           children: <Widget>[
  //             GestureDetector(
  //               child: Chip(
  //                 backgroundColor: Colors.green,
  //                 label: Text(
  //                   '${widget.desaEvent}',
  //                   style: new TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 12.0,
  //                   ),
  //                 ),
  //               ),
  //               onTap: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => ProfilDesa(
  //                       id: "${widget.idDesa}",
  //                       desa: "${widget.desaEvent}",
  //                       kecamatan: "${widget.kecamatanEvent}",
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //             SizedBox(width: 5.0),
  //             Chip(
  //               backgroundColor: Colors.green,
  //               label: Text(
  //                 '${widget.kecamatanEvent}',
  //                 style: new TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 12.0,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         new Container(
  //           child: new Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               new Text(
  //                 'Penyelenggara : ',
  //                 maxLines: 3,
  //                 style: new TextStyle(
  //                   color: Colors.grey[500],
  //                   fontSize: 12.0,
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Text(
  //                   '${widget.penyelenggaraEvent}',
  //                   maxLines: 3,
  //                   style: new TextStyle(
  //                     color: Colors.grey[500],
  //                     fontSize: 12.0,
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(width: 10.0),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
  //           data: '${widget.uraianEvent}',
  //           // onLaunchFail: (url) {
  //           //   // optional, type Function
  //           //   print("launch $url failed");
  //           // },
  //           // scrollable: false,
  //         ),
  //         // HtmlView(
  //         //   padding: new EdgeInsets.all(10.0),
  //         //   data: '${widget.uraianEvent}',
  //         //   onLaunchFail: (url) {
  //         //     // optional, type Function
  //         //     print("launch $url failed");
  //         //   },
  //         //   scrollable: false,
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  Widget _jam() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20),
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Chip(
                        backgroundColor: Colors.red[400],
                        avatar: CircleAvatar(
                          backgroundColor: Colors.red[400],
                          child: Icon(Icons.date_range,
                              size: 16, color: Colors.white),
                        ),
                        label: Text(
                          'Tanggal',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width - 248,
                          child: Text(
                            'Mulai     ' +
                                "${widget.tglmulaiEvent}", //NOTE api tgl mulai detail event
                            style: TextStyle(color: Colors.grey),
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width - 248,
                        child: Text(
                          'Selesai  ' +
                              "${widget.tglselesaiEvent}", //NOTE api tgl selesai detail event
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Container(height: 50, child: VerticalDivider(color: Colors.grey)),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Chip(
                        backgroundColor: Colors.blue[400],
                        avatar: CircleAvatar(
                          backgroundColor: Colors.blue[400],
                          child: Icon(Icons.access_time,
                              size: 16, color: Colors.white),
                        ),
                        label: Text(
                          'Waktu',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 268,
                        child: Text(
                          'Mulai     ' +
                              "${widget.mulaiEvent}", //NOTE api jam mulai detail event
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 268,
                        child: Text(
                          'Selesai  ' +
                              "${widget.selesaiEvent}", //NOTE api jam selesai detail event
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
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
            FlatButton(
              color: Colors.grey,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0),
              ),
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
                SnackBar snackBar = SnackBar(
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
                );
                scaffoldKey.currentState.showSnackBar(snackBar);
              },
            ),
          ],
        ),
        Column(
          children: <Widget>[
            FlatButton(
              color: Colors.grey,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0),
              ),
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
                SnackBar snackBar = SnackBar(
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
                );
                scaffoldKey.currentState.showSnackBar(snackBar);
              },
            ),
          ],
        ),
        Column(
          children: <Widget>[
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0),
              ),
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
                Share.share("${widget.urlEvent}");
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget wHeader() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return ClipPath(
      // clipper: ArcClipper(),
      child: CachedNetworkImage(
        imageUrl: '${widget.gambarEvent}',
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
        height: mediaQueryData.size.height * 0.4,
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

  // Widget _detail(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     body: GestureDetector(
  //       child: Center(
  //         child: Hero(
  //           tag: 'imageHero',
  //           child: Image.network(
  //             "${widget.gambarEvent}", //NOTE api gambar detail event
  //           ),
  //         ),
  //       ),
  //       onTap: () {
  //         Navigator.pop(context);
  //       },
  //     ),
  //   );
  // }
}

// ignore: must_be_immutable
class IconTile extends StatelessWidget {
  String imgAssetPath;
  Color backColor;

  IconTile({this.imgAssetPath, this.backColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            color: backColor, borderRadius: BorderRadius.circular(15)),
        child: Image.asset(
          imgAssetPath,
          width: 20,
        ),
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
