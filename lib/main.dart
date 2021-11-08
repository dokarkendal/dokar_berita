//ANCHOR package navigator
import 'package:dokar_aplikasi/akun/hal_akun.dart';
import 'package:dokar_aplikasi/berita/detail_page_kritiksaran_warga.dart';
import 'package:dokar_aplikasi/berita/form/form_kritik_warga.dart';
import 'package:dokar_aplikasi/berita/form/hal_kritik_warga.dart';
import 'package:dokar_aplikasi/berita/hal_siskeudes.dart';
import 'package:dokar_aplikasi/berita/tes.dart';
import 'package:dokar_aplikasi/akun/google_account.dart';
import 'package:dokar_aplikasi/akun/hal_akun_add.dart';
import 'package:dokar_aplikasi/akun/hal_expansion_tes.dart';
import 'package:dokar_aplikasi/akun/hal_profil_desa.dart';
import 'package:dokar_aplikasi/berita/bantuan.dart';
import 'package:dokar_aplikasi/berita/galeri.dart';
import 'package:dokar_aplikasi/berita/detail_page_berita.dart';
import 'package:dokar_aplikasi/berita/edit/hal_akun_edit.dart';
import 'package:dokar_aplikasi/berita/edit/hal_akun_edit_semua.dart';
import 'package:dokar_aplikasi/berita/edit/hal_berita_edit.dart';
import 'package:dokar_aplikasi/berita/edit_semua.dart';
import 'package:dokar_aplikasi/berita/form/form_bumdes.dart';
import 'package:dokar_aplikasi/berita/form/form_inovasi.dart';
import 'package:dokar_aplikasi/berita/form/form_agenda.dart';
import 'package:dokar_aplikasi/berita/form/form_kegiatan.dart';
import 'package:dokar_aplikasi/berita/hal_agenda.dart';
import 'package:dokar_aplikasi/berita/list/hal_penulis_list.dart';
import 'package:dokar_aplikasi/berita/detail_galeri.dart';
import 'package:dokar_aplikasi/berita/hal_input.dart';
import 'package:dokar_aplikasi/berita/hal_tab_berita_warga.dart';
import 'package:dokar_aplikasi/berita/hal_tab_berita_admin.dart';
import 'package:dokar_aplikasi/berita/detail_page_agenda.dart';
import 'package:dokar_aplikasi/berita/list/hal_berita_list.dart';
import 'package:dokar_aplikasi/berita/list/hal_list_desa.dart';
import 'package:dokar_aplikasi/berita/list/hal_list_kecamatan.dart';
import 'package:dokar_aplikasi/berita/list/hal_bumdes_list.dart';
import 'package:dokar_aplikasi/berita/list/hal_event_list.dart';
import 'package:dokar_aplikasi/berita/list/hal_inovasi_list.dart';
import 'package:dokar_aplikasi/berita/list/hal_kegiatan_list.dart';
import 'package:dokar_aplikasi/profil/data/hal_agenda_profile.dart';
import 'package:dokar_aplikasi/profil/data/hal_berita_profile.dart';
import 'package:dokar_aplikasi/profil/data/hal_bid_profile.dart';
import 'package:dokar_aplikasi/profil/data/hal_bumdes_profile.dart';
import 'package:dokar_aplikasi/profil/data/hal_fasum_detail_page.dart';
import 'package:dokar_aplikasi/profil/data/hal_fasum_ibadah.dart';
import 'package:dokar_aplikasi/profil/data/hal_fasum_kesehatan.dart';
import 'package:dokar_aplikasi/profil/data/hal_fasum_olahraga.dart';
import 'package:dokar_aplikasi/profil/data/hal_fasum_pendidikan.dart';
import 'package:dokar_aplikasi/profil/data/hal_fasum_profile.dart';
import 'package:dokar_aplikasi/profil/data/hal_galeri_profile.dart';
import 'package:dokar_aplikasi/profil/data/hal_kegiatan_profile.dart';
import 'package:dokar_aplikasi/profil/data/hal_potensi_profile.dart';
import 'package:dokar_aplikasi/profil/data/hal_siskeudes_profile.dart';
import 'package:dokar_aplikasi/profil/hal_aparatur.dart';
import 'package:dokar_aplikasi/profil/hal_profil.dart';
import 'package:dokar_aplikasi/profil/hal_sejarah.dart';
import 'package:dokar_aplikasi/profil/hal_visimisi.dart';
import 'package:dokar_aplikasi/screens/onboarding_screen.dart';
import 'package:dokar_aplikasi/berita/form/form_berita.dart';
import 'package:dokar_aplikasi/screens/splash_screen.dart';
import 'package:dokar_aplikasi/berita/hal_admin_tes.dart';
import 'package:dokar_aplikasi/daftar_warga_login.dart';
import 'package:dokar_aplikasi/daftar_admin.dart';
import 'package:dokar_aplikasi/daftar_warga.dart';
import 'package:dokar_aplikasi/berita/hal_berita.dart';
import 'package:dokar_aplikasi/login_warga.dart';
import 'package:dokar_aplikasi/login_admin.dart';
import 'package:dokar_aplikasi/pilih_akun.dart';
import 'package:dokar_aplikasi/hal_dua.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'berita/detail_page_kritiksaran.dart';
import 'berita/hal_kritiksaran.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light),
  );
//ANCHOR routes halaman
  runApp(
    MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.

        primaryColor: Color(0xFFfecd2e),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Splash Screen',
      routes: <String, WidgetBuilder>{
        '/HalSiskeudesProfile': (BuildContext context) =>
            new HalSiskeudesProfile(),
        '/FormKritikWarga': (BuildContext context) => new FormKritikWarga(),
        '/DetailKritikSaranWarga': (BuildContext context) =>
            new DetailKritikSaranWarga(),
        '/FormKritikSaran': (BuildContext context) => new FormKritikSaran(),
        '/ListKecamatan': (BuildContext context) => new ListKecamatan(),
        '/GoogleAccount': (BuildContext context) => new GoogleAccount(),
        '/ListDesa': (BuildContext context) => new ListDesa(),
        '/HalbumdesProfile': (BuildContext context) => new HalbumdesProfile(),
        '/AgendaProfile': (BuildContext context) => new AgendaProfile(),
        '/HalFasumDetailPage': (BuildContext context) =>
            new HalFasumDetailPage(),
        '/HalFasumPendidikan': (BuildContext context) =>
            new HalFasumPendidikan(),
        '/HalAparaturDesa': (BuildContext context) => new HalAparaturDesa(),
        '/SimplePieChart': (BuildContext context) => new SimplePieChart(),
        '/HalFasumOlahraga': (BuildContext context) => new HalFasumOlahraga(),
        '/HalFasumKesehatan': (BuildContext context) => new HalFasumKesehatan(),
        '/HalFasumIbadah': (BuildContext context) => new HalFasumIbadah(),
        '/HalFasumProfile': (BuildContext context) => new HalFasumProfile(),
        '/GaleriProfile': (BuildContext context) => new GaleriProfile(),
        '/HalBIDProfile': (BuildContext context) => new HalBIDProfile(),
        '/HalPotensiProfile': (BuildContext context) => new HalPotensiProfile(),
        '/HalKegiatanProfile': (BuildContext context) =>
            new HalKegiatanProfile(),
        '/HalberitaProfile': (BuildContext context) => new HalberitaProfile(),
        '/HalSejarahDesa': (BuildContext context) => new HalSejarahDesa(),
        '/HalVisiDesa': (BuildContext context) => new HalVisiDesa(),
        '/HalProfilDesa': (BuildContext context) => new HalProfilDesa(),
        '/ProfilDesa': (BuildContext context) => new ProfilDesa(),
        '/FormAkunEditSemua': (BuildContext context) => new FormAkunEditSemua(),
        '/ListPenulis': (BuildContext context) => new ListPenulis(),
        '/Login': (BuildContext context) => new Login(),
        '/HomePage': (BuildContext context) => new HomePage(),
        '/FormAddAkun': (BuildContext context) => new FormAddAkun(),
        '/Berita': (BuildContext context) => new Berita(),
        '/Agenda': (BuildContext context) => new Agenda(),
        '/HalAkun': (BuildContext context) => new HalAkun(),
        '/PilihAKun': (BuildContext context) => new PilihAKun(),
        '/FormAkunEdit': (BuildContext context) => new FormAkunEdit(),
        '/Haldua': (BuildContext context) => new Haldua(),
        '/AdminTes': (BuildContext context) => new AdminTes(),
        '/EditSemua': (BuildContext context) => new EditSemua(),
        '/InputSemua': (BuildContext context) => new InputSemua(),
        '/LoginPage': (BuildContext context) => new LoginPage(),
        '/ExpansionTileSample': (BuildContext context) =>
            new ExpansionTileSample(),
        '/PilihAkun': (BuildContext context) => new PilihAKun(),
        '/FormBerita': (BuildContext context) => new FormBerita(),
        '/FormInovasi': (BuildContext context) => new FormInovasi(),
        '/FormBumdes': (BuildContext context) => new FormBumdes(),
        '/FormKegiatan': (BuildContext context) => new FormKegiatan(),
        '/DaftarWarga': (BuildContext context) => new DaftarWarga(),
        '/DaftarAdmin': (BuildContext context) => new DaftarAdmin(),
        '/AgendaDetail': (BuildContext context) => new AgendaDetail(),
        '/FormBeritaEdit': (BuildContext context) => new FormBeritaEdit(),
        '/OnboardingPage': (BuildContext context) => new OnboardingPage(),
        '/DaftarWargaLogin': (BuildContext context) => new DaftarWargaLogin(),
        '/HalamanBeritaWarga': (BuildContext context) =>
            new HalamanBeritaWarga(),
        '/HalamanBeritaadmin': (BuildContext context) =>
            new HalamanBeritaadmin(),
        '/FormBeritaDashbord': (BuildContext context) =>
            new FormBeritaDashbord(),
        '/HalKegiatanList': (BuildContext context) => new HalKegiatanList(),
        '/HalInovasiList': (BuildContext context) => new HalInovasiList(),
        '/HalBumdesList': (BuildContext context) => new HalBumdesList(),
        '/HalEventList': (BuildContext context) => new HalEventList(),
        '/DetailBerita': (BuildContext context) => new DetailBerita(),
        '/FormAgenda': (BuildContext context) => new FormAgenda(),
        '/Galeri': (BuildContext context) => new Galeri(),
        '/Tes': (BuildContext context) => new Tes(),
        '/DetailGaleri': (BuildContext context) => new DetailGaleri(),
        '/KritikSaran': (BuildContext context) => new KritikSaran(),
        '/DetailKritikSaran': (BuildContext context) => new DetailKritikSaran(),
      },
      home: SplashScreenPage(),
    ),
  );
}
