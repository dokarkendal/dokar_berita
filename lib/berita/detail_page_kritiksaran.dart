import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html/style.dart';
// import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../rflutter_alert.dart';
import '../style/styleset.dart';

class DetailKritikSaran extends StatefulWidget {
  final String dId, dJudul, dTanggal, dNama, dEmail, dIsi, dPublish;

  DetailKritikSaran(
      {this.dTanggal,
      this.dPublish,
      this.dId,
      this.dJudul,
      this.dIsi,
      this.dNama,
      this.dEmail});

  @override
  _DetailKritikSaranState createState() => _DetailKritikSaranState();
}

class _DetailKritikSaranState extends State<DetailKritikSaran> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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

  @override
  void initState() {
    super.initState();
  }

  void publish() async {
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/kritiksaran/publish"),
        body: {"IdKritik": "${widget.dId}"});
    var publish = json.decode(response.body);
    print(publish);
    //Navigator.pushReplacementNamed(context, '/KritikSaran');
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/KritikSaran', ModalRoute.withName('/Haldua'));
  }

  void unpublish() async {
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/kritiksaran/unpublish"),
        body: {"IdKritik": "${widget.dId}"});
    var unpublish = json.decode(response.body);
    print(unpublish);
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/KritikSaran', ModalRoute.withName('/Haldua'));
  }

  void delete() async {
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/kritiksaran/delete"),
        body: {"IdKritik": "${widget.dId}"});
    var delete = json.decode(response.body);
    print(delete);
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/KritikSaran', ModalRoute.withName('/Haldua'));
  }

  Widget _publish() {
    return IconButton(
      padding: EdgeInsets.all(5.0),
      icon: Icon(Icons.redo),
      color: Colors.brown[800],
      iconSize: 20.0,
      onPressed: () {
        print("publish ${widget.dId}");
        if ("${widget.dPublish}" == '1') {
          Alert(
            context: context,
            type: AlertType.warning,
            style: alertStyle,
            title: "Publish.",
            desc: "Kritik Saran sudah di Publish.",
            buttons: [
              DialogButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () => Navigator.pop(context),
                color: Colors.blue[300],
              )
            ],
          ).show();
        } else {
          Alert(
            context: context,
            type: AlertType.warning,
            style: alertStyle,
            title: "Puplish.",
            desc: "Apa Kritik Saran ingin di Publish?",
            buttons: [
              DialogButton(
                child: Text(
                  "Tidak",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () => Navigator.pop(context),
                color: Colors.red[300],
              ),
              DialogButton(
                child: Text(
                  "Ya",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  publish();
                  Navigator.pop(context);
                },
                color: Colors.green[300],
              )
            ],
          ).show();
        }
      },
    );
  }

  Widget _unpublish() {
    return IconButton(
      padding: EdgeInsets.all(5.0),
      icon: Icon(Icons.undo),
      color: Colors.brown[800],
      iconSize: 20.0,
      onPressed: () {
        print("unpublish ${widget.dId}");
        if ("${widget.dPublish}" == '0') {
          Alert(
            context: context,
            type: AlertType.warning,
            style: alertStyle,
            title: "Unpublish.",
            desc: "Kritik Saran sudah di Unpublish.",
            buttons: [
              DialogButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () => Navigator.pop(context),
                color: Colors.blue[300],
              )
            ],
          ).show();
        } else {
          Alert(
            context: context,
            type: AlertType.warning,
            style: alertStyle,
            title: "Unpublish.",
            desc: "Apa Kritik Saran ingin di Unpublish?",
            buttons: [
              DialogButton(
                child: Text(
                  "Tidak",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () => Navigator.pop(context),
                color: Colors.red[300],
              ),
              DialogButton(
                child: Text(
                  "Ya",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  unpublish();
                  Navigator.pop(context);
                },
                color: Colors.green[300],
              )
            ],
          ).show();
        }
      },
    );
  }

  Widget _delete() {
    return IconButton(
      padding: EdgeInsets.all(5.0),
      icon: Icon(Icons.delete),
      color: Colors.brown[800],
      iconSize: 20.0,
      onPressed: () {
        print("delete ${widget.dId}");
        Alert(
          context: context,
          type: AlertType.warning,
          style: alertStyle,
          title: "Delete.",
          desc: "Apa Kritik Saran ingin di Delete?",
          buttons: [
            DialogButton(
              child: Text(
                "Tidak",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () => Navigator.pop(context),
              color: Colors.red[300],
            ),
            DialogButton(
              child: Text(
                "Ya",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () {
                delete();
                Navigator.pop(context);
              },
              color: Colors.green[300],
            )
          ],
        ).show();
      },
    );
  }

  Widget wShare() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    Icons.undo,
                    size: 20,
                    color: Colors.brown[800],
                  ),
                  Text(
                    "  " + "Unpublish",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                print("unpublish ${widget.dId}");
                if ("${widget.dPublish}" == '0') {
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    style: alertStyle,
                    title: "Unpublish.",
                    desc: "Kritik Saran sudah di Unpublish.",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.blue[300],
                      )
                    ],
                  ).show();
                } else {
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    style: alertStyle,
                    title: "Unpublish.",
                    desc: "Apa Kritik Saran ingin di Unpublish?",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Tidak",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.red[300],
                      ),
                      DialogButton(
                        child: Text(
                          "Ya",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () {
                          unpublish();
                          Navigator.pop(context);
                        },
                        color: Colors.green[300],
                      )
                    ],
                  ).show();
                }
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
                    Icons.redo,
                    size: 20,
                    color: Colors.brown[800],
                  ),
                  Text(
                    "  " + "Publish",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                print("publish ${widget.dId}");
                if ("${widget.dPublish}" == '1') {
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    style: alertStyle,
                    title: "Publish.",
                    desc: "Kritik Saran sudah di Publish.",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.blue[300],
                      )
                    ],
                  ).show();
                } else {
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    style: alertStyle,
                    title: "Puplish.",
                    desc: "Apa Kritik Saran ingin di Publish?",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Tidak",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.red[300],
                      ),
                      DialogButton(
                        child: Text(
                          "Ya",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () {
                          publish();
                          Navigator.pop(context);
                        },
                        color: Colors.green[300],
                      )
                    ],
                  ).show();
                }
              },
            ),
          ],
        ),
        Column(
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // padding: EdgeInsets.all(15.0),
                elevation: 0, backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // <-- Radius
                ),
              ),
              // color: Colors.green,
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
                    "  " + "Balas",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _html() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 40),
      child: Html(
        style: {
          "p": Style(
            padding: EdgeInsets.all(10.0),
          )
        },
        // padding: new EdgeInsets.all(10.0),
        data: '${widget.dIsi}',
        // onLaunchFail: (url) {
        //   // optional, type Function
        //   print("launch $url failed");
        // },
        // scrollable: false,
      ),
    );
  }

  Widget _judul() {
    return Column(
      children: <Widget>[
        Text(
          "${widget.dJudul}",
          style: TextStyle(
              fontSize: 21, color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _info() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: Icon(Icons.account_circle, size: 50, color: Colors.grey[400]),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: 5,
                    top: 10,
                    bottom: 5,
                  ),
                  child: Text(
                    "${widget.dNama}",
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 5,
                  ),
                  child: Text(
                    "${widget.dTanggal}",
                    style: new TextStyle(
                      color: Colors.black45,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 5,
              ),
              child: Text(
                "${widget.dEmail}",
                style: new TextStyle(
                  color: Colors.black45,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _delete(),
            _unpublish(),
            _publish(),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _judul(),
                  _info(),
                  _html(),
                  //wShare(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
