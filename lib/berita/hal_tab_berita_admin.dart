//ANCHOR package tabbar berita
import 'package:flutter/material.dart';
import 'package:dokar_aplikasi/berita/hal_search.dart';
import './hal_berita.dart' as berita;
import './hal_bumdes.dart' as bumdes;
import './hal_inovasi.dart' as inovasi;
import './hal_agenda.dart' as agenda;

class HalamanBeritaadmin extends StatefulWidget {
  @override
  _HalamanBeritaadminState createState() => _HalamanBeritaadminState();
}

class _HalamanBeritaadminState extends State<HalamanBeritaadmin>
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
              setState(
                () {
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
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: "Cari...",
                        hintStyle:
                            TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    );
                  } else {
                    this.cusIcon = Icon(Icons.search);
                    this.custSearchBar = Text("DOKAR");
                  }
                },
              );
            },
            icon: cusIcon,
          ),
        ],
        title: custSearchBar,
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          new berita.Berita(),
          new agenda.Agenda(),
          new inovasi.Inovasi(),
          new bumdes.Bumdes(),
        ],
      ),
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
