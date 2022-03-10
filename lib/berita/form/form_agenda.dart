//ANCHOR package input form agenda
import 'dart:async'; //NOTE  api syn
import 'dart:convert'; //NOTE api to json
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:async/async.dart'; //NOTE upload gambar
import 'package:flutter/material.dart';
import 'package:dokar_aplikasi/style/constants.dart';
import 'package:image_picker/image_picker.dart'; //NOTE akses galeri dan camera
import 'package:http/http.dart' as http; //NOTE api to http
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart'; //NOTE upload gambar path
import 'package:shared_preferences/shared_preferences.dart'; //NOTE save session
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img; //NOTE image
import 'dart:math' as Math;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:status_alert/status_alert.dart';

//ANCHOR class form agenda
class FormAgenda extends StatefulWidget {
  @override
  FormAgendaState createState() => FormAgendaState();
}

class FormAgendaState extends State<FormAgenda> {
//ANCHOR variable form agenda
  File _image;
  String username = "";
  bool _isInAsyncCall = false;
  List kategoriAdmin = List();
  final formKey = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MM-dd");
  final formatTime = DateFormat("HH:mm");
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var alertStyle = AlertStyle(
    isCloseButton: false,
  );

//ANCHOR controller form agenda
  TextEditingController cJudul = new TextEditingController();
  TextEditingController cPenyelenggara = new TextEditingController();
  TextEditingController cIsi = new TextEditingController();
  TextEditingController cTanggalmulai = new TextEditingController();
  TextEditingController cTanggalselesai = new TextEditingController();
  TextEditingController cJammulai = new TextEditingController();
  TextEditingController cJamselesai = new TextEditingController();
  TextEditingController cUsername = new TextEditingController();
  TextEditingController cStatus = new TextEditingController();

//ANCHOR akses gallery
  Future getImageGallery() async {
    // ignore: deprecated_member_use
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
    // ignore: deprecated_member_use
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

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

//ANCHOR cek session admin form agenda
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
    super.initState();
  }

//ANCHOR api gambar post form agenda
  Future upload(File imageFile) async {
    setState(() {
      _isInAsyncCall = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var stream =
        // ignore: deprecated_member_use
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse(
        "http://dokar.kendalkab.go.id/webservice/android/agenda/postevent");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));
    request.fields['judul'] = cJudul.text;
    request.fields['penyelenggara'] = cPenyelenggara.text;
    request.fields['isi'] = cIsi.text;
    request.fields['tgl_mulai'] = cTanggalmulai.text;
    request.fields['tgl_selesai'] = cTanggalselesai.text;
    request.fields['jam_mulai'] = cJammulai.text;
    request.fields['jam_selesai'] = cJamselesai.text;
    request.fields['id_desa'] = pref.getString("IdDesa");
    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image Uploaded");
      setState(
        () {
          _isInAsyncCall = false;
        },
      );
      await Future.delayed(
        Duration(seconds: 2),
        () {
          Navigator.of(this.context).pushNamedAndRemoveUntil(
            '/Haldua',
            ModalRoute.withName('/Haldua'),
          );
        },
      );
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Sukses',
        subtitle: 'Event berhasil di upload',
        configuration: IconConfiguration(icon: Icons.done),
      );
    } else {
      print("Upload Failed");
    }
    response.stream.transform(utf8.decoder).listen(
      (value) {
        print(value);
      },
    );
  }

//ANCHOR body form kegiatan
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Form Agenda',
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
//ANCHOR input judul kegiatan
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: TextFormField(
                        controller: cJudul,
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
                          hintText: 'Nama Agenda',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR input penyelenggara
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: TextFormField(
                        controller: cPenyelenggara,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.people,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Penyelenggara',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR input isi agenda
                    Container(
                      alignment: Alignment.topLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 200.0,
                      child: TextFormField(
                        controller: cIsi,
                        // maxLines: 10,
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
                          hintText: 'Uraian Agenda',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR input tanggal mulai
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: DateTimeField(
                        controller: cTanggalmulai,
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
                          hintText: 'Tanggal mulai',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR input tanggal selesai
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: DateTimeField(
                        controller: cTanggalselesai,
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
                          prefixIcon: Icon(
                            Icons.date_range,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Tanggal selesai',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR input Jam mulai
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: DateTimeField(
                        controller: cJammulai,
                        format: formatTime,
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now(),
                            ),
                            builder: (context, child) => MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child),
                          );
                          return DateTimeField.convert(time);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          //contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.access_time,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Jam mulai',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR input Jam selesai
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: DateTimeField(
                        controller: cJamselesai,
                        format: formatTime,
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now(),
                            ),
                            builder: (context, child) => MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child),
                          );
                          return DateTimeField.convert(time);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.access_time,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Jam selesai',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR input gambar
                    Center(
                      child: _image == null
                          ? new Text("Gambar belum di pilih !")
                          : new Image.file(_image),
                    ),
                    Center(
                      child: Row(
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
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
                    Container(
                      width: mediaQueryData.size.width,
                      height: mediaQueryData.size.height * 0.07,
                      child: RaisedButton.icon(
                        icon: Icon(
                          Icons.file_upload,
                          color: Colors.white,
                        ),
                        label: Text("UPLOAD AGENDA"),
                        onPressed: () async {
                          if (cJudul.text == null || cJudul.text == '') {
                            SnackBar snackBar = SnackBar(
                              content: Text(
                                'Nama Agenda wajib di isi.',
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
                          } else if (cPenyelenggara.text == null ||
                              cPenyelenggara.text == '') {
                            SnackBar snackBar = SnackBar(
                              content: Text(
                                'Penyelenggara wajib di isi.',
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
                          } else if (cIsi.text == null || cIsi.text == '') {
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
                          } else if (cTanggalmulai.text == null ||
                              cTanggalmulai.text == '') {
                            SnackBar snackBar = SnackBar(
                              content: Text(
                                'Tanggal Mulai wajib di isi.',
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
                          } else if (cTanggalselesai.text == null ||
                              cTanggalselesai.text == '') {
                            SnackBar snackBar = SnackBar(
                              content: Text(
                                'Tanggal Selesai wajib di isi.',
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
                          } else if (cJammulai.text == null ||
                              cJammulai.text == '') {
                            SnackBar snackBar = SnackBar(
                              content: Text(
                                'Jam Mulai wajib di isi.',
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
                          } else if (cJamselesai.text == null ||
                              cJamselesai.text == '') {
                            SnackBar snackBar = SnackBar(
                              content: Text(
                                'Jam Selesai wajib di isi.',
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
                          } else if (_image == null) {
                            SnackBar snackBar = SnackBar(
                              content: Text(
                                'Gambar wajib di isi.',
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
                            upload(_image);
                          }
                        },
                        color: Colors.green,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17.0),
                        ),
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
