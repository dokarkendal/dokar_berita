//ANCHOR package kegiatan edit
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:async/async.dart'; //upload gambar
import 'package:flutter/material.dart';
import 'package:dokar_aplikasi/style/constants.dart';
import 'package:image_picker/image_picker.dart'; //akses galeri dan camera
import 'package:http/http.dart' as http; //api
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart'; //upload gambar path
import 'package:shared_preferences/shared_preferences.dart'; //save session
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'dart:math' as Math;

import 'package:status_alert/status_alert.dart';

//ANCHOR class form kegiatan edit
class FormKegiatanEdit extends StatefulWidget {
  final String dJudul, dKatTempat, dIsi, dTanggal, dGambar, dIdKegiatan, dVideo;

  FormKegiatanEdit(
      {this.dJudul,
      this.dKatTempat,
      this.dIsi,
      this.dTanggal,
      this.dGambar,
      this.dIdKegiatan,
      this.dVideo});
  @override
  FormKegiatanEditState createState() => FormKegiatanEditState();
}

class FormKegiatanEditState extends State<FormKegiatanEdit> {
//ANCHOR variable kegiatan edit
  File _image;
  String username = "";
  String _mySelection;
  List kategoriAdmin = List();
  final format = DateFormat("yyyy-MM-dd");
  final formKey = GlobalKey<FormState>();

  bool _isInAsyncCall = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//ANCHOR controller
  TextEditingController dVideo = new TextEditingController();
  TextEditingController dJudul = new TextEditingController();
  TextEditingController dKatTempat = new TextEditingController();
  TextEditingController dIsi = new TextEditingController();
  TextEditingController dTanggal = new TextEditingController();
  TextEditingController cUsername = new TextEditingController();
  TextEditingController cStatus = new TextEditingController();
  TextEditingController dGambar = new TextEditingController();
  TextEditingController dIdKegiatan = new TextEditingController();

//ANCHOR input image size flutter
  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int rand = new Math.Random().nextInt(100000);

    Img.Image image = Img.decodeImage(
      imageFile.readAsBytesSync(),
    );
    Img.Image smallerImg = Img.copyResize(image, width: 1144, height: 792);

    var compressImg = new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(
        Img.encodeJpg(smallerImg, quality: 1000),
      );

    setState(
      () {
        _image = compressImg;
      },
    );
  }

  Future getImageCamera() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int rand = new Math.Random().nextInt(100000);

    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, width: 1144, height: 792);

    var compressImg = new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 1000));

    setState(
      () {
        _image = compressImg;
      },
    );
  }

//ANCHOR session edit kegiatan
  // ignore: unused_element
  Future _cekSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(
        () {
          username = pref.getString("userAdmin");
        },
      );
    }
  }

  @override
  void initState() {
    dVideo = new TextEditingController(text: "${widget.dVideo}");
    dJudul = new TextEditingController(text: "${widget.dJudul}");
    dKatTempat = new TextEditingController(text: "${widget.dKatTempat}");
    dIsi = new TextEditingController(text: "${widget.dIsi}");
    dTanggal = new TextEditingController(text: "${widget.dTanggal}");
    dGambar = new TextEditingController(text: "${widget.dGambar}");
    dIdKegiatan = new TextEditingController(text: "${widget.dIdKegiatan}");
    super.initState();
  }

  @override
  void dispose() {
    dJudul.dispose();
    super.dispose();
  }

//ANCHOR upload gambar kegiatan edit
  Future uploadGambarKegiatanEdit(File imageFile) async {
    setState(
      () {
        _isInAsyncCall = true;
      },
    );

    SharedPreferences pref = await SharedPreferences.getInstance();
    var stream =
        // ignore: deprecated_member_use
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse(
        "http://dokar.kendalkab.go.id/webservice/android/kabar/editkegiatan");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));
    request.fields['judul'] = dJudul.text;
    request.fields['tempat'] = dKatTempat.text;
    request.fields['isi'] = dIsi.text;
    request.fields['tanggal'] = dTanggal.text;
    request.fields['id_desa'] = pref.getString("IdDesa");
    request.fields['username'] = pref.getString("userAdmin");
    request.fields['status'] = pref.getString("status");
    request.fields['id_kegiatan'] = dIdKegiatan.text;
    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      setState(
        () {
          _isInAsyncCall = false;
        },
      );
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/HalKegiatanList', ModalRoute.withName('/EditSemua'));
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Sukses',
        subtitle: 'Kegiatan Berhasil di upload',
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
          '/HalKegiatanList', ModalRoute.withName('/EditSemua'));
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Failed.',
        subtitle: 'Kegiatan Gagal di upload.',
        configuration: IconConfiguration(icon: Icons.done),
      );
    }
    response.stream.transform(utf8.decoder).listen(
      (value) {
        print(value);
      },
    );
  }

//ANCHOR upload no gambar kegiatan edit
  Future uploadNoGambarKegiatanEdit() async {
    setState(
      () {
        _isInAsyncCall = true;
      },
    );

    SharedPreferences pref = await SharedPreferences.getInstance();
    if (_mySelection == null) {
      final response = await http.post(
        "http://dokar.kendalkab.go.id/webservice/android/kabar/editkegiatan",
        body: {
          "judul": dJudul.text,
          "tempat": dKatTempat.text,
          "isi": dIsi.text,
          "tanggal": dTanggal.text,
          "id_desa": pref.getString("IdDesa"),
          "username": pref.getString("userAdmin"),
          "status": pref.getString("status"),
          "id_kegiatan": dIdKegiatan.text,
        },
      );
      var datauser = json.decode(response.body);
      print(datauser);
      if (response.statusCode == 200) {
        setState(
          () {
            _isInAsyncCall = false;
          },
        );
        Navigator.of(this.context).pushNamedAndRemoveUntil(
            '/HalKegiatanList', ModalRoute.withName('/EditSemua'));
        StatusAlert.show(
          this.context,
          duration: Duration(seconds: 2),
          title: 'Sukses',
          subtitle: 'Kegiatan Berhasil di upload',
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
            '/HalKegiatanList', ModalRoute.withName('/EditSemua'));
        StatusAlert.show(
          this.context,
          duration: Duration(seconds: 2),
          title: 'Failed.',
          subtitle: 'Kegiatan Gagal di upload.',
          configuration: IconConfiguration(icon: Icons.done),
        );
      }
    }
  }

//ANCHOR body kegiatan
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Form Edit Kegiatan'),
        backgroundColor: Color(0xFFee002d),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.5,
        progressIndicator:
            CircularProgressIndicator(backgroundColor: Colors.red),
        child: ListView(
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR judul kegiatan edit
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: TextFormField(
                        controller: dJudul,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          //errorText: _validate ? 'Harus di isi' : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.text_fields,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Judul Kegiatan',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR kategori kegiatan edit
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: TextFormField(
                        controller: dKatTempat,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          //errorText: _validate ? 'Harus di isi' : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.place,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Tempat Kegiatan',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR kegiatan isi edit
                    Container(
                      alignment: Alignment.topLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 200.0,
                      child: TextFormField(
                        controller: dIsi,
                        maxLines: null,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          //contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.library_books,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Uraian Kegiatan',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR kegiatan tanggal isi
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: DateTimeField(
                        controller: dTanggal,
                        format: format,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          //contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.date_range,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Pilih tanggal',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR input link youtube
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: TextFormField(
                        controller: dVideo,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.ondemand_video,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Embed video youtube',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//NOTE gambar kegiatan edit
                    Center(
                      child: _image == null
                          ? new Text("Pilih gambar kegiatan!")
                          : new Image.file(_image),
                    ),
                    Row(
                      children: <Widget>[
                        RaisedButton(
                          child: Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                          onPressed: getImageGallery,
                          color: Color(0xFFee002d),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17.0),
                          ),
                        ),
                        RaisedButton(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          onPressed: getImageCamera,
                          color: Color(0xFFee002d),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17.0),
                          ),
                        ),
                      ],
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
                    RaisedButton.icon(
                      icon: Icon(
                        Icons.file_upload,
                        color: Colors.white,
                      ),
                      label: Text("UPLOAD KEGIATAN"),
                      onPressed: () async {
                        if (dJudul.text == null || dJudul.text == '') {
                          SnackBar snackBar = SnackBar(
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
                          );
                          scaffoldKey.currentState.showSnackBar(snackBar);
                        } else if (dKatTempat.text == null ||
                            dKatTempat.text == '') {
                          SnackBar snackBar = SnackBar(
                            content: Text(
                              'Tempat wajib di isi.',
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
                          );
                          scaffoldKey.currentState.showSnackBar(snackBar);
                        } else if (dIsi.text == null || dIsi.text == '') {
                          SnackBar snackBar = SnackBar(
                            content: Text(
                              'Uraian wajib di isi.',
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
                          );
                          scaffoldKey.currentState.showSnackBar(snackBar);
                        } else if (dTanggal.text == null ||
                            dTanggal.text == '') {
                          SnackBar snackBar = SnackBar(
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
                          );
                          scaffoldKey.currentState.showSnackBar(snackBar);
                        } else {
                          if (_image == null) {
                            uploadNoGambarKegiatanEdit();
                          } else {
                            uploadGambarKegiatanEdit(_image);
                          }
                        }
                      },
                      color: Colors.green,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17.0),
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
