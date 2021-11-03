// ignore: unused_import
import 'package:dokar_aplikasi/bottom-bar.dart';
import 'package:flutter/material.dart';
import 'package:dokar_aplikasi/berita/hal_search.dart';
import './hal_berita.dart' as berita;
import './hal_bumdes.dart' as bumdes;
import './hal_inovasi.dart' as inovasi;
import './hal_agenda.dart' as agenda;

void main() {
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "DOKAR",
      home: new HalamanBeritaWarga(),
    ),
  );
}

class HalamanBeritaWarga extends StatefulWidget {
  @override
  _HalamanBeritaWargaState createState() => _HalamanBeritaWargaState();
}

class _HalamanBeritaWargaState extends State<HalamanBeritaWarga>
    with SingleTickerProviderStateMixin {
  String value;
  TabController controller;

  String notifStatus = '';
  String token = '';
  // ignore: unused_field
  static String topik = '';

  Icon cusIcon = Icon(Icons.search);
  Widget custSearchBar = Text("DOKAR");

  @override
  void initState() {
    controller = new TabController(vsync: this, length: 4);
    super.initState();
  }

  Widget googleuseracount() {
    return IconButton(
        onPressed: () {
          print("object");
          //await new Future.delayed(const Duration(seconds: 3));
          Navigator.pushNamed(context, '/GoogleAccount');
        },
        icon: Icon(Icons.account_circle));
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.dehaze, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/ListKecamatan');
          },
        ),
        backgroundColor: Color(0xFFee002d),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                if (this.cusIcon.icon == Icons.search) {
                  this.cusIcon = Icon(Icons.cancel);
                  this.custSearchBar = Container(
                      height: 40,
                      child: TextField(
                        autofocus: false,
                        onSubmitted: (text) {
                          value = text;
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Search(value: value),
                          ));
                        },
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: "Cari berita",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          hintStyle: TextStyle(
                              fontSize: 16.0, color: Colors.grey[400]),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ));
                } else {
                  this.cusIcon = Icon(Icons.search);
                  this.custSearchBar = Text("DOKAR");
                }
              });
            },
            icon: cusIcon,
          ),
          googleuseracount(),
        ],
        title: custSearchBar,
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          new berita.Berita(),
          new agenda.Agenda(),
          new inovasi.Inovasi(controller),
          new bumdes.Bumdes(),
        ],
      ),
      /*floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,*/
      bottomNavigationBar: new Material(
        color: Color(0xFFee002d),
        child: new TabBar(
          indicatorColor: Colors.white,
          controller: controller,
          tabs: <Widget>[
            new Tab(
              icon: new Icon(
                Icons.library_books,
              ),
              text: 'Berita',
            ),
            new Tab(
              icon: new Icon(Icons.event),
              text: 'Agenda',
            ),
            new Tab(
              icon: new Icon(Icons.assessment),
              text: 'Inovasi',
            ),
            new Tab(
              icon: new Icon(Icons.shopping_basket),
              text: 'Bumdes',
            ),
          ],
        ),
      ),
    );
  }
}
