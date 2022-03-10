import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetailGaleri extends StatefulWidget {
  final String dGambar, dDesa, dJudul;
  DetailGaleri({this.dGambar, this.dDesa, this.dJudul});

  @override
  DetailGaleriState createState() => DetailGaleriState();
}

class DetailGaleriState extends State<DetailGaleri> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            gambar(),
            Divider(),
            desa(),
            judul(),
          ],
        ),
      ),
    );
  }

  Widget gambar() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Column(
      children: <Widget>[
        // Image.network(
        //   "${widget.dGambar}", //NOTE api gambar detail event
        // ),
        CachedNetworkImage(
          imageUrl: "${widget.dGambar}",
          // new NetworkImage(databerita[index]["kabar_gambar"]),
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
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height * 0.3,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget desa() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "${widget.dDesa}",
        overflow: TextOverflow.ellipsis,
        style: new TextStyle(
          //fontSize: 16.0,
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
      ),
    );
  }

  Widget judul() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "${widget.dJudul}",
        //overflow: TextOverflow.ellipsis,
        style: new TextStyle(
          //fontSize: 16.0,
          color: Colors.white,
        ),
        //maxLines: 1,
      ),
    );
  }
}

class Sales {
  final String year;
  final int sales;

  Sales(this.year, this.sales);
}
