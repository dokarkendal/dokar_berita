import 'package:auto_size_text/auto_size_text.dart';
import 'package:dokar_aplikasi/berita/list/hal_list_desa.dart';
import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';

class ListKecamatan extends StatefulWidget {
  final String idDesa;

  ListKecamatan({this.idDesa});

  @override
  _ListKecamatanState createState() => _ListKecamatanState();
}

class _ListKecamatanState extends State<ListKecamatan> {
  ScrollController _scrollController = new ScrollController();
  GlobalKey<RefreshIndicatorState> refreshKey;
  bool isLoading = false;
  List dataJSON;

  // ignore: missing_return
  Future<String> ambildata() async {
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "http://dokar.kendalkab.go.id/webservice/android/dashbord/kecamatan"),
        headers: {"Accept": "application/json"});
    this.setState(
      () {
        dataJSON = json.decode(hasil.body);
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
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('List Kecamatan'),
        backgroundColor: Color(0xFFee002d),
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
        child: OfflineBuilder(
          connectivityBuilder: (BuildContext context,
              ConnectivityResult connectivity, Widget child) {
            final bool connected = connectivity != ConnectivityResult.none;
            return Stack(
              fit: StackFit.expand,
              children: [
                child,
                Positioned(
                  left: 0.0,
                  right: 0.0,
                  height: 32.0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    color: connected ? null : Colors.orange,
                    child: connected
                        ? null
                        : Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Periksa jaringan internet",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                SizedBox(
                                  width: 12.0,
                                  height: 12.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            );
          },
          child: new Container(
            child: Container(
              padding: new EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  cardKecamatan(),
                  SizedBox(height: 10.0),
                  Expanded(
                    //child: cardKecamatan(),
                    child: _listkecamatan(),
                  )
                ],
              ),
            ),
          ),
        ),

        /*SingleChildScrollView(
        child: Container(
          padding: new EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              cardKecamatan(),
              SizedBox(height: 10.0),
              _listkecamatan(),
            ],
          ),
        ),
      ),*/
      ),
    );
  }

  Widget _listkecamatan() {
    return GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
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
          child: FlatButton(
            color: Color(0xFFee002d),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(dataJSON[index]["kecamatan"],
                  style: TextStyle(fontSize: 12.0),
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
    return Container(
      padding: new EdgeInsets.all(5.0),
      width: SizeConfig.safeBlockHorizontal * 100,
      height: SizeConfig.safeBlockVertical * 20,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFee002d),
            Color(0xFFe3002a),
            Color(0xFFd90028),
            Color(0xFFcc0025),
          ],
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
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
            padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/images/kecamatan1.png',
                  width: SizeConfig.safeBlockHorizontal * 30,
                  height: SizeConfig.safeBlockVertical * 30,
                ),
                SizedBox(width: SizeConfig.safeBlockHorizontal * 3),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AutoSizeText(
                      'Daftar Kecamatan',
                      minFontSize: 2,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AutoSizeText(
                      'Di KABUPATEN KENDAL',
                      minFontSize: 10,
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
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
}
