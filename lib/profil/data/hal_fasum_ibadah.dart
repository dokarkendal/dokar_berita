import 'package:dokar_aplikasi/profil/data/hal_fasum_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';

class HalFasumIbadah extends StatefulWidget {
  final String dNama, dId, idDesa;
  HalFasumIbadah({this.dNama, this.dId, this.idDesa});
  @override
  _HalFasumIbadahState createState() => _HalFasumIbadahState();
}

class _HalFasumIbadahState extends State<HalFasumIbadah> {
  List dataJSON;
  String id = '';

  @override
  void initState() {
    super.initState();
    id = "${widget.dId}";
    ambildata();
  }

  // ignore: missing_return
  Future<String> ambildata() async {
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "http://dokar.kendalkab.go.id/webservice/android/dashbord/kategorifasum/" +
                id),
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
        title: Text('RUMAH IBADAH'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: dataJSON == null ? 0 : dataJSON.length,
          itemBuilder: (context, index) {
            return new Container(
              color: Colors.grey[100],
              padding: EdgeInsets.only(
                left: 5.0,
                right: 5.0,
              ),
              child: new Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HalFasumDetail(
                            dNama: dataJSON[index]["nama"],
                            dId: dataJSON[index]["id"],
                            idDesa: "${widget.idDesa}"),
                      ),
                    );
                  },
                  child: ListTile(
                    /*subtitle: Row(
                              children: <Widget>[
                                new Text(
                                  dataJSON[index]["kabar_tanggal"],
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                new Text(
                                  dataJSON[index]["kabar_kategori"],
                                ),
                              ],
                            ),*/
                    title: new Text(
                      dataJSON[index]["nama"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
            );
          },
        ),
      ),
    );
  }
}
