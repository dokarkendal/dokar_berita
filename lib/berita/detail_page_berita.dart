import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:share/share.dart';

import 'package:http/http.dart' as http; //api

class DetailBerita extends StatefulWidget {
  String dGambar,
      dKategori,
      dJudul,
      dAdmin,
      dTanggal,
      dHtml,
      dUrl,
      dId,
      dIdDesa;

  DetailBerita(
      {this.dGambar,
      this.dKategori,
      this.dAdmin,
      this.dTanggal,
      this.dJudul,
      this.dHtml,
      this.dUrl,
      this.dId,
      this.dIdDesa});

  @override
  _DetailBeritaState createState() => _DetailBeritaState();
}

class _DetailBeritaState extends State<DetailBerita> {
  Future<String> getKategori() async {
    //SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        "http://dokar.kendalkab.go.id/webservice/android/kabar/viewest",
        body: {
          "IdDesa": "${widget.dIdDesa}",
          "Kategori": "${widget.dKategori}",
          "IdBerita": "${widget.dId}"
        });
    var kategori = json.decode(response.body);
    setState(() {
      print(kategori);
      print("${widget.dIdDesa}");
    });

    //print(id);
  }

  @override
  void initState() {
    super.initState();
    this.getKategori();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Berita'),
        backgroundColor: Color(0xFFee002d),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            //padding: EdgeInsets.all(1),
            //child: Card(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.network(
                          "${widget.dGambar}",
                        ),
                        Container(
                          height: 6.0,
                        ),
                        /*new Text(
                          "${widget.dKategori}",
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),*/
                        Text(
                          "${widget.dJudul}",
                          style: TextStyle(
                              fontSize: 21,
                              color: Color(0xFFee002d),
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 5.0,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.account_circle,
                                size: 16, color: Colors.black45),
                            SizedBox(
                              width: 5,
                            ),
                            new Text(
                              "${widget.dAdmin}",
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                              ),
                            ),
                            Container(
                                height: 15,
                                child: VerticalDivider(color: Colors.red)),
                            Icon(Icons.date_range,
                                size: 16, color: Colors.black45),
                            SizedBox(
                              width: 5,
                            ),
                            new Text(
                              "${widget.dTanggal}",
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45),
                            ),
                            Container(
                                height: 15,
                                child: VerticalDivider(color: Colors.red)),
                            Icon(Icons.create, size: 16, color: Colors.black45),
                            SizedBox(
                              width: 5,
                            ),
                            new Text(
                              "${widget.dKategori}",
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45),
                            ),
                          ],
                        ),
                        Divider(),
                        new HtmlView(
                          padding: new EdgeInsets.all(5.0),
                          data: "${widget.dHtml}",
                          onLaunchFail: (url) {
                            // optional, type Function
                            print("launch $url failed");
                          },
                          scrollable: false,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Material(
                                  borderRadius: BorderRadius.circular(100.0),
                                  color: Colors.red.withOpacity(0.1),
                                  child: IconButton(
                                    padding: EdgeInsets.all(15.0),
                                    icon: Icon(Icons.home),
                                    color: Colors.red,
                                    iconSize: 30.0,
                                    onPressed: () {},
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text('Home',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0))
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Material(
                                  borderRadius: BorderRadius.circular(100.0),
                                  color: Colors.green.withOpacity(0.1),
                                  child: IconButton(
                                    padding: EdgeInsets.all(15.0),
                                    icon: Icon(Icons.message),
                                    color: Colors.green,
                                    iconSize: 30.0,
                                    onPressed: () {},
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text('Comment',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0))
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Material(
                                  borderRadius: BorderRadius.circular(100.0),
                                  color: Colors.blue.withOpacity(0.1),
                                  child: IconButton(
                                    padding: EdgeInsets.all(15.0),
                                    icon: Icon(Icons.share),
                                    color: Colors.blue,
                                    iconSize: 30.0,
                                    onPressed: () {
                                      Share.share("${widget.dUrl}");
                                    },
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text('Share',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0))
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            //),
          ),
          SizedBox(
            height: 30,
          ),
          /*Container(
            child: Column(
              children: <Widget>[
                new NameDetail(
                  name: widget.dJudul,
                  //email: widget.dEmail,
                ),
                //new BagianIcon(),
                //new BagianContact(
                    //phone: widget.dPhone,
                    //city: widget.dCity,
                    //postal: widget.dZip,
                    )
              ],
            ),
          ),*/
        ],
      ),
    );
  }
}

/*class NameDetail extends StatelessWidget {
  final String name, email;
  NameDetail({this.name, this.email});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 24),
                ),
                Text(
                  "Email : $email",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.star,
                size: 40,
                color: Colors.orange,
              ),
              Text(
                "12",
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
    );
  }
}*/

/*class BagianIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          IconText(
            iconData: Icons.camera,
            text: "Camera",
          ),
          IconText(
            iconData: Icons.phone,
            text: "Phone",
          ),
          IconText(
iconData: Icons.message,
            text: "Message",
          ),
        ],
      ),
    );
  }
}

class IconText extends StatelessWidget {
  IconText({this.iconData, this.text});
  final IconData iconData;
  final String text;
  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Column(
        children: <Widget>[
          Icon(
            iconData,
            size: 20,
            color: Colors.green,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.green),
          ),
        ],
      ),
    );
  }
}

class BagianContact extends StatelessWidget {
  String phone, city, postal;

  BagianContact({this.phone, this.city, this.postal});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Container(
                child: Text(
                  'Dengan Banyak Class',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                child: Text(
                  phone,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: Text(
                  city,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                child: Text(
                  postal,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
