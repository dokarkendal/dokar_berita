//ANCHOR package navigator
import 'package:dokar_aplikasi/akun/hal_akun.dart';
import 'package:dokar_aplikasi/berita/detail_page_kritiksaran_warga.dart';
import 'package:dokar_aplikasi/berita/form/form_kritik_warga.dart';
import 'package:dokar_aplikasi/berita/form/hal_kritik_warga.dart';
import 'package:dokar_aplikasi/berita/hal_siskeudes.dart';
// import 'package:dokar_aplikasi/berita/tes.dart';
// import 'package:dokar_aplikasi/akun/google_account.dart';
import 'package:dokar_aplikasi/akun/hal_akun_add.dart';
// import 'package:dokar_aplikasi/akun/hal_expansion_tes.dart';
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
import 'package:dokar_aplikasi/hal_dashboard_warga.dart';
import 'package:dokar_aplikasi/hal_login_warga.dart';
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
// import 'package:dokar_aplikasi/screens/onboarding_screen.dart';
import 'package:dokar_aplikasi/berita/form/form_berita.dart';
import 'package:dokar_aplikasi/screens/splash_screen.dart';
// import 'package:dokar_aplikasi/berita/hal_admin_tes.dart';
// import 'package:dokar_aplikasi/daftar_warga_login.dart';
import 'package:dokar_aplikasi/hal_login_admin.dart';
// import 'package:dokar_aplikasi/daftar_warga.dart';
import 'package:dokar_aplikasi/berita/hal_berita.dart';
// import 'package:dokar_aplikasi/login_warga.dart';
// import 'package:dokar_aplikasi/login_admin.dart';
import 'package:dokar_aplikasi/hal_pilih_user.dart';
import 'package:dokar_aplikasi/hal_dashboard_admin.dart';
import 'package:dokar_aplikasi/version/version.dart';
import 'package:dokar_aplikasi/warga/detail_galeri_warga.dart';
import 'package:dokar_aplikasi/warga/edit/form_edit_warga.dart';
import 'package:dokar_aplikasi/warga/hal_data_dukung_surat.dart';
import 'package:dokar_aplikasi/warga/hal_lengkapi_data_warga.dart';
import 'package:dokar_aplikasi/warga/hal_lengkapi_dokumen_warga.dart';
import 'package:dokar_aplikasi/warga/hal_profil_warga.dart';
import 'package:dokar_aplikasi/warga/surat/detail_surat_warga.dart';
import 'package:dokar_aplikasi/warga/surat/hal_surat_semua.dart';
import 'package:dokar_aplikasi/warga/surat/surat_pengajuan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'berita/detail_page_kritiksaran.dart';
import 'berita/hal_kritiksaran.dart';
import 'berita/tes.dart';
import 'hal_daftar_warga.dart';
import 'warga/edit/hal_edit_warga.dart';

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
        primarySwatch: Colors.orange,
        primaryColor: Colors.orange[300],
        // textTheme: TextTheme(
        //   bodyText1: TextStyle(color: Colors.red),
        // ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Splash Screen',
      routes: <String, WidgetBuilder>{
        '/HalSiskeudesProfile': (BuildContext context) => HalSiskeudesProfile(
              idDesa: '',
              kodeDesa: '',
            ),
        '/FormKritikWarga': (BuildContext context) => FormKritikWarga(
              idDesa: '',
            ),
        '/DetailKritikSaranWarga': (BuildContext context) =>
            DetailKritikSaranWarga(
              dEmail: '',
              dId: '',
              dIsi: '',
              dJudul: '',
              dNama: '',
              dPublish: '',
              dTanggal: '',
            ),
        '/FormKritikSaran': (BuildContext context) => FormKritikSaran(
              idDesa: '',
            ),
        '/ListKecamatan': (BuildContext context) => ListKecamatan(
              idDesa: '',
            ),
        // '/GoogleAccount': (BuildContext context) =>  GoogleAccount(),
        '/ListDesa': (BuildContext context) => ListDesa(
              dId: '',
              dNama: '',
            ),
        '/HalbumdesProfile': (BuildContext context) => HalbumdesProfile(
              idDesa: '',
              namaDesa: '',
            ),
        '/AgendaProfile': (BuildContext context) => AgendaProfile(
              idDesa: '',
              namaDesa: '',
            ),
        '/HalFasumDetailPage': (BuildContext context) => HalFasumDetailPage(
              dAlamat: '',
              dDesa: '',
              dDeskripsi: '',
              dGambar: '',
              dId: '',
              dJenis: '',
              dKategori: '',
              dKecamatan: '',
              dKoordinat: '',
              dNama: '',
            ),
        '/HalFasumPendidikan': (BuildContext context) => HalFasumPendidikan(
              dId: '',
              dNama: '',
              idDesa: '',
            ),
        '/HalAparaturDesa': (BuildContext context) => HalAparaturDesa(
              idDesa: '',
            ),
        '/SimplePieChart': (BuildContext context) => SimplePieChart(
              idDesa: '',
              kodeDesa: '',
            ),
        '/HalFasumOlahraga': (BuildContext context) => HalFasumOlahraga(
              dId: '',
              dNama: '',
              idDesa: '',
            ),
        '/HalFasumKesehatan': (BuildContext context) => HalFasumKesehatan(
              dId: '',
              dNama: '',
              idDesa: '',
            ),
        '/HalFasumIbadah': (BuildContext context) => HalFasumIbadah(
              dId: '',
              dNama: '',
              idDesa: '',
            ),
        '/HalFasumProfile': (BuildContext context) => HalFasumProfile(
              idDesa: '',
              namaDesa: '',
            ),
        '/GaleriProfile': (BuildContext context) => GaleriProfile(
              idDesa: '',
              namaDesa: '',
            ),
        '/HalBIDProfile': (BuildContext context) => HalBIDProfile(
              idDesa: '',
              namaDesa: '',
            ),
        '/HalPotensiProfile': (BuildContext context) => HalPotensiProfile(
              idDesa: '',
              namaDesa: '',
            ),
        '/HalKegiatanProfile': (BuildContext context) => HalKegiatanProfile(
              idDesa: '',
              namaDesa: '',
            ),
        '/HalberitaProfile': (BuildContext context) => HalberitaProfile(
              idDesa: '',
              namaDesa: '',
            ),
        '/HalSejarahDesa': (BuildContext context) => HalSejarahDesa(
              idDesa: '',
            ),
        '/HalVisiDesa': (BuildContext context) => HalVisiDesa(
              idDesa: '',
            ),
        '/HalProfilDesa': (BuildContext context) => HalProfilDesa(
              idDesa: '',
            ),
        '/ProfilDesa': (BuildContext context) => ProfilDesa(
              desa: '',
              id: '',
              kecamatan: '',
              title: '',
            ),
        '/FormAkunEditSemua': (BuildContext context) => FormAkunEditSemua(
              dEmail: '',
              dHp: '',
              dIdAdmin: '',
              dNama: '',
              dPassword: '',
              dStatus: '',
              dUsername: '',
            ),
        '/ListPenulis': (BuildContext context) => ListPenulis(),
        // '/Login': (BuildContext context) =>  Login(),
        // '/HomePage': (BuildContext context) =>  HomePage(),
        '/FormAddAkun': (BuildContext context) => FormAddAkun(
              nama: '',
            ),
        '/Berita': (BuildContext context) => Berita(),
        '/Agenda': (BuildContext context) => Agenda(),
        '/HalAkun': (BuildContext context) => HalAkun(),
        '/PilihAKun': (BuildContext context) => PilihAKun(),
        '/FormAkunEdit': (BuildContext context) => FormAkunEdit(
              nama: '',
            ),
        '/Haldua': (BuildContext context) => Haldua(),
        // '/AdminTes': (BuildContext context) => AdminTes(),
        '/EditSemua': (BuildContext context) => EditSemua(),
        '/InputSemua': (BuildContext context) => InputSemua(),
        // '/LoginPage': (BuildContext context) =>  LoginPage(),
        '/ExpansionTileSample': (BuildContext context) => ExpansionTileSample(),
        '/PilihAkun': (BuildContext context) => PilihAKun(),
        '/FormBerita': (BuildContext context) => FormBerita(),
        '/FormInovasi': (BuildContext context) => FormInovasi(),
        '/FormBumdes': (BuildContext context) => FormBumdes(),
        '/FormKegiatan': (BuildContext context) => FormKegiatan(),
        // '/DaftarWarga': (BuildContext context) =>  DaftarWarga(),
        '/DaftarAdmin': (BuildContext context) => DaftarAdmin(),
        '/AgendaDetail': (BuildContext context) => AgendaDetail(
              desaEvent: '',
              gambarEvent: '',
              idDesa: '',
              judulEvent: '',
              kecamatanEvent: '',
              mulaiEvent: '',
              penyelenggaraEvent: '',
              selesaiEvent: '',
              tglmulaiEvent: '',
              tglselesaiEvent: '',
              uraianEvent: '',
              urlEvent: '',
            ),
        '/FormBeritaEdit': (BuildContext context) => FormBeritaEdit(
              dGambar: '',
              dIdBerita: '',
              dIsi: '',
              dJudul: '',
              dKategori: '',
              dKomentar: '',
              dTanggal: '',
              dVideo: '',
            ),
        // '/OnboardingPage': (BuildContext context) =>  OnboardingPage(),
        // '/DaftarWargaLogin': (BuildContext context) =>  DaftarWargaLogin(),
        '/HalamanBeritaWarga': (BuildContext context) => HalamanBeritaWarga(),
        '/HalamanBeritaadmin': (BuildContext context) => HalamanBeritaadmin(),
        '/FormBeritaDashbord': (BuildContext context) => FormBeritaDashbord(),
        '/HalKegiatanList': (BuildContext context) => HalKegiatanList(),
        '/HalInovasiList': (BuildContext context) => HalInovasiList(),
        '/HalBumdesList': (BuildContext context) => HalBumdesList(),
        '/HalEventList': (BuildContext context) => HalEventList(),
        '/DetailBerita': (BuildContext context) => DetailBerita(
              dAdmin: '',
              dBaca: '',
              dDesa: '',
              dGambar: '',
              dHtml: '',
              dId: '',
              dIdDesa: '',
              dJudul: '',
              dKategori: '',
              dKecamatan: '',
              dTanggal: '',
              dUrl: '',
              dVideo: '',
              dWaktu: '',
            ),
        '/FormAgenda': (BuildContext context) => FormAgenda(),
        '/Galeri': (BuildContext context) => Galeri(),
        // '/Tes': (BuildContext context) =>  Tes(),
        '/DetailGaleri': (BuildContext context) => DetailGaleri(
              dDesa: '',
              dGambar: '',
              dJudul: '',
            ),
        '/DetailGaleriWarga': (BuildContext context) => DetailGaleriWarga(
              dGambar: '',
              dJudul: '',
            ),
        '/KritikSaran': (BuildContext context) => KritikSaran(),
        '/DetailKritikSaran': (BuildContext context) => DetailKritikSaran(
              dEmail: '',
              dId: '',
              dIsi: '',
              dJudul: '',
              dNama: '',
              dPublish: '',
              dTanggal: '',
            ),
        '/MyEditor': (BuildContext context) => MyEditor(),
        '/Version': (BuildContext context) => Version(),
        '/HalLoginWarga': (BuildContext context) => HalLoginWarga(),
        '/HalDaftarWarga': (BuildContext context) => HalDaftarWarga(),
        '/HalDashboardWarga': (BuildContext context) => HalDashboardWarga(),
        '/HalLengkapiDataWarga': (BuildContext context) =>
            HalLengkapiDataWarga(),
        '/HalLengkapiDokumenWarga': (BuildContext context) =>
            HalLengkapiDokumenWarga(),
        '/HalProfilWarga': (BuildContext context) => HalProfilWarga(),
        '/HalEditWarga': (BuildContext context) => HalEditWarga(),
        '/FormEditWarga': (BuildContext context) => FormEditWarga(),
        '/PengajuanSurat': (BuildContext context) => PengajuanSurat(),
        '/HalSemuaSurat': (BuildContext context) => HalSemuaSurat(),
        '/HalDataDukungSurat': (BuildContext context) => HalDataDukungSurat(
              dIdTambah: '',
            ),
        '/HalDetailSurat': (BuildContext context) => HalDetailSurat(
              dNama: '',
              dNik: '',
              dStatus: '',
              dNoSurat: '',
              dKategori: '',
              dTanggal: '',
              dKode: '',
              dKeterangan: '',
              dIdSurat: '',
            ),
      },
      home: SplashScreenPage(),
    ),
  );
}
