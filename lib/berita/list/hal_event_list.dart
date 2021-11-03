////////////////////////////////PACKAGE//////////////////////////////////////
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'package:dio/dio.dart';
import 'package:dokar_aplikasi/berita/edit/hal_agenda_edit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //api
import 'package:shared_preferences/shared_preferences.dart'; //save session
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

////////////////////////////////PROJECT///////////////////////////////////////
class HalEventList extends StatefulWidget {
  @override
  HalEventListState createState() => HalEventListState();
}

class HalEventListState extends State<HalEventList> {
////////////////////////////////DEKLARASI////////////////////////////////////

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

  String username = "";
  List eventAdmin = List();
  GlobalKey<RefreshIndicatorState> refreshKey;
  final SlidableController slidableController = SlidableController();

  void hapusberita(eventAdmin) async {
    //print(beritaAdmin);
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        "http://dokar.kendalkab.go.id/webservice/android/agenda/deleteevent",
        body: {
          "IdAgenda": eventAdmin,
          "IdDesa": pref.getString("IdDesa"),
        });
    var deleted = json.decode(response.body);
    print(deleted);
    Navigator.pushReplacementNamed(context, '/HalEventList');
  }

///////////////////////////////CEK SESSION ADMIN///////////////////////////////////
  // ignore: unused_element
  Future _cekSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(() {
        username = pref.getString("userAdmin");
        //id = pref.getString("IdDesa");
      });
    }
  }

  //NOTE url api load berita
  List databerita = new List();
  bool isLoading = false;
  final dio = new Dio();
  List tempList = new List();
  ScrollController _scrollController = new ScrollController();
  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/agenda/listevent/";

  void _getMoreData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    //NOTE if else load more
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      final response = await dio.get(nextPage + pref.getString("IdDesa") + "/");

      nextPage = response.data['next'];

      for (int i = 0; i < response.data['result'].length; i++) {
        tempList.add(response.data['result'][i]);
      }

      setState(() {
        isLoading = false;
        databerita.addAll(tempList);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //this.getBerita();
    this._getMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

///////////////////////////////HALAMAN UTAMA//////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
        backgroundColor: Color(0xFFee002d),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1), () {
            //redirect
          });
        },
        child: ListView.builder(
          //scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: databerita.length + 1, //NOTE if else listview berita
          // ignore: missing_return
          itemBuilder: (BuildContext context, int i) {
            if (i == databerita.length) {
              return _buildProgressIndicator();
            } else {
              if (databerita[i]["id_agenda"] == 'Notfound') {
              } else {
                Widget _container() {
                  if (databerita[i]["device"] == '1') {
                    return new Container(
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
                                builder: (context) => new FormAgendaEdit(
                                  cJudul: databerita[i]["judul_agenda"],
                                  cPenyelenggara: databerita[i]
                                      ["penyelenggara"],
                                  cIsi: databerita[i]["uraian_agenda"],
                                  cTanggalmulai: databerita[i]
                                      ["tglmulai_agenda"],
                                  cTanggalselesai: databerita[i]
                                      ["tglselesai_agenda"],
                                  cJammulai: databerita[i]["jam_mulai"],
                                  cJamselesai: databerita[i]["jam_selesai"],
                                  cGambar: databerita[i]["gambar_agenda"],
                                  cIdAgenda: databerita[i]["id_agenda"],
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 64,
                                minHeight: 64,
                                maxWidth: 84,
                                maxHeight: 84,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Image(
                                  image: new NetworkImage(
                                      databerita[i]["gambar_agenda"]),
                                  fit: BoxFit.cover,
                                  height: 150.0,
                                  width: 110.0,
                                ),
                              ),
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    databerita[i]["penyelenggara"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            title: new Text(
                              databerita[i]["judul_agenda"],
                              style: new TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(
                              Icons.phone_android,
                              size: 14.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return new Container(
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
                            Alert(
                              context: context,
                              type: AlertType.warning,
                              style: alertStyle,
                              title: "Peringatan.",
                              desc:
                                  "Konten di input melalui Website, Apa anda ingin melanjutkan edit.",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "Tidak",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  color: Colors.green[300],
                                ),
                                DialogButton(
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                      new MaterialPageRoute(
                                        builder: (context) =>
                                            new FormAgendaEdit(
                                          cJudul: databerita[i]["judul_agenda"],
                                          cPenyelenggara: databerita[i]
                                              ["penyelenggara"],
                                          cIsi: databerita[i]["uraian_agenda"],
                                          cTanggalmulai: databerita[i]
                                              ["tglmulai_agenda"],
                                          cTanggalselesai: databerita[i]
                                              ["tglselesai_agenda"],
                                          cJammulai: databerita[i]["jam_mulai"],
                                          cJamselesai: databerita[i]
                                              ["jam_selesai"],
                                          cGambar: databerita[i]
                                              ["gambar_agenda"],
                                          cIdAgenda: databerita[i]["id_agenda"],
                                        ),
                                      ),
                                    );
                                  },
                                  color: Colors.red[300],
                                )
                              ],
                            ).show();
                          },
                          child: ListTile(
                            leading: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 64,
                                minHeight: 64,
                                maxWidth: 84,
                                maxHeight: 84,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Image(
                                  image: new NetworkImage(
                                      databerita[i]["gambar_agenda"]),
                                  fit: BoxFit.cover,
                                  height: 150.0,
                                  width: 110.0,
                                ),
                              ),
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 16.0,
                                ),
                                new Text(
                                  databerita[i]["penyelenggara"],
                                ),
                              ],
                            ),
                            title: new Text(
                              databerita[i]["judul_agenda"],
                              style: new TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(
                              Icons.computer,
                              size: 14.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }

                return Slidable(
                  //key: Key(itemC.title),
                  controller: slidableController,
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: _container(),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Hapus',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        Alert(
                          context: context,
                          type: AlertType.error,
                          title: "Hapus? ",
                          desc: databerita[i]["judul_agenda"],
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Tidak",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () => Navigator.pop(context),
                              color: Colors.green,
                            ),
                            DialogButton(
                              child: Text(
                                "Hapus",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () {
                                hapusberita(databerita[i]["id_agenda"]);
                                Navigator.pop(context);
                              },
                              color: Colors.red,
                            )
                          ],
                        ).show();
                      },
                    ),
                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }
}
