import 'package:auto_size_text/auto_size_text.dart';
import 'package:dokar_aplikasi/akun/hal_profil_desa.dart';
import 'package:dokar_aplikasi/style/size_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';

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
    //SharedPreferences pref = await SharedPreferences.getInstance();
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "http://dokar.kendalkab.go.id/webservice/android/dashbord/desa/${widget.dId}/"),
        headers: {"Accept": "application/json"});

    this.setState(
      () {
        dataJSON = json.decode(hasil.body);
        print(id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.dNama}'),
        backgroundColor: Color(0xFFee002d),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: new EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              cardDesa(),
              SizedBox(height: 10.0),
              _listDesa(),
            ],
          ),
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
            color: Colors.blue,
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
                  child: Text(dataJSON[index]["desa"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.0),
                      textAlign: TextAlign.center),
                )),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 12,
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
    return Container(
      padding: new EdgeInsets.all(5.0),
      width: SizeConfig.safeBlockHorizontal * 100,
      height: SizeConfig.safeBlockVertical * 20,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2167c1),
            Color(0xFF0d6dc4),
            Color(0xFF1686c7),
            Color(0xFF2c94cd),
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
                  'assets/images/desa1.png',
                  width: SizeConfig.safeBlockHorizontal * 30,
                  height: SizeConfig.safeBlockVertical * 30,
                ),
                SizedBox(width: SizeConfig.safeBlockHorizontal * 3),
                new Column(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
