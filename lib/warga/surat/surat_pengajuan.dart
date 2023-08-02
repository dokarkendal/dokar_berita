import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../style/styleset.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PengajuanSurat extends StatefulWidget {
  const PengajuanSurat({super.key});

  @override
  State<PengajuanSurat> createState() => _PengajuanSuratState();
}

class _PengajuanSuratState extends State<PengajuanSurat> {
  bool loadingdata = false;
  bool loadingajukan = false;
  String? cNIK = "";
  String? cNama = "";
  String? cTempatlahir = "";
  String? cTanggallahir = "";
  String? cKelamin = "";
  String? cKelaminID = "";
  String? cStatusKawin = "";
  String? cStatusKawinID = "";
  String? cAgama = "";
  String? cAgamaID = "";
  String? cPekerjaan = "";
  String? cPekerjaanID = "";
  String? cAlamat = "";
  String? cAlamatDomisili = "";
  TextEditingController cKeterangan = TextEditingController();

  List kategoriSuratAPI = [];
  var _pilihSurat;
  Future<void> getKatSurat() async {
    final response = await http.get(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/dashbord/kategorisurat"),
    );
    var getsuratJSON = json.decode(response.body);
    if (mounted) {
      setState(() {
        kategoriSuratAPI = getsuratJSON;
        print(getsuratJSON);
      });
    }
  }

  Future _cekProfil() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      loadingdata = true;
    });
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/account/DatawargabyUid"),
        body: {
          "uid": pref.getString("uid"),
        });
    var cekProfil = json.decode(response.body)["Data"];
    print(cekProfil);
    if (mounted) {
      setState(() {
        cNIK = cekProfil['nik'];
        cNama = cekProfil['nama'];
        cTempatlahir = cekProfil['tmp_lahir'];
        cTanggallahir = cekProfil['tgl_lahir'];
        cKelaminID = cekProfil['kelamin_id'];
        cKelamin = cekProfil['kelamin'];
        cStatusKawinID = cekProfil['kawin_id'];
        cStatusKawin = cekProfil['kawin'];
        cAgamaID = cekProfil['agama_id'];
        cAgama = cekProfil['agama'];
        cPekerjaanID = cekProfil['pekerjaan_id'];
        cPekerjaan = cekProfil['pekerjaan'];
        cAlamat = cekProfil['alamat'];
        cAlamatDomisili = cekProfil['domisili_alamat'];
        loadingdata = false;
      });
    }
  }

  Future<void> ajukanSurat() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      loadingajukan = true;
    });
    Future.delayed(Duration(seconds: 2), () async {
      final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/surat/Pengajuan"),
        body: {
          "uid": pref.getString("uid")!,
          "id_desa": pref.getString("id_desa")!,
          "kategori": _pilihSurat,
          "keterangan": cKeterangan.text,
        },
      );
      var ajukanSurat = json.decode(response.body);
      print(ajukanSurat);
      if (ajukanSurat["Status"] == "Sukses") {
        setState(() {
          loadingajukan = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ajukanSurat['Notif'],
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                print('OK snackbar');
              },
            ),
          ),
        );
        Navigator.pop(context);
      } else {
        setState(() {
          loadingajukan = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ajukanSurat['Notif'],
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'ULANGI',
              textColor: Colors.white,
              onPressed: () {
                print('ULANGI snackbar');
              },
            ),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _cekProfil();
    getKatSurat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          'PENGAJUAN SURAT',
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
          ? _buildProgressIndicator()
          : Container(
              padding: const EdgeInsets.all(5),
              color: Colors.grey.shade200,
              child: ListView(
                children: [
                  // _cardExpanded(),
                  _peringatanpengajuan(),
                  _profil(),
                  _paddingTop1(),
                  _formKatSurat(),
                  _paddingTop1(),
                  _formKeterangan(),
                  _paddingTop1(),
                  _paddingTop1(),
                  _buttomAjukanSurat(),
                  _paddingTop1(),
                  _paddingTop1(),
                ],
              ),
            ),
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: loadingdata ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buttomAjukanSurat() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return loadingajukan
        ? Column(
            children: [
              SizedBox(
                width: mediaQueryData.size.width,
                height: mediaQueryData.size.height * 0.07,
                child: ElevatedButton(
                  onPressed: () async {},
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      color: titleText,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )
        : SizedBox(
            width: mediaQueryData.size.width,
            height: mediaQueryData.size.height * 0.07,
            child: ElevatedButton(
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                print(pref.getString("uid"));
                print(pref.getString("id_desa"));
                print(_pilihSurat);
                print(cKeterangan.text);
                ajukanSurat();
              },
              child: const Text(
                'BUAT SURAT',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  color: titleText,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
  }

  Widget _formKeterangan() {
    return Container(
      // padding: EdgeInsets.all(3),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              maxLines: null,
              controller: cKeterangan,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(200),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.my_library_books_rounded,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Keterangan",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formKatSurat() {
    return Container(
      // padding: EdgeInsets.all(3),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Container(
            decoration: decorationTextField,
            child: DropdownButtonFormField(
              isDense: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail, color: Colors.brown[800]),
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
              hint: Text('Pilih Kategori Surat'),
              isExpanded: true,
              items: kategoriSuratAPI.map(
                (item0) {
                  return DropdownMenuItem(
                    child: Text(item0['nama'].toString()),
                    value: item0['id'].toString(),
                  );
                },
              ).toList(),
              onChanged: (val) async {
                setState(() {
                  _pilihSurat = val as String;
                  print("KLIK");
                  print(_pilihSurat);
                });

                // Wait for getKecamatan() to complete before rebuilding the widget
              },
              value: _pilihSurat,
            ),
          )
        ],
      ),
    );
  }

  Widget _profil() {
    return Container(
      // padding: const EdgeInsets.all(3),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _profilText(),
                      _dividerHeight1(),
                      namaProfil(),
                      _dividerHeight1(),
                      nikProfil(),
                      _dividerHeight1(),
                      ttlProfil(),
                      _dividerHeight1(),
                      kelaminProfil(),
                      _dividerHeight1(),
                      statusProfil(),
                      _dividerHeight1(),
                      agamaProfil(),
                      _dividerHeight1(),
                      pekerjaanProfil(),
                      _dividerHeight1(),
                      alamatProfilKTP(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // bool _isExpanded = false;
  // Widget _cardExpanded() {
  //   MediaQueryData mediaQueryData = MediaQuery.of(context);
  //   return Container(
  //     padding: EdgeInsets.only(
  //       top: MediaQuery.of(context).size.height * 0.005,
  //       bottom: MediaQuery.of(context).size.height * 0.005,
  //     ),
  //     // height: mediaQueryData.size.height * 0.11,
  //     decoration: BoxDecoration(
  //       color: Colors.lightBlue[600],
  //       borderRadius: const BorderRadius.all(Radius.circular(10.0)),
  //       boxShadow: [
  //         BoxShadow(
  //             color: Colors.black.withOpacity(0.1),
  //             offset: const Offset(0.0, 5.0),
  //             blurRadius: 7.0),
  //       ],
  //     ),
  //     child: ExpansionTile(
  //       title: Text(
  //         'Catatan',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       subtitle: Text(
  //         'Klik disini!. Pastikan data diri anda sudah benar, jika belum silahkan perbarui di menu Data Diri',
  //         style: TextStyle(
  //           color: Colors.white,
  //           // fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       trailing: Icon(
  //         _isExpanded ? Icons.expand_less : Icons.expand_more,
  //         color: _isExpanded ? Colors.white : Colors.white,
  //       ),
  //       onExpansionChanged: (value) {
  //         setState(() {
  //           _isExpanded = value;
  //         });
  //       },
  //       children: <Widget>[
  //         _profil(),
  //       ],
  //     ),
  //   );
  // }

  Widget _peringatanpengajuan() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.all(15.0),
      height: mediaQueryData.size.height * 0.13,
      decoration: BoxDecoration(
        color: Colors.lightBlue[600],
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0.0, 5.0),
              blurRadius: 7.0),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Catatan",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
              )
            ],
          ),
          _paddingTop1(),
          Text(
            "Pastikan data diri anda sudah benar, jika belum silahkan perbarui di menu Data Diri",
            style: TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _paddingTop1() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
    );
  }

  Widget _profilText() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(
        "Informasi",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _dividerHeight1() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget namaProfil() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Nama",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cNama == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cNama",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget nikProfil() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.numbers,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "NIK",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cNIK == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cNIK",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget ttlProfil() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.date_range,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Tempat, Tanggal Lahir",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cTanggallahir == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cTempatlahir, $cTanggallahir",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget kelaminProfil() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_people_sharp,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Kelamin",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cKelamin == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cKelamin",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget statusProfil() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Status",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cStatusKawin == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cStatusKawin",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget agamaProfil() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.mosque,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Agama",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cAgama == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cAgama",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget pekerjaanProfil() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.work,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Pekerjaan",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cPekerjaan == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cPekerjaan",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget alamatProfilKTP() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on_rounded,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Alamat KTP",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cAlamat == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cAlamat",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }
}
