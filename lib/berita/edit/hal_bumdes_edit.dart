//ANCHOR package bumdes edit
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'dart:io';
import 'package:async/async.dart'; //upload gambar
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_cropper/image_cropper.dart';
// import 'package:dokar_aplikasi/style/constants.dart';
import 'package:image_picker/image_picker.dart'; //akses galeri dan camera
import 'package:http/http.dart' as http; //api
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart'; //upload gambar path
import 'package:shared_preferences/shared_preferences.dart'; //save session
// import 'package:path_provider/path_provider.dart';
// import 'package:image/image.dart' as Img;
// import 'dart:math' as Math;

// import 'package:status_alert/status_alert.dart';

import '../../style/styleset.dart';

//ANCHOR class form bumdes edit
class FormBumdesEdit extends StatefulWidget {
  final String dJudul, dKatTempat, dIsi, dTanggal, dGambar, dIdBumdes, dVideo;

  FormBumdesEdit(
      {required this.dJudul,
      required this.dKatTempat,
      required this.dIsi,
      required this.dTanggal,
      required this.dGambar,
      required this.dIdBumdes,
      required this.dVideo});
  @override
  FormBumdesEditState createState() => FormBumdesEditState();
}

class FormBumdesEditState extends State<FormBumdesEdit> {
//ANCHOR variable bumdes edit
  // File _image;
  String username = "";

  final formKey = GlobalKey<FormState>();

  bool _loadingeditberita = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//ANCHOR controller bumdes edit
  TextEditingController dVideo = new TextEditingController();
  TextEditingController dJudul = new TextEditingController();
  TextEditingController dKatTempat = new TextEditingController();
  // TextEditingController dIsi = new TextEditingController();
  TextEditingController dTanggal = new TextEditingController();
  TextEditingController cUsername = new TextEditingController();
  TextEditingController cStatus = new TextEditingController();
  TextEditingController dGambar = new TextEditingController();
  TextEditingController dIdBumdes = new TextEditingController();
  late HtmlEditorController controller2;
  String? textToDisplay;

  bool _inProcess = false;
  File? _selectedFile;

  getImage(ImageSource source) async {
    setState(
      () {
        _inProcess = true;
      },
    );

    XFile? image = await ImagePicker().pickImage(source: source);

    if (image != null) {
      File? cropped = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 2),
        compressQuality: 100,
        maxWidth: 572,
        maxHeight: 396,
        cropStyle: CropStyle.rectangle,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: const AndroidUiSettings(
          toolbarColor: Colors.black,
          toolbarTitle: "Crop",
          statusBarColor: Colors.black,
          backgroundColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
        ),
      );

      setState(
        () {
          _selectedFile = cropped;
          _inProcess = false;
        },
      );
    } else {
      setState(
        () {
          _inProcess = false;
        },
      );
    }
  }

  void clearimage() {
    setState(
      () {
        _selectedFile = null;
      },
    );
  }

//ANCHOR input image size flutter bumdes edit
  // Future getImageGallery() async {
  //   // ignore: deprecated_member_use
  //   var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

  //   final tempDir = await getTemporaryDirectory();
  //   final path = tempDir.path;

  //   int rand = new Math.Random().nextInt(100000);

  //   Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
  //   Img.Image smallerImg = Img.copyResize(image, width: 1144, height: 792);

  //   var compressImg = new File("$path/image_$rand.jpg")
  //     ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 1000));

  //   setState(
  //     () {
  //       _image = compressImg;
  //     },
  //   );
  // }

  // Future getImageCamera() async {
  //   // ignore: deprecated_member_use
  //   var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

  //   final tempDir = await getTemporaryDirectory();
  //   final path = tempDir.path;

  //   int rand = new Math.Random().nextInt(100000);

  //   Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
  //   Img.Image smallerImg = Img.copyResize(image, width: 1144, height: 792);

  //   var compressImg = new File("$path/image_$rand.jpg")
  //     ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 1000));

  //   setState(
  //     () {
  //       _image = compressImg;
  //     },
  //   );
  // }

//ANCHOR session edit kegiatan bumdes edit
  // ignore: unused_element
  Future _cekSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userAdmin") != null) {
      setState(
        () {
          username = pref.getString("userAdmin")!;
        },
      );
    }
  }

  @override
  void initState() {
    controller2 = HtmlEditorController();
    dVideo = new TextEditingController(text: "${widget.dVideo}");
    dJudul = new TextEditingController(text: "${widget.dJudul}");
    dKatTempat = new TextEditingController(text: "${widget.dKatTempat}");
    // dIsi = new TextEditingController(text: "${widget.dIsi}");
    dTanggal = new TextEditingController(text: "${widget.dTanggal}");
    dGambar = new TextEditingController(text: "${widget.dGambar}");
    dIdBumdes = new TextEditingController(text: "${widget.dIdBumdes}");
    super.initState();
  }

  @override
  void dispose() {
    dJudul.dispose();
    super.dispose();
  }

//ANCHOR upload gambar bumdes edit
  Future uploadGambarKegiatanEdit(File _selectedFile) async {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    setState(() {
      _loadingeditberita = true;
    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    var stream = new http.ByteStream(
      // ignore: deprecated_member_use
      DelegatingStream.typed(
        _selectedFile.openRead(),
      ),
    );
    var length = await _selectedFile.length();
    var uri = Uri.parse(
        "http://dokar.kendalkab.go.id/webservice/android/bumdes/edit");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(_selectedFile.path));
    request.fields['judul'] = dJudul.text;
    request.fields['tempat'] = dKatTempat.text;
    request.fields['isi'] = textToDisplay ?? '';
    request.fields['id_desa'] = pref.getString("IdDesa")!;
    request.fields['username'] = pref.getString("userAdmin")!;
    request.fields['status'] = pref.getString("status")!;
    request.fields['id_bumdes'] = dIdBumdes.text;

    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        _loadingeditberita = false;
      });
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          elevation: 6.0,
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.done,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(
                width: mediaQueryData.size.width * 0.02,
              ),
              Flexible(
                child: Text(
                  "Edit Bumdes sukses",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              // Navigator.pushReplacementNamed(context, '/HalDashboard');
            },
          ),
        ),
      );
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/HalBumdesList', ModalRoute.withName('/EditSemua'));
      // StatusAlert.show(
      //   this.context,
      //   duration: Duration(seconds: 2),
      //   title: 'Sukses',
      //   subtitle: 'Bumdes Berhasil di upload',
      //   configuration: IconConfiguration(icon: Icons.done),
      // );
    } else {
      print("Upload Failed");
      setState(() {
        _loadingeditberita = false;
      });
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          elevation: 6.0,
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(
                width: mediaQueryData.size.width * 0.02,
              ),
              Flexible(
                child: Text(
                  "Edit gagal di upload",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'ULANGI',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/HalBumdesList', ModalRoute.withName('/EditSemua'));
      // StatusAlert.show(
      //   this.context,
      //   duration: Duration(seconds: 2),
      //   title: 'Failed.',
      //   subtitle: 'Bumdes Gagal di upload.',
      //   configuration: IconConfiguration(icon: Icons.done),
      // );
    }
    response.stream.transform(utf8.decoder).listen(
      (value) {
        print(value);
      },
    );
  }

//ANCHOR upload no gambar bumdes edit
  Future uploadNoGambarKegiatanEdit() async {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    setState(() {
      _loadingeditberita = true;
    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/bumdes/edit"),
        body: {
          "judul": dJudul.text,
          "tempat": dKatTempat.text,
          "isi": textToDisplay ?? '',
          "id_desa": pref.getString("IdDesa"),
          "username": pref.getString("userAdmin"),
          "status": pref.getString("status"),
          "id_bumdes": dIdBumdes.text,
        });
    var datauser = json.decode(response.body);
    print(datauser);
    if (response.statusCode == 200) {
      setState(() {
        _loadingeditberita = false;
      });
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          elevation: 6.0,
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.done,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(
                width: mediaQueryData.size.width * 0.02,
              ),
              Flexible(
                child: Text(
                  "Edit Bumdes Sukses",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              // Navigator.pushReplacementNamed(context, '/HalDashboard');
            },
          ),
        ),
      );
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/HalBumdesList', ModalRoute.withName('/EditSemua'));
      // StatusAlert.show(
      //   this.context,
      //   duration: Duration(seconds: 2),
      //   title: 'Sukses',
      //   subtitle: 'Bumdes Berhasil di upload',
      //   configuration: IconConfiguration(icon: Icons.done),
      // );
    } else {
      print("Upload Failed");
      setState(() {
        _loadingeditberita = false;
      });
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          elevation: 6.0,
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(
                width: mediaQueryData.size.width * 0.02,
              ),
              Flexible(
                child: Text(
                  "Edit gagal di upload",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'ULANGI',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/HalBumdesList', ModalRoute.withName('/EditSemua'));
      // StatusAlert.show(
      //   this.context,
      //   duration: Duration(seconds: 2),
      //   title: 'Failed.',
      //   subtitle: 'Bumdes Gagal di upload.',
      //   configuration: IconConfiguration(icon: Icons.done),
      // );
    }
  }

//ANCHOR body bumdes edit
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        // title: Text('Form Bumdes Edit'),
        title: Text(
          'EDIT BUMDES',
          style: TextStyle(
            color: appbarTitle,
            fontWeight: FontWeight.bold,
            // fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        // backgroundColor: Color(0xFFee002d),
      ),
      body: ListView(
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(top: 10.0),
                  ),
//ANCHOR judul bumdes edit
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: decorationTextField,
                    // height: 60.0,
                    child: TextFormField(
                      controller: dJudul,
                      maxLines: null,
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
                          color: Colors.grey,
                        ),
                        hintText: 'Judul Bumdes',
                        hintStyle: decorationHint,
                      ),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 10.0),
                  ),
//ANCHOR kategori bumdes edit
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: decorationTextField,
                    // height: 60.0,
                    child: TextFormField(
                      controller: dKatTempat,
                      maxLines: null,
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
                          Icons.place,
                          color: Colors.grey,
                        ),
                        hintText: 'Tempat Kegiatan',
                        hintStyle: decorationHint,
                      ),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 10.0),
                  ),
//ANCHOR kegiatan bumdes edit
                  Container(
                      alignment: Alignment.topLeft,
                      decoration: decorationTextField,
                      // height: 200.0,
                      child: HtmlEditor(
                        controller: controller2,
                        htmlEditorOptions: HtmlEditorOptions(
                          mobileLongPressDuration: Duration.zero,
                          hint: 'Uraian Bumdes',
                          initialText: widget.dIsi,
                          // shouldEnsureVisible: true,
                          // autoAdjustHeight: true,
                          //initialText: "<p>text content initial, if any</p>",
                        ),
                        htmlToolbarOptions: HtmlToolbarOptions(
                          // toolbarPosition: ToolbarPosition.aboveEditor,
                          // toolbarType: ToolbarType.nativeScrollable,
                          defaultToolbarButtons: [
                            StyleButtons(
                              style: false,
                            ),
                            FontSettingButtons(
                              fontName: false,
                              fontSizeUnit: false,
                            ),
                            FontButtons(
                              clearAll: false,
                              strikethrough: false,
                              subscript: false,
                              superscript: false,
                            ),
                            ColorButtons(
                              foregroundColor: false,
                              highlightColor: false,
                            ),
                            ListButtons(
                              ul: false,
                              ol: false,
                              listStyles: false,
                            ),
                            ParagraphButtons(
                              increaseIndent: false,
                              decreaseIndent: false,
                              textDirection: false,
                              lineHeight: false,
                              caseConverter: false,
                            ),
                            InsertButtons(
                              link: false,
                              picture: false,
                              audio: false,
                              video: false,
                              table: false,
                              hr: false,
                            ),
                            OtherButtons(
                              fullscreen: false,
                              codeview: false,
                              help: false,
                            ),
                          ],
                          customToolbarButtons: [
                            //your widgets here
                            // Button1(),
                            // Button2(),
                          ],
                          customToolbarInsertionIndices: [2, 5],
                        ),
                      )
                      // child: TextFormField(
                      //   controller: dIsi,
                      //   maxLines: null,
                      //   keyboardType: TextInputType.multiline,
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontFamily: 'OpenSans',
                      //   ),
                      //   decoration: InputDecoration(
                      //     border: decorationBorder,
                      //     contentPadding: EdgeInsets.symmetric(vertical: 50.0),
                      //     prefixIcon: Icon(
                      //       Icons.library_books,
                      //       color: Colors.grey,
                      //     ),
                      //     hintText: 'Uraian Kegiatan',
                      //     hintStyle: decorationHint,
                      //   ),
                      // ),
                      ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 10.0),
                  ),
//ANCHOR input link youtube bumdes edit
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: decorationTextField,
                    // height: 60.0,
                    child: TextFormField(
                      controller: dVideo,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        border: decorationBorder,
                        // contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: Icon(
                          Icons.ondemand_video,
                          color: Colors.grey,
                        ),
                        hintText: 'Link Youtube',
                        hintStyle: decorationHint,
                      ),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 20.0),
                  ),
//NOTE gambar bumdes edit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      getImageWidget(),
                      Column(
                        children: [
                          _cameraButton(),
                          Padding(
                            padding: EdgeInsets.only(
                                top: mediaQueryData.size.height * 0.01),
                          ),
                          _galeryButton(),
                        ],
                      ),
                      (_inProcess)
                          ? Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height * 0.95,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : const Center()
                    ],
                  ),
                  // Center(
                  //   child: _image == null
                  //       ? new Text("Pilih gambar kegiatan!")
                  //       : new Image.file(_image),
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     ElevatedButton(
                  //       child: Icon(
                  //         Icons.image,
                  //         color: Colors.white,
                  //       ),
                  //       onPressed: getImageGallery,
                  //       style: ElevatedButton.styleFrom(
                  //         // padding: EdgeInsets.all(15.0),
                  //         elevation: 0, backgroundColor: Colors.red,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius:
                  //               BorderRadius.circular(10), // <-- Radius
                  //         ),
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: EdgeInsets.only(left: 5.0),
                  //     ),
                  //     ElevatedButton(
                  //       child: Icon(
                  //         Icons.camera_alt,
                  //         color: Colors.white,
                  //       ),
                  //       onPressed: getImageCamera,
                  //       style: ElevatedButton.styleFrom(
                  //         // padding: EdgeInsets.all(15.0),
                  //         elevation: 0, backgroundColor: Colors.red,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius:
                  //               BorderRadius.circular(10), // <-- Radius
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 20.0),
                  ),
                  _loadingeditberita
                      ? Column(
                          children: [
                            SizedBox(
                              width: mediaQueryData.size.width,
                              height: mediaQueryData.size.height * 0.07,
                              child: ElevatedButton(
                                onPressed: () async {},
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  textStyle: const TextStyle(
                                    color: titleText,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          width: mediaQueryData.size.width,
                          height: mediaQueryData.size.height * 0.07,
                          child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.file_upload,
                              color: Colors.white,
                            ),
                            label: Text(
                              "EDIT BUMDES",
                              style: TextStyle(
                                color: subtitle,
                              ),
                            ),
                            onPressed: () async {
                              String? txt = await controller2.getText();
                              setState(() {
                                textToDisplay = txt;
                              });
                              if (dJudul.text.isEmpty || dJudul.text == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                                      }),
                                ));
                                // scaffoldKey.currentState.showSnackBar(snackBar);
                              } else if (dKatTempat.text.isEmpty ||
                                  dKatTempat.text == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                                      }),
                                ));
                                // scaffoldKey.currentState.showSnackBar(snackBar);
                              } else if (textToDisplay == null ||
                                  textToDisplay == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                                      }),
                                ));
                                // scaffoldKey.currentState.showSnackBar(snackBar);
                              } else {
                                if (_selectedFile == null) {
                                  uploadNoGambarKegiatanEdit();
                                } else {
                                  uploadGambarKegiatanEdit(_selectedFile!);
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
    );
  }

  Widget _cameraButton() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return SizedBox(
      width: mediaQueryData.size.height * 0.15,
      height: mediaQueryData.size.height * 0.05,
      child: ElevatedButton(
        onPressed: () {
          getImage(ImageSource.camera);
        },
        child: Row(
          children: [
            const Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.only(left: mediaQueryData.size.height * 0.01),
            ),
            const Text(
              'Kamera',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: subtitle,
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

///////tes gambar crop
  Widget getImageWidget() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    if (_selectedFile != null) {
      return Image.file(
        _selectedFile!,
        width: mediaQueryData.size.width * 0.5,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        "assets/images/load.png",
        width: mediaQueryData.size.width * 0.5,
      );
    }
  }

  Widget _galeryButton() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return SizedBox(
      width: mediaQueryData.size.height * 0.15,
      height: mediaQueryData.size.height * 0.05,
      child: ElevatedButton(
        onPressed: () {
          getImage(ImageSource.gallery);
        },
        child: Row(
          children: [
            const Icon(
              Icons.photo,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.only(left: mediaQueryData.size.height * 0.01),
            ),
            const Text(
              'Galeri',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: subtitle,
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
