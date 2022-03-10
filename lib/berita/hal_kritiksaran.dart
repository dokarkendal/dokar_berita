import 'dart:async'; // api to json
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; //save session
import 'package:flutter_slidable/flutter_slidable.dart';

import 'detail_page_kritiksaran.dart';

class KritikSaran extends StatefulWidget {
  @override
  KritikSaranState createState() => KritikSaranState();
}

class KritikSaranState extends State<KritikSaran> {
  String username = "";

  // ignore: unused_field
  String _mySelection;
  List kegiatanAdmin = List();
  GlobalKey<RefreshIndicatorState> refreshKey;
  final SlidableController slidableController = SlidableController();

  List kritiksaran = new List();
  bool isLoading = false;
  final dio = new Dio();
  List tempList = new List();
  ScrollController _scrollController = new ScrollController();

  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/kritiksaran/list";

  void _getMoreData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    //NOTE if else load more
    if (!isLoading) {
      setState(
        () {
          isLoading = true;
        },
      );

      final response =
          await dio.get(nextPage + "/" + pref.getString("IdDesa") + "/");
      List tempList = new List();
      nextPage = response.data['next'];

      for (int i = 0; i < response.data['result'].length; i++) {
        tempList.add(response.data['result'][i]);
      }
      setState(
        () {
          isLoading = false;
          kritiksaran.addAll(tempList);
        },
      );
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this._getMoreData();
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _getMoreData();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kritik Saran',
          style: TextStyle(
            color: Color(0xFF2e2e2e),
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1), () {});
        },
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: kritiksaran.length + 1, //NOTE if else listview berita
          itemBuilder: (BuildContext context, int i) {
            if (i == kritiksaran.length) {
              return _buildProgressIndicator();
            } else {
              if (kritiksaran[i]["kritik_id"] == 'Notfound') {
                return new Container(
                    /*child: Center(
                    child: new Column(
                      children: <Widget>[
                        new Padding(
                          padding: new EdgeInsets.all(100.0),
                        ),
                        new Text(
                          "DATA KOSONG",
                          style: new TextStyle(
                            fontSize: 30.0,
                            color: Colors.grey[350],
                          ),
                        ),
                        new Padding(
                          padding: new EdgeInsets.all(20.0),
                        ),
                        new Icon(Icons.help_outline,
                            size: 150.0, color: Colors.grey[350]),
                      ],
                    ),
                  ),*/
                    );
              } else {
                return Slidable(
                  controller: slidableController,
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.grey[100],
                    padding: EdgeInsets.only(
                      left: 5.0,
                      right: 5.0,
                    ),
                    child: new Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: new InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            new MaterialPageRoute(
                              builder: (context) => new DetailKritikSaran(
                                dId: kritiksaran[i]["kritik_id"],
                                dJudul: kritiksaran[i]["kritik_judul"],
                                dTanggal: kritiksaran[i]["kritik_tanggal"],
                                dIsi: kritiksaran[i]["kritik_isi"],
                                dNama: kritiksaran[i]["kritik_nama"],
                                dEmail: kritiksaran[i]["kritik_email"],
                                dPublish: kritiksaran[i]["kritik_publish"],
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          subtitle: Row(
                            children: <Widget>[
                              new Text(
                                kritiksaran[i]["kritik_tanggal"],
                              ),
                              Container(
                                  height: 15,
                                  child: VerticalDivider(color: Colors.grey)),
                              new Text(
                                kritiksaran[i]["kritik_email"],
                              ),
                            ],
                          ),
                          title: new Text(
                            kritiksaran[i]["kritik_judul"],
                            style: new TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(
                            Icons.message,
                            size: 26.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
