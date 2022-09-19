import 'package:auto_size_text/auto_size_text.dart';
import 'package:dokar_aplikasi/berita/list/hal_list_desa.dart';
import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

class ListKecamatan extends StatefulWidget {
  final String idDesa;

  ListKecamatan({this.idDesa});

  @override
  _ListKecamatanState createState() => _ListKecamatanState();
}

class _ListKecamatanState extends State<ListKecamatan> {
  ScrollController _scrollController = ScrollController();
  GlobalKey<RefreshIndicatorState> refreshKey;
  bool isLoading = false;
  List dataJSON;

  Future ambildata() async {
    setState(() {
      isLoading = true;
    });
    http.Response hasil = await http.get(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/dashbord/kecamatan"),
        headers: {"Accept": "application/json"});
    this.setState(
      () {
        dataJSON = json.decode(hasil.body);
        isLoading = false;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    ambildata();
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _listkecamatan();
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.brown[800], //change your color here
        ),
        title: Text(
          'DOKAR',
          style: TextStyle(
            color: Colors.brown[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await Future.delayed(
            Duration(seconds: 2),
            () {
              Navigator.pushReplacementNamed(context, '/ListKecamatan');
            },
          );
        },
        child: isLoading
            ? _buildProgressIndicator()
            : Container(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.01),
                    ),
                    cardKecamatan(),
                    Padding(
                      padding: EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.01),
                    ),
                    Expanded(
                      child: _listkecamatan(),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        highlightColor: Colors.white,
        baseColor: Colors.grey[300],
        child: Container(
          padding: EdgeInsets.all(5.0),
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

  Widget _listkecamatan() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 8),
      ),
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: dataJSON == null ? 0 : dataJSON.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(3.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(15.0),
              elevation: 2.0,
              primary: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // <-- Radius
              ),
            ),
            // color: Theme.of(context).primaryColor,
            // textColor: Colors.white,
            // shape: RoundedRectangleBorder(
            //   borderRadius:  BorderRadius.circular(5.0),
            // ),
            child: Align(
              alignment: Alignment.center,
              child: Text(dataJSON[index]["kecamatan"],
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.brown[800],
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListDesa(
                    dNama: dataJSON[index]["kecamatan"],
                    dId: dataJSON[index]["id"],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget cardKecamatan() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(left: mediaQueryData.size.height * 0.05),
      width: mediaQueryData.size.width,
      height: mediaQueryData.size.height * 0.2,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0.0, 3.0),
              blurRadius: 15.0)
        ],
      ),
      child: Row(
        children: <Widget>[
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'assets/images/kecamatan1.png',
                width: mediaQueryData.size.width * 0.25,
                height: mediaQueryData.size.height * 0.25,
              ),
              SizedBox(width: SizeConfig.safeBlockHorizontal * 3),
              Padding(
                padding:
                    EdgeInsets.only(top: mediaQueryData.size.height * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AutoSizeText(
                      'Daftar Kecamatan',
                      minFontSize: 2,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.brown[800],
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AutoSizeText(
                      'Di KABUPATEN KENDAL',
                      minFontSize: 10,
                      style: TextStyle(
                        color: Colors.brown[800],
                        fontSize: 14.0,
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
}
