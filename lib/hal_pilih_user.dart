//ANCHOR Selesai
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PilihAKun extends StatefulWidget {
  @override
  _PilihAKunState createState() => _PilihAKunState();
}

class _PilihAKunState extends State<PilihAKun> {
//NOTE Variabel
  String topik = '';

//NOTE Inistate
  @override
  void initState() {
    super.initState();
    _cekLogin();
  }

//NOTE Fungsi Cek Login
  Future _cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userStatus") == 'Admin') {
      if (pref.getString("NotifStatus") == null) {
        pref.setString('NotifStatus', '1');
        setState(() {
          topik = 'Admin';
        });
      }
      Navigator.pushReplacementNamed(context, '/Haldua');
    } else if (pref.getString("userStatus") == 'Warga') {
      Navigator.pushReplacementNamed(context, '/HalDashboardWarga');
    } else {}
  }

//NOTE Scaffold
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            _logo(),
            Padding(
              padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
              child: _textjudul(),
            ),
            Padding(
              padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.3),
              child: _text(),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.45),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(mediaQueryData.size.height * 0.03),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.02),
                      ),
                      _tombolAdmin(),
                      Padding(
                        padding: EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.03),
                      ),
                      _tombolWarga(),
                      Padding(
                        padding: EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.03),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[400],
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Atau',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[400],
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.02),
                      ),
                      _lanjut(),
                      Padding(
                        padding: EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.1),
                      ),
                      _youtubeDokar(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

//NOTE Gambar Header
  Widget _logo() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              "assets/images/gold2.png",
            ),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter),
      ),
    );
  }

//NOTE Judul
  Widget _textjudul() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
          left: mediaQueryData.size.height * 0.03,
          right: mediaQueryData.size.height * 0.03,
          bottom: mediaQueryData.size.height * 0.03,
          top: mediaQueryData.size.height * 0.010,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AutoSizeText(
              "Selamat datang",
              minFontSize: 16,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                  color: Colors.brown[800]),
              maxLines: 1,
            ),
            AutoSizeText(
              "Di DOKAR",
              minFontSize: 16,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                  color: Colors.brown[800]),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

//NOTE Subtitle
  Widget _text() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: mediaQueryData.size.height * 0.03,
          right: mediaQueryData.size.height * 0.03,
          bottom: mediaQueryData.size.height * 0.03,
          top: mediaQueryData.size.height * 0.07,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AutoSizeText(
              "Portal Informasi Desa dan Kelurahan",
              minFontSize: 16,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 22.0, color: Colors.white),
              maxLines: 1,
            ),
            AutoSizeText(
              "Kabupaten Kendal",
              minFontSize: 16,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 22.0, color: Colors.white),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

//NOTE Tombol Warga
  Widget _tombolWarga() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: mediaQueryData.size.width,
      child: ElevatedButton(
        onPressed: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          setState(() {
            topik = 'Warga';
          });
          if (pref.getString("NotifStatus") == null) {
            pref.setString('NotifStatus', '1');
          }
          // Navigator.pushNamed(context, '/HalamanBeritaWarga');
          // Navigator.pushNamed(context, '/HalLoginWarga');
          Navigator.pushNamed(context, '/HalDaftarWarga');
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(15.0),
          backgroundColor: Colors.orange[300],
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          'Layanan',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

//NOTE Tombol Admin
  Widget _tombolAdmin() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: mediaQueryData.size.width,
      child: ElevatedButton(
        onPressed: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          setState(() {
            topik = 'Admin';
          });
          if (pref.getString("NotifStatus") == null) {
            pref.setString('NotifStatus', '1');
          }
          Navigator.pushNamed(context, '/DaftarAdmin');
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(15.0),
          backgroundColor: Colors.blue[800],
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          'Admin',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

//NOTE Link youtube dokar
  Widget _youtubeDokar() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Info tentang dokar?"),
          GestureDetector(
            onTap: () async {
              //LINK Channel Youtube DOKAR
              final Uri url = Uri.parse(
                  'https://www.youtube.com/watch?v=Aa7eKzqp3PA&list=PLkNaCvRUXZ8f3Kta00_Ks_hGMa_hlpyyy');
              if (!await launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              )) {
                throw 'Could not launch $url';
              }
            },
            child: Text(
              "  Lihat",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          )
        ],
      ),
    );
  }

//NOTE Link Privacy Dokar
  // Widget _privacy() {
  //   return Container(
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         GestureDetector(
  //           onTap: () async {
  //             final Uri url =
  //                 Uri.parse('https://dokar.kendalkab.go.id/privacy');
  //             if (!await launchUrl(
  //               url,
  //               mode: LaunchMode.externalApplication,
  //             )) {
  //               throw 'Could not launch $url';
  //             }
  //           },
  //           child: Text(
  //             "Syarat & Ketentuan",
  //             style: TextStyle(
  //               fontSize: 14.0,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.blue[800],
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  //NOTE Link Privacy Dokar
  Widget _lanjut() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Lanjut tanpa mendaftar "),
          Padding(
            padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.01),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/HalamanBeritaWarga');
            },
            child: Icon(
              Icons.arrow_circle_right_outlined,
              color: Colors.blue[800],
            ),
          )
        ],
      ),
    );
  }
}
