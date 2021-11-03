import 'dart:convert';

List<ApiKabar> modelUserFromJson(String str) =>
    List<ApiKabar>.from(json.decode(str).map((x) => ApiKabar.fromJson(x)));

String modelUserToJson(List<ApiKabar> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ApiKabar {
  String kabarId;
  String kabarJudul;
  String kabarKategori;
  String kabarIsi;
  String kabarGambar;
  String kabarVideo;
  String kabarTanggal;
  String kabarAdmin;
  String kabarWaktu;
  String dataNama;
  String dataKecamatan;
  String dataKabupaten;

  ApiKabar(
      {this.kabarId,
      this.kabarJudul,
      this.kabarKategori,
      this.kabarIsi,
      this.kabarGambar,
      this.kabarVideo,
      this.kabarTanggal,
      this.kabarAdmin,
      this.kabarWaktu,
      this.dataNama,
      this.dataKecamatan,
      this.dataKabupaten});

  ApiKabar.fromJson(Map<String, dynamic> json) {
    kabarId = json['kabar_id'];
    kabarJudul = json['kabar_judul'];
    kabarKategori = json['kabar_kategori'];
    kabarIsi = json['kabar_isi'];
    kabarGambar = json['kabar_gambar'];
    kabarVideo = json['kabar_video'];
    kabarTanggal = json['kabar_tanggal'];
    kabarAdmin = json['kabar_admin'];
    kabarWaktu = json['kabar_waktu'];
    dataNama = json['data_nama'];
    dataKecamatan = json['data_kecamatan'];
    dataKabupaten = json['data_kabupaten'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kabar_id'] = this.kabarId;
    data['kabar_judul'] = this.kabarJudul;
    data['kabar_kategori'] = this.kabarKategori;
    data['kabar_isi'] = this.kabarIsi;
    data['kabar_gambar'] = this.kabarGambar;
    data['kabar_video'] = this.kabarVideo;
    data['kabar_tanggal'] = this.kabarTanggal;
    data['kabar_admin'] = this.kabarAdmin;
    data['kabar_waktu'] = this.kabarWaktu;
    data['data_nama'] = this.dataNama;
    data['data_kecamatan'] = this.dataKecamatan;
    data['data_kabupaten'] = this.dataKabupaten;
    return data;
  }
}
