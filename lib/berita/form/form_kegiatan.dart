//ANCHOR package input form Kegiatan
import 'dart:async'; //NOTE  api syn
import 'dart:convert'; //NOTE api to json
import 'dart:io';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:async/async.dart'; //NOTE upload gambar
import 'package:flutter/material.dart';
// import 'package:dokar_aplikasi/style/constants.dart';
import 'package:image_picker/image_picker.dart'; //NOTE akses galeri dan camera
import 'package:http/http.dart' as http; //NOTE api to http
// import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart'; //NOTE upload gambar path
import 'package:shared_preferences/shared_preferences.dart'; //NOTE save session
// import 'package:path_provider/path_provider.dart';
// import 'package:image/image.dart' as Img; //NOTE image
// import 'dart:math' as Math;
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:status_alert/status_alert.dart';

import '../../style/styleset.dart';

//ANCHOR class Form Kegiatan
class FormKegiatan extends StatefulWidget {
  @override
  FormKegiatanState createState() => FormKegiatanState();
}

class FormKegiatanState extends State<FormKegiatan> {
//ANCHOR variable
  // File _image;
  String username = "";
  bool _loadingkegiatan = false;
  // ignore: unused_field
  late String _mySelection;
  List kategoriAdmin = [];
  final formKey = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MM-dd");
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var alertStyle = AlertStyle(
    isCloseButton: false,
  );

//ANCHOR controller
  TextEditingController cYoutube = TextEditingController();
  TextEditingController cJudul = TextEditingController();
  TextEditingController cTempatKegiatan = TextEditingController();
  // TextEditingController cIsi = TextEditingController();
  TextEditingController cTanggal = TextEditingController();
  TextEditingController cUsername = TextEditingController();
  TextEditingController cStatus = TextEditingController();

  late HtmlEditorController controller2;
  String? textToDisplay;

//ANCHOR akses gallery
  // Future getImageGallery() async {
  //   // ignore: deprecated_member_use
  //   var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   if (imageFile == null) {
  //     return null;
  //   }
  //   final tempDir = await getTemporaryDirectory();
  //   final path = tempDir.path;

  //   int rand = Math.Random().nextInt(100000);

  //   Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
  //   Img.Image smallerImg = Img.copyResize(image, width: 1144, height: 792);

  //   var compressImg = File("$path/image_$rand.jpg")
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

  //   int rand = Math.Random().nextInt(100000);

  //   Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
  //   Img.Image smallerImg = Img.copyResize(image, width: 1144, height: 792);

  //   var compressImg = File("$path/image_$rand.jpg")
  //     ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 1000));

  //   setState(() {
  //     _image = compressImg;
  //   });
  // }

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
      _inProcess = true;
      CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 2),
        compressQuality: 100,
        maxWidth: 572,
        maxHeight: 396,
        cropStyle: CropStyle.rectangle,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarColor: Colors.black,
            toolbarTitle: "Crop",
            statusBarColor: Color.fromARGB(255, 53, 23, 23),
            backgroundColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true,
          ),
        ],
      );

      setState(() {
        _selectedFile = File(cropped!.path); // Convert CroppedFile to File
        _inProcess = false;
      });
    } else {
      setState(() {
        _inProcess = false;
      });
    }
  }

  void clearimage() {
    setState(
      () {
        _selectedFile = null;
      },
    );
  }

//ANCHOR cek session admin
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
    super.initState();
  }

//ANCHOR api gambar post
  void upload(File _selectedFile) async {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    setState(() {
      _loadingkegiatan = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var stream =
        // ignore: deprecated_member_use
        http.ByteStream(DelegatingStream.typed(_selectedFile.openRead()));
    var length = await _selectedFile.length();
    var uri = Uri.parse(
        "http://dokar.kendalkab.go.id/webservice/android/kabar/postkegiatan");

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile("image", stream, length,
        filename: basename(_selectedFile.path));
    request.fields['video'] = cYoutube.text;
    request.fields['judul'] = cJudul.text;
    request.fields['tempat'] = cTempatKegiatan.text;
    request.fields['isi'] = textToDisplay ?? '';
    request.fields['komentar'] = 'tidak';
    request.fields['tanggal'] = cTanggal.text;
    request.fields['id_desa'] = pref.getString("IdDesa")!;
    request.fields['username'] = pref.getString("userAdmin")!;
    request.fields['status'] = pref.getString("status")!;
    request.fields['id_admin'] = pref.getString("IdAdmin")!;
    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image Uploaded");
      setState(
        () {
          _loadingkegiatan = false;
        },
      );
      // await Future.delayed(
      //   Duration(seconds: 2),
      //   () {
      //     Navigator.of(this.context).pushNamedAndRemoveUntil(
      //       '/Haldua',
      //       ModalRoute.withName('/Haldua'),
      //     );
      //   },
      // );
      // StatusAlert.show(
      //   this.context,
      //   duration: Duration(seconds: 2),
      //   title: 'Sukses',
      //   subtitle: 'Kegiatan berhasil di upload',
      //   configuration: IconConfiguration(icon: Icons.done),
      // );
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
                  "Upload kegiatan sukses",
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
      await Future.delayed(
        Duration(seconds: 2),
        () {
          Navigator.pop(this.context);
        },
      );
    } else {
      print("Upload Failed");

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
                "Kegiatan gagal di upload",
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
      );
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
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          'INPUT KEGIATAN',
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
      body: ListView(
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
//ANCHOR input judul kegiatan
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: decorationTextField,
                    // height: 60.0,
                    child: TextFormField(
                      maxLines: null,
                      controller: cJudul,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        border: decorationBorder,
                        // contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: Icon(
                          Icons.text_fields,
                          color: Colors.grey[600],
                        ),
                        hintText: 'Judul Kegiatan',
                        hintStyle: decorationHint,
                      ),
                      // validator: (value) {
                      //   if (value.isEmpty) {
                      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //       content: Text(
                      //         'Judul wajib di isi',
                      //         style: TextStyle(color: Colors.white),
                      //       ),
                      //       backgroundColor: Colors.orange[700],
                      //       action: SnackBarAction(
                      //         label: 'ULANGI',
                      //         textColor: Colors.white,
                      //         onPressed: () {
                      //           print('ULANGI snackbar');
                      //         },
                      //       ),
                      //     ));
                      //     // scaffoldKey.currentState.showSnackBar(snackBar);
                      //   }
                      //   return null;
                      // },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
//ANCHOR input tempat kegiatan
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: decorationTextField,
                    // height: 60.0,
                    child: TextFormField(
                      maxLines: null,
                      controller: cTempatKegiatan,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        border: decorationBorder,
                        // contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: Icon(
                          Icons.place,
                          color: Colors.grey,
                        ),
                        hintText: 'Tempat Kegiatan',
                        hintStyle: decorationHint,
                      ),
                      // validator: (value) {
                      //   if (value.isEmpty) {
                      //     //return '               ! Judul harus diisi !';
                      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //       content: Text(
                      //         'Tempat wajib di isi',
                      //         style: TextStyle(color: Colors.white),
                      //       ),
                      //       backgroundColor: Colors.orange[700],
                      //       action: SnackBarAction(
                      //         label: 'ULANGI',
                      //         textColor: Colors.white,
                      //         onPressed: () {
                      //           print('ULANGI snackbar');
                      //         },
                      //       ),
                      //     ));
                      //     // scaffoldKey.currentState.showSnackBar(snackBar);
                      //   }
                      //   return null;
                      // },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
//ANCHOR input uraian kegiatan
                  Container(
                      alignment: Alignment.topLeft,
                      decoration: decorationTextField,
                      // height: 200.0,
                      child: HtmlEditor(
                        controller: controller2,
                        htmlEditorOptions: HtmlEditorOptions(
                          hint: 'Uraian kegiatan',
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
                      //   controller: cIsi,
                      //   maxLines: null,
                      //   keyboardType: TextInputType.emailAddress,
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
                      //   // validator: (value) {
                      //   //   if (value.isEmpty) {
                      //   //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //   //       content: Text(
                      //   //         'Uraian wajib di isi',
                      //   //         style: TextStyle(color: Colors.white),
                      //   //       ),
                      //   //       backgroundColor: Colors.orange[700],
                      //   //       action: SnackBarAction(
                      //   //         label: 'ULANGI',
                      //   //         textColor: Colors.white,
                      //   //         onPressed: () {
                      //   //           print('ULANGI snackbar');
                      //   //         },
                      //   //       ),
                      //   //     ));
                      //   //     // scaffoldKey.currentState.showSnackBar(snackBar);
                      //   //   }
                      //   //   return null;
                      //   // },
                      // ),
                      ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
//ANCHOR input tanggal kegiatan
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: decorationTextField,
                    // height: 60.0,
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
                        border: decorationBorder,
                        //contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: Icon(
                          Icons.date_range,
                          color: Colors.grey[600],
                        ),
                        hintText: 'Pilih tanggal',
                        hintStyle: decorationHint,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
//ANCHOR input link youtube
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: decorationTextField,
                    // height: 60.0,
                    child: TextFormField(
                      controller: cYoutube,
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
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
//ANCHOR input gambar kegiatan

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
                  //       ? Text("Gambar belum di pilih !")
                  //       : Image.file(_image),
                  // ),
                  // Center(
                  //   child: Row(
                  //     children: <Widget>[
                  //       ElevatedButton(
                  //         child: Icon(
                  //           Icons.image,
                  //           color: Colors.white,
                  //         ),
                  //         onPressed: getImageGallery,
                  //         style: ElevatedButton.styleFrom(
                  //           // padding: EdgeInsets.all(15.0),
                  //           elevation: 0, backgroundColor: Colors.red,
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius:
                  //                 BorderRadius.circular(10), // <-- Radius
                  //           ),
                  //         ),
                  //         // color: Color(0xFFee002d),
                  //         // shape: RoundedRectangleBorder(
                  //         //   borderRadius: BorderRadius.circular(17.0),
                  //         // ),
                  //       ),
                  //       Padding(
                  //         padding: EdgeInsets.only(left: 5.0),
                  //       ),
                  //       ElevatedButton(
                  //         child: Icon(
                  //           Icons.camera_alt,
                  //           color: Colors.white,
                  //         ),
                  //         onPressed: getImageCamera,
                  //         style: ElevatedButton.styleFrom(
                  //           // padding: EdgeInsets.all(15.0),
                  //           elevation: 0, backgroundColor: Colors.red,
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius:
                  //                 BorderRadius.circular(10), // <-- Radius
                  //           ),
                  //         ),
                  //         // color: Color(0xFFee002d),
                  //         // shape: RoundedRectangleBorder(
                  //         //   borderRadius: BorderRadius.circular(17.0),
                  //         // ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  _loadingkegiatan
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
                              "UPLOAD KEGIATAN",
                              style: const TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              String? txt = await controller2.getText();
                              setState(() {
                                textToDisplay = txt;
                              });
                              if (cJudul.text.isEmpty || cJudul.text == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    'Judul wajib di isi',
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
                              } else if (cTempatKegiatan.text.isEmpty ||
                                  cTempatKegiatan.text == '') {
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
                              } else if (cTanggal.text.isEmpty ||
                                  cTanggal.text == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                                      }),
                                ));
                                // scaffoldKey.currentState.showSnackBar(snackBar);
                              } else if (_selectedFile == null) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                                      }),
                                ));
                                // scaffoldKey.currentState.showSnackBar(snackBar);
                              } else {
                                upload(_selectedFile!);
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
