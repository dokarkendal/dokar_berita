import 'package:flutter/material.dart';

class ExpansionTileSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Bantuan",
          style: TextStyle(
            color: Color(0xFF2e2e2e),
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              tMasuk(),
              tBerita(),
              tAkun(),
              tDashbordInput(),
              tEdit(),
              tPublish(),
              tUnpublish(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget tMasuk() {
  return Card(
    child: ExpansionTile(
      leading: Icon(
        Icons.fingerprint,
        color: Color(0xFF2e2e2e),
      ),
      title: Text(
        "Masuk",
        style: TextStyle(
          color: Color(0xFF2e2e2e),
          fontWeight: FontWeight.bold,
        ),
      ),
      children: <Widget>[
        ExpansionTile(
          title: Text("Admin"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih tombol admin",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Menu admin di tujukan untuk admin pengelola website desa yang sudah mempunyai user dan password",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/1.png',
                width: 300.0,
                height: 50.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Masukan user dan password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "User dan password di dapatkan dari Dinas Komunikasi Kabupaten Kendal",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/2.png',
                width: 200.0,
                height: 200.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Klik tombol login ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Jika salah, akan ada indikator kesalahan. jika benar akan menuju dashbord",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/3.png',
                width: 300.0,
                height: 50.0,
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
        ExpansionTile(
          title: Text("Lewati"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih tombol lewati",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilihan untuk masayarakat umum untuk melihat berita selain admin pengelola website desa",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/4.png',
                width: 300.0,
                height: 50.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Halaman berita warga",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Halaman berita untuk warga umum",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/5.png',
                width: 200.0,
                height: 300.0,
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ],
    ),
  );
}

Widget tBerita() {
  return Card(
    child: ExpansionTile(
      leading: Icon(
        Icons.library_books,
        color: Color(0xFF2e2e2e),
      ),
      title: Text(
        "Berita",
        style: TextStyle(
          color: Color(0xFF2e2e2e),
          fontWeight: FontWeight.bold,
        ),
      ),
      children: <Widget>[
        ExpansionTile(
          title: Text("Konten"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih Beranda",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih beranda pada dashbord admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/6.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih tab berita",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih tab sesuai informasi yang di inginkan",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/7.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("Pencarian"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Klik icon cari",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Di halaman beranda sebelah kanan atas",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/8.png',
                width: 300.0,
                height: 80.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Ketik pencarian berita",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Tulis keyword informasi yang ingin di cari",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/9.png',
                width: 300.0,
                height: 80.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "3. Hasil pencarian",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Hasil pencarian berita",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/10.png',
                width: 300.0,
                height: 120.0,
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ],
    ),
  );
}

Widget tAkun() {
  return Card(
    child: ExpansionTile(
      leading: Icon(
        Icons.account_circle,
        color: Color(0xFF2e2e2e),
      ),
      title: Text(
        "Akun",
        style: TextStyle(
          color: Color(0xFF2e2e2e),
          fontWeight: FontWeight.bold,
        ),
      ),
      children: <Widget>[
        ExpansionTile(
          title: Text("Edit akun Admin"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu akun",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Di sebelah diri atas halaman dashbord admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/11.png',
                width: 300.0,
                height: 80.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih Edit akun",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Jika anda mengubah data , anda harus login lagi",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/12.png',
                width: 150.0,
                height: 300.0,
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
        ExpansionTile(
          title: Text("Edit akun Penulis"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu penulis",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu penulis di dashbord",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/penulis.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Slide penulis",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pada halaman penulis, slide penulis yang mau di edit",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/editpenulis.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "3.Pilih Edit",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Edit data penulis sesuai keinginan",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/editpenulis2.png',
                width: 150.0,
                height: 300.0,
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
        ExpansionTile(
          title: Text("Add akun"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih Penulis",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih icon di sebelah kiri atas",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/penulis.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih icon add akun",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Di sebalh kanan atas di halaman akun",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/addakun.png',
                width: 300.0,
                height: 80.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "3. Isi data",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "isi detail user admin atau penulis dan 'SIMPAN'",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/14.png',
                width: 150.0,
                height: 300.0,
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
        ExpansionTile(
          title: Text("Log out"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih icon logout",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu logout di halaman dashbord admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/16.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Login ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Jika anda logout anda harus login lagi untuk masuk dashbord",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/2.png',
                width: 200.0,
                height: 200.0,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget tEdit() {
  return Card(
    child: ExpansionTile(
      leading: Icon(
        Icons.spellcheck,
        color: Color(0xFF2e2e2e),
      ),
      title: Text(
        "Edit",
        style: TextStyle(
          color: Color(0xFF2e2e2e),
          fontWeight: FontWeight.bold,
        ),
      ),
      children: <Widget>[
        ExpansionTile(
          title: Text("Edit Berita"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu dashbord",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu dashbord di halaman admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/dashbord.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'Berita'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu Berita",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/berita2.png',
                width: 300.0,
                height: 80.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "3. Pilih 'Berita' yang ingin di edit",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Ubah berita dan pilih 'SIMPAN'",
                style: TextStyle(),
              ),
            ),
            /*Container(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/images/onboarding2.png',
                width: 120.0,
                height: 120.0,
              ),
            ),*/
          ],
        ),
        ExpansionTile(
          title: Text("Edit Kegiatan"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu dashbord",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu dashbord di halaman admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/dashbord.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'Kegiatan'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu Kegiatan",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/kegiatan2.png',
                width: 300.0,
                height: 80.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "3. Pilih 'Kegiatan' yang ingin di edit",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Ubah kegiatan dan pilih 'SIMPAN'",
                style: TextStyle(),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("Edit BID"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu dashbord",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu dashbord di halaman admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/bantuan/dashbord.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'BID'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu BID",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/bantuan/BID.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "3. Pilih 'BID' yang ingin di edit",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Ubah BID dan pilih 'SIMPAN'",
                style: TextStyle(),
              ),
            ),
            /*Container(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/images/onboarding2.png',
                width: 120.0,
                height: 120.0,
              ),
            ),*/
          ],
        ),
        ExpansionTile(
          title: Text("Edit Bumdes"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu dashbord",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu dashbord di halaman admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/dashbord.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'Bumdes'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu Bumdes",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/bumdes2.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "3. Pilih 'Bumdes' yang ingin di edit",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Ubah bumdes dan pilih 'SIMPAN'",
                style: TextStyle(),
              ),
            ),
            /*Container(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/images/onboarding2.png',
                width: 120.0,
                height: 120.0,
              ),
            ),*/
          ],
        ),
        ExpansionTile(
          title: Text("Edit Agenda"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu dashbord",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu dashbord di halaman admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/bantuan/dashbord.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'Agenda'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu Agenda",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/bantuan/agenda2.png',
                width: 300.0,
                height: 80.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "3. Pilih 'Agenda' yang ingin di edit",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Ubah berita dan pilih 'SIMPAN'",
                style: TextStyle(),
              ),
            ),
            /*Container(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/images/onboarding2.png',
                width: 120.0,
                height: 120.0,
              ),
            ),*/
          ],
        ),
      ],
    ),
  );
}

Widget tPublish() {
  return Card(
    child: ExpansionTile(
      leading: Icon(
        Icons.undo,
        color: Color(0xFF2e2e2e),
      ),
      title: Text(
        "Publish",
        style: TextStyle(
          color: Color(0xFF2e2e2e),
          fontWeight: FontWeight.bold,
        ),
      ),
      children: <Widget>[
        ExpansionTile(
          title: Text("Publish Berita"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu dashbord",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu dashbord di halaman admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/dashbord.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'Berita'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu Berita",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/beritapub.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "3. Publish",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Slide ke kanan untuk publish ",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/publish.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("Publish Kegiatan"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu dashbord",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu dashbord di halaman admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/dashbord.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'Kegiatan'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu Kegiatan",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/kegiatanpub.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "3. Publish",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Slide ke kanan untuk publish ",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/publish.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("Publish BID"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu dashbord",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu dashbord di halaman admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/dashbord.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'BID'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu BID",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/bidpub.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "3. Publish",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Slide ke kanan untuk publish ",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/publish.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("Publish Bumdes"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu dashbord",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu dashbord di halaman admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/dashbord.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'Bumdes'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu Bumdes",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/bumdespub.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "3. Publish",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Slide ke kanan untuk publish ",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/publish.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget tUnpublish() {
  return Card(
    child: ExpansionTile(
      leading: Icon(
        Icons.redo,
        color: Color(0xFF2e2e2e),
      ),
      title: Text(
        "UnPublish",
        style: TextStyle(
          color: Color(0xFF2e2e2e),
          fontWeight: FontWeight.bold,
        ),
      ),
      children: <Widget>[
        ExpansionTile(
          title: Text("UnPublish Berita"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu dashbord",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu dashbord di halaman admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/dashbord.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'Berita'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu Berita",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/beritapub.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "3. UnPublish",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Slide ke kanan untuk Unpublish ",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/publish.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("UnPublish Kegiatan"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu dashbord",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu dashbord di halaman admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/dashbord.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'Kegiatan'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu Kegiatan",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/kegiatanpub.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "3. UnPublish",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Slide ke kanan untuk Unpublish ",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/publish.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("UnPublish BID"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu dashbord",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu dashbord di halaman admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/dashbord.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'BID'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu BID",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/bidpub.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "3. UnPublish",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Slide ke kanan untuk Unpublish ",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/publish.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("UnPublish Bumdes"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu dashbord",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu dashbord di halaman admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/dashbord.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'Bumdes'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu Bumdes",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/bumdespub.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "3. UnPublish",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Slide ke kanan untuk Unpublish ",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/publish.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget tDashbordInput() {
  return Card(
    child: ExpansionTile(
      leading: Icon(
        Icons.create,
        color: Color(0xFF2e2e2e),
      ),
      title: Text(
        "Input",
        style: TextStyle(
          color: Color(0xFF2e2e2e),
          fontWeight: FontWeight.bold,
        ),
      ),
      children: <Widget>[
        ExpansionTile(
          title: Text("Input Berita"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu Tulis",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu tulis di dashbord admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/tulis.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'Berita'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Tulis berita sesuai form yang tersedia dan upload",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/berita.png',
                width: 300.0,
                height: 80.0,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("Input Kegiatan"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu Tulis",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu tulis di dashbord admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/tulis.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'Kegiatan'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Tulis kegiatan sesuai form yang tersedia dan upload",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/kegiatan.png',
                width: 300.0,
                height: 80.0,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("Input BID"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu Tulis",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu BID di dashbord admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/tulis.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'BID'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Tulis BID sesuai form yang tersedia dan upload",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/BID.png',
                width: 300.0,
                height: 80.0,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("Input Bumdes"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu Tulis",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu Bumdes di dashbord admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/tulis.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'Bumdes'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Tulis Bumdes sesuai form yang tersedia dan upload",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/bumdes.png',
                width: 300.0,
                height: 80.0,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("Input Agenda"),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "1. Pilih menu Tulis",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Pilih menu Agenda di dashbord admin",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/tulis.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "2. Pilih menu 'Agenda'",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Tulis Agenda sesuai form yang tersedia dan upload",
                style: TextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bantuan/agenda.png',
                width: 300.0,
                height: 80.0,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
