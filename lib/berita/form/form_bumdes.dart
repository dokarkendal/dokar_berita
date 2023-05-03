//ANCHOR package input form Bumdes
import 'dart:async'; //NOTE  api syn
import 'dart:convert'; //NOTE api to json
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
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

//ANCHOR class Form Bumdes
class FormBumdes extends StatefulWidget {
  @override
  FormBumdesState createState() => FormBumdesState();
}

class FormBumdesState extends State<FormBumdes> {
//ANCHOR variable bumde
  // File _image;
  String username = "";
  List kategoriAdmin = [];
  bool _loadingbumdes = false;
  final formKey = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MM-dd");
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var alertStyle = AlertStyle(
    isCloseButton: false,
  );
  bool _inProcess = false;
  File? _selectedFile;

//ANCHOR controller bumdes
  TextEditingController cYoutube = TextEditingController();
  TextEditingController cJudul = TextEditingController();
  TextEditingController cTempatBumdes = TextEditingController();
  TextEditingController cIsi = TextEditingController();
  TextEditingController cUsername = TextEditingController();
  TextEditingController cStatus = TextEditingController();

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
        // aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
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

// //ANCHOR akses gallery bumdes
//   Future getImageGallery() async {
//     // ignore: deprecated_member_use
//     var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
//     if (imageFile == null) {
//       return null;
//     }
//     final tempDir = await getTemporaryDirectory();
//     final path = tempDir.path;

//     int rand = Math.Random().nextInt(100000);

//     Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
//     Img.Image smallerImg = Img.copyResize(image, width: 1144, height: 792);

//     var compressImg = File("$path/image_$rand.jpg")
//       ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 1000));

//     setState(
//       () {
//         _image = compressImg;
//       },
//     );
//   }

//   Future getImageCamera() async {
//     // ignore: deprecated_member_use
//     var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

//     final tempDir = await getTemporaryDirectory();
//     final path = tempDir.path;

//     int rand = Math.Random().nextInt(100000);

//     Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
//     Img.Image smallerImg = Img.copyResize(image, width: 1144, height: 792);

//     var compressImg = File("$path/image_$rand.jpg")
//       ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 1000));

//     setState(
//       () {
//         _image = compressImg;
//       },
//     );
//   }

//ANCHOR cek session admin bumdes
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
    super.initState();
  }

//ANCHOR api gambar post bumdes
  Future uploadBumdes(File _selectedFile) async {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    setState(() {
      _loadingbumdes = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var stream = http.ByteStream(
      // ignore: deprecated_member_use
      DelegatingStream.typed(
        _selectedFile.openRead(),
      ),
    );
    var length = await _selectedFile.length();
    var uri = Uri.parse(
        "http://dokar.kendalkab.go.id/webservice/android/bumdes/post");

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile("image", stream, length,
        filename: basename(_selectedFile.path));
    request.fields['video'] = cYoutube.text;
    request.fields['judul'] = cJudul.text;
    request.fields['tempat'] = cTempatBumdes.text;
    request.fields['isi'] = cIsi.text;
    request.fields['id_desa'] = pref.getString("IdDesa")!;
    request.fields['username'] = pref.getString("userAdmin")!;
    request.fields['status'] = pref.getString("status")!;
    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image Uploaded");
      setState(
        () {
          _loadingbumdes = false;
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
      //   subtitle: 'Bumdes berhasil di upload',
      //   configuration: IconConfiguration(icon: Icons.done),
      // );
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
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
                  "Upload bumdes sukses",
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
      Navigator.pop(this.context);
    } else {
      print("Upload Failed");
      SnackBar(
        duration: const Duration(seconds: 3),
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
                "Bumdes gagal di upload",
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

//ANCHOR body form bumdes
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
          'INPUT BUMDES',
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
//ANCHOR input judul Bumdes
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: decorationTextField,
                    // height: 60.0,
                    child: TextFormField(
                      controller: cJudul,
                      maxLines: null,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
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
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
//ANCHOR input tempat Bumdes
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: decorationTextField,
                    // height: 60.0,
                    child: TextFormField(
                      controller: cTempatBumdes,
                      maxLines: null,
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
                        hintText: 'Tempat Bumdes',
                        hintStyle: decorationHint,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
//ANCHOR input uraian Bumdes
                  Container(
                    alignment: Alignment.topLeft,
                    decoration: decorationTextField,
                    // height: 200.0,
                    child: TextFormField(
                      controller: cIsi,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        border: decorationBorder,
                        contentPadding: EdgeInsets.symmetric(vertical: 50.0),
                        prefixIcon: Icon(
                          Icons.library_books,
                          color: Colors.grey,
                        ),
                        hintText: 'Uraian Bumdes',
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
                        hintText: 'Embed video youtube',
                        hintStyle: decorationHint,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
//ANCHOR input gambar
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
                  //         // color: Color(0xFFee002d),
                  //         // shape: RoundedRectangleBorder(
                  //         //   borderRadius: BorderRadius.circular(17.0),
                  //         // ),
                  //         style: ElevatedButton.styleFrom(
                  //           // padding: EdgeInsets.all(15.0),
                  //           elevation: 0, backgroundColor: Colors.red,
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius:
                  //                 BorderRadius.circular(10), // <-- Radius
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  _loadingbumdes
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
                              "UPLOAD BUMDES",
                              style: const TextStyle(color: subtitle),
                            ),
                            onPressed: () async {
                              if (cJudul.text.isEmpty || cJudul.text == '') {
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
                              } else if (cTempatBumdes.text.isEmpty ||
                                  cTempatBumdes.text == '') {
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
                              } else if (cIsi.text.isEmpty || cIsi.text == '') {
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
                                uploadBumdes(_selectedFile!);
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
