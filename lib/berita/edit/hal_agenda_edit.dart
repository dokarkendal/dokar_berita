//ANCHOR package agenda edit
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:async/async.dart'; //upload gambar
import 'package:flutter/material.dart';
// import 'package:dokar_aplikasi/style/constants.dart';
import 'package:image_picker/image_picker.dart'; //akses galeri dan camera
import 'package:http/http.dart' as http; //api
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart'; //upload gambar path
import 'package:shared_preferences/shared_preferences.dart'; //save session
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'dart:math' as Math;
import 'package:status_alert/status_alert.dart';

import '../../style/styleset.dart';

//ANCHOR class form agenda edit
class FormAgendaEdit extends StatefulWidget {
  final String cJudul,
      cPenyelenggara,
      cIsi,
      cTanggalmulai,
      cTanggalselesai,
      cJammulai,
      cJamselesai,
      cGambar,
      cIdAgenda;

  FormAgendaEdit(
      {this.cJudul,
      this.cPenyelenggara,
      this.cIsi,
      this.cTanggalmulai,
      this.cTanggalselesai,
      this.cJammulai,
      this.cJamselesai,
      this.cGambar,
      this.cIdAgenda});
  @override
  FormAgendaEditState createState() => FormAgendaEditState();
}

class FormAgendaEditState extends State<FormAgendaEdit> {
//ANCHOR variable agenda edit
  File _image;
  String username = "";
  String _mySelection;
  List kategoriAdmin = [];
  final format = DateFormat("yyyy-MM-dd");
  final formatTime = DateFormat("HH:mm");
  final formKey = GlobalKey<FormState>();
  bool _isInAsyncCall = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//ANCHOR controller agenda edit
  TextEditingController cJudul = TextEditingController();
  TextEditingController cPenyelenggara = TextEditingController();
  TextEditingController cIsi = TextEditingController();
  TextEditingController cTanggalmulai = TextEditingController();
  TextEditingController cTanggalselesai = TextEditingController();
  TextEditingController cJammulai = TextEditingController();
  TextEditingController cJamselesai = TextEditingController();
  TextEditingController cIdAgenda = TextEditingController();
  TextEditingController cGambar = TextEditingController();

//ANCHOR input image size flutter agenda edit
  Future getImageGallery() async {
    // ignore: deprecated_member_use
    var imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

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

//ANCHOR session agenda edit
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
    cJudul = TextEditingController(text: "${widget.cJudul}");
    cPenyelenggara = TextEditingController(text: "${widget.cPenyelenggara}");
    cIsi = TextEditingController(text: "${widget.cIsi}");
    cTanggalmulai = TextEditingController(text: "${widget.cTanggalmulai}");
    cTanggalselesai = TextEditingController(text: "${widget.cTanggalselesai}");
    cJammulai = TextEditingController(text: "${widget.cJammulai}");
    cJamselesai = TextEditingController(text: "${widget.cJamselesai}");
    cIdAgenda = TextEditingController(text: "${widget.cIdAgenda}");
    cGambar = TextEditingController(text: "${widget.cGambar}");

    super.initState();
  }

  @override
  void dispose() {
    cJudul.dispose();
    super.dispose();
  }

//ANCHOR upload gambar agenda edit
  Future uploadGambarKegiatanEdit(File imageFile) async {
    setState(() {
      _isInAsyncCall = true;
    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    var stream = http.ByteStream(
      // ignore: deprecated_member_use
      DelegatingStream.typed(
        imageFile.openRead(),
      ),
    );
    var length = await imageFile.length();
    var uri = Uri.parse(
        "http://dokar.kendalkab.go.id/webservice/android/agenda/editevent");

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));
    request.fields['judul'] = cJudul.text;
    request.fields['penyelenggara'] = cPenyelenggara.text;
    request.fields['isi'] = cIsi.text;
    request.fields['tgl_mulai'] = cTanggalmulai.text;
    request.fields['tgl_selesai'] = cTanggalselesai.text;
    request.fields['jam_mulai'] = cJammulai.text;
    request.fields['jam_selesai'] = cJamselesai.text;
    request.fields['gambar_agenda'] = cGambar.text;
    request.fields['id_desa'] = pref.getString("IdDesa");
    request.fields['id_agenda'] = cIdAgenda.text;

    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Uploaded Succes");
      print(response);
      setState(
        () {
          _isInAsyncCall = false;
        },
      );
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/HalEventList', ModalRoute.withName('/EditSemua'));
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Sukses',
        subtitle: 'Event Berhasil di upload',
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
          '/HalEventList', ModalRoute.withName('/EditSemua'));
      StatusAlert.show(
        this.context,
        duration: Duration(seconds: 2),
        title: 'Failed',
        subtitle: 'Event Gagal di upload',
        configuration: IconConfiguration(icon: Icons.done),
      );
    }
    response.stream.transform(utf8.decoder).listen(
      (value) {
        print(value);
      },
    );
  }

//ANCHOR upload no gambar agenda edit
  Future uploadNoGambarKegiatanEdit() async {
    setState(() {
      _isInAsyncCall = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (_mySelection == null) {
      final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/agenda/editevent"),
        body: {
          "judul": cJudul.text,
          "penyelenggara": cPenyelenggara.text,
          "isi": cIsi.text,
          "tgl_mulai": cTanggalmulai.text,
          "tgl_selesai": cTanggalselesai.text,
          "jam_mulai": cJammulai.text,
          "jam_selesai": cJamselesai.text,
          "id_desa": pref.getString("IdDesa"),
          "id_agenda": cIdAgenda.text,
        },
      );
      var datauser = json.decode(response.body);

      if (response.statusCode == 200) {
        print(datauser);
        setState(() {
          _isInAsyncCall = false;
        });
        Navigator.of(this.context).pushNamedAndRemoveUntil(
            '/HalEventList', ModalRoute.withName('/EditSemua'));
        StatusAlert.show(
          this.context,
          duration: Duration(seconds: 2),
          title: 'Sukses',
          subtitle: 'Event Berhasil di upload',
          configuration: IconConfiguration(icon: Icons.done),
        );
      } else {
        print("Upload Failed.");
        setState(() {
          _isInAsyncCall = false;
        });
        Navigator.of(this.context).pushNamedAndRemoveUntil(
            '/HalEventList', ModalRoute.withName('/EditSemua'));
        StatusAlert.show(
          this.context,
          duration: Duration(seconds: 2),
          title: 'Failed.',
          subtitle: 'Event Gagal di upload.',
          configuration: IconConfiguration(icon: Icons.done),
        );
      }
    }
  }

//ANCHOR body agenda edit
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
          'EDIT AGENDA',
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
//ANCHOR judul agenda edit
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: decorationTextField,
                      // height: 60.0,
                      child: TextFormField(
                        maxLines: null,
                        controller: cJudul,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          //errorText: _validate ? 'Harus di isi' : null,
                          border: decorationBorder,
                          // contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.text_fields,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Judul Agenda',
                          hintStyle: decorationHint,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
//ANCHOR Penyelenggara agenda edit
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: decorationTextField,
                      // height: 60.0,
                      child: TextFormField(
                        maxLines: null,
                        controller: cPenyelenggara,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          //errorText: _validate ? 'Harus di isi' : null,
                          border: decorationBorder,
                          // contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.people,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Penyelenggara',
                          hintStyle: decorationHint,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
//ANCHOR agenda isi agenda edit
                    Container(
                      alignment: Alignment.topLeft,
                      decoration: decorationTextField,
                      // height: 200.0,
                      child: TextFormField(
                        controller: cIsi,
                        maxLines: null,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: decorationBorder,
                          //contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.library_books,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Uraian Agenda',
                          hintStyle: decorationHint,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
//ANCHOR  tanggal agenda edit
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: decorationTextField,
                      // height: 60.0,
                      child: DateTimeField(
                        controller: cTanggalmulai,
                        format: format,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                        decoration: InputDecoration(
                          border: decorationBorder,
                          prefixIcon: Icon(
                            Icons.date_range,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Tanggal Mulai',
                          hintStyle: decorationHint,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    //ANCHOR agenda tanggal edit
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: decorationTextField,
                      // height: 60.0,
                      child: DateTimeField(
                        controller: cTanggalselesai,
                        format: format,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                        decoration: InputDecoration(
                          border: decorationBorder,
                          //contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.date_range,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Tanggal Selesai',
                          hintStyle: decorationHint,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
//ANCHOR input Jam selesai agenda edit
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: decorationTextField,
                      // height: 60.0,
                      child: DateTimeField(
                        controller: cJammulai,
                        format: formatTime,
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                            builder: (context, child) => MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child),
                          );
                          return DateTimeField.convert(time);
                        },
                        decoration: InputDecoration(
                          border: decorationBorder,
                          //contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.access_time,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Jam Mulai',
                          hintStyle: decorationHint,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
//ANCHOR input Jam selesai agenda edit
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: decorationTextField,
                      // height: 60.0,
                      child: DateTimeField(
                        controller: cJamselesai,
                        format: formatTime,
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                            builder: (context, child) => MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child),
                          );
                          return DateTimeField.convert(time);
                        },
                        decoration: InputDecoration(
                          border: decorationBorder,
                          prefixIcon: Icon(
                            Icons.access_time,
                            color: Colors.grey[600],
                          ),
                          hintText: 'Jam Selesai',
                          hintStyle: decorationHint,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
//NOTE gambar agenda edit
                    Center(
                      child: _image == null
                          ? Text("Pilih gambar.")
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
                    Container(
                      width: mediaQueryData.size.width,
                      height: mediaQueryData.size.height * 0.07,
                      child: ElevatedButton.icon(
                        icon: Icon(
                          Icons.file_upload,
                          color: Colors.white,
                        ),
                        label: Text("SIMPAN AGENDA"),
                        onPressed: () async {
                          if (cJudul.text == null || cJudul.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                            ));
                            // scaffoldKey.currentState.showSnackBar(snackBar);
                          } else if (cPenyelenggara.text == null ||
                              cPenyelenggara.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                            ));
                            // scaffoldKey.currentState.showSnackBar(snackBar);
                          } else if (cIsi.text == null || cIsi.text == '') {
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
                          } else if (cTanggalmulai.text == null ||
                              cTanggalmulai.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                            ));
                            // scaffoldKey.currentState.showSnackBar(snackBar);
                          } else if (cTanggalselesai.text == null ||
                              cTanggalselesai.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                            ));
                            // scaffoldKey.currentState.showSnackBar(snackBar);
                          } else if (cJammulai.text == null ||
                              cJammulai.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                            ));
                            // scaffoldKey.currentState.showSnackBar(snackBar);
                          } else if (cJamselesai.text == null ||
                              cJamselesai.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                            ));
                            // scaffoldKey.currentState.showSnackBar(snackBar);
                          } else {
                            if (_image == null) {
                              uploadNoGambarKegiatanEdit();
                            } else {
                              uploadGambarKegiatanEdit(_image);
                            }
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
                        //   color: Colors.green,
                        //   textColor: Colors.white,
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(17.0),
                        //   ),
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
