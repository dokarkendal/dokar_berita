import 'package:dokar_aplikasi/berita/cek.dart';
import 'package:dokar_aplikasi/berita/hal_berita_edit.dart';
import 'package:dokar_aplikasi/berita/hal_berita_list.dart';
import 'package:dokar_aplikasi/login_warga.dart';
import 'package:dokar_aplikasi/pilih_akun.dart';
import 'package:dokar_aplikasi/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokar_aplikasi/screens/splash_screen.dart';
import 'package:dokar_aplikasi/hal_dua.dart';
import 'package:dokar_aplikasi/daftar_admin.dart';
import 'package:dokar_aplikasi/daftar_warga.dart';
import 'package:dokar_aplikasi/daftar_warga_login.dart';
import 'package:dokar_aplikasi/berita/hal_tab_berita_warga.dart';
import 'package:dokar_aplikasi/berita/hal_tab_berita_admin.dart';
import 'package:dokar_aplikasi/login_admin.dart';
import 'package:dokar_aplikasi/berita/hal_admin_tes.dart';
import 'package:dokar_aplikasi/berita/form/form_berita.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Splash Screen',
    routes: <String, WidgetBuilder>{
      '/Haldua': (BuildContext context) => new Haldua(),
      '/LoginPage': (BuildContext context) => new LoginPage(),
      '/PilihAkun': (BuildContext context) => new PilihAKun(),
      '/DaftarWarga': (BuildContext context) => new DaftarWarga(),
      '/DaftarAdmin': (BuildContext context) => new DaftarAdmin(),
      '/DaftarWargaLogin': (BuildContext context) => new DaftarWargaLogin(),
      '/HalamanBeritaWarga': (BuildContext context) => new HalamanBeritaWarga(),
      '/HalamanBeritaadmin': (BuildContext context) => new HalamanBeritaadmin(),
      '/Login': (BuildContext context) => new Login(),
      '/AdminTes': (BuildContext context) => new AdminTes(),
      '/FormBerita': (BuildContext context) => new FormBerita(),
      '/FormBeritaEdit': (BuildContext context) => new FormBeritaEdit(),
      '/FormBeritaDashbord': (BuildContext context) => new FormBeritaDashbord(),
      '/OnboardingPage': (BuildContext context) => new OnboardingPage(),
      '/DoctorsInfo': (BuildContext context) => new DoctorsInfo(),

      //'/Dialogs': (BuildContext context) => new Dialogs(),
    },
    home: SplashScreenPage(),
  ));
}

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      debugShowCheckedModeBanner: false,
      home: SplashScreenPage(),
    );
  }
}*/
