import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../detail_page_ppid.dart';

class HalPPIDList extends StatefulWidget {
  final String idDesa, namaDesa, idKategori, namaKategori;

  HalPPIDList({
    required this.idDesa,
    required this.namaDesa,
    required this.idKategori,
    required this.namaKategori,
  });

  @override
  State<HalPPIDList> createState() => _HalPPIDListState();
}

class _HalPPIDListState extends State<HalPPIDList> {
  ScrollController _scrollController = ScrollController();
  List dataPPID = [];
  bool isLoading = false;
  final dio = Dio();
  late String dibaca;
  late List dataJSON;

  String nextPage =
      "http://dokar.kendalkab.go.id/webservice/android/ppid/getbyiddesa";

  void _getMoreData() async {
    //NOTE if else load more
    //SharedPreferences pref = await SharedPreferences.getInstance();

    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      print(nextPage);
      final response = await dio
          .get(nextPage + "/${widget.idDesa}" + "/" + "${widget.idKategori}/");
      List tempList = [];
      nextPage = response.data['next'];
      print(response.toString());
      for (int i = 0; i < response.data['result'].length; i++) {
        tempList.add(response.data['result'][i]);
      }

      if (mounted) {
        setState(
          () {
            isLoading = false;
            dataPPID.addAll(tempList);
            print(tempList);
            print("${widget.idDesa}");
            print("${widget.idKategori}");
          },
        );
      }
    }
  }

  @override
  void initState() {
    //this.getBerita();
    this._getMoreData();
    super.initState();
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _getMoreData();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('${widget.idDesa}' + '${widget.idKategori}'),
      // ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.brown[800], //change your color here
        ),
        title: Text(
          'PPID ' + "${widget.namaDesa}",
          style: TextStyle(
            color: Colors.brown[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: [
          headerPPID(),
          ListView.builder(
            //scrollDirection: Axis.horizontal,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: dataPPID.length + 1, //NOTE if else listview berita
            // ignore: missing_return
            itemBuilder: (BuildContext context, int i) {
              if (i == dataPPID.length) {
                return _buildProgressIndicator();
              } else {
                if (dataPPID[i]["id"] == 'Notfound') {
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
                              dkategori: dataPPID[i]["kategori"],
                              djudul: dataPPID[i]["judul"],
                              ddeskripsi: dataPPID[i]["deskripsi"],
                              dtanggal: dataPPID[i]["tanggal"],
                              pdfPath: dataPPID[i]["file"],
                              dNamadesa: "${widget.namaDesa}",
                            ),
                          ),
                        );
                      },
                      leading: Icon(
                        Icons.notes_rounded,
                        size: 35, // Replace with the desired icon
                        color:
                            Colors.grey, // Replace with the desired icon color
                      ),
                      title: Text(
                        dataPPID[i]["judul"],
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dataPPID[i]["kategori"],
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
                                  dataPPID[i]["tahun"],
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: mediaQueryData.size.width * 0.01,
                              ),
                              dataPPID[i]["file"] == "-"
                                  ? Container()
                                  : Container(
                                      padding: EdgeInsets.all(
                                        mediaQueryData.size.height * 0.005,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3.0)),
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
        ],
      ),
    );
  }

  Widget headerPPID() {
    final mediaQueryData = MediaQuery.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0.0, 1.0),
              blurRadius: 3.0),
        ],
      ),
      child: Stack(
        children: [
          SizedBox(
            width: mediaQueryData.size.width,
            height: mediaQueryData.size.height * 0.10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: mediaQueryData.size.height * 0.04,
              horizontal: mediaQueryData.size.height * 0.03,
            ),
            child: SizedBox(
              width: 220,
              child: Text(
                "${widget.namaKategori}",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
              ),
            ),
          ),
          Positioned(
            // top: mediaQueryData.size.height * 0.05,
            left: mediaQueryData.size.height * 0.04,
            child: Image.asset(
              'assets/images/ppiddetail.png',
              width: mediaQueryData.size.height * 0.7,
              height: mediaQueryData.size.width * 0.6,
            ),
          ),
        ],
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
