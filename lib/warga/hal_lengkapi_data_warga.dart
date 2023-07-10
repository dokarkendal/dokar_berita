import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http; //api
import '../style/styleset.dart';
import 'dart:async'; // api syn
import 'dart:convert'; // api to json

class HalLengkapiDataWarga extends StatefulWidget {
  const HalLengkapiDataWarga({super.key});

  @override
  State<HalLengkapiDataWarga> createState() => _HalLengkapiDataWargaState();
}

class _HalLengkapiDataWargaState extends State<HalLengkapiDataWarga> {
  bool loadingdata = false;
  bool loadingsimpan = false;
  final format = DateFormat("yyyy-MM-dd");
  TextEditingController cId = TextEditingController();
  TextEditingController cUid = TextEditingController();
  TextEditingController cNIK = TextEditingController();
  TextEditingController cNama = TextEditingController();
  TextEditingController cTempatlahir = TextEditingController();
  TextEditingController cTanggallahir = TextEditingController();
  TextEditingController cKelamin = TextEditingController();
  TextEditingController cKelaminID = TextEditingController();

  TextEditingController cStstusKawin = TextEditingController();
  TextEditingController cStstusKawinID = TextEditingController();
  TextEditingController cAgama = TextEditingController();
  TextEditingController cAgamaID = TextEditingController();
  TextEditingController cPekerjaan = TextEditingController();
  TextEditingController cPekerjaanID = TextEditingController();
  TextEditingController cAlamat = TextEditingController();
  TextEditingController cAlamatKTP = TextEditingController();

  TextEditingController cKota = TextEditingController();
  TextEditingController cKotaKTP = TextEditingController();
  TextEditingController cKecamatan = TextEditingController();
  TextEditingController cKecamatanKTP = TextEditingController();
  TextEditingController cDesa = TextEditingController();
  TextEditingController cDesaKTP = TextEditingController();

  TextEditingController cRT = TextEditingController();
  TextEditingController cRTKTP = TextEditingController();
  TextEditingController cRW = TextEditingController();
  TextEditingController cRWKTP = TextEditingController();
  TextEditingController cKewarganegaraan = TextEditingController();
  TextEditingController cKodepos = TextEditingController();
  TextEditingController cKodeposKTP = TextEditingController();
  late String iddesa;
  Future<void> getAkunWarga() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      loadingdata = true;
    });
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/account/DatawargabyUid"),
        body: {
          "uid": pref.getString("uid")!,
        });
    var akunwarga = json.decode(response.body)["Data"];
    print(akunwarga);

    if (mounted) {
      setState(
        () {
          loadingdata = false;

          cId = TextEditingController(text: akunwarga['id']);
          cUid = TextEditingController(text: akunwarga['uid']);
          cNIK = TextEditingController(text: akunwarga['nik']);
          cNama = TextEditingController(text: akunwarga['nama']);
          cTempatlahir = TextEditingController(text: akunwarga['tmp_lahir']);
          cTanggallahir = TextEditingController(text: akunwarga['tgl_lahir']);
          cKelamin = TextEditingController(text: akunwarga['kelamin']);
          cKelaminID = TextEditingController(text: akunwarga['kelamin_id']);
          cStstusKawin = TextEditingController(text: akunwarga['kawin']);
          cStstusKawinID = TextEditingController(text: akunwarga['kawin_id']);
          cAgama = TextEditingController(text: akunwarga['agama']);
          cAgamaID = TextEditingController(text: akunwarga['agama_id']);
          cPekerjaan = TextEditingController(text: akunwarga['pekerjaan']);
          cPekerjaanID = TextEditingController(text: akunwarga['pekerjaan_id']);
          cKewarganegaraan =
              TextEditingController(text: akunwarga['kewarganegaraan']);
          cAlamatKTP = TextEditingController(text: akunwarga['alamat']);
          cKotaKTP = TextEditingController(text: akunwarga['kota']);
          cKecamatanKTP = TextEditingController(text: akunwarga['kecamatan']);
          cDesaKTP = TextEditingController(text: akunwarga['desa']);
          cRTKTP = TextEditingController(text: akunwarga['rt']);
          cRWKTP = TextEditingController(text: akunwarga['rw']);
          cKodeposKTP = TextEditingController(text: akunwarga['kodepos']);
          cAlamat = TextEditingController(text: akunwarga['domisili_alamat']);
          cKota = TextEditingController(text: akunwarga['domisili_kota']);
          cKecamatan =
              TextEditingController(text: akunwarga['domisili_kecamatan']);
          cDesa = TextEditingController(text: akunwarga['domisili_desa']);
          cRT = TextEditingController(text: akunwarga['domisili_rt']);
          cRW = TextEditingController(text: akunwarga['domisili_rw']);
          cKodepos = TextEditingController(text: akunwarga['domisili_pos']);
          iddesa = akunwarga['id_desa'];
        },
      );
    }
  }

  // bool _isInAsyncCall = false;
  Future cekPrint(pilihKelamin, pilihAgama, pilihKawin, pilihPekerjaaan) async {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    // FocusScope.of(context).requestFocus(FocusNode());
    setState(
      () {
        loadingsimpan = true;
      },
    );

    Future.delayed(Duration(seconds: 1), () async {
      final response = await http.post(
          Uri.parse(
              "http://dokar.kendalkab.go.id/webservice/android/account/Updatewarga/$iddesa"),
          body: {
            "uid": cUid.text,
            "id": cId.text,
            "nik": cNIK.text,
            "nama": cNama.text,
            "tmp_lahir": cTempatlahir.text,
            "tgl_lahir": cTanggallahir.text,
            "kelamin": pilihKelamin.toString(),
            "agama": pilihAgama.toString(),
            "kawin": pilihKawin.toString(),
            "kewarganegaraan": cKewarganegaraan.text,
            "alamat": cAlamatKTP.text,
            "kota": cKotaKTP.text,
            "kecamatan": cKecamatanKTP.text,
            "desa": cDesaKTP.text,
            "rt": cRTKTP.text,
            "rw": cRWKTP.text,
            "pekerjaan": pilihPekerjaaan.toString(),
            "pos": cKodeposKTP.text,
            "alamat_domisili": cAlamat.text,
            "rt_domisili": cRT.text,
            "rw_domisili": cRW.text,
            "pos_domisili": cKodepos.text,
          });
      var lengkapidata = json.decode(response.body);
      print(lengkapidata);
      if (lengkapidata["Status"] == "Sukses") {
        setState(() {
          loadingsimpan = false;
        });
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            elevation: 6.0,
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.done,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  width: mediaQueryData.size.width * 0.02,
                ),
                Flexible(
                  child: Text(
                    lengkapidata['Notif'],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                // Navigator.pushReplacementNamed(context, '/HalDashboard');
                // Navigator.pop(context);
              },
            ),
          ),
        );
        Navigator.pop(context);
      } else {
        setState(() {
          loadingsimpan = false;
        });
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            elevation: 6.0,
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  width: mediaQueryData.size.width * 0.02,
                ),
                Flexible(
                  child: Text(
                    lengkapidata['Notif'],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            action: SnackBarAction(
              label: 'ULANGI',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    });
    print("PRIINT DARI POST");
    print(pilihKelamin);
    print(pilihAgama);
    print(pilihKawin);
    print(pilihPekerjaaan);
  }

  List kelaminAPI = [];
  var _pilihKelamin;
  Future<void> getKelamin() async {
    final response = await http.get(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/dashbord/kelamin"),
    );
    var getkelaminJSON = json.decode(response.body);
    if (mounted) {
      setState(() {
        kelaminAPI = getkelaminJSON;
        print(getkelaminJSON);
      });
    }
  }

  List agamaAPI = [];
  var _pilihAgama;
  Future<void> getAgama() async {
    final response = await http.get(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/dashbord/agama"),
    );
    var getagamaJSON = json.decode(response.body);
    if (mounted) {
      setState(() {
        agamaAPI = getagamaJSON;
        print(getagamaJSON);
      });
    }
  }

  List kawinAPI = [];
  var _pilihKawin;
  Future<void> getKawin() async {
    final response = await http.get(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/dashbord/kawin"),
    );
    var getkawinJSON = json.decode(response.body);
    if (mounted) {
      setState(() {
        kawinAPI = getkawinJSON;
        print(getkawinJSON);
      });
    }
  }

  List pekerjaanAPI = [];
  var _pilihPekerjaaan;
  Future<void> getPekerjaan() async {
    final response = await http.get(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/dashbord/pekerjaan"),
    );
    var getpekerjaanJSON = json.decode(response.body);
    if (mounted) {
      setState(() {
        pekerjaanAPI = getpekerjaanJSON;
        print(getpekerjaanJSON);
      });
    }
  }

  @override
  void initState() {
    getAkunWarga();
    getKelamin();
    getAgama();
    getKawin();
    getPekerjaan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          'LENGKAPI DATA',
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
          : ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _textPribadi(),
                      _paddingTop2(),
                      _formNIK(),
                      _paddingTop2(),
                      _formNama(),
                      _paddingTop2(),
                      _formTempatLahir(),
                      _paddingTop2(),
                      _formTglLahir(),
                      _paddingTop2(),
                      _formKelamin(),
                      _paddingTop2(),
                      _formAgama(),
                      _paddingTop2(),
                      _formKawin(),
                      _paddingTop2(),
                      _formPekerjaan(),
                      _paddingTop2(),
                      _formKewarganegaraan(),
                      _paddingTop2(),
                      _paddingTop2(),
                      _textKTP(),
                      _paddingTop2(),
                      _formAlamatKTP(),
                      _paddingTop2(),
                      _formKotaKTP(),
                      _paddingTop2(),
                      _formKecKTP(),
                      _paddingTop2(),
                      _formDesaKTP(),
                      _paddingTop2(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _formRtKTP(),
                          _formRwKTP(),
                        ],
                      ),
                      _paddingTop2(),
                      _formPosKTP(),
                      _paddingTop2(),
                      _textDomisili(),
                      _paddingTop2(),
                      _formAlamatDomisili(),
                      _paddingTop2(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _formRtDomisili(),
                          _formRwDomisili(),
                        ],
                      ),
                      _paddingTop2(),
                      _formPosDomisili(),
                      _paddingTop2(),
                      _paddingTop2(),
                      _tombolDaftar(),
                      _paddingTop2(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _textPribadi() {
    return Text(
      "Data Pribadi",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _textKTP() {
    return Text(
      "Data KTP",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _textDomisili() {
    return Text(
      "Data Domisili",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _paddingTop2() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
    );
  }

  Widget _tombolDaftar() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return loadingsimpan
        ? Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: mediaQueryData.size.height * 0.07,
                child: ElevatedButton(
                  onPressed: () async {},
                  style: ElevatedButton.styleFrom(
                    // padding: EdgeInsets.all(15.0),
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // <-- Radius
                    ),
                    textStyle: const TextStyle(
                      color: titleText,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            height: mediaQueryData.size.height * 0.07,
            child: ElevatedButton(
              onPressed: () async {
                if (_pilihKelamin == null || _pilihKelamin == "") {
                  _pilihKelamin = cKelaminID;
                } else {
                  _pilihKelamin = _pilihKelamin;
                }

                if (_pilihAgama == null || _pilihAgama == "") {
                  _pilihAgama = cAgamaID;
                } else {
                  _pilihAgama = _pilihAgama;
                }

                if (_pilihKawin == null || _pilihKawin == "") {
                  _pilihKawin = cStstusKawinID;
                } else {
                  _pilihKawin = _pilihKawin;
                }

                if (_pilihPekerjaaan == null || _pilihPekerjaaan == "") {
                  _pilihPekerjaaan = cPekerjaanID;
                } else {
                  _pilihPekerjaaan = _pilihPekerjaaan;
                }

                if (cNIK.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'NIK masih kosong',
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
                  ));
                } else if (cNama.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Nama masih kosong',
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
                  ));
                } else if (cTempatlahir.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Tempat masih kosong',
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
                  ));
                } else if (cTanggallahir.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Tanggal masih kosong',
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
                  ));
                }
                // else if (_pilihKelamin.text.isEmpty) {
                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //     content: Text(
                //       'Kelamin masih kosong',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //     backgroundColor: Colors.red,
                //     action: SnackBarAction(
                //       label: 'ULANGI',
                //       textColor: Colors.white,
                //       onPressed: () {
                //         print('ULANGI snackbar');
                //       },
                //     ),
                //   ));
                // } else if (_pilihAgama.text.isEmpty) {
                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //     content: Text(
                //       'Agama masih kosong',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //     backgroundColor: Colors.red,
                //     action: SnackBarAction(
                //       label: 'ULANGI',
                //       textColor: Colors.white,
                //       onPressed: () {
                //         print('ULANGI snackbar');
                //       },
                //     ),
                //   ));
                // } else if (_pilihKawin.text.isEmpty) {
                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //     content: Text(
                //       'Status masih kosong',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //     backgroundColor: Colors.red,
                //     action: SnackBarAction(
                //       label: 'ULANGI',
                //       textColor: Colors.white,
                //       onPressed: () {
                //         print('ULANGI snackbar');
                //       },
                //     ),
                //   ));
                // } else if (_pilihPekerjaaan.text.isEmpty) {
                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //     content: Text(
                //       'Pekerjaan masih kosong',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //     backgroundColor: Colors.red,
                //     action: SnackBarAction(
                //       label: 'ULANGI',
                //       textColor: Colors.white,
                //       onPressed: () {
                //         print('ULANGI snackbar');
                //       },
                //     ),
                //   ));
                // }
                else if (cKewarganegaraan.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Warga Negara masih kosong',
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
                  ));
                } else if (cAlamatKTP.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Alamat KTP masih kosong',
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
                  ));
                } else if (cKotaKTP.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Kota KTP masih kosong',
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
                  ));
                } else if (cKecamatanKTP.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Kecamatan KTP masih kosong',
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
                  ));
                } else if (cDesaKTP.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Desa KTP masih kosong',
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
                  ));
                } else if (cRTKTP.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'RT KTP masih kosong',
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
                  ));
                } else if (cRWKTP.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Alamat KTP masih kosong',
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
                  ));
                } else if (cKodeposKTP.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Alamat KTP masih kosong',
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
                  ));
                } else if (cAlamat.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Alamat domisili kosong',
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
                  ));
                } else if (cRT.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'RT Domisili masih kosong',
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
                  ));
                } else if (cRW.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'RW Domisili masih kosong',
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
                  ));
                } else if (cKodepos.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'POS Domisili kosong',
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
                  ));
                } else {
                  cekPrint(_pilihKelamin, _pilihAgama, _pilihKawin,
                      _pilihPekerjaaan);
                }

                // print(cNama);
                // print("DAFTAR");
                // print(_pilihKelamin);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15.0),
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // <-- Radius
                ),
              ),
              child: Text(
                'SIMPAN',
                style: TextStyle(
                  color: Colors.brown[800],
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          );
  }

  Widget _formNIK() {
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
              controller: cNIK,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(16),
              ],
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.credit_card_rounded,
                    color: Colors.brown[800],
                  ),
                  hintText: loadingdata ? "Memuat.." : "NIK",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  counterText: ''),
              // maxLength: 16,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'NIK tidak boleh kosong';
                }
                if (value!.length != 16) {
                  return 'NIK harus memiliki 16 digit';
                }
                return null; // Return null to indicate the input is valid
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _formNama() {
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
              controller: cNama,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Nama",
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

  Widget _formTempatLahir() {
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
              controller: cTempatlahir,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.home,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Tempat Lahir",
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

  Widget _formTglLahir() {
    return Container(
      alignment: Alignment.centerLeft,
      // decoration: kBoxDecorationStyle2,
      // height: 60.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: DateTimeField(
        controller: cTanggallahir,
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
        decoration: InputDecoration(
          // border: InputBorder.none,
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          prefixIcon: Icon(
            Icons.date_range,
            color: Colors.brown[800],
          ),
          hintText: loadingdata ? "Memuat.." : "Tanggal Lahir",
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _formKelamin() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Container(
            decoration: decorationTextField,
            child: DropdownButtonFormField(
              isDense: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_city, color: Colors.brown[800]),
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
              hint: loadingdata
                  ? Text('Memuat')
                  : cKelamin.text.isEmpty
                      ? Text('Pilih Kelamin')
                      : Text(cKelamin.text),
              isExpanded: true,
              items: kelaminAPI.map(
                (item0) {
                  return DropdownMenuItem(
                    child: Text(item0['nama'].toString()),
                    value: item0['id'].toString(),
                  );
                },
              ).toList(),
              onChanged: (val0) async {
                setState(() {
                  _pilihKelamin = val0 as String;
                  print("KLIK");
                  print(_pilihKelamin);
                });

                // Wait for getKecamatan() to complete before rebuilding the widget
              },
              value: _pilihKelamin,
            ),
          )
        ],
      ),
    );
  }

  Widget _formAgama() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Container(
            decoration: decorationTextField,
            child: DropdownButtonFormField(
              isDense: true,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.mosque,
                  color: Colors.brown[800],
                ),
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
              hint: loadingdata
                  ? Text('Memuat')
                  : cAgama.text.isEmpty
                      ? Text('Pilih Agama')
                      : Text(cAgama.text),
              isExpanded: true,
              items: agamaAPI.map(
                (item2) {
                  return DropdownMenuItem(
                    child: Text(item2['nama'].toString()),
                    value: item2['id'].toString(),
                  );
                },
              ).toList(),
              onChanged: (val2) async {
                setState(() {
                  _pilihAgama = val2 as String;
                  print(_pilihAgama);
                });

                // Wait for getKecamatan() to complete before rebuilding the widget
              },
              value: _pilihAgama,
            ),
          )
        ],
      ),
    );
  }

  Widget _formKawin() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Container(
            decoration: decorationTextField,
            child: DropdownButtonFormField(
              isDense: true,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.emoji_people_sharp,
                  color: Colors.brown[800],
                ),
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
              hint: loadingdata
                  ? Text('Memuat')
                  : cStstusKawin.text.isEmpty
                      ? Text('Pilih Status')
                      : Text(cStstusKawin.text),
              isExpanded: true,
              items: kawinAPI.map(
                (item3) {
                  return DropdownMenuItem(
                    child: Text(item3['nama'].toString()),
                    value: item3['id'].toString(),
                  );
                },
              ).toList(),
              onChanged: (val3) async {
                setState(() {
                  _pilihKawin = val3 as String;
                  print(_pilihKawin);
                });

                // Wait for getKecamatan() to complete before rebuilding the widget
              },
              value: _pilihKawin,
            ),
          )
        ],
      ),
    );
  }

  Widget _formPekerjaan() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Container(
            decoration: decorationTextField,
            child: DropdownButtonFormField(
              isDense: true,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.work,
                  color: Colors.brown[800],
                ),
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
              hint: loadingdata
                  ? Text('Memuat')
                  : cPekerjaan.text.isEmpty
                      ? Text('Pilih Pekerjaan')
                      : Text(cPekerjaan.text),
              isExpanded: true,
              items: pekerjaanAPI.map(
                (item4) {
                  return DropdownMenuItem(
                    child: Text(item4['nama'].toString()),
                    value: item4['id'].toString(),
                  );
                },
              ).toList(),
              onChanged: (val4) async {
                setState(() {
                  _pilihPekerjaaan = val4 as String;
                  print(_pilihPekerjaaan);
                });

                // Wait for getKecamatan() to complete before rebuilding the widget
              },
              value: _pilihPekerjaaan,
            ),
          )
        ],
      ),
    );
  }

  Widget _formKewarganegaraan() {
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
              controller: cKewarganegaraan,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.flag_rounded,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Kewarganegaraan",
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

  Widget _formAlamatKTP() {
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
              controller: cAlamatKTP,
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
                  Icons.home,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Alamat KTP",
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

  Widget _formKotaKTP() {
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
              controller: cKotaKTP,
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
                  Icons.business_outlined,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Kota",
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

  Widget _formKecKTP() {
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
              controller: cKecamatanKTP,
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
                  Icons.business_outlined,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Kecamatan",
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

  Widget _formDesaKTP() {
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
              controller: cDesaKTP,
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
                  Icons.business_outlined,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Desa",
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

  Widget _formRtKTP() {
    return Container(
      // width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.46,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: cRTKTP,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(5),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.numbers,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "RT",
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

  Widget _formRwKTP() {
    return Container(
      // width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.46,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: cRWKTP,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(5),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.numbers,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "RW",
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

  Widget _formPosKTP() {
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
              controller: cKodeposKTP,
              keyboardType: TextInputType.number,
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
                  Icons.markunread_mailbox,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Kode Pos",
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

  Widget _formAlamatDomisili() {
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
              controller: cAlamat,
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
                  Icons.home,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Alamat Domisili",
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

  Widget _formRtDomisili() {
    return Container(
      // width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.46,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: cRT,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(5),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.numbers,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "RT Domisili",
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

  Widget _formRwDomisili() {
    return Container(
      // width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.46,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: cRW,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(5),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.numbers,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "RW Domisili",
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

  Widget _formPosDomisili() {
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
              controller: cKodepos,
              keyboardType: TextInputType.number,
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
                  Icons.markunread_mailbox,
                  color: Colors.brown[800],
                ),
                hintText: loadingdata ? "Memuat.." : "Kode Pos Domisili",
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
}
