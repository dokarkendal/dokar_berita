import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_html_view/flutter_html_view.dart';
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
      {this.dGambar,
      this.dTempat,
      this.dBaca,
      this.dAdmin,
      this.dTanggal,
      this.dJudul,
      this.dHtml,
      this.dUrl,
      this.dVideo,
      this.dId,
      this.dIdDesa,
      this.dDesa,
      this.dKecamatan,
      this.dKategori});

  @override
  _DetailPotensiState createState() => _DetailPotensiState();
}

class _DetailPotensiState extends State<DetailPotensi> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  YoutubePlayerController youTube;
  String dibaca = '';

  // ignore: missing_return
  Future<String> addViews() async {
    //SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        "http://dokar.kendalkab.go.id/webservice/android/kabar/viewest",
        body: {
          "IdDesa": "${widget.dIdDesa}",
          "Kategori": "${widget.dKategori}",
          "IdBerita": "${widget.dId}"
        });
    var kategori = json.decode(response.body);
    setState(
      () {
        print(kategori);
        //print("${widget.dIdDesa}");
      },
    );
  }

  @override
  void initState() {
    youTube = YoutubePlayerController(
      initialVideoId: "${widget.dVideo}",
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
      ),
    );
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

  Widget _playYoutube(youTube) {
    String vid = "${widget.dVideo}";
    int panjang = vid.length;
    if ("${widget.dVideo}" == null) {
      return new Center(
        child: Chip(
          backgroundColor: Colors.red[400],
          avatar: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.videocam_off, size: 16, color: Colors.black45),
          ),
          label: Text(
            'Tidak ada embed video',
            style: new TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ),
      );
    } else {
      if (panjang >= 12) {
        return new Center(
          child: Chip(
            backgroundColor: Colors.red[400],
            avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.videocam_off, size: 16, color: Colors.black45),
            ),
            label: Text(
              'Embed video hanya dari youtube',
              style: new TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ),
        );
      } else if (panjang == 0) {
        return new Center(
          child: Chip(
            backgroundColor: Colors.red[400],
            avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.videocam_off, size: 16, color: Colors.black45),
            ),
            label: Text(
              'Tidak ada embed video',
              style: new TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ),
        );
      } else {
        return new YoutubePlayer(
          controller: youTube,
          showVideoProgressIndicator: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Detail Kegiatan'),
        backgroundColor: Color(0xFFee002d),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    wHeader(),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 190.0,
                        right: 10.0,
                        left: 10.0,
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          padding: new EdgeInsets.all(15.0),
                          child: IntrinsicHeight(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                        child: new Text(
                                          '${widget.dJudul}',
                                          style: new TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      new Row(
                                        children: <Widget>[
                                          Chip(
                                            backgroundColor: Colors.green,
                                            label: Text(
                                              '${widget.dDesa}',
                                              style: new TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5.0),
                                          Chip(
                                            backgroundColor: Colors.green,
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
                                      new Container(
                                        child: new Text(
                                          '${widget.dTempat}',
                                          style: new TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey[500],
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      new Container(
                                        child: new Row(
                                          children: <Widget>[
                                            new Text(
                                              '${widget.dKategori}',
                                              maxLines: 3,
                                              style: new TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 12.0,
                                              ),
                                            ),
                                            SizedBox(width: 10.0),
                                            new Text(
                                              '${widget.dTanggal}',
                                              maxLines: 3,
                                              style: new TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 12.0,
                                              ),
                                            ),
                                            SizedBox(width: 10.0),
                                            Icon(
                                              Icons.remove_red_eye,
                                              size: 12,
                                              color: Colors.grey[500],
                                            ),
                                            new Text(
                                              dibaca,
                                              maxLines: 3,
                                              style: new TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 12.0,
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
                      ),
                    ),
                  ],
                ),
                _html(),
                _playYoutube(youTube),
                SizedBox(
                  height: 40,
                ),
                wShare(),
              ],
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
                Share.share("${widget.dUrl}");
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _html() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          HtmlView(
            padding: new EdgeInsets.all(10.0),
            data: '${widget.dHtml}',
            onLaunchFail: (url) {
              // optional, type Function
              print("launch $url failed");
            },
            scrollable: false,
          ),
        ],
      ),
    );
  }

  Widget wHeader() {
    var screenWidth = MediaQuery.of(context).size.width;
    return ClipPath(
      clipper: ArcClipper(),
      child: Image.network(
        '${widget.dGambar}',
        width: screenWidth,
        height: 230.0,
        fit: BoxFit.cover,
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
