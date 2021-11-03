import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

class DetailBumdes extends StatefulWidget {
  String dGambar, dJudul, dAdmin, dHtml, dTempat;

  DetailBumdes(
      {this.dGambar, this.dTempat, this.dAdmin, this.dJudul, this.dHtml});

  @override
  _DetailBumdesState createState() => _DetailBumdesState();
}

class _DetailBumdesState extends State<DetailBumdes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Potensi'),
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
                          ],
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.location_on,
                                size: 16, color: Colors.black45),
                            SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: 350,
                              child: Text(
                                "${widget.dTempat}",
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45),
                              ),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.account_circle,
                                size: 30, color: Colors.black45),
                            Container(
                                height: 15,
                                child: VerticalDivider(color: Colors.grey)),
                            Icon(Icons.date_range,
                                size: 30, color: Colors.black45),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                                height: 15,
                                child: VerticalDivider(color: Colors.grey)),
                            Icon(Icons.create, size: 30, color: Colors.black45),
                            SizedBox(
                              width: 5,
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
            height: 40,
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
