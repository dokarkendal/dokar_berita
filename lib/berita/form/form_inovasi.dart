//ANCHOR package input form inovasi
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

//ANCHOR class Form inovasi
class FormInovasi extends StatefulWidget {
  @override
  FormInovasiState createState() => FormInovasiState();
}

class FormInovasiState extends State<FormInovasi> {
//ANCHOR variable form inovasi
  File _image;
  String username = "";
  String _mySelection;
  bool _isInAsyncCall = false;
  List kategoriAdmin = List();
  final formKey = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MM-dd");
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var alertStyle = AlertStyle(
    isCloseButton: false,
  );

//ANCHOR controller form inovasi
  TextEditingController cYoutube = new TextEditingController();
  TextEditingController cJudul = new TextEditingController();
  TextEditingController cKategori = new TextEditingController();
  TextEditingController cIsi = new TextEditingController();
  TextEditingController cTanggal = new TextEditingController();
  TextEditingController cUsername = new TextEditingController();
  TextEditingController cStatus = new TextEditingController();

//ANCHOR akses gallery form inovasi
  Future getImageGallery() async {
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

//ANCHOR cek session admin form inovasi
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

//ANCHOR api gambar post form inovasi
  Future upload(File imageFile) async {
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
    var uri =
        Uri.parse("http://dokar.kendalkab.go.id/webservice/android/bid/post");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));
    request.fields['video'] = cYoutube.text;
    request.fields['judul'] = cJudul.text;
    request.fields['kategori'] = _mySelection;
    request.fields['isi'] = cIsi.text;
    request.fields['tanggal'] = cTanggal.text;
    request.fields['id_desa'] = pref.getString("IdDesa");
    request.fields['username'] = pref.getString("userAdmin");
    request.fields['status'] = pref.getString("status");
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
              '/Haldua', ModalRoute.withName('/Haldua'));
        },
      );
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Sukses',
        subtitle: 'Inovasi berhasil di upload',
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

//ANCHOR hal utama form inovasi
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Form Inovasi'),
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
//ANCHOR input judul form inovasi
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
                          hintText: 'Judul inovasi',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR input kategori form inovasi
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
                            hint: Text('Pilih Kategori'),
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
//ANCHOR input uraian form inovasi
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
                          hintText: 'Uraian inovasi',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR input tanggal form inovasi
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: DateTimeField(
                        controller: cTanggal,
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
//ANCHOR input link youtube form inovasi
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: TextFormField(
                        controller: cYoutube,
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
//ANCHOR input gambar form inovasi
                    Center(
                      child: _image == null
                          ? new Text("Gambar belum di pilih !")
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
                      label: Text("UPLOAD BID"),
                      onPressed: () async {
                        if (cJudul.text == null || cJudul.text == '') {
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
                        } else if (_mySelection == null || _mySelection == '') {
                          SnackBar snackBar = SnackBar(
                            content: Text(
                              'Kategori wajib di isi.',
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
                        } else if (cTanggal.text == null ||
                            cTanggal.text == '') {
                          SnackBar snackBar = SnackBar(
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
