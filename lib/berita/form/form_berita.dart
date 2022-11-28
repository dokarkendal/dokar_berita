//ANCHOR package input form berita
import 'dart:async'; //NOTE  api syn
import 'dart:convert'; //NOTE api to json
import 'dart:io';
// import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:async/async.dart'; //NOTE upload gambar
import 'package:flutter/material.dart';
import 'package:dokar_aplikasi/style/constants.dart';
import 'package:image_picker/image_picker.dart'; //NOTE akses galeri dan camera
import 'package:http/http.dart' as http; //NOTE api to http
import 'package:path/path.dart'; //NOTE upload gambar path
import 'package:shared_preferences/shared_preferences.dart'; //NOTE save session
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img; //NOTE image
import 'dart:math' as Math;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:status_alert/status_alert.dart';

import '../../style/styleset.dart';

//ANCHOR class Form berita
class FormBerita extends StatefulWidget {
  @override
  FormBeritaState createState() => FormBeritaState();
}

class FormBeritaState extends State<FormBerita> {
//ANCHOR variable form berita
  // QuillController _controller = QuillController.basic();
  File _image;
  String username = "";
  String _mySelection;
  bool _isInAsyncCall = false;
  List kategoriAdmin = [];
  final formKey = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MM-dd");
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var alertStyle = AlertStyle(
    isCloseButton: false,
    isOverlayTapDismiss: false,
    animationDuration: Duration(milliseconds: 400),
  );

  // ignore: unused_field
  String _valKomentar;
  // ignore: unused_field
  List _listKomentar = ["Aktif", "Tidak"];

//ANCHOR controller form berita
  TextEditingController cYoutube = TextEditingController();
  TextEditingController cJudul = TextEditingController();
  TextEditingController cKategori = TextEditingController();
  TextEditingController cIsi = TextEditingController();
  TextEditingController cTanggal = TextEditingController();
  TextEditingController cUsername = TextEditingController();
  TextEditingController cStatus = TextEditingController();

//ANCHOR akses gallery form berita
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

    setState(
      () {
        _image = compressImg;
      },
    );
  }

//cek
  Future getImageCamera() async {
    // ignore: deprecated_member_use
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int rand = Math.Random().nextInt(100000);

    Img.Image image = Img.decodeImage(
      imageFile.readAsBytesSync(),
    );
    Img.Image smallerImg = Img.copyResize(image, width: 1144, height: 792);

    var compressImg = File("$path/image_$rand.jpg")
      ..writeAsBytesSync(
        Img.encodeJpg(smallerImg, quality: 1000),
      );

    setState(
      () {
        _image = compressImg;
      },
    );
  }

//ANCHOR cek session admin form berita
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

//ANCHOR api kategori berita form berita
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
    this.setState(() {
      kategoriAdmin = kategori;
      print(kategoriAdmin);
    });
  }

  @override
  void initState() {
    super.initState();
    this.getKategori();
  }

//ANCHOR api gambar post form berita
  Future upload(File imageFile) async {
    setState(
      () {
        _isInAsyncCall = true;
      },
    );
    SharedPreferences pref = await SharedPreferences.getInstance();
    var stream =
        // ignore: deprecated_member_use
        http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse(
        "http://dokar.kendalkab.go.id/webservice/android/kabar/postberita");

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));
    request.fields['video'] = cYoutube.text;
    request.fields['judul'] = cJudul.text;
    request.fields['kategori'] = _mySelection;
    // request.fields['komentar'] = _valKomentar;
    request.fields['isi'] = cIsi.text;
    request.fields['tanggal'] = cTanggal.text;
    request.fields['id_desa'] = pref.getString("IdDesa");
    request.fields['username'] = pref.getString("userAdmin");
    request.fields['status'] = pref.getString("status");
    request.fields['id_admin'] = pref.getString("IdAdmin");
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
        subtitle: 'Berita berhasil di upload',
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

//ANCHOR hal utama form berita
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
          'INPUT BERITA ',
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
        opacity: 0.5,
        progressIndicator:
            CircularProgressIndicator(backgroundColor: Colors.red),
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
//ANCHOR input judul form berita
                    Container(
                      alignment: Alignment.topLeft,
                      // height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      // height: 60.0,
                      child: TextFormField(
                        maxLines: null,
                        controller: cJudul,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
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
                      padding: EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR input kategori form berita
                    Column(
                      children: <Widget>[
                        Container(
                          // padding: EdgeInsets.only(left: 20.0),
                          // alignment: Alignment.centerLeft,
                          // decoration: kBoxDecorationStyle2,
                          // height: 60.0,
                          // alignment: Alignment.topLeft,
                          // height: 100,
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
                            hint: Text('Pilih Kategori'),
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
                                  print(val);
                                },
                              );
                            },
                            value: _mySelection,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR input uraian form berita
                    Container(
                      alignment: Alignment.topLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 200.0,
                      child: TextFormField(
                        controller: cIsi,
                        maxLines: null,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          //contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.library_books,
                            color: Colors.grey,
                          ),
                          hintText: 'Uraian Berita',
                          hintStyle: kHintTextStyle2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR input tanggal form berita
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
                    //  Padding(
                    //   padding:  EdgeInsets.only(top: 20.0),
                    // ),
                    //  Column(
                    //   children: <Widget>[
                    //     Container(
                    //       padding:  EdgeInsets.only(left: 20.0),
                    //       alignment: Alignment.centerLeft,
                    //       decoration: kBoxDecorationStyle2,
                    //       height: 60.0,
                    //       child: DropdownButton(
                    //         underline: SizedBox(),
                    //         isExpanded: true,
                    //         hint: Text("Aktifkan Komentar"),
                    //         items: _listKomentar.map(
                    //           (value) {
                    //             return DropdownMenuItem(
                    //               child: Text(value),
                    //               value: value,
                    //             );
                    //           },
                    //         ).toList(),
                    //         onChanged: (value) {
                    //           setState(
                    //             () {
                    //               _valKomentar = value;
                    //             },
                    //           );
                    //         },
                    //         value: _valKomentar,
                    //       ),
                    //     )
                    //   ],
                    // ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR input link youtube form berita
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
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
//ANCHOR input gambar form berita
                    Center(
                      child: _image == null
                          ? Text("Gambar belum di pilih !")
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
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Container(
                      width: mediaQueryData.size.width,
                      height: mediaQueryData.size.height * 0.07,
                      child: ElevatedButton.icon(
                        icon: Icon(
                          Icons.file_upload,
                          color: Colors.white,
                        ),
                        label: Text("UPLOAD BERITA"),
                        onPressed: () async {
                          if (cJudul.text == null || cJudul.text == '') {
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
                          } else if (_mySelection == null ||
                              _mySelection == '') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                            ));
                            // scaffoldKey.currentState.showSnackBar(snackBar);
                          } else if (cIsi.text == null || cIsi.text == '') {
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
                          } else if (cTanggal.text == null ||
                              cTanggal.text == '') {
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
                          }
                          // else if (_valKomentar == null ||
                          //     _valKomentar == '') {
                          //   SnackBar snackBar = SnackBar(
                          //     content: Text(
                          //       'Komentar wajib di pilih.',
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //     backgroundColor: Colors.orange[700],
                          //     action: SnackBarAction(
                          //       label: 'ULANGI',
                          //       textColor: Colors.white,
                          //       onPressed: () {
                          //         print('ULANGI snackbar');
                          //       },
                          //     ),
                          //   );
                          //   scaffoldKey.currentState.showSnackBar(snackBar);
                          // }
                          else if (_image == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                            ));
                            // scaffoldKey.currentState.showSnackBar(snackBar);
                          } else {
                            upload(_image);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          // padding: EdgeInsets.all(15.0),
                          elevation: 0, backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15), // <-- Radius
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
