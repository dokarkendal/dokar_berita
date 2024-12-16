import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../style/styleset.dart';

class HalNomorSurat extends StatefulWidget {
  const HalNomorSurat({super.key});

  @override
  State<HalNomorSurat> createState() => _HalNomorSuratState();
}

class _HalNomorSuratState extends State<HalNomorSurat> {
  // Controller untuk input nomor surat
  TextEditingController cNomorSurat = TextEditingController();

  // Flag untuk status loading
  bool loadingdata = false;
  @override
  void initState() {
    super.initState();
    fetchNomorSurat();
  }

  String nomorSurat = "Memuat...";
  Future<void> fetchNomorSurat() async {
    // final url = Uri.parse(
    //     "https://dokar.kendalkab.go.id/webservice/android/surat/KodeInisial");
    // const headers = {
    //   "Key": "VmZNRWVGTjhFeVptSUFJcjdURDlaQT09",
    //   "Content-Type": "application/json"
    // };
    SharedPreferences pref = await SharedPreferences.getInstance();
    // final body = jsonEncode({
    //   "id_desa": pref.getString("IdDesa").toString(),
    // });
    final response = await http.post(
        Uri.parse(
            "https://dokar.kendalkab.go.id/webservice/android/surat/KodeInisial"),
        headers: {
          "Key": "VmZNRWVGTjhFeVptSUFJcjdURDlaQT09",
        },
        body: {
          "id_desa": pref.getString("IdDesa").toString(),
        });
    var datauser = json.decode(response.body);
    print(datauser);
    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          nomorSurat = data['kode'] ?? "Data tidak ditemukan";
          cNomorSurat.text = nomorSurat; // update nilai cNomorSurat
        });
        print(nomorSurat);
      } else {
        setState(() {
          nomorSurat = "Gagal memuat data: ${response.statusCode}";
          cNomorSurat.text = nomorSurat; // update nilai cNomorSurat
        });
        print(nomorSurat);
      }
    } catch (e) {
      setState(() {
        nomorSurat = "Terjadi kesalahan: $e";
        cNomorSurat.text = nomorSurat; // update nilai cNomorSurat
      });
      print(nomorSurat);
    }
  }

  // Fungsi POST untuk menyimpan setting inisial surat
  Future<void> postSettingInisial() async {
    final String url =
        'https://dokar.kendalkab.go.id/webservice/android/surat/SettingInisial';

    setState(() {
      loadingdata = true; // Set loading to true when starting
    });

    await Future.delayed(Duration(seconds: 2)); // Add 2 second delay

    try {
      var headers = {
        // 'Content-Type': 'application/x-www-form-urlencoded',
        'key': 'VmZNRWVGTjhFeVptSUFJcjdURDlaQT09',
      };
      SharedPreferences pref = await SharedPreferences.getInstance();
      var body = {
        'id_desa': pref.getString("IdDesa"),
        'kode': cNomorSurat.text,
      };

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      setState(() {
        loadingdata = false; // Set loading to false after getting response
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil menyimpan pengaturan nomor surat'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.popUntil(context, ModalRoute.withName('/HalSuratAdmin'));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Gagal terhubung ke server. Status: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        loadingdata = false; // Ensure loading is false on error
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          'NOMOR SURAT',
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _peringatanNomor(),
            _paddingTop2(),
            _formKeterangan(),
            _paddingTop2(),
            _paddingTop2(),
            _buttonSimpan(),
          ],
        ),
      ),
    );
  }

  Widget _formKeterangan() {
    return Container(
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
              controller: cNomorSurat,
              // initialValue: nomorSurat,
              // enabled: false,
              keyboardType: TextInputType.text,
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
                  Icons.numbers_rounded,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Nomor",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nomor tidak boleh kosong';
                }
                return null; // Return null if the validation passes
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _peringatanNomor() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.all(15.0),
      height: mediaQueryData.size.height * 0.20,
      decoration: BoxDecoration(
        color: Colors.lightBlue[400],
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
                "Informasi",
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
          _paddingTop2(),
          Text(
            "- Setting kode inisial desa/kelurahan untuk nomor surat. \n- Kode inisial tidak boleh sama dengan desa/kelurahan lain. \n- Contoh: KDL untuk kelurahan Kendal. \n- Setelah jadi nomor surat: KDL/500/0001/2023. \n- 500: kode klasifikasi sesuai kategori surat. \n- 0001: nomor urut surat setiap desa/kelurahan. \n- 2023: tahun surat dibuat oleh desa/kelurahan.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonSimpan() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: loadingdata ? null : postSettingInisial,
        child: loadingdata
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Text(
                "SIMPAN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
      ),
    );
  }

  Widget _paddingTop2() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
    );
  }

  // Tambahkan dispose untuk membersihkan controller
  @override
  void dispose() {
    cNomorSurat.dispose();
    super.dispose();
  }
}
