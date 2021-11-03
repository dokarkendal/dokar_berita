import 'package:flutter/material.dart';
import 'package:dokar_aplikasi/berita/hal_search.dart';
import './hal_berita.dart' as berita;
import './hal_bumdes.dart' as bumdes;
import './hal_potensi.dart' as potensi;
import './hal_layanan.dart' as layanan;

//import 'package:testflutter/haldua.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "DOKAR",

    /*routes: <String, WidgetBuilder>{
    '/Halsatu': (BuildContext context) => new Halsatu(),
    '/Haldua': (BuildContext context) => new Haldua(),
    },*/
    home: new HalamanBeritaWarga(),
  ));
}

class HalamanBeritaWarga extends StatefulWidget {
  @override
  _HalamanBeritaWargaState createState() => _HalamanBeritaWargaState();
}

class _HalamanBeritaWargaState extends State<HalamanBeritaWarga>
    with SingleTickerProviderStateMixin {
  String value;
  TabController controller;
  @override
  void initState() {
    controller = new TabController(vsync: this, length: 4);
    super.initState();
  }

  Icon cusIcon = Icon(Icons.search);
  Widget custSearchBar = Text("DOKAR");

  Widget build(BuildContext context) {
    return new Scaffold(
      /* floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {},
      ),*/
      appBar: new AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.account_circle),
        ),
        backgroundColor: Color(0xFFee002d),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                if (this.cusIcon.icon == Icons.search) {
                  this.cusIcon = Icon(Icons.cancel);
                  this.custSearchBar = TextField(
                    autofocus: false,
                    onSubmitted: (text) {
                      value = text;
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Search(value: value),
                      ));
                    },
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Cari berita",
                      hintStyle:
                          TextStyle(fontSize: 16.0, color: Colors.red[100]),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  );
                } else {
                  this.cusIcon = Icon(Icons.search);
                  this.custSearchBar = Text("DOKAR");
                }
              });
            },
            icon: cusIcon,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none),
          )
        ],
        title: custSearchBar,
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          new berita.Berita(),
          new potensi.Potensi(),
          new bumdes.Bumdes(),
          new layanan.Layanan(),
        ],
      ),
      /*floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,*/
      bottomNavigationBar: new Material(
        color: Color(0xFFee002d),
        child: new TabBar(
          controller: controller,
          tabs: <Widget>[
            new Tab(
              icon: new Icon(
                Icons.library_books,
              ),
              text: 'Berita',
            ),
            new Tab(
              icon: new Icon(Icons.assessment),
              text: 'Potensi',
            ),
            new Tab(
              icon: new Icon(Icons.shopping_basket),
              text: 'Bumdes',
            ),
            new Tab(
              icon: new Icon(Icons.drafts),
              text: 'Layanan',
            ),
          ],
        ),
      ),
    );
  }
}

//NAVIGASI HALAMAN//

/*void main() {
  runApp(new MaterialApp(
    home: new Halsatu(),
    title: "Dokar Kendal",
    routes: <String, WidgetBuilder>{
      '/Halsatu': (BuildContext context) => new Halsatu(),
      '/Haldua': (BuildContext context) => new Haldua(),
    },
  ));
}*/

/*class Halsatu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color(0xFFee002d),
        leading: new Icon(Icons.home),
        title: new Center(
          child: new Text("Dokar Kendal"),
        ),
        actions: <Widget>[new Icon(Icons.search)],
      ),
      body: new Center(
        child: new IconButton(
          icon: new Icon(
            Icons.headset,
            size: 30.0,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/Haldua');
          },
        ),
      ),
    );
  }
}*/

///MEMBUAT CARD///

/*class HalamanSatu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color(0xFFee002d),
        leading: new Icon(Icons.home),
        title: new Center(
          child: new Text("Dokar Kendal"),
        ),
        actions: <Widget>[new Icon(Icons.search)],
      ),
      body: new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new CardSaya(
              icon: Icons.home,
              teks: "Home",
              warnaIcon: Colors.brown,
            ),
            new CardSaya(
              icon: Icons.favorite,
              teks: "Favorite",
              warnaIcon: Colors.pink,
            ),
            new CardSaya(
              icon: Icons.place,
              teks: "Place",
              warnaIcon: Colors.blue,
            ),
            new CardSaya(
              icon: Icons.home,
              teks: "Place",
              warnaIcon: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}*/

/*class CardSaya extends StatelessWidget {
  CardSaya({this.icon, this.teks, this.warnaIcon});

  final IconData icon;
  final String teks;
  final Color warnaIcon;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.all(10.0),
      child: new Card(
          child: Column(
        children: <Widget>[
          new Icon(
            icon,
            size: 50.0,
            color: warnaIcon,
          ),
          new Text(
            teks,
            style: new TextStyle(fontSize: 20.0),
          )
        ],
      )),
    );
  }
}*/

/*Widget build(BuildContext context) {
return new Scaffold(
body: new Center(
 child: new Container(
color: Color(0xFFee002d),
width: 200.0,
height: 100.0,
child: new Center(
child: new Icon(Icons.android, color: Colors.white, size: 50.0),
 ),
),
);
}*/
