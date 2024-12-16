import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../style/styleset.dart';
import 'dart:convert';

class HalSuratAdmin extends StatefulWidget {
  const HalSuratAdmin({super.key});

  @override
  State<HalSuratAdmin> createState() => _HalSuratAdminState();
}

class _HalSuratAdminState extends State<HalSuratAdmin> {
  bool loadingdata = false;

  String? acc = "";
  String? ditolak = "";
  String? diajukan = "";
  String? menunggu = "";
  String? nomorSurat = "";

  Future _jumlahSurat() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      loadingdata = true;
    });
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/surat/jumlahsurat"),
        body: {
          "id_desa": pref.getString("IdDesa"),
        });

    if (mounted) {
      if (response.statusCode == 200) {
        var jumlahsurat = json.decode(response.body)["Data"];
        print(jumlahsurat);
        setState(() {
          acc = jumlahsurat['ACC'];
          ditolak = jumlahsurat['Ditolak'];
          diajukan = jumlahsurat['Diajukan'];
          menunggu = jumlahsurat['Menunggu'];
          loadingdata = false;
        });
      } else {
        setState(() {
          loadingdata = false;
        });
      }
    }
  }

  Future fetchNomorSurat() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      loadingdata = true;
    });
    final response = await http.post(
        Uri.parse(
            "https://dokar.kendalkab.go.id/webservice/android/surat/KodeInisial"),
        headers: {
          "Key": "VmZNRWVGTjhFeVptSUFJcjdURDlaQT09",
        },
        body: {
          "id_desa": pref.getString("IdDesa"),
        });

    if (mounted) {
      if (response.statusCode == 200) {
        var kode = json.decode(response.body)["kode"];
        print(kode);
        setState(() {
          nomorSurat = kode;
          loadingdata = false;
        });
      } else {
        setState(() {
          loadingdata = false;
        });
      }
    }
    // final response = await http.post(
    //     Uri.parse(
    //         "https://dokar.kendalkab.go.id/webservice/android/surat/KodeInisial"),
    //     headers: {
    //       "Key": "VmZNRWVGTjhFeVptSUFJcjdURDlaQT09",
    //     },
    //     body: {
    //       "id_desa": pref.getString("IdDesa").toString(),
    //     });
    // var datauser = json.decode(response.body);
    // print(datauser);
    // try {
    //   if (response.statusCode == 200) {
    //     final data = json.decode(response.body);
    //     setState(() {
    //       nomorSurat = data['kode'] ?? "Data tidak ditemukan";
    //     });
    //     print(nomorSurat);
    //   } else {
    //     setState(() {
    //       nomorSurat = "Gagal memuat data: ${response.statusCode}";
    //     });
    //     print(nomorSurat);
    //   }
    // } catch (e) {
    //   setState(() {
    //     nomorSurat = "Terjadi kesalahan: $e";
    //   });
    //   print(nomorSurat);
    // }
  }

  @override
  void initState() {
    super.initState();
    fetchNomorSurat();
    _jumlahSurat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchNomorSurat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          'SURAT WARGA',
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
            // fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: loadingdata
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  editNomor(),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      suratBelumAcc(),
                      suratAjukan(),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      suratTolak(),
                      suratAcc(),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget suratBelumAcc() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: mediaQueryData.size.width * 0.46,
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
        color: Colors.blueGrey.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/HalSuratMenunggu');
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.mark_email_unread_rounded,
                      color: Colors.blueGrey,
                      size: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: mediaQueryData.size.width * 0.01,
                      ),
                    ),
                    Text(
                      menunggu.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: mediaQueryData.size.height * 0.01,
                  ),
                ),
                const Text(
                  'Surat menunggu', //IBADAH
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: mediaQueryData.size.height * 0.01,
                  ),
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      "Surat belum di tandatanngani oleh kepala desa",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget suratAjukan() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: mediaQueryData.size.width * 0.46,
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
        color: Colors.blue[800]?.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/HalSuratAjukan')
                .then((value) => _jumlahSurat());
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.outgoing_mail,
                      color: Colors.blue[800],
                      size: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: mediaQueryData.size.width * 0.01,
                      ),
                    ),
                    Text(
                      diajukan.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: mediaQueryData.size.height * 0.01,
                  ),
                ),
                const Text(
                  'Surat diajukan', //IBADAH
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: mediaQueryData.size.height * 0.01,
                  ),
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Surat belum di tandatanngani oleh kepala desa",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget suratTolak() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: mediaQueryData.size.width * 0.46,
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
        color: Colors.red.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/HalSuratTolak');
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.unsubscribe_rounded,
                      color: Colors.red,
                      size: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: mediaQueryData.size.width * 0.01,
                      ),
                    ),
                    Text(
                      ditolak.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: mediaQueryData.size.height * 0.01,
                  ),
                ),
                const Text(
                  'Surat ditolak', //IBADAH
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: mediaQueryData.size.height * 0.01,
                  ),
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      "Surat belum di tandatanngani oleh kepala desa",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget suratAcc() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: mediaQueryData.size.width * 0.46,
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
        color: Colors.green.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/HalSuratACC');
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.mark_email_read_rounded,
                      color: Colors.green,
                      size: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: mediaQueryData.size.width * 0.01,
                      ),
                    ),
                    Text(
                      acc.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: mediaQueryData.size.height * 0.01,
                  ),
                ),
                const Text(
                  'Surat sudah verif', //IBADAH
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: mediaQueryData.size.height * 0.01,
                  ),
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      "Surat sudah di tandatanngani oleh kepala desa",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget editNomor() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: mediaQueryData.size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0.0, 3.0),
              blurRadius: 7.0),
        ],
        border: Border.all(width: 2, color: Colors.green),
      ),
      child: Material(
        color: Colors.green.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/HalNomorSurat')
                .then((value) => fetchNomorSurat());
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.numbers_rounded,
                      color: Colors.green,
                      size: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: mediaQueryData.size.width * 0.01,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kode Nomor Surat',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          nomorSurat!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/HalNomorSurat');
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
