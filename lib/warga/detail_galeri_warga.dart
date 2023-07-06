import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetailGaleriWarga extends StatefulWidget {
  final String dGambar, dJudul;
  DetailGaleriWarga({
    required this.dGambar,
    required this.dJudul,
  });

  @override
  DetailGaleriWargaState createState() => DetailGaleriWargaState();
}

class DetailGaleriWargaState extends State<DetailGaleriWarga> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the back button to white
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            gambar(),
            Divider(),
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
          height: mediaQueryData.size.height * 0.4,
          fit: BoxFit.contain,
        ),
      ],
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
