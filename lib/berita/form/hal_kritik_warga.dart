import 'dart:async'; // api to json
import 'package:dio/dio.dart';
//import 'package:dokar_aplikasi/berita/detail_page_kritiksaran.dart';
import 'package:dokar_aplikasi/berita/detail_page_kritiksaran_warga.dart';
import 'package:dokar_aplikasi/berita/form/form_kritik_warga.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart'; //save session
import 'package:flutter_slidable/flutter_slidable.dart';

class FormKritikSaran extends StatefulWidget {
  final String idDesa;

  FormKritikSaran({
    Key key,
    this.idDesa,
  }) : super(key: key);

  @override
  FormKritikSaranState createState() => FormKritikSaranState();
}

class FormKritikSaranState extends State<FormKritikSaran> {
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
    //SharedPreferences pref = await SharedPreferences.getInstance();
    //NOTE if else load more
    if (!isLoading) {
      setState(
        () {
          isLoading = true;
        },
      );

      final response = await dio.get(nextPage + "/" + "${widget.idDesa}" + "/");
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
        title: Text('Kritik dan Saran'),
        backgroundColor: Color(0xFFee002d),
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
                return new Container();
              } else {
                return Slidable(
                  controller: slidableController,
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.grey[100],
                    padding: EdgeInsets.only(
                      left: 3.0,
                      right: 3.0,
                    ),
                    child: new Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: new InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            new MaterialPageRoute(
                              builder: (context) => new DetailKritikSaranWarga(
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
                                kritiksaran[i]["kritik_email"],
                              ),
                              Container(
                                  height: 15,
                                  child: VerticalDivider(color: Colors.grey)),
                              new Text(
                                kritiksaran[i]["kritik_tanggal"],
                              ),
                            ],
                          ),
                          title: new Text(
                            kritiksaran[i]["kritik_nama"],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormKritikWarga(idDesa: "${widget.idDesa}"),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFee002d),
      ),
    );
  }
}
