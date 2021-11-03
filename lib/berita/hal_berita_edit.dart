////////////////////////////////PACKAGE//////////////////////////////////////
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
import 'package:path/path.dart'; //upload gambar path
import 'package:shared_preferences/shared_preferences.dart'; //save session

import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'package:flutter_html_view/flutter_html_view.dart';

import 'dart:math' as Math;

////////////////////////////////PROJECT///////////////////////////////////////
class FormBeritaEdit extends StatefulWidget {
  String dJudul, dKategori, dIsi, dTanggal, dGambar, dIdBerita;

  FormBeritaEdit(
      {this.dJudul,
      this.dKategori,
      this.dIsi,
      this.dTanggal,
      this.dGambar,
      this.dIdBerita});
  @override
  FormBeritaEditState createState() => FormBeritaEditState();
}

class FormBeritaEditState extends State<FormBeritaEdit> {
////////////////////////////////DEKLARASI////////////////////////////////////
  File _image;
  String username = "";
  String _mySelection;
  List kategoriAdmin = List();
  final format = DateFormat("yyyy-MM-dd");

  bool _validate = false;

////////////////////////////////CONTROLER/////////////////////////////////////
  TextEditingController dJudul = new TextEditingController();
  TextEditingController dKategori = new TextEditingController();
  TextEditingController dIsi = new TextEditingController();
  TextEditingController dTanggal = new TextEditingController();
  TextEditingController cUsername = new TextEditingController();
  TextEditingController cStatus = new TextEditingController();
  TextEditingController dGambar = new TextEditingController();
  TextEditingController dIdBerita = new TextEditingController();
///////////////////////////////AKSES GALERI///////////////////////////////////
  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int rand = new Math.Random().nextInt(100000);

    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, width: 1144, height: 792);

    var compressImg = new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 1000));

    setState(() {
      _image = compressImg;
    });
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

    setState(() {
      _image = compressImg;
    });
  }

///////////////////////////////CEK SESSION ADMIN///////////////////////////////////
  Future _cekSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(() {
        username = pref.getString("userAdmin");
      });
    }
  }

///////////////////////////////API KATEGORI BERITA///////////////////////////////////
  Future<String> getKategori() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        "http://dokar.kendalkab.go.id/webservice/android/kabar/kategori",
        body: {
          "IdDesa": pref.getString("IdDesa"),
        });
    var kategori = json.decode(response.body);
    this.setState(() {
      kategoriAdmin = kategori;

      print(kategoriAdmin);
      //print(id);
    });
  }

  @override
  void initState() {
    dJudul = new TextEditingController(text: "${widget.dJudul}");
    dKategori = new TextEditingController(text: "${widget.dKategori}");
    dIsi = new TextEditingController(text: "${widget.dIsi}");
    dTanggal = new TextEditingController(text: "${widget.dTanggal}");
    dGambar = new TextEditingController(text: "${widget.dGambar}");
    dIdBerita = new TextEditingController(text: "${widget.dIdBerita}");
    super.initState();
    this.getKategori();
  }

  @override
  void dispose() {
    dJudul.dispose();
    super.dispose();
  }

///////////////////////////////FUNGSI UPLOAD API GAMBAR/////////////////////////////////
  Future upload(File imageFile) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri =
        Uri.parse("http://dokar.kendalkab.go.id/webservice/android/kabar/edit");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));
    request.fields['judul'] = dJudul.text;
    if (_mySelection == null) {
    } else {
      request.fields['kategori'] = _mySelection;
    }
    request.fields['isi'] = dIsi.text;
    request.fields['tanggal'] = dTanggal.text;
    request.fields['id_desa'] = pref.getString("IdDesa");
    request.fields['username'] = pref.getString("userAdmin");
    request.fields['status'] = pref.getString("status");
    request.fields['id_berita'] = dIdBerita.text;

    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Upload Failed");
    }
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  Future uploadNoImg() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (_mySelection == null) {
      final response = await http.post(
          "http://dokar.kendalkab.go.id/webservice/android/kabar/edit",
          body: {
            "judul": dJudul.text,
            "isi": dIsi.text,
            "tanggal": dTanggal.text,
            "id_desa": pref.getString("IdDesa"),
            "username": pref.getString("userAdmin"),
            "status": pref.getString("status"),
            "id_berita": dIdBerita.text,
          });
      var datauser = json.decode(response.body);
      print(datauser);
    } else {
      final response = await http.post(
          "http://dokar.kendalkab.go.id/webservice/android/kabar/edit",
          body: {
            "judul": dJudul.text,
            "kategori": _mySelection,
            "isi": dIsi.text,
            "tanggal": dTanggal.text,
            "id_desa": pref.getString("IdDesa"),
            "username": pref.getString("userAdmin"),
            "status": pref.getString("status"),
            "id_berita": dIdBerita.text,
          });
      var datauser = json.decode(response.body);
      print(datauser);
    }

    /*var uri =
        Uri.parse("http://dokar.kendalkab.go.id/webservice/android/kabar/edit");

    var request = new http.MultipartRequest("POST", uri);

    
    request.fields['judul'] = dJudul.text;
    request.fields['kategori'] = _mySelection;
    request.fields['isi'] = dIsi.text;
    request.fields['tanggal'] = dTanggal.text;
    request.fields['id_desa'] = pref.getString("IdDesa");
    request.fields['username'] = pref.getString("userAdmin");
    request.fields['status'] = pref.getString("status");
    request.fields['id_berita'] = dIdBerita.text;
 */
  }

///////////////////////////////HALAMAN UTAMA//////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Berita Edit'),
        backgroundColor: Color(0xFFee002d),
      ),
      body: ListView(children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(top: 20.0),
              ),
///////////////////////////////INPUT JUDUL///////////////////////////////////
              Container(
                alignment: Alignment.centerLeft,
                decoration: kBoxDecorationStyle2,
                height: 60.0,
                child: TextField(
                  controller: dJudul,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'OpenSans',
                  ),
                  decoration: InputDecoration(
                    errorText: _validate ? 'Harus di isi' : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.person,
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
///////////////////////////////INPUT KATEGORI///////////////////////////////////
              new Column(
                children: <Widget>[
                  Container(
                    padding: new EdgeInsets.only(left: 20.0),
                    alignment: Alignment.centerLeft,
                    decoration: kBoxDecorationStyle2,
                    height: 60.0,
                    child: DropdownButton(
                      //controller: dKategori,
                      //icon: Icon(Icons.accessibility_new),
                      underline: SizedBox(),
                      hint: Text("${widget.dKategori}"),
                      isExpanded: true,
                      items: kategoriAdmin.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item['kategori_nama']),
                          value: item['kategori_nama'].toString(),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _mySelection = newVal;
                        });
                      },
                      value: _mySelection,
                    ),
                  )
                ],
              ),
              new Padding(
                padding: new EdgeInsets.only(top: 20.0),
              ),
///////////////////////////////INPUT URAIAN///////////////////////////////////
              Container(
                alignment: Alignment.topLeft,
                decoration: kBoxDecorationStyle2,
                height: 200.0,
                child: TextField(
                  controller: dIsi,
                  maxLines: 10,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'OpenSans',
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    //contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.person,
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
///////////////////////////////INPUT TANGGAL///////////////////////////////////
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
///////////////////////////////INPUT GAMBAR///////////////////////////////////
              Center(
                child: _image == null
                    ? new Text("Pilih gambar berita!")
                    : new Image.file(_image),
              ),
              /*TextField(
                //controller: cJudul,
                decoration: new InputDecoration(
                  hintText: "Title",
                ),
              ),*/
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
              /*RaisedButton(
                child: Text(
                  "SIMPAN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    //fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
                onPressed: () {
                  upload(_image);
                },
                color: Colors.green[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17.0),
                ),
              ),*/

              RaisedButton.icon(
                icon: Icon(
                  Icons.file_upload,
                  color: Colors.white,
                ),
                label: Text("UPLOAD BERITA"),
                onPressed: () {
                  if (dJudul.text.isEmpty) {
                    setState(() {
                      dJudul.text.isEmpty
                          ? _validate = true
                          : _validate = false;
                    });
                  } else {
                    if (_image == null || dKategori == null) {
                      uploadNoImg();
                      Navigator.pushReplacementNamed(context, '/Haldua');
                    } else {
                      upload(_image);
                      Navigator.pushReplacementNamed(context, '/Haldua');
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
        )
      ]),
    );
  }
}

/*import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:dokar_aplikasi/style/constants.dart';
import "package:image_picker/image_picker.dart"; //akses galeri dan camera
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //api
import 'package:async/async.dart'; //upload gambar
import 'package:path/path.dart'; //upload gambar path
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'package:shared_preferences/shared_preferences.dart'; //save session

class FormBerita extends StatefulWidget {
  @override
  _FormBeritaState createState() => _FormBeritaState();
}

class _FormBeritaState extends State<FormBerita> {
  final format = DateFormat("yyyy-MM-dd");
  /*List<String> kategori = [
    "-Pilih Kategori",
    "BERITA",
    "POTENSI",
    "BUMDES",
    "SOSIAL",
  ];*/
  String _kategori = "-Pilih Kategori";

  String username = "";
  String _mySelection;
  List kategoriAdmin = List();

  Future _cekSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(() {
        username = pref.getString("userAdmin");
      });
    }
  }

  Future<String> getKategori() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        "http://dokar.kendalkab.go.id/webservice/android/kabar/kategori",
        body: {
          "IdDesa": pref.getString("IdDesa"),
        });
    var kategori = json.decode(response.body);
    this.setState(() {
      kategoriAdmin = kategori;

      print(kategoriAdmin);
      //print(id);
    });
  }

  File _image;

  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 300.0,
      maxWidth: 300.0,
    );

    setState(() {
      _image = imageFile;
      print('_image: $_image');
    });
  }

  Future getImageCamera() async {
    var imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 300.0,
      maxWidth: 300.0,
    );

    setState(() {
      _image = imageFile;
      print('_image: $_image');
    });
  }

  Future upload(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri =
        Uri.parse("http://dokar.kendalkab.go.id/webservice/android/kabar/post");

    var request = new http.MultipartRequest("POST", uri);
    var multipleFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipleFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Upload Berhasil");
      print('_image: $_image');
    } else {
      print("Upload Failed");
    }
  }

  @override
  void initState() {
    super.initState();
    this.getKategori();
  }

  /*void pilihKategori(String value) {
    setState(() {
      _kategori = value;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Form Berita'),
        backgroundColor: Color(0xFFee002d),
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(top: 20.0),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: kBoxDecorationStyle2,
                  height: 60.0,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'OpenSans',
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 14.0),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey[600],
                      ),
                      hintText: 'Judul Berita',
                      hintStyle: kHintTextStyle2,
                    ),
                  ),
                ),
                /*new TextField(
                  decoration: new InputDecoration(
                      hintText: "Judul Berita",
                      labelText: "Judul Berita",
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0))),
                ),*/
                new Padding(
                  padding: new EdgeInsets.only(top: 20.0),
                ),
                new Column(
                  children: <Widget>[
                    Container(
                      padding: new EdgeInsets.only(left: 20.0),
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle2,
                      height: 60.0,
                      child: DropdownButton(
                        //icon: Icon(Icons.accessibility_new),
                        underline: SizedBox(),
                        hint: Text('Pilih Kategori'),
                        isExpanded: true,
                        items: kategoriAdmin.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item['kategori_nama']),
                            value: item['kategori_nama'].toString(),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _mySelection = newVal;
                          });
                        },
                        value: _mySelection,
                      ),

                      /*new DropdownButton(
                      isExpanded: true,
                      onChanged: (String value) {
                        pilihKategori(value);
                      },
                      value: _kategori,
                      items: kategori.map((String value) {
                        return new DropdownMenuItem(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),*/
                    )
                  ],
                ),
                new Padding(
                  padding: new EdgeInsets.only(top: 20.0),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  decoration: kBoxDecorationStyle2,
                  height: 200.0,
                  child: TextField(
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
                        Icons.person,
                        color: Colors.grey[600],
                      ),
                      hintText: 'Uraian Berita',
                      hintStyle: kHintTextStyle2,
                    ),
                  ),
                ),
                /*new TextField(
                  decoration: new InputDecoration(
                      hintText: "Pilih Kategori",
                      labelText: "Pilih Kategori",
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0))),
                ),*/
                new Padding(
                  padding: new EdgeInsets.only(top: 20.0),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: kBoxDecorationStyle2,
                  height: 60.0,
                  child: DateTimeField(
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
                //Text(' (${format.pattern})'),

                /*new TextField(
                  maxLines: 3,
                  decoration: new InputDecoration(
                      hintText: "Uraian Berita",
                      labelText: "Uraian Berita",
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0))),
                ),*/
                new Padding(
                  padding: new EdgeInsets.only(top: 20.0),
                ),
                //UPLOAD GAMBAR
                Center(
                  child: _image == null
                      ? new Text("No image selected")
                      : new Image.file(_image),
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Icon(Icons.image),
                      onPressed: getImageGallery,
                    ),
                    RaisedButton(
                      child: Icon(Icons.camera_alt),
                      onPressed: getImageCamera,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    RaisedButton(
                        child: Text("UPLOAD"),
                        onPressed: () {
                          upload(_image);
                        }),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/

/*String _jk = "";

  void _pilihJk(String value) {
    setState(() {
      _jk = value;
    });
  }*/
/*new RadioListTile(
                  value: "laki-laki",
                  title: new Text("Laki-laki"),
                  groupValue: _jk,
                  onChanged: (String value) {
                    _pilihJk(value);
                  },
                  activeColor: Colors.red,
                ),
                new RadioListTile(
                  value: "Perempuan",
                  title: new Text("Perempuan"),
                  groupValue: _jk,
                  onChanged: (String value) {
                    _pilihJk(value);
                  },
                  activeColor: Colors.red,
                ),
                new Padding(
                  padding: new EdgeInsets.only(top: 20.0),
                ),*/
