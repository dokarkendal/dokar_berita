import 'package:auto_size_text/auto_size_text.dart';
import 'package:dokar_aplikasi/akun/hal_profil_desa.dart';
import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';

import 'package:shimmer/shimmer.dart';

class ListDesa extends StatefulWidget {
  final String dNama, dId;
  ListDesa({this.dNama, this.dId});

  @override
  _ListDesaState createState() => _ListDesaState();
}

class _ListDesaState extends State<ListDesa> {
  List dataJSON;
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
  Future<String> ambildata() async {
    setState(() {
      isLoading = true;
    });
    //SharedPreferences pref = await SharedPreferences.getInstance();
    http.Response hasil = await http.get(
        Uri.encodeFull(
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
        title: Text('${widget.dNama}'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isLoading
          ? _buildProgressIndicator()
          : Container(
              padding: new EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
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
            (MediaQuery.of(context).size.height / 7),
      ),
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: dataJSON == null ? 0 : dataJSON.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(3.0),
          child: FlatButton(
            color: Colors.blue[800],
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0),
            ),
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
                    ),
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
      padding: new EdgeInsets.only(left: mediaQueryData.size.height * 0.05),
      width: mediaQueryData.size.width,
      height: mediaQueryData.size.height * 0.2,
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
        children: <Widget>[
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'assets/images/desa1.png',
                width: mediaQueryData.size.width * 0.25,
                height: mediaQueryData.size.height * 0.25,
              ),
              SizedBox(width: SizeConfig.safeBlockHorizontal * 3),
              Padding(
                padding:
                    EdgeInsets.only(top: mediaQueryData.size.height * 0.05),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AutoSizeText(
                      'Daftar Desa',
                      minFontSize: 2,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AutoSizeText(
                      'KEC. ' + '${widget.dNama}',
                      minFontSize: 10,
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    ),
                    AutoSizeText(
                      'KABUPATEN KENDAL',
                      minFontSize: 10,
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
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
        baseColor: Colors.grey[300],
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
                    height: mediaQueryData.size.height * 0.25,
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
