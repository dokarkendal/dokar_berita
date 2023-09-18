import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailPagePPID extends StatefulWidget {
  final String dkategori, djudul, ddeskripsi, dtanggal, pdfPath, dNamadesa;

  DetailPagePPID({
    required this.dkategori,
    required this.djudul,
    required this.ddeskripsi,
    required this.dtanggal,
    required this.pdfPath,
    required this.dNamadesa,
  });

  @override
  State<DetailPagePPID> createState() => _DetailPagePPIDState();
}

class _DetailPagePPIDState extends State<DetailPagePPID> {
  late PDFViewController pdfViewController;
  int currentPage = 0;
  int totalPages = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.brown[800], //change your color here
        ),
        title: Text(
          'PPID ' + "${widget.dNamadesa}",
          style: TextStyle(
            color: Colors.brown[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.djudul}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(
                    height: 5,
                    color: Colors.white,
                  ),
                  Row(
                    children: [
                      Text(
                        "${widget.dkategori}",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Container(
                          height: 10,
                          child: VerticalDivider(color: Colors.grey)),
                      Text(
                        "${widget.dtanggal}",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Html(
                    style: {},
                    data: '${widget.ddeskripsi}',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 600,
              child: PDF().cachedFromUrl(
                "${widget.pdfPath}",
                placeholder: (progress) => Center(child: Text('$progress %')),
                errorWidget: (error) => Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.2,
                        ),
                      ),
                      Text(
                        "PDF Kosong",
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.grey[350],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                      ),
                      Icon(Icons.picture_as_pdf_rounded,
                          size: 100.0, color: Colors.grey[350]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
