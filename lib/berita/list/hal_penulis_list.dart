////////////////////////////////PACKAGE//////////////////////////////////////
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dokar_aplikasi/berita/edit/hal_akun_edit_semua.dart';
import 'package:dokar_aplikasi/rflutter_alert.dart';
import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http; //api
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
  String status;
  List databerita;
  GlobalKey<RefreshIndicatorState> refreshKey;
  final SlidableController slidableController = SlidableController();

///////////////////////////////CEK SESSION ADMIN///////////////////////////////////
  // ignore: unused_element
  Future _cekSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(
        () {
          username = pref.getString("userAdmin");
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

  // ignore: missing_return
  Future<List> ambildata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
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
          databerita = json.decode(response.body);
          print(databerita);
        },
      );
    }
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

  /*Widget _admin() {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: databerita == null ? 0 : databerita.length,
      itemBuilder: (context, i) {
        return Slidable(
          controller: slidableController,
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: new Container(
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
                onTap: () {},
                child: ListTile(
                  leading: Material(
                    borderRadius: BorderRadius.circular(100.0),
                    color: Colors.green,
                    child: IconButton(
                      padding: EdgeInsets.all(15.0),
                      icon: Icon(Icons.people),
                      color: Colors.white,
                      iconSize: 25.0,
                      onPressed: () {},
                    ),
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      SizedBox(
                        height: 22.0,
                        child: InkWell(
                          child: FlatButton(
                            color: Colors.orange,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.perm_contact_calendar,
                                  size: 10,
                                  color: Colors.white,
                                ),
                                Text(
                                  databerita[i]["status"],
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      new Text(
                        databerita[i]["nama"],
                      ),
                    ],
                  ),
                  title: new Text(
                    databerita[i]["user_name"],
                    style: new TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 14.0,
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            IconSlideAction(
              caption: 'Edit',
              color: Colors.blue,
              icon: Icons.mode_edit,
              onTap: () {},
            ),
          ],
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
                      onPressed: () {},
                      color: Colors.red,
                    )
                  ],
                ).show();
              },
            ),
          ],
        );
      },
    );
  }*/
  Widget _penulis() {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: databerita == null ? 0 : databerita.length,
      // ignore: missing_return
      itemBuilder: (context, i) {
        if (databerita[i]["status"] == 'Admin') {
          return Slidable(
            controller: slidableController,
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: new Container(
              color: Colors.grey[100],
              // padding: EdgeInsets.only(
              //   left: 5.0,
              //   right: 5.0,
              // ),
              child: new Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: new InkWell(
                  onTap: () {},
                  child: ListTile(
                    leading: Material(
                      borderRadius: BorderRadius.circular(100.0),
                      color: Colors.blue,
                      child: IconButton(
                        padding: EdgeInsets.all(15.0),
                        icon: Icon(Icons.perm_contact_calendar),
                        color: Colors.white,
                        iconSize: 25.0,
                        onPressed: () {},
                      ),
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        SizedBox(
                          height: 22.0,
                          child: InkWell(
                            child: FlatButton(
                              color: Colors.orange,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                              ),
                              child: Row(
                                children: <Widget>[
                                  /*Icon(
                                    Icons.perm_contact_calendar,
                                    size: 10,
                                    color: Colors.white,
                                  ),*/
                                  Text(
                                    databerita[i]["status"],
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        /*SizedBox(
                          width: 16.0,
                        ),
                        new Text(
                          databerita[i]["nama"],
                        ),*/
                      ],
                    ),
                    title: new Text(
                      databerita[i]["user_name"],
                      style: new TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14.0,
                    ),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              IconSlideAction(
                caption: 'Edit',
                color: Colors.green,
                icon: Icons.mode_edit,
                onTap: () {
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (context) => new FormAkunEditSemua(
                        dIdAdmin: databerita[i]["no"],
                        dNama: databerita[i]["nama"],
                        dHp: databerita[i]["hp"],
                        dEmail: databerita[i]["email"],
                        dUsername: databerita[i]["user_name"],
                        dStatus: databerita[i]["status"],
                      ),
                    ),
                  );
                },
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Hapus',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
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
          );
        } else if (databerita[i]["status"] == 'Penulis') {
          return Slidable(
            controller: slidableController,
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: new Container(
              color: Colors.grey[100],
              // padding: EdgeInsets.only(
              //   left: 5.0,
              //   right: 5.0,
              // ),
              child: new Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: new InkWell(
                  onTap: () {},
                  child: ListTile(
                    leading: Material(
                      borderRadius: BorderRadius.circular(100.0),
                      color: Colors.green,
                      child: IconButton(
                        padding: EdgeInsets.all(15.0),
                        icon: Icon(Icons.people),
                        color: Colors.white,
                        iconSize: 25.0,
                        onPressed: () {},
                      ),
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        SizedBox(
                          height: 22.0,
                          child: InkWell(
                            child: FlatButton(
                              color: Colors.grey,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                              ),
                              child: Row(
                                children: <Widget>[
                                  /*Icon(
                                    Icons.perm_contact_calendar,
                                    size: 10,
                                    color: Colors.white,
                                  ),*/
                                  Text(
                                    databerita[i]["status"],
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        /*SizedBox(
                          width: 16.0,
                        ),
                        new Text(
                          databerita[i]["nama"],
                        ),*/
                      ],
                    ),
                    title: new Text(
                      databerita[i]["user_name"],
                      style: new TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14.0,
                    ),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              IconSlideAction(
                caption: 'Edit',
                color: Colors.green,
                icon: Icons.mode_edit,
                onTap: () {
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (context) => new FormAkunEditSemua(
                        dIdAdmin: databerita[i]["no"],
                        dNama: databerita[i]["nama"],
                        dHp: databerita[i]["hp"],
                        dEmail: databerita[i]["email"],
                        dUsername: databerita[i]["user_name"],
                        dStatus: databerita[i]["status"],
                      ),
                    ),
                  );
                },
              ),
              /*IconSlideAction(
                caption: 'Lihat',
                color: Colors.blue,
                icon: Icons.remove_red_eye,
                onTap: () {},
              ),*/
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Hapus',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
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
          );
        } else if (databerita[i]["status"] == 'Not Found') {
          return new Container(
            child: Center(
              child: new Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: new Icon(Icons.people,
                        size: 50.0, color: Colors.grey[350]),
                  ),
                  new Text(
                    "Belum ada penulis",
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[350],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget cardAkun() {
    return Container(
      padding: new EdgeInsets.all(5.0),
      width: SizeConfig.safeBlockHorizontal * 100,
      height: SizeConfig.safeBlockVertical * 20,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     Color(0xFFee002d),
        //     Color(0xFFe3002a),
        //     Color(0xFFd90028),
        //     Color(0xFFcc0025),
        //   ],
        //   stops: [0.1, 0.4, 0.7, 0.9],
        // ),
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
            padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/images/penulis.png',
                  width: SizeConfig.safeBlockHorizontal * 30,
                  height: SizeConfig.safeBlockVertical * 30,
                ),
                SizedBox(width: SizeConfig.safeBlockHorizontal * 3),
                new Column(
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
                /*new Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Kelola admin dan penulis',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '- Buatkan user untuk admin dan penulis',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                      ),
                      Text(
                        '- 2 admin dan 3 penulis',
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.brown[800], //change your color here
        ),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Kelola Akun',
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_add),
            color: Color(0xFF2e2e2e),
            iconSize: 20.0,
            onPressed: () {
              Navigator.pushNamed(context, '/FormAddAkun');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: new EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              //_admin(),
              cardAkun(),
              _penulis(),
            ],
          ),
        ),
      ),
    );
  }
}
