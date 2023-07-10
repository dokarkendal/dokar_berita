import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../style/styleset.dart';
import 'package:badges/badges.dart' as badges;

class HalAkun extends StatefulWidget {
  @override
  _HalAkunState createState() => _HalAkunState();
}

class _HalAkunState extends State<HalAkun> {
  late String? nama = "";
  late String? email = "";
  late String? hp = "";
  late String? username = "";
  String kecamatan = "";
  String namadesa = "";
  String notifStatus = '';
  String token = '';
  String topik = '';
  String website = '';
  String expired = '';
  String desaid = '';

  bool loadingdata = false;

  Future<void> detailAkun(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      loadingdata = true;
    });
    final response = await http.post(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/account/detail"),
      body: {
        "IdAdmin": pref.getString("IdAdmin"),
      },
    );
    var detailakun = json.decode(response.body);
    if (mounted) {
      setState(
        () {
          loadingdata = false;
          nama = detailakun['nama']!;
          email = detailakun['email'];
          hp = detailakun['hp'];
          username = detailakun['username'];
          kecamatan = pref.getString("kecamatan")!;
          namadesa = pref.getString("desa")!;
          website = pref.getString("website")!;
          expired = pref.getString("expired")!;
          desaid = pref.getString("desaid")!;
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    detailAkun(context);
    cekNotif();
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

  void cekNotif() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(
      () {
        notifStatus = pref.getString("NotifStatus")!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        // centerTitle: true,
        title: Text(
          "AKUN",
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
            // fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            iconSize: 23.0,
            onPressed: () async {
              Navigator.pushNamed(context, '/Version');
            },
          )
        ],
      ),
      body: loadingdata
          ? _buildProgressIndicator()
          : Container(
              color: Colors.grey.shade200,
              child: ListView(
                children: [
                  // cardAkun(),
                  _content(),
                  _website(),
                  // buttonEdit(),
                  // SizedBox(
                  //   height: 20.0,
                  // ),
                ],
              )
              // children: <Widget>[
              //   Container(
              //     padding: EdgeInsets.all(10),
              //     child: Column(
              //       children: <Widget>[
              //         cardAkun(),
              //         // Divider(),
              //         _content(),
              //         // namaEdit(),
              //         // Divider(
              //         //     // thickness: 0.1,
              //         //     // height: null,
              //         //     ),
              //         // emailEdit(),
              //         // Divider(),
              //         // hpEdit(),
              //         // Divider(),
              //         // usernameEdit(),
              //         // Divider(),
              //         // passwordEdit(),
              //         // Divider(),
              //         // buttonEdit(),
              //         // Text(website)
              //       ],
              //     ),
              //   ),

              //   Container(
              //     width: 300.00,
              //   ),
              // ],
              ),
    );
  }

  Widget namaEdit() {
    return InkWell(
      onTap: () {
        /*Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => new FormBeritaDashbord(),
            ),
          );*/
      },
      child: ListTile(
        leading: Icon(
          Icons.home,
          size: 30.0,
        ),
        title: new Text(
          "Nama Orang",
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: nama == null
            ? Text(
                "memuat..",
                style: new TextStyle(
                  fontSize: 14.0,
                  color: Colors.blue[800],
                ),
              )
            : Text(
                "$nama",
                style: new TextStyle(
                  fontSize: 14.0,
                  color: Colors.blue[800],
                ),
              ),
        dense: true,
        // contentPadding: EdgeInsets.zero,
        /*trailing:
            Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black),*/
      ),
    );
  }

  // Widget usernameEdit() {
  //   return InkWell(
  //     onTap: () {
  //       /*Navigator.of(context).push(
  //           new MaterialPageRoute(
  //             builder: (context) => new FormBeritaDashbord(),
  //           ),
  //         );*/
  //     },
  //     child: ListTile(
  //       leading: Icon(
  //         Icons.supervised_user_circle,
  //         size: 30.0,
  //       ),
  //       title: new Text(
  //         "Username",
  //         style: new TextStyle(
  //           fontSize: 16.0,
  //           color: Colors.black,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       subtitle: username == null
  //           ? Text(
  //               "memuat..",
  //               style: new TextStyle(
  //                 fontSize: 14.0,
  //                 color: Colors.blue[800],
  //               ),
  //             )
  //           : Text(
  //               "$username",
  //               style: new TextStyle(
  //                 fontSize: 14.0,
  //                 color: Colors.blue[800],
  //               ),
  //             ),
  //       dense: true,
  //       /*trailing:
  //           Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black),*/
  //     ),
  //   );
  // }
  Widget usernameEdit() {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Username",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: username == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$username",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            ),
    );
  }

  Widget emailEdit() {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.mail,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Email",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: email == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$email",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            ),
    );
    // return InkWell(
    //   onTap: () {
    //     /*Navigator.of(context).push(
    //         new MaterialPageRoute(
    //           builder: (context) => new FormBeritaDashbord(),
    //         ),
    //       );*/
    //   },
    //   child: ListTile(
    //     leading: Icon(
    //       Icons.email,
    //       size: 30.0,
    //     ),
    //     title: new Text(
    //       "Email",
    //       style: new TextStyle(
    //         fontSize: 16.0,
    //         color: Colors.black,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     subtitle: email == null
    //         ? Text(
    //             "memuat..",
    //             style: new TextStyle(
    //               fontSize: 14.0,
    //               color: Colors.blue[800],
    //             ),
    //           )
    //         : Text(
    //             "$email",
    //             style: new TextStyle(
    //               fontSize: 14.0,
    //               color: Colors.blue[800],
    //             ),
    //           ),
    //     dense: true,
    //   ),
    // );
  }

  Widget hpEdit() {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.phone,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Phone",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: hp == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$hp",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            ),
    );
    // return InkWell(
    //   onTap: () {},
    //   child: ListTile(
    //     leading: Icon(
    //       Icons.phone_android,
    //       size: 30.0,
    //     ),
    //     title: new Text(
    //       "No. Tlp",
    //       style: new TextStyle(
    //         fontSize: 16.0,
    //         color: Colors.black,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     subtitle: hp == null
    //         ? Text(
    //             "memuat..",
    //             style: new TextStyle(
    //               fontSize: 14.0,
    //               color: Colors.blue[800],
    //             ),
    //           )
    //         : Text(
    //             "$hp",
    //             style: new TextStyle(
    //               fontSize: 14.0,
    //               color: Colors.blue[800],
    //             ),
    //           ),
    //     dense: true,
    //   ),
    // );
  }

  Widget websiteEdit() {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.language,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Website",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: website.isEmpty
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$website",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            ),
    );
    // return InkWell(
    //   onTap: () {},
    //   child: ListTile(
    //     leading: Icon(
    //       Icons.phone_android,
    //       size: 30.0,
    //     ),
    //     title: new Text(
    //       "No. Tlp",
    //       style: new TextStyle(
    //         fontSize: 16.0,
    //         color: Colors.black,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     subtitle: hp == null
    //         ? Text(
    //             "memuat..",
    //             style: new TextStyle(
    //               fontSize: 14.0,
    //               color: Colors.blue[800],
    //             ),
    //           )
    //         : Text(
    //             "$hp",
    //             style: new TextStyle(
    //               fontSize: 14.0,
    //               color: Colors.blue[800],
    //             ),
    //           ),
    //     dense: true,
    //   ),
    // );
  }

  Widget expiredEdit() {
    var expireddate;
    if (expired == "") {
      expireddate = Text(
        "-",
        style: new TextStyle(
          fontSize: 14.0,
          color: Colors.blue[800],
        ),
      );
    } else {
      expireddate = Text(
        "$expired",
        style: new TextStyle(
          fontSize: 14.0,
          color: Colors.blue[800],
        ),
      );
    }
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Expired",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: expired.isEmpty
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            )
          : expireddate,
    );
    // return InkWell(
    //   onTap: () {},
    //   child: ListTile(
    //     leading: Icon(
    //       Icons.phone_android,
    //       size: 30.0,
    //     ),
    //     title: new Text(
    //       "No. Tlp",
    //       style: new TextStyle(
    //         fontSize: 16.0,
    //         color: Colors.black,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     subtitle: hp == null
    //         ? Text(
    //             "memuat..",
    //             style: new TextStyle(
    //               fontSize: 14.0,
    //               color: Colors.blue[800],
    //             ),
    //           )
    //         : Text(
    //             "$hp",
    //             style: new TextStyle(
    //               fontSize: 14.0,
    //               color: Colors.blue[800],
    //             ),
    //           ),
    //     dense: true,
    //   ),
    // );
  }

  Widget domainEdit() {
    var domain;
    if (desaid == "0") {
      domain = Text(
        "kendalkab.go.id",
        style: new TextStyle(
          fontSize: 14.0,
          color: Colors.blue[800],
        ),
      );
    } else {
      domain = Row(
        children: [
          Text(
            "desa.id ",
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.blue[800],
            ),
          ),
          badges.Badge(
            position: badges.BadgePosition.center(),
            badgeContent: Icon(
              Icons.check,
              size: 9,
              color: Colors.white,
            ),
            badgeStyle: badges.BadgeStyle(
              badgeColor: Colors.blue,
              shape: badges.BadgeShape.twitter,
            ),
          ),
        ],
      );
    }
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.http,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Domain",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: desaid.isEmpty
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.blue[800],
              ),
            )
          : domain,
    );
    // return InkWell(
    //   onTap: () {},
    //   child: ListTile(
    //     leading: Icon(
    //       Icons.language,
    //       size: 30.0,
    //     ),
    //     title: new Text(
    //       "Expired Domain",
    //       style: new TextStyle(
    //         fontSize: 16.0,
    //         color: Colors.black,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     subtitle: expired.isEmpty
    //         ? Text(
    //             "-",
    //             style: new TextStyle(
    //               fontSize: 14.0,
    //               color: Colors.blue[800],
    //             ),
    //           )
    //         : Text(
    //             expired,
    //             style: new TextStyle(
    //               fontSize: 14.0,
    //               color: Colors.blue[800],
    //             ),
    //           ),
    //     dense: true,
    //   ),
    // );
  }

  Widget _content() {
    return Container(
      padding: const EdgeInsets.all(3),
      child: Column(
        children: [
          cardAkun(),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _akuntext(),
                      usernameEdit(),
                      _dividerHeight1(),
                      emailEdit(),
                      _dividerHeight1(),
                      hpEdit(),
                      // _dividerHeight1(),
                      // domainEdit(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _website() {
    return Container(
      padding: const EdgeInsets.all(3),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _websitetext(),
                  websiteEdit(),
                  _dividerHeight1(),
                  domainEdit(),
                  _dividerHeight1(),
                  expiredEdit(),
                  // hpEdit(),
                  // _dividerHeight1(),
                  // domainEdit(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dividerHeight1() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _akuntext() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(
        "Akun",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _websitetext() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(
        "Website",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget buttonEdit() {
    return loadingdata
        ? SizedBox()
        : Container(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 15,
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 18,
                ),
                label: Text(
                  "EDIT AKUN",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/FormAkunEdit');
                },
                style: ElevatedButton.styleFrom(
                  // padding: EdgeInsets.all(15.0),
                  elevation: 0, backgroundColor: Colors.blue[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // <-- Radius
                  ),
                ),
                // color: Colors.blue[800],
                // textColor: Colors.white,
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(10.0),
                // ),
              ),
            ),
          );
  }

  Widget cardAkun() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Card(
      color: Theme.of(context).primaryColor,

      // width: mediaQueryData.size.width * 1,
      // height: mediaQueryData.size.height * 0.1,
      // decoration: BoxDecoration(
      //   color: Theme.of(context).primaryColor,
      //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
      //   boxShadow: [
      //     BoxShadow(
      //         color: Colors.black.withOpacity(0.1),
      //         offset: Offset(0.0, 3.0),
      //         blurRadius: 15.0)
      //   ],
      // ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/logos/logokendal.png',
                  width: mediaQueryData.size.width * 0.13,
                  height: mediaQueryData.size.height * 0.13,
                ),
                SizedBox(width: mediaQueryData.size.width * 0.05),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AutoSizeText(
                      "Desa " + namadesa,
                      minFontSize: 2,
                      maxLines: 2,
                      style: TextStyle(
                        color: Color(0xFF2e2e2e),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AutoSizeText(
                      "Kec. " + kecamatan.toLowerCase(),
                      minFontSize: 2,
                      maxLines: 2,
                      style: TextStyle(
                        color: Color(0xFF2e2e2e),
                        fontSize: 16.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    AutoSizeText(
                      "Kab. Kendal ",
                      minFontSize: 2,
                      maxLines: 2,
                      style: TextStyle(
                        color: Color(0xFF2e2e2e),
                        fontSize: 16.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    // AutoSizeText(
                    //   '- Edit informasi akun',
                    //   minFontSize: 10,
                    //   style: TextStyle(
                    //     color: Color(0xFF2e2e2e),
                    //     fontSize: 14.0,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // Add your button press logic here
              Navigator.pushNamed(context, '/FormAkunEdit');
            },
            child: Text(
              'Ubah',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
