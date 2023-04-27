////////////////////////////////PACKAGE//////////////////////////////////////
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dokar_aplikasi/berita/edit/hal_akun_edit_semua.dart';
// import 'package:dokar_aplikasi/rflutter_alert.dart';
// import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http; //api
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../style/styleset.dart'; //save session

////////////////////////////////PROJECT///////////////////////////////////////
class ListPenulis extends StatefulWidget {
  @override
  ListPenulisState createState() => ListPenulisState();
}

class ListPenulisState extends State<ListPenulis> {
////////////////////////////////DEKLARASI////////////////////////////////////
  String username = "";
  late String status;
  late List databerita = [];
  bool loadingdata = false;
  late GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  // final SlidableController slidableController = SlidableController();

///////////////////////////////CEK SESSION ADMIN///////////////////////////////////
  // ignore: unused_element
  Future _cekSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(
        () {
          username = pref.getString("userAdmin")!;
        },
      );
    }
  }

  void hapusadmin(beritaAdmin, status) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/account/deletepenulis"),
        body: {
          "IdAdmin": beritaAdmin,
          "IdDesa": pref.getString("IdDesa"),
          "status": status,
          "IdAdminSession": pref.getString("IdAdmin"),
        });
    var deleted = json.decode(response.body);
    print(deleted);
    Navigator.pushReplacementNamed(context, '/ListPenulis');
  }

  Future<void> ambildata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      loadingdata = true;
    });
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/account/listpenulis"),
        body: {
          "IdDesa": pref.getString("IdDesa"),
          "status": pref.getString("status"),
        });
    if (mounted) {
      this.setState(
        () {
          loadingdata = false;
          databerita = json.decode(response.body);
          print(databerita);
        },
      );
    }
  }

//ANCHOR loading
  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: loadingdata ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this.ambildata();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _penulis() {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: databerita == null ? 0 : databerita.length,
      // ignore: missing_return
      itemBuilder: (context, i) {
        if (databerita[i]["status"] == 'Admin') {
          return Slidable(
              child: Container(
                color: Colors.grey[100],
                child: Card(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: IconButton(
                        padding: EdgeInsets.all(15.0),
                        icon: Icon(Icons.perm_contact_calendar),
                        color: Colors.white,
                        iconSize: 30.0,
                        onPressed: () {},
                      ),
                      title: Text(
                        databerita[i]["user_name"],
                        style: TextStyle(
                          // fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        databerita[i]["status"],
                        style: TextStyle(
                          // fontSize: 10,
                          // fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // controller: slidableController,
              startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      label: 'Edit',
                      backgroundColor: Colors.green,
                      icon: Icons.mode_edit,
                      onPressed: (context) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FormAkunEditSemua(
                              dIdAdmin: databerita[i]["no"],
                              dNama: databerita[i]["nama"],
                              dHp: databerita[i]["hp"],
                              dEmail: databerita[i]["email"],
                              dUsername: databerita[i]["user_name"],
                              dStatus: databerita[i]["status"],
                              dPassword: '',
                            ),
                          ),
                        );
                      },
                    ),
                  ]),
              // actionExtentRatio: 0.25,
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                    label: 'Hapus',
                    backgroundColor: Colors.red,
                    icon: Icons.delete,
                    onPressed: (context) {
                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: "Hapus " + databerita[i]["status"],
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Tidak",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () => Navigator.pop(context),
                            color: Colors.green,
                          ),
                          DialogButton(
                            child: Text(
                              "Hapus",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              hapusadmin(
                                  databerita[i]["no"], databerita[i]["status"]);
                              Navigator.pop(context);
                            },
                            color: Colors.red,
                          )
                        ],
                      ).show();
                    },
                  ),
                ],
              ));
        } else if (databerita[i]["status"] == 'Penulis') {
          return Slidable(
            child: Container(
              color: Colors.grey[100],
              child: Card(
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  onTap: () {},
                  child: ListTile(
                    leading: IconButton(
                      padding: EdgeInsets.all(15.0),
                      icon: Icon(Icons.account_circle_rounded),
                      color: Colors.white,
                      iconSize: 30.0,
                      onPressed: () {},
                    ),
                    title: Text(
                      databerita[i]["user_name"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      databerita[i]["status"],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // controller: slidableController,
            startActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                    label: 'Edit',
                    backgroundColor: Colors.green,
                    icon: Icons.mode_edit,
                    onPressed: (context) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FormAkunEditSemua(
                            dIdAdmin: databerita[i]["no"],
                            dNama: databerita[i]["nama"],
                            dHp: databerita[i]["hp"],
                            dEmail: databerita[i]["email"],
                            dUsername: databerita[i]["user_name"],
                            dStatus: databerita[i]["status"],
                            dPassword: '',
                          ),
                        ),
                      );
                    },
                  ),
                ]),
            // actionExtentRatio: 0.25,

            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  label: 'Hapus',
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  onPressed: (context) {
                    Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Hapus " + databerita[i]["status"],
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Tidak",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () => Navigator.pop(context),
                          color: Colors.green,
                        ),
                        DialogButton(
                          child: Text(
                            "Hapus",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            hapusadmin(
                                databerita[i]["no"], databerita[i]["status"]);
                            Navigator.pop(context);
                          },
                          color: Colors.red,
                        )
                      ],
                    ).show();
                  },
                ),
              ],
            ),
          );
        } else if (databerita[i]["status"] == 'Not Found') {
          return Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child:
                        Icon(Icons.people, size: 50.0, color: Colors.grey[350]),
                  ),
                  Text(
                    "Belum ada penulis",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[350],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget cardAkun() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return Container(
      padding: EdgeInsets.all(5.0),
      // width: mediaQueryData.size.width * 0.1,
      height: mediaQueryData.size.height * 0.2,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0.0, 3.0),
              blurRadius: 15.0)
        ],
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/images/penulis.png',
                  width: mediaQueryData.size.width * 0.2,
                  height: mediaQueryData.size.height * 0.2,
                ),
                SizedBox(width: mediaQueryData.size.width * 0.1),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AutoSizeText(
                      'Admin dan penulis',
                      minFontSize: 2,
                      maxLines: 2,
                      style: TextStyle(
                        color: Color(0xFF2e2e2e),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AutoSizeText(
                      '- Buatkan user',
                      minFontSize: 10,
                      style: TextStyle(
                        color: Color(0xFF2e2e2e),
                        fontSize: 14.0,
                      ),
                    ),
                    AutoSizeText(
                      '- 2 admin dan 3 penulis',
                      minFontSize: 10,
                      style: TextStyle(
                        color: Color(0xFF2e2e2e),
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _padding10() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.brown[800], //change your color here
        ),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'KELOLA AKUN',
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: loadingdata
          ? _buildProgressIndicator()
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    //_admin(),
                    cardAkun(),
                    _padding10(),
                    _penulis(),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/FormAddAkun').then(
            (value) => setState(
              () {
                ambildata();
              },
            ),
          );
        },
        label: const Text(
          'Tambah',
          style: TextStyle(
            color: subtitle,
          ),
        ),
        icon: const Icon(
          Icons.add,
          color: subtitle,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
