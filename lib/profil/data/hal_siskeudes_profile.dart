import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //api
//import 'dart:async'; // api syn
import 'dart:convert';
import 'package:intl/intl.dart';

class HalSiskeudesProfile extends StatefulWidget {
  final String idDesa, kodeDesa;

  HalSiskeudesProfile({this.idDesa, this.kodeDesa});

  @override
  _HalSiskeudesProfileState createState() => _HalSiskeudesProfileState();
}

class _HalSiskeudesProfileState extends State<HalSiskeudesProfile> {
  String date = DateFormat('yyyy').format(DateTime.now());
  var dataPendapatan;
  var dataBelanja;
  var dataPembiayaan;
  var formatter = new NumberFormat("#,###", "id");

  String jPAD = '';
  String jPT = '';
  String jPL = '';
  String jBP = '';
  String jBBJ = '';
  String jBM = '';
  String jBTT = '';
  String jPnP = '';
  String jPlP = '';

  void pendapatan() async {
    http.Response hasil = await http.get(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/siskeudes/GetPendapatan/" +
                "${widget.kodeDesa}"),
        headers: {"Accept": "application/json"});
    this.setState(
      () {
        dataPendapatan = json.decode(hasil.body);
      },
    );
    print(dataPendapatan);
    if (dataPendapatan['Nama_Desa'] == 'NotFound') {
      setState(() {
        jPAD = '0';
        jPT = '0';
        jPL = '0';
      });
    } else {
      setState(() {
        jPAD = formatter.format(int.parse(dataPendapatan['JPAD']));
        jPT = formatter.format(int.parse(dataPendapatan['JPT']));
        jPL = formatter.format(int.parse(dataPendapatan['JPL']));
      });
    }
  }

  void belanja() async {
    http.Response hasil = await http.get(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/siskeudes/GetBelanja/" +
                "${widget.kodeDesa}"),
        headers: {"Accept": "application/json"});
    dataBelanja = json.decode(hasil.body);
    if (dataBelanja['Nama_Desa'] == 'NotFound') {
      this.setState(() {
        jBP = '0';
        jBBJ = '0';
        jBM = '0';
        jBTT = '0';
      });
    } else {
      this.setState(() {
        jBP = formatter.format(int.parse(dataBelanja['JBP']));
        jBBJ = formatter.format(int.parse(dataBelanja['JBBJ']));
        jBM = formatter.format(int.parse(dataBelanja['JBM']));
        jBTT = formatter.format(int.parse(dataBelanja['JBTT']));
      });
    }
    print(dataBelanja);
    print("${widget.kodeDesa}");
  }

  void pembiayaan() async {
    http.Response hasil = await http.get(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/siskeudes/GetPembiayaan/" +
                "${widget.kodeDesa}"),
        headers: {"Accept": "application/json"});
    this.setState(
      () {
        dataPembiayaan = json.decode(hasil.body);
      },
    );
    print(dataPembiayaan);
    if (dataPembiayaan['Nama_Desa'] == 'NotFound') {
      setState(() {
        jPnP = '0';
        jPlP = '0';
      });
    } else {
      setState(() {
        jPnP = formatter.format(int.parse(dataPembiayaan['JPnP']));
        jPlP = formatter.format(int.parse(dataPembiayaan['JPlP']));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    pendapatan();
    belanja();
    pembiayaan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Siskeudes'),
        backgroundColor: Color(0xFFee002d),
      ),
      body: SingleChildScrollView(
        //child: Text("Siskeudes $date"),
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("KODE DESA : ${widget.kodeDesa}"),
                      Text("<===== PENDAPATAN =====>"),
                      Text("PENDAPATAN ASLI DESA : Rp. $jPAD"),
                      Text("PENDAPATAN TRANSFER : Rp. $jPT"),
                      Text("PENDAPATAN LAIN : Rp. $jPL"),
                      Text("<===== BELANJA =====>"),
                      Text("BELANJA PEGAWAI : Rp. $jBP"),
                      Text("BELANJA BARANG JASA : Rp. $jBBJ"),
                      Text("BELANJA MODAL : Rp. $jBM"),
                      Text("BELANJA TIDAK TERDUGA : Rp. $jBTT"),
                      Text("<===== PEMBIAYAAN =====>"),
                      Text("PENERIMAAN PEMBIAYAAN : Rp. $jPnP"),
                      Text("PENGELUARAN PEMBIAYAAN : Rp. $jPlP"),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
