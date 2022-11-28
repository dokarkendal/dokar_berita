//ANCHOR package edit berita
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:async/async.dart'; //upload gambar
import 'package:flutter/material.dart';
import 'package:dokar_aplikasi/style/constants.dart';
import 'package:image_picker/image_picker.dart'; //akses galeri dan camera
import 'package:http/http.dart' as http; //api
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart'; //upload gambar path
import 'package:shared_preferences/shared_preferences.dart'; //save session
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'dart:math' as Math;

import 'package:status_alert/status_alert.dart';

import '../../style/styleset.dart';

//ANCHOR class form berita edit
class FormBeritaEdit extends StatefulWidget {
  final String dJudul,
      dKategori,
      dIsi,
      dTanggal,
      dGambar,
      dIdBerita,
      dVideo,
      dKomentar;

  FormBeritaEdit(
      {this.dJudul,
      this.dKategori,
      this.dIsi,
      this.dTanggal,
      this.dGambar,
      this.dIdBerita,
      this.dVideo,
      this.dKomentar});
  @override
  FormBeritaEditState createState() => FormBeritaEditState();
}

class FormBeritaEditState extends State<FormBeritaEdit> {
//ANCHOR variable berita edit
  File _image;
  String username = "";
  String _mySelection;
  List kategoriAdmin = [];
  final format = DateFormat("yyyy-MM-dd");
  final formKey = GlobalKey<FormState>();

  bool _isInAsyncCall = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String _valKomentar;
  List _listKomentar = ["Aktif", "Tidak"];

//ANCHOR controller berita edit
  TextEditingController dVideo = TextEditingController();
  TextEditingController dJudul = TextEditingController();
  TextEditingController dKategori = TextEditingController();
  TextEditingController dIsi = TextEditingController();
  TextEditingController dTanggal = TextEditingController();
  TextEditingController cUsername = TextEditingController();
  TextEditingController cStatus = TextEditingController();
  TextEditingController dGambar = TextEditingController();
  TextEditingController dIdBerita = TextEditingController();
  TextEditingController dKomentar = TextEditingController();

//ANCHOR input image size flutter berita edit
  Future getImageGallery() async {
    // ignore: deprecated_member_use
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int rand = Math.Random().nextInt(100000);

    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, width: 1144, height: 792);

    var compressImg = File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 1000));

    setState(() {
      _image = compressImg;
    });
  }

  Future getImageCamera() async {
    // ignore: deprecated_member_use
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int rand = Math.Random().nextInt(100000);

    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, width: 1144, height: 792);

    var compressImg = File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 1000));

    setState(() {
      _image = compressImg;
    });
  }

//ANCHOR session berita edit
  // ignore: unused_element
  Future _cekSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(() {
        username = pref.getString("userAdmin");
      });
    }
  }

//ANCHOR kategori edit berita
  // ignore: missing_return
  Future<String> getKategori() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/kabar/kategori"),
        body: {
          "IdDesa": pref.getString("IdDesa"),
        });
    var kategori = json.decode(response.body);
    if (mounted) {
      this.setState(
        () {
          kategoriAdmin = kategori;
          print(kategoriAdmin);
        },
      );
    }
  }

//ANCHOR Controller edit berita
  @override
  void initState() {
    dVideo = TextEditingController(text: "${widget.dVideo}");
    dJudul = TextEditingController(text: "${widget.dJudul}");
    dKategori = TextEditingController(text: "${widget.dKategori}");
    dIsi = TextEditingController(text: "${widget.dIsi}");
    dTanggal = TextEditingController(text: "${widget.dTanggal}");
    dGambar = TextEditingController(text: "${widget.dGambar}");
    dIdBerita = TextEditingController(text: "${widget.dIdBerita}");
    dKomentar = TextEditingController(text: "${widget.dKomentar}");
    super.initState();
    this.getKategori();
  }

  @override
  void dispose() {
    dJudul.dispose();
    super.dispose();
  }

//ANCHOR upload gambar berita edit
  Future uploadGambarBeritaEdit(File imageFile) async {
    setState(
      () {
        _isInAsyncCall = true;
      },
    );

    if (_valKomentar == null || _valKomentar == '') {
      _valKomentar = "${widget.dKomentar}";
    }

    if (_mySelection == null || _mySelection == '') {
      _mySelection = "${widget.dKategori}";
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    var stream =
        // ignore: deprecated_member_use
        http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri =
        Uri.parse("http://dokar.kendalkab.go.id/webservice/android/kabar/edit");

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));
    request.fields['judul'] = dJudul.text;
    request.fields['kategori'] = _mySelection;
    request.fields['isi'] = dIsi.text;
    request.fields['tanggal'] = dTanggal.text;
    request.fields['komentar'] = _valKomentar;
    request.fields['video'] = dVideo.text;
    request.fields['id_desa'] = pref.getString("IdDesa");
    request.fields['username'] = pref.getString("userAdmin");
    request.fields['status'] = pref.getString("status");
    request.fields['id_berita'] = dIdBerita.text;

    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Uploaded Succes");
      setState(
        () {
          _isInAsyncCall = false;
        },
      );
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/FormBeritaDashbord', ModalRoute.withName('/EditSemua'));
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 3),
        title: 'Sukses',
        subtitle: 'Berita Berhasil di edit',
        configuration: IconConfiguration(icon: Icons.done),
      );
    } else {
      print("Upload Failed");
      setState(
        () {
          _isInAsyncCall = false;
        },
      );
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/FormBeritaDashbord', ModalRoute.withName('/EditSemua'));
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Failed.',
        subtitle: 'Berita Gagal di upload.',
        configuration: IconConfiguration(icon: Icons.done),
      );
    }
    response.stream.transform(utf8.decoder).listen(
      (value) {
        print(value);
      },
    );
  }

//ANCHOR upload no gambar berita edit
  Future uploadNoGambarBeritaEdit() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(
      () {
        _isInAsyncCall = true;
      },
    );

    if (_valKomentar == null || _valKomentar == '') {
      _valKomentar = "${widget.dKomentar}";
    }

    if (_mySelection == null || _mySelection == '') {
      _mySelection = "${widget.dKategori}";
    }

    final response = await http.post(
        Uri.parse("http://dokar.kendalkab.go.id/webservice/android/kabar/edit"),
        body: {
          "judul": dJudul.text,
          "kategori": _mySelection,
          "komentar": _valKomentar,
          "video": dVideo.text,
          "isi": dIsi.text,
          "tanggal": dTanggal.text,
          "id_desa": pref.getString("IdDesa"),
          "username": pref.getString("userAdmin"),
          "status": pref.getString("status"),
          "id_berita": dIdBerita.text,
        });
    var datauser = json.decode(response.body);
    print(datauser);
    if (response.statusCode == 200) {
      print("Uploaded Succes");
      setState(
        () {
          _isInAsyncCall = false;
        },
      );
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/FormBeritaDashbord', ModalRoute.withName('/EditSemua'));
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Sukses',
        subtitle: 'Berita Berhasil di edit',
        configuration: IconConfiguration(icon: Icons.done),
      );
    } else {
      print("Upload Failed");
      setState(
        () {
          _isInAsyncCall = false;
        },
      );
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/FormBeritaDashbord', ModalRoute.withName('/EditSemua'));
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Failed.',
        subtitle: 'Berita Gagal di upload.',
        configuration: IconConfiguration(icon: Icons.done),
      );
    }
  }

  // double bur = 0.5;
//ANCHOR Body edit berita
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          'EDIT BERITA',
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
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 1,
        // blur: bur,
        color: Theme.of(context).primaryColor,
        progressIndicator: Padding(
          padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.4),
          child: Column(
            children: [
              SpinKitWave(color: Colors.white),
              SizedBox(height: mediaQueryData.size.height * 0.05),
              Text(
                'Sedang mengedit..',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )
            ],
          ),
        ),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
//ANCHOR judul berita berita edit
                    Container(
                      alignment: Alignment.topLeft,
                      // height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        maxLines: null,
                        controller: dJudul,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          hintText: 'Judul Berita',
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[400],
                          ),
                          prefixIcon: Icon(
                            Icons.text_fields,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
//ANCHOR kategori berita edit
                    Column(
                      children: <Widget>[
                        Container(
                          // padding: EdgeInsets.only(left: 20.0),
                          // alignment: Alignment.centerLeft,
                          // decoration: kBoxDecorationStyle2,
                          // height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: DropdownButtonFormField(
                            // underline: SizedBox(),
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              // hintText: 'Judul Berita',
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[400],
                              ),
                              // prefixIcon: Icon(
                              //   Icons.text_fields,
                              //   color: Colors.grey,
                              // ),
                            ),
                            hint: Text("${widget.dKategori}"),
                            isExpanded: true,
                            items: kategoriAdmin.map(
                              (item) {
                                return DropdownMenuItem(
                                  child: Text(item['kategori_nama']),
                                  value: item['kategori_nama'].toString(),
                                );
                              },
                            ).toList(),
                            onChanged: (val) {
                              setState(
                                () {
                                  _mySelection = val;
                                },
                              );
                            },
                            value: _mySelection,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
//ANCHOR isi berita edit
                    Container(
                      alignment: Alignment.topLeft,
                      // decoration: kBoxDecorationStyle2,
                      // height: 200.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: dIsi,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          color: Colors.black,
                          // fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          // border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.library_books,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Uraian Berita',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
//ANCHOR tangal berita edit
                    Container(
                      alignment: Alignment.centerLeft,
                      // decoration: kBoxDecorationStyle2,
                      // height: 60.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: DateTimeField(
                        controller: dTanggal,
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
                            color: Colors.grey[600],
                          ),
                          hintText: 'Pilih tanggal',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),

                    Column(
                      children: <Widget>[
                        Container(
                          // padding: EdgeInsets.only(left: 20.0),
                          alignment: Alignment.centerLeft,
                          // decoration: kBoxDecorationStyle2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          // height: 60.0,
                          child: DropdownButtonFormField(
                            // underline: SizedBox(),
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              // hintText: 'Judul Berita',
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[400],
                              ),
                              // prefixIcon: Icon(
                              //   Icons.text_fields,
                              //   color: Colors.grey,
                              // ),
                            ),
                            isExpanded: true,
                            hint: Text("${widget.dKomentar}"),
                            items: _listKomentar.map(
                              (value) {
                                return DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                );
                              },
                            ).toList(),
                            onChanged: (value) {
                              setState(
                                () {
                                  _valKomentar = value;
                                },
                              );
                            },
                            value: _valKomentar,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
//ANCHOR input link youtube
                    Container(
                      alignment: Alignment.centerLeft,
                      // decoration: kBoxDecorationStyle2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      height: 60.0,
                      child: TextFormField(
                        controller: dVideo,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          // border: InputBorder.none,
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          // contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.ondemand_video,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Embed video youtube',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
//ANCHOR gambar berita edit
                    Center(
                      child: _image == null
                          ? Text("Pilih gambar berita!")
                          : Image.file(_image),
                    ),
                    Row(
                      children: <Widget>[
                        ElevatedButton(
                          child: Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                          onPressed: getImageGallery,
                          style: ElevatedButton.styleFrom(
                            // padding: EdgeInsets.all(15.0),
                            elevation: 0, backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // <-- Radius
                            ),
                          ),
                          // color: Color(0xFFee002d),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(17.0),
                          // ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0),
                        ),
                        ElevatedButton(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          onPressed: getImageCamera,
                          style: ElevatedButton.styleFrom(
                            // padding: EdgeInsets.all(15.0),
                            elevation: 0, backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // <-- Radius
                            ),
                          ),
                          // color: Color(0xFFee002d),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(17.0),
                          // ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
//NOTE tombol upload edit berita
                    Container(
                      width: mediaQueryData.size.width,
                      height: mediaQueryData.size.height * 0.07,
                      child: ElevatedButton.icon(
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        label: Text("SIMPAN BERITA"),
                        onPressed: () {
                          if (dJudul.text == null || dJudul.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Judul wajib di isi.',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.orange[700],
                              action: SnackBarAction(
                                label: 'ULANGI',
                                textColor: Colors.white,
                                onPressed: () {
                                  print('ULANGI snackbar');
                                },
                              ),
                            ));
                            // scaffoldKey.currentState.showSnackBar(snackBar);
                          } else if (dIsi.text == null || dIsi.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Judul wajib di isi.',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.orange[700],
                              action: SnackBarAction(
                                label: 'ULANGI',
                                textColor: Colors.white,
                                onPressed: () {
                                  print('ULANGI snackbar');
                                },
                              ),
                            ));
                            // scaffoldKey.currentState.showSnackBar(snackBar);
                          } else if (dTanggal.text == null ||
                              dTanggal.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Tanggal wajib di isi.',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.orange[700],
                              action: SnackBarAction(
                                label: 'ULANGI',
                                textColor: Colors.white,
                                onPressed: () {
                                  print('ULANGI snackbar');
                                },
                              ),
                            ));
                            // scaffoldKey.currentState.showSnackBar(snackBar);
                          } else {
                            if (_image == null) {
                              uploadNoGambarBeritaEdit();
                            } else {
                              uploadGambarBeritaEdit(_image);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          // padding: EdgeInsets.all(15.0),
                          elevation: 0, backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // <-- Radius
                          ),
                        ),
                        // color: Colors.green,
                        // textColor: Colors.white,
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(17.0),
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
