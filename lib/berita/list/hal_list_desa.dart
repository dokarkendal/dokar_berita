import 'package:auto_size_text/auto_size_text.dart';
import 'package:dokar_aplikasi/akun/hal_profil_desa.dart';
// import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';

import 'package:shimmer/shimmer.dart';

class ListDesa extends StatefulWidget {
  final String dNama, dId;
  ListDesa({required this.dNama, required this.dId});

  @override
  _ListDesaState createState() => _ListDesaState();
}

class _ListDesaState extends State<ListDesa> {
  late List dataJSON;
  String id = '';
  String kecamatan = '';
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    id = "${widget.dId}";
    kecamatan = "${widget.dNama}";
    ambildata();
    print("${widget.dId}");
  }

  // ignore: missing_return
  Future<void> ambildata() async {
    setState(() {
      isLoading = true;
    });
    //SharedPreferences pref = await SharedPreferences.getInstance();
    http.Response hasil = await http.get(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/dashbord/desa/${widget.dId}/"),
        headers: {"Accept": "application/json"});

    this.setState(
      () {
        dataJSON = json.decode(hasil.body);
        isLoading = false;
        print(id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.brown[800], //change your color here
        ),
        title: Text(
          "KECAMATAN " + '${widget.dNama}',
          style: TextStyle(
            color: Colors.brown[800],
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isLoading
          ? _buildProgressIndicator()
          : Container(
              padding: new EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  cardDesa(),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: _listDesa(),
                  )
                ],
              ),
            ),
    );
  }

  Widget _listDesa() {
    return GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 8),
      ),
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: dataJSON == null ? 0 : dataJSON.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(3.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              // padding: EdgeInsets.all(15.0),
              elevation: 0, backgroundColor: Colors.blue[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // <-- Radius
              ),
            ),
            // color: Colors.blue[800],
            // textColor: Colors.white,
            // shape: RoundedRectangleBorder(
            //   borderRadius: new BorderRadius.circular(5.0),
            // ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    dataJSON[index]["desa"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 13,
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilDesa(
                    id: dataJSON[index]["id"],
                    desa: dataJSON[index]["desa"],
                    kecamatan: "${widget.dNama}",
                    title: '',
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget cardDesa() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      // padding: new EdgeInsets.only(left: mediaQueryData.size.height * 0.05),
      width: mediaQueryData.size.width,
      height: mediaQueryData.size.height * 0.15,
      decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     Color(0xFF2167c1),
        //     Color(0xFF0d6dc4),
        //     Color(0xFF1686c7),
        //     Color(0xFF2c94cd),
        //   ],
        //   stops: [0.1, 0.4, 0.7, 0.9],
        // ),
        color: Colors.blue[800],
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0.0, 3.0),
              blurRadius: 15.0)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Image.asset(
              //   'assets/logos/logokendal.png',
              //   width: mediaQueryData.size.width * 0.20,
              //   height: mediaQueryData.size.height * 0.20,
              // ),
              SizedBox(width: mediaQueryData.size.width * 0.04),
              Padding(
                padding:
                    EdgeInsets.only(top: mediaQueryData.size.height * 0.01),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AutoSizeText(
                      'DAFTAR DESA',
                      minFontSize: 2,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    AutoSizeText(
                      'KEC. ' + '${widget.dNama}',
                      minFontSize: 10,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                    AutoSizeText(
                      'KABUPATEN KENDAL',
                      minFontSize: 10,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // SizeConfig().init(context);
    return Padding(
      padding: new EdgeInsets.all(1.0),
      child: Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        highlightColor: Colors.white,
        baseColor: Colors.grey[300]!,
        child: Container(
          padding: new EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey,
                    ),
                    height: mediaQueryData.size.height * 0.16,
                    width: mediaQueryData.size.width,
                    // color: Colors.grey,
                  ),

                  // Row(
                ],
              ),
              SizedBox(height: mediaQueryData.size.height * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                      SizedBox(width: mediaQueryData.size.height * 0.01),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: mediaQueryData.size.height * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                      SizedBox(width: mediaQueryData.size.height * 0.01),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: mediaQueryData.size.height * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                      SizedBox(width: mediaQueryData.size.height * 0.01),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: mediaQueryData.size.height * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                      SizedBox(width: mediaQueryData.size.height * 0.01),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: mediaQueryData.size.height * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                      SizedBox(width: mediaQueryData.size.height * 0.01),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: mediaQueryData.size.height * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                      SizedBox(width: mediaQueryData.size.height * 0.01),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: mediaQueryData.size.height * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                      SizedBox(width: mediaQueryData.size.height * 0.01),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: mediaQueryData.size.height * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                      SizedBox(width: mediaQueryData.size.height * 0.01),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: mediaQueryData.size.height * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                      SizedBox(width: mediaQueryData.size.height * 0.01),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey,
                        ),
                        height: mediaQueryData.size.height * 0.05,
                        width: mediaQueryData.size.width * 0.47,
                        // color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
