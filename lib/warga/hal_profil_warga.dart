import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import '../style/styleset.dart';

class HalProfilWarga extends StatefulWidget {
  const HalProfilWarga({super.key});

  @override
  State<HalProfilWarga> createState() => _HalProfilWargaState();
}

class _HalProfilWargaState extends State<HalProfilWarga> {
  bool loadingdata = false;
  String cId = "";
  String cUid = "";
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
  String? cKota = "";
  String? cKotaDomisili = "";
  String? cKecamatan = "";
  String? cKecamatanDomisili = "";
  String? cDesa = "";
  String? cDesaDomisili = "";
  String? cRT = "";
  String? cRTDomisili = "";
  String? cRW = "";
  String? cRWDomisili = "";
  String? cKewarganegaraan = "";
  String? cKodepos = "";
  String? cKodeposDomisili = "";
  String? iddesa = "";

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
        cId = cekProfil['id'];
        cUid = cekProfil['uid'];
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
        cKewarganegaraan = cekProfil['kewarganegaraan'];
        cAlamat = cekProfil['alamat'];
        cKota = cekProfil['kota'];
        cKecamatan = cekProfil['kecamatan'];
        cDesa = cekProfil['desa'];
        cRT = cekProfil['rt'];
        cRW = cekProfil['rw'];
        cKodepos = cekProfil['kodepos'];
        cAlamatDomisili = cekProfil['domisili_alamat'];
        cKotaDomisili = cekProfil['domisili_kota'];
        cKecamatanDomisili = cekProfil['domisili_kecamatan'];
        cDesaDomisili = cekProfil['domisili_desa'];
        cRTDomisili = cekProfil['domisili_rt'];
        cRWDomisili = cekProfil['domisili_rw'];
        cKodeposDomisili = cekProfil['domisili_pos'];
        iddesa = cekProfil['id_desa'];
        loadingdata = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cekProfil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          "DATA DIRI",
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
            // fontSize: 25.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            iconSize: 23.0,
            onPressed: () async {
              Navigator.pushNamed(context, '/HalLengkapiDataWarga');
              // .then((value) => detailAkunWarga());
            },
          )
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: loadingdata
          ? _buildProgressIndicator()
          : Container(
              color: Colors.grey.shade200,
              child: ListView(
                children: [
                  _profil(),
                  _profilKTP(),
                  _profilDomisili(),
                ],
              ),
            ),
    );
  }

  //ANCHOR loading
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

  Widget _profil() {
    return Container(
      padding: const EdgeInsets.all(3),
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
                      kewarganegaraanProfil(),
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

  Widget _profilKTP() {
    return Container(
      padding: const EdgeInsets.all(3),
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
                      _profilTextKTP(),
                      _dividerHeight1(),
                      alamatProfilKTP(),
                      _dividerHeight1(),
                      kotaProfilKTP(),
                      _dividerHeight1(),
                      kecamatanProfilKTP(),
                      _dividerHeight1(),
                      desaProfilKTP(),
                      _dividerHeight1(),
                      rtrwProfilKTP(),
                      _dividerHeight1(),
                      kodeposProfilKTP(),
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

  Widget _profilDomisili() {
    return Container(
      padding: const EdgeInsets.all(3),
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
                      _profilTextDomisili(),
                      _dividerHeight1(),
                      alamatProfilDomiisli(),
                      // _dividerHeight1(),
                      // kotaProfilDomiisli(),
                      // _dividerHeight1(),
                      // kecamatanProfilDomiisli(),
                      // _dividerHeight1(),
                      // desaProfilDomisili(),
                      _dividerHeight1(),
                      rtrwProfilDomisili(),
                      _dividerHeight1(),
                      kodeposProfilDomisili(),
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
      subtitle: cNIK == null
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
      subtitle: cNIK == null
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
      subtitle: cNIK == null
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
      subtitle: cNIK == null
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
      subtitle: cNIK == null
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

  Widget kewarganegaraanProfil() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.flag,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Kewarganegaraan",
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
              "$cKewarganegaraan",
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

  Widget kotaProfilKTP() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.apartment,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Kabupaten",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cKota == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cKota",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget kecamatanProfilKTP() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.apartment,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Kecamatan",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cKecamatan == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cKecamatan",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget desaProfilKTP() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.apartment,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Desa",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cDesa == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cDesa",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget rtrwProfilKTP() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.home,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "RT / RW",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cRT == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cRT / $cRW",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget kodeposProfilKTP() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.markunread_mailbox_rounded,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Kode Pos",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cKodepos == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cKodepos",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget alamatProfilDomiisli() {
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
        "Alamat Domisili",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cAlamatDomisili == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cAlamatDomisili",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget kotaProfilDomiisli() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.apartment,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Kabupaten Domiisli",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cKotaDomisili == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cKotaDomisili",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget kecamatanProfilDomiisli() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.apartment,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Kecamatan Domiisli",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cKecamatanDomisili == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cKecamatanDomisili",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget desaProfilDomisili() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.apartment,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Desa Domisili",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cDesaDomisili == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cDesaDomisili",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget rtrwProfilDomisili() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.home,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "RT / RW Domisili",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cRTDomisili == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cRTDomisili / $cRWDomisili ",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget kodeposProfilDomisili() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.markunread_mailbox_rounded,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      title: const AutoSizeText(
        "Kode Pos Domisili ",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.center,
      ),
      subtitle: cKodeposDomisili == null
          ? Text(
              "memuat..",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.blue[800],
              ),
            )
          : Text(
              "$cKodeposDomisili ",
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget _profilText() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(
        "Akun",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _profilTextKTP() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(
        "Identitas KTP",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _profilTextDomisili() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(
        "Identitas Domisili",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
