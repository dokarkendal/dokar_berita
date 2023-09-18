import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'detail_page_ppid.dart';

// ignore: must_be_immutable
class HalSearchPPID extends StatefulWidget {
  String value, tahun, idDesa, namaDesa;
  HalSearchPPID({
    this.value = 'text',
    this.tahun = 'text',
    required this.idDesa,
    required this.namaDesa,
  });

  @override
  State<HalSearchPPID> createState() => _HalSearchPPIDState(value, tahun);
}

class _HalSearchPPIDState extends State<HalSearchPPID> {
  ScrollController _scrollController = ScrollController();
  late List filterPPID = [];
  String value;
  String tahun;
  _HalSearchPPIDState(this.value, this.tahun);
  bool isLoading = false;
  Future<void> searchPPID() async {
    setState(
      () {
        isLoading = true;
      },
    );
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/ppid/search/${widget.idDesa}/"),
        body: {
          "search": "${widget.value}",
          "tahun": "${widget.tahun}",
        });
    if (mounted) {
      setState(
        () {
          isLoading = false;
          filterPPID = json.decode(response.body)['result'];
          print(filterPPID);
          print(Uri.base);
        },
      );
    }

    print(filterPPID);
  }

  @override
  void initState() {
    searchPPID();
    super.initState();
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
          "HASIL " + "' " + "$value" + " '" + " ${widget.tahun}",
          style: TextStyle(
            color: Colors.brown[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        //scrollDirection: Axis.horizontal,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: filterPPID.length + 1, //NOTE if else listview berita
        // ignore: missing_return
        itemBuilder: (BuildContext context, int i) {
          if (i == filterPPID.length) {
            return _buildProgressIndicator();
          } else {
            if (filterPPID[i]["id"] == 'Notfound') {
              return Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: mediaQueryData.size.height * 0.2,
                      ),
                    ),
                    Text(
                      "PPID Kosong",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.grey[350],
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.all(5.0),
                    // ),
                    Icon(Icons.notes_rounded,
                        size: 150.0, color: Colors.grey[350]),
                  ],
                ),
              );
            } else {
              return Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 1.0,
                color: Colors.white,
                child: ListTile(
                  dense: true,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailPagePPID(
                          dkategori: filterPPID[i]["kategori"],
                          djudul: filterPPID[i]["judul"],
                          ddeskripsi: filterPPID[i]["deskripsi"],
                          dtanggal: filterPPID[i]["tanggal"],
                          pdfPath: filterPPID[i]["file"],
                          dNamadesa: "${widget.namaDesa}",
                        ),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.notes_rounded,
                    size: 35, // Replace with the desired icon
                    color: Colors.grey, // Replace with the desired icon color
                  ),
                  title: Text(
                    filterPPID[i]["judul"],
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // subtitle: Text(
                  //   filterPPID[i]["kategori"],
                  //   style: TextStyle(
                  //     color: Colors.grey[500],
                  //     fontSize: 12.0,
                  //   ),
                  // ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        filterPPID[i]["kategori"],
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12.0,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                              mediaQueryData.size.height * 0.005,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0)),
                            ),
                            // margin: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              filterPPID[i]["tahun"],
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 10.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: mediaQueryData.size.width * 0.01,
                          ),
                          filterPPID[i]["file"] == "-"
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.all(
                                    mediaQueryData.size.height * 0.005,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                  ),
                                  // margin: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    "PDF",
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
