import 'package:cached_network_image/cached_network_image.dart';
import 'package:dokar_aplikasi/profil/data/hal_fasum_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //api
import 'dart:async'; // api syn
import 'dart:convert';

import '../../style/styleset.dart';

class HalFasumDetail extends StatefulWidget {
  final String dNama, dId, idDesa;
  HalFasumDetail({this.dNama, this.dId, this.idDesa});

  @override
  _HalFasumDetailState createState() => _HalFasumDetailState();
}

class _HalFasumDetailState extends State<HalFasumDetail> {
  List dataJSON;
  String id = '';
  String nama = '';

  @override
  void initState() {
    super.initState();
    id = "${widget.dId}";
    nama = "${widget.dNama}";
    ambildata();
  }

  // ignore: missing_return
  Future<String> ambildata() async {
    //SharedPreferences pref = await SharedPreferences.getInstance();
    http.Response hasil = await http.get(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/dashbord/fasilitasumum/${widget.idDesa}/" +
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
      // appBar: AppBar(
      //   title: Text(
      //     '${widget.dNama}'.toUpperCase(),
      //   ),
      //   centerTitle: true,
      //   elevation: 0,
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          // ignore: unnecessary_brace_in_string_interps
          '${widget.dNama}'.toUpperCase(),
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: dataJSON == null ? 0 : dataJSON.length,
          itemBuilder: (context, index) {
            if (dataJSON[index]["nama"] == 'NotFound') {
              return Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(100.0),
                      ),
                      Text(
                        "DATA KOSONG",
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.grey[350],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                      ),
                      Icon(Icons.notes_sharp,
                          size: 150.0, color: Colors.grey[350]),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                color: Colors.grey[100],
                padding: EdgeInsets.only(
                  left: 5.0,
                  right: 5.0,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HalFasumDetailPage(
                            dNama: dataJSON[index]["nama"],
                            dId: dataJSON[index]["id"],
                            dJenis: dataJSON[index]["jenis"],
                            dKategori: dataJSON[index]["kategori"],
                            dGambar: dataJSON[index]["gambar"],
                            dDeskripsi: dataJSON[index]["deskripsi"],
                            dAlamat: dataJSON[index]["alamat"],
                            dDesa: dataJSON[index]["desa"],
                            dKecamatan: dataJSON[index]["kecamatan"],
                            dKoordinat: dataJSON[index]["koordinat"],
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
                          child: CachedNetworkImage(
                            imageUrl: dataJSON[index]["gambar"],
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/load.png",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            fit: BoxFit.cover,
                            height: 150.0,
                            width: 110.0,
                          ),
                        ),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Text(
                            dataJSON[index]["jenis"],
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          Flexible(
                            child: Text(
                              dataJSON[index]["kategori"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      title: Text(
                        dataJSON[index]["nama"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
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
            }
          },
        ),
      ),
    );
  }
}
