/// Simple pie chart example.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http; //api
//import 'dart:async'; // api syn
import 'dart:convert';

class SimplePieChart extends StatefulWidget {
  final String idDesa, kodeDesa;

  SimplePieChart({this.idDesa, this.kodeDesa});

  @override
  _SimplePieChartState createState() => _SimplePieChartState();
}

class _SimplePieChartState extends State<SimplePieChart> {
  String date = DateFormat('yyyy').format(DateTime.now());
  var dataPendapatan;
  var dataBelanja;
  var dataPembiayaan;
  var formatter = new NumberFormat("#,###", "id");

  int tPAD = 0;
  String jPAD = '';
  int tPT = 0;
  String jPT = '';
  int tPL = 0;
  String jPL = '';
  int tBP = 0;
  String jBP = '';
  int tBBJ = 0;
  String jBBJ = '';
  int tBM = 0;
  String jBM = '';
  int tBTT = 0;
  String jBTT = '';
  int tPnP = 0;
  String jPnP = '';
  int tPlP = 0;
  String jPlP = '';
  String kode = '3324072015';

  void pendapatan() async {
    http.Response hasil = await http.get(
        Uri.encodeFull(
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
        tPAD = 0;
        jPAD = '0';
        tPT = 0;
        jPT = '0';
        tPL = 0;
        jPL = '0';
      });
    } else {
      setState(() {
        tPAD = int.parse(dataPendapatan['JPAD']);
        jPAD = formatter.format(int.parse(dataPendapatan['JPAD']));
        tPT = int.parse(dataPendapatan['JPT']);
        jPT = formatter.format(int.parse(dataPendapatan['JPT']));
        tPL = int.parse(dataPendapatan['JPL']);
        jPL = formatter.format(int.parse(dataPendapatan['JPL']));
      });
    }
  }

  void belanja() async {
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "http://dokar.kendalkab.go.id/webservice/android/siskeudes/GetBelanja/" +
                "${widget.kodeDesa}"),
        headers: {"Accept": "application/json"});
    dataBelanja = json.decode(hasil.body);
    if (dataBelanja['Nama_Desa'] == 'NotFound') {
      this.setState(() {
        tBP = 0;
        tBBJ = 0;
        tBM = 0;
        tBTT = 0;

        jBP = '0';
        jBBJ = '0';
        jBM = '0';
        jBTT = '0';
      });
    } else {
      this.setState(() {
        tBP = int.parse(dataBelanja['JBP']);
        tBBJ = int.parse(dataBelanja['JBBJ']);
        tBM = int.parse(dataBelanja['JBM']);
        tBTT = int.parse(dataBelanja['JBTT']);

        jBP = formatter.format(int.parse(dataBelanja['JBP']));
        jBBJ = formatter.format(int.parse(dataBelanja['JBBJ']));
        jBM = formatter.format(int.parse(dataBelanja['JBM']));
        jBTT = formatter.format(int.parse(dataBelanja['JBTT']));
      });
    }
    print(dataBelanja);
  }

  void pembiayaan() async {
    http.Response hasil = await http.get(
        Uri.encodeFull(
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
        tPnP = 0;
        tPlP = 0;

        jPnP = '0';
        jPlP = '0';
      });
    } else {
      setState(() {
        tPnP = int.parse(dataPembiayaan['JPnP']);
        tPlP = int.parse(dataPembiayaan['JPlP']);

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
    var data = [
      Sales("PAD", tPAD),
      Sales("PT", tPT),
      Sales("PL", tPL),
      Sales("BP", tBP),
      Sales("BBJ", tBBJ),
      Sales("BM", tBM),
      Sales("BTT", tBTT),
      Sales("PnP", tPnP),
      Sales("PlP", tPlP),
    ];

    var series = [
      charts.Series(
          domainFn: (Sales sales, _) => sales.day,
          measureFn: (Sales sales, _) => sales.sold,
          id: 'Sales',
          data: data)
    ];

    var chart = charts.PieChart(series,
        animate: true,
        defaultRenderer: new charts.ArcRendererConfig(
            arcRendererDecorators: [new charts.ArcLabelDecorator()])
        /*defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
        new charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.inside)
      ]),*/
        );

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xFFee002d), title: Text("Siskeudes")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 400, child: chart),
                DataTable(
                  columns: [
                    DataColumn(
                      label: Text(
                        'PENDAPATAN',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(label: Text(' ')),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text('PENDAPATAN ASLI DESA')),
                        DataCell(Text('Rp. $jPAD')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('PENDAPATAN TRANSFER')),
                        DataCell(Text('Rp. $jPT')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('PENDAPATAN LAIN')),
                        DataCell(Text('Rp. $jPL')),
                      ],
                    ),
                  ],
                ),
                DataTable(
                  columns: [
                    DataColumn(
                      label: Text(
                        'BELANJA',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(label: Text(' ')),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text('BELANJA PEGAWAI')),
                        DataCell(Text('Rp. $jBP')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('BELANJA BARANG ')),
                        DataCell(Text('Rp. $jBBJ')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('BELANJA MODAL')),
                        DataCell(Text('Rp. $jBM')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('BELANJA TIDAK TERDUGA')),
                        DataCell(Text('Rp. $jBTT')),
                      ],
                    ),
                  ],
                ),
                DataTable(
                  columns: [
                    DataColumn(
                      label: Text(
                        'PEMBIAYAAN',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(label: Text(' ')),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text('PENERIMAAN PEMBIAYAAN')),
                        DataCell(Text('Rp. $jPnP')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('PENGELUARAN PEMBIAYAAN')),
                        DataCell(Text('Rp. $jPlP')),
                      ],
                    ),
                  ],
                ),
                /*Column(
                  children: <Widget>[
                    //Text("KODE DESA : ${widget.kodeDesa}"),
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
                )*/
              ],
            ),
          ),
        ));
  }
}

class Sales {
  final String day;
  final int sold;

  Sales(this.day, this.sold);
}
