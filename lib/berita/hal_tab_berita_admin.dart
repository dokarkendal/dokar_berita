//ANCHOR package tabbar berita
import 'package:flutter/material.dart';
import 'package:dokar_aplikasi/berita/hal_search.dart';
import '../style/styleset.dart';
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
  late String value;
  late TabController controller;

  Icon cusIcon = Icon(
    Icons.search,
    color: appbarIcon,
  );
  Widget custSearchBar = Text(
    "DOKAR",
    style: TextStyle(
      color: appbarTitle,
      fontWeight: FontWeight.bold,
      fontSize: 25.0,
    ),
  );

  int _currentIndex = 0;
  final tabs = [
    berita.Berita(),
    agenda.Agenda(),
    inovasi.Inovasi(),
    bumdes.Bumdes(),
  ];

  @override
  void initState() {
    controller = new TabController(vsync: this, length: 3);
    super.initState();
  }

  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.dehaze, color: appbarIcon),
          onPressed: () {
            Navigator.pushNamed(context, '/ListKecamatan');
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(
                () {
                  if (this.cusIcon.icon == Icons.search) {
                    this.cusIcon = Icon(
                      Icons.cancel,
                      color: appbarIcon,
                    );
                    this.custSearchBar = Container(
                      height: mediaQueryData.size.height * 0.05,
                      // width: mediaQueryData.size.width,
                      child: Container(
                        alignment: Alignment.center,
                        child: TextField(
                          autofocus: false,
                          onSubmitted: (text) {
                            value = text;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Search(value: value),
                              ),
                            );
                          },
                          textInputAction: TextInputAction.go,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            hintText: "Cari berita",
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[600],
                            ),
                            // contentPadding: const EdgeInsets.only(
                            //     left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    );
                  } else {
                    this.cusIcon = Icon(
                      Icons.search,
                      color: appbarIcon,
                    );
                    this.custSearchBar = Text(
                      "DOKAR",
                      style: TextStyle(
                        color: Color(0xFF2e2e2e),
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                      ),
                    );
                  }
                },
              );
            },
            icon: cusIcon,
          ),
        ],
        title: custSearchBar,
      ),
      body: tabs[_currentIndex],
      // new TabBarView(
      //   controller: controller,
      //   children: <Widget>[
      //     new berita.Berita(),
      //     new agenda.Agenda(),
      //     new inovasi.Inovasi(),
      //     new bumdes.Bumdes(),
      //   ],
      // ),
      // bottomNavigationBar: new Material(
      //   color: Color(0xFFee002d),
      //   child: new TabBar(
      //     indicatorColor: Colors.white,
      //     controller: controller,
      //     tabs: <Widget>[
      //       new Tab(
      //         icon: new Icon(
      //           Icons.library_books,
      //         ),
      //         text: 'Berita',
      //       ),
      //       new Tab(
      //         icon: new Icon(Icons.event),
      //         text: 'Agenda',
      //       ),
      //       new Tab(
      //         icon: new Icon(Icons.assessment),
      //         text: 'Inovasi',
      //       ),
      //       new Tab(
      //         icon: new Icon(Icons.shopping_basket),
      //         text: 'Bumdes',
      //       ),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.brown[800],
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        //backgroundColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: "Berita",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
            ),
            label: "Event",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: "Inovasi",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Bumdes",
          ),
        ],
        onTap: (index) {
          if (index != 4) {
            setState(
              () {
                _currentIndex = index;
              },
            );
          }
        },
      ),
    );
  }
}
