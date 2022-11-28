//ANCHOR package inovasi edit
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

//ANCHOR class form inovasi edit
class FormInovasiEdit extends StatefulWidget {
  final String dJudul, dKategori, dIsi, dTanggal, dGambar, dIdBerita, dVideo;

  FormInovasiEdit(
      {this.dJudul,
      this.dKategori,
      this.dIsi,
      this.dTanggal,
      this.dGambar,
      this.dIdBerita,
      this.dVideo});
  @override
  FormInovasiEditState createState() => FormInovasiEditState();
}

class FormInovasiEditState extends State<FormInovasiEdit> {
//ANCHOR variable inovasi edit
  File _image;
  String username = "";
  String _mySelection;
  List kategoriAdmin = [];
  final format = DateFormat("yyyy-MM-dd");
  final formKey = GlobalKey<FormState>();

  bool _isInAsyncCall = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//ANCHOR controller inovasi edit
  TextEditingController dVideo = new TextEditingController();
  TextEditingController dJudul = new TextEditingController();
  TextEditingController dKategori = new TextEditingController();
  TextEditingController dIsi = new TextEditingController();
  TextEditingController dTanggal = new TextEditingController();
  TextEditingController cUsername = new TextEditingController();
  TextEditingController cStatus = new TextEditingController();
  TextEditingController dGambar = new TextEditingController();
  TextEditingController dIdBerita = new TextEditingController();

//ANCHOR input image size flutter inovasi edit
  Future getImageGallery() async {
    // ignore: deprecated_member_use
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

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

  Future getImageCamera() async {
    // ignore: deprecated_member_use
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

//ANCHOR session inovasi edit
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

//ANCHOR Controller inovasi edit
  @override
  void initState() {
    dVideo = new TextEditingController(text: "${widget.dVideo}");
    dJudul = new TextEditingController(text: "${widget.dJudul}");
    dKategori = new TextEditingController(text: "${widget.dKategori}");
    dIsi = new TextEditingController(text: "${widget.dIsi}");
    dTanggal = new TextEditingController(text: "${widget.dTanggal}");
    dGambar = new TextEditingController(text: "${widget.dGambar}");
    dIdBerita = new TextEditingController(text: "${widget.dIdBerita}");
    super.initState();
  }

  @override
  void dispose() {
    dJudul.dispose();
    super.dispose();
  }

//ANCHOR upload gambar inovasi edit
  Future uploadGambarInovasiEdit(File imageFile) async {
    setState(
      () {
        _isInAsyncCall = true;
      },
    );

    if (_mySelection == null || _mySelection == '') {
      _mySelection = "${widget.dKategori}";
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    var stream =
        // ignore: deprecated_member_use
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri =
        Uri.parse("http://dokar.kendalkab.go.id/webservice/android/bid/edit");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));
    request.fields['judul'] = dJudul.text;
    request.fields['kategori'] = _mySelection;
    request.fields['isi'] = dIsi.text;
    request.fields['tanggal'] = dTanggal.text;
    request.fields['id_desa'] = pref.getString("IdDesa");
    request.fields['username'] = pref.getString("userAdmin");
    request.fields['IdInovasi'] = dIdBerita.text;

    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      setState(
        () {
          _isInAsyncCall = false;
        },
      );
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/HalInovasiList', ModalRoute.withName('/EditSemua'));
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Sukses',
        subtitle: 'Inovasi Berhasil di upload',
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
          '/HalInovasiList', ModalRoute.withName('/EditSemua'));
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Failed.',
        subtitle: 'Inovasi Gagal di upload.',
        configuration: IconConfiguration(icon: Icons.done),
      );
    }
    response.stream.transform(utf8.decoder).listen(
      (value) {
        print(value);
      },
    );
  }

//ANCHOR upload no gambar inovasi edit
  Future uploadNoGambarInovasiEdit() async {
    setState(() {
      _isInAsyncCall = true;
    });

    if (_mySelection == null || _mySelection == '') {
      _mySelection = "${widget.dKategori}";
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse("http://dokar.kendalkab.go.id/webservice/android/bid/edit"),
      body: {
        "judul": dJudul.text,
        "kategori": _mySelection,
        "isi": dIsi.text,
        "tanggal": dTanggal.text,
        "id_desa": pref.getString("IdDesa"),
        "username": pref.getString("userAdmin"),
        "IdInovasi": dIdBerita.text,
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
          '/HalInovasiList', ModalRoute.withName('/EditSemua'));
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Sukses',
        subtitle: 'Inovasi Berhasil di upload',
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
          '/HalInovasiList', ModalRoute.withName('/EditSemua'));
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Failed.',
        subtitle: 'Inovasi Gagal di upload.',
        configuration: IconConfiguration(icon: Icons.done),
      );
    }
  }

//ANCHOR Body edit inovasi
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Form Inovasi Edit',
          style: TextStyle(
            color: Color(0xFF2e2e2e),
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
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
//ANCHOR judul inovasi edit
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
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.text_fields,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Judul Berita',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR kategori inovasi edit
                    new Column(
                      children: <Widget>[
                        Container(
                          padding: new EdgeInsets.only(left: 20.0),
                          alignment: Alignment.centerLeft,
                          decoration: kBoxDecorationStyle2,
                          height: 60.0,
                          child: DropdownButton<String>(
                            //icon: Icon(Icons.accessibility_new),
                            underline: SizedBox(),
                            hint: Text("${widget.dKategori}"),
                            isExpanded: true,
                            items: <String>[
                              'SDM',
                              'IFRASTRUKTUR',
                              'Kewirausahaan Dan Pengembangan Ekonomi Lokal',
                              'Lain-lain'
                            ].map(
                              (String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              },
                            ).toList(),
                            onChanged: (newVal) {
                              setState(
                                () {
                                  _mySelection = newVal;
                                },
                              );
                            },
                            value: _mySelection,
                          ),
                        )
                      ],
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR isi inovasi edit
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
                          prefixIcon: Icon(
                            Icons.library_books,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Uraian Berita',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR tangal inovasi edit
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
                              lastDate: DateTime(2100));
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
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
//ANCHOR gambar inovasi edit
                    Center(
                      child: _image == null
                          ? new Text("Pilih gambar berita!")
                          : new Image.file(_image),
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
                                  BorderRadius.circular(15), // <-- Radius
                            ),
                          ),
                          // color: Color(0xFFee002d),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(17.0),
                          // ),
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
                                  BorderRadius.circular(15), // <-- Radius
                            ),
                          ),
                          // color: Color(0xFFee002d),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(17.0),
                          // ),
                        ),
                      ],
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//NOTE tombol upload edit inovasi
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.file_upload,
                        color: Colors.white,
                      ),
                      label: Text("UPLOAD BID"),
                      onPressed: () async {
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
                          ));
                          // scaffoldKey.currentState.showSnackBar(snackBar);
                        } else if (dTanggal.text == null ||
                            dTanggal.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Tanggal wajib di isi',
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
                            uploadNoGambarInovasiEdit();
                          } else {
                            uploadGambarInovasiEdit(_image);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        // padding: EdgeInsets.all(15.0),
                        elevation: 0, backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // <-- Radius
                        ),
                      ),
                      // color: Colors.green,
                      // textColor: Colors.white,
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(17.0),
                      // ),
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
