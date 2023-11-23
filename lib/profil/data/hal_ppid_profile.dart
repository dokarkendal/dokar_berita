import 'package:dokar_aplikasi/berita/hal_search_ppid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../berita/list/hal_list_ppid.dart';

class HalPpidProfile extends StatefulWidget {
  final String idDesa, namaDesa;

  HalPpidProfile({
    required this.idDesa,
    required this.namaDesa,
  });

  @override
  State<HalPpidProfile> createState() => _HalPpidProfileState();
}

class _HalPpidProfileState extends State<HalPpidProfile> {
  late String valuePPID;
  late String tahunPPID;
  var _pilihtahun;
  List cariTahun = [];
  Future<void> gettahunPPID() async {
    final response = await http.get(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/ppid/tahun/${widget.idDesa}/}"),
    );
    var gettahunppidJSON = json.decode(response.body);
    if (mounted) {
      setState(() {
        cariTahun = gettahunppidJSON;
        print(gettahunppidJSON);
      });
    }
  }

  List<dynamic> kategoriPPID = [];
  List<dynamic> filterkategoriPPID = [];
  Future<dynamic> getKategori() async {
    final res = await http.get(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/ppid/getkategori"),
    );

    if (mounted) {
      if (res.statusCode == 200) {
        setState(
          () {
            kategoriPPID = json.decode(res.body);
            filterkategoriPPID = kategoriPPID;
          },
        );
        if (kDebugMode) {
          print(kategoriPPID);
        }
      }
      return kategoriPPID;
    }
  }

  @override
  void initState() {
    super.initState();
    getKategori();
    gettahunPPID();
  }

  void filterDisciplineList(String query) {
    setState(() {
      filterkategoriPPID = kategoriPPID
          .where((item) =>
              item['id']!.toLowerCase().contains(query.toLowerCase()) ||
              item['kategori']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Center(
        // physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            headerPPID(),
            cariPPID(),
            listPPID(),
          ],
        ),
      ),
    );
  }

  Widget cariPPID() {
    TextEditingController _textController = TextEditingController();

    void submitForm() {
      String valuePPID = _textController.text;

      if (valuePPID.isEmpty && _pilihtahun == null) {
        // Show a Snackbar with an error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('idDesa and/or namaDesa is empty or null.'),
        ));
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HalSearchPPID(
              value: valuePPID,
              tahun: _pilihtahun,
              idDesa: "${widget.idDesa}",
              namaDesa: "${widget.namaDesa}",
            ),
          ),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.24,
            height: MediaQuery.of(context).size.height * 0.07,
            child: DropdownButtonFormField(
              isDense: true,
              decoration: InputDecoration(
                // prefixIcon: Icon(Icons.mail, color: Colors.brown[800]),
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[400],
                ),
              ),
              hint: Text('Tahun'),
              isExpanded: true,
              items: cariTahun.map(
                (item0) {
                  return DropdownMenuItem(
                    child: Text(item0['tahun'].toString()),
                    value: item0['tahun'].toString(),
                  );
                },
              ).toList(),
              onChanged: (val) async {
                setState(() {
                  _pilihtahun = val as String;
                  print("tahun");
                  print(_pilihtahun);
                });

                // Wait for getKecamatan() to complete before rebuilding the widget
              },
              value: _pilihtahun,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.02,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.69,
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                hintText: 'Cari PPID...',
                // border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search), // Add a clear icon
                  onPressed: () {
                    submitForm();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listPPID() {
    return Expanded(
      child: ListView.builder(
        itemCount: filterkategoriPPID.length,
        itemBuilder: (context, index) {
          final item = filterkategoriPPID[index];
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0.0, 3.0),
                      blurRadius: 7.0),
                ],
              ),
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HalPPIDList(
                          idDesa: "${widget.idDesa}",
                          namaDesa: "${widget.namaDesa}",
                          idKategori: item['id']!,
                          namaKategori: item['kategori']!,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons
                          .auto_stories_rounded, // Replace with your desired icon
                      color: Colors.grey, // Set the icon color as needed
                    ),
                    // leading: Text(
                    //   item['id']!,
                    //   style: const TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    title: Text(item['kategori']!),
                  ),
                ),
              ),
            ),
          );
        },
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
            height: mediaQueryData.size.height * 0.15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: mediaQueryData.size.height * 0.04,
              horizontal: mediaQueryData.size.height * 0.03,
            ),
            child: Text(
              "Pejabat Pengelola \nInformasi dan \nDokumentasi",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
            ),
          ),
          Positioned(
            // top: mediaQueryData.size.height * 0.05,
            left: mediaQueryData.size.height * 0.04,
            child: Image.asset(
              'assets/images/ppid.png',
              width: mediaQueryData.size.height * 0.7,
              height: mediaQueryData.size.width * 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
