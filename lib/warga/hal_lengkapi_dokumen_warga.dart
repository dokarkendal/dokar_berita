import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../style/styleset.dart';
// api to json

class HalLengkapiDokumenWarga extends StatefulWidget {
  const HalLengkapiDokumenWarga({super.key});

  @override
  State<HalLengkapiDokumenWarga> createState() =>
      _HalLengkapiDokumenWargaState();
}

class _HalLengkapiDokumenWargaState extends State<HalLengkapiDokumenWarga> {
  bool loadingdata = false;
  File? _selectedFile;
  bool _loading = false;
  bool _inProcess = false;
  List dokumenAPI = [];
  var _pilihDokumen;
  Future<void> getKelamin() async {
    final response = await http.get(
      Uri.parse(
          "http://dokar.kendalkab.go.id/webservice/android/dashbord/jenisdatadukung"),
    );
    var getdokumenJSON = json.decode(response.body);
    if (mounted) {
      setState(() {
        dokumenAPI = getdokumenJSON;
        print(getdokumenJSON);
      });
    }
  }

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

  // Future upload(File _selectedFile) async {
  //   MediaQueryData mediaQueryData = MediaQuery.of(this.context);
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   setState(
  //     () {
  //       _loading = true;
  //     },
  //   );
  //   Future.delayed(
  //     const Duration(seconds: 2),
  //     () async {
  //       var stream = http.ByteStream(
  //         // ignore: deprecated_member_use
  //         DelegatingStream.typed(
  //           _selectedFile.openRead(),
  //         ),
  //       );
  //       var length = await _selectedFile.length();
  //       var uri = Uri.parse(
  //           "https://dokar.kendalkab.go.id/webservice/android/account/UploadDatadukung");
  //       var request = http.MultipartRequest("POST", uri);
  //       var multipartFile = http.MultipartFile(
  //         "file",
  //         stream,
  //         length,
  //         filename: basename(_selectedFile.path),
  //       );
  //       request.fields['uid'] = pref.getString("uid")!;
  //       request.fields['keterangan'] = _pilihDokumen;
  //       request.files.add(multipartFile);
  //       var response = await request.send();
  //       if (response.statusCode == 200) {
  //         if (kDebugMode) {
  //           print(_selectedFile);
  //           print("Image Uploaded");
  //         }
  //         setState(
  //           () {
  //             _loading = false;
  //           },
  //         );
  //         ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
  //           duration: const Duration(seconds: 2),
  //           elevation: 6.0,
  //           behavior: SnackBarBehavior.floating,
  //           content: Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               const Icon(
  //                 Icons.check_circle,
  //                 size: 30,
  //                 color: Colors.white,
  //               ),
  //               SizedBox(
  //                 width: mediaQueryData.size.width * 0.01,
  //               ),
  //               const Text(
  //                 'Dokumen berhasil diunggah',
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ],
  //           ),
  //           backgroundColor: Colors.green,
  //           action: SnackBarAction(
  //             label: 'OK',
  //             textColor: Colors.white,
  //             onPressed: () {
  //               Navigator.pop(this.context);
  //               // Navigator.pushReplacementNamed(this.context, '/ListDokter');
  //               if (kDebugMode) {
  //                 print('Berhasil');
  //               }
  //             },
  //           ),
  //         ));
  //         // ignore: deprecated_member_use
  //         // scaffoldKey.currentState?.showSnackBar(snackBar);
  //         clearimage();
  //         setState(() {
  //           _pilihDokumen = null;
  //         });
  //       } else {
  //         setState(
  //           () {
  //             _loading = false;
  //           },
  //         );
  //         ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
  //           duration: const Duration(seconds: 2),
  //           elevation: 6.0,
  //           behavior: SnackBarBehavior.floating,
  //           content: Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               const Icon(
  //                 Icons.error,
  //                 size: 30,
  //                 color: Colors.white,
  //               ),
  //               SizedBox(
  //                 width: mediaQueryData.size.width * 0.01,
  //               ),
  //               const Text(
  //                 'Upload gagal',
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ],
  //           ),
  //           backgroundColor: Colors.red,
  //           action: SnackBarAction(
  //             label: 'GAGAL',
  //             textColor: Colors.white,
  //             onPressed: () {
  //               if (kDebugMode) {
  //                 print('Gagal');
  //               }
  //             },
  //           ),
  //         ));
  //         // ignore: deprecated_member_use
  //         // scaffoldKey.currentState?.showSnackBar(snackBar);
  //         if (kDebugMode) {
  //           print("Upload Failed");
  //         }
  //       }
  //       response.stream.transform(utf8.decoder).listen(
  //         (value) {
  //           if (kDebugMode) {
  //             print(value);
  //           }
  //         },
  //       );
  //     },
  //   );
  // }
  Future<void> _uploadData() async {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
    });
    try {
      // Hapus penundaan buatan (Future.delayed)
      final response = await ApiService.uploadDataDukungWarga(
        _selectedFile!,
        pref.getString("uid")!,
        _pilihDokumen!,
      );

      if (response != null && response.statusCode == 200) {
        // Tangani respons sukses
        print("Image Uploaded");
        final responseBody = await response.stream.bytesToString();
        try {
          final decodedResponse = jsonDecode(responseBody);
          final notifMessage = decodedResponse['Notif'] ?? 'Upload Berhasil';
          print(decodedResponse);
          print(notifMessage);

          ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              elevation: 6.0,
              behavior: SnackBarBehavior.floating,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: mediaQueryData.size.width * 0.01,
                  ),
                  Text(
                    notifMessage,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pop(this.context);
                  // Navigator.pushReplacementNamed(context, '/ListDokter');
                  if (kDebugMode) {
                    print('Berhasil');
                  }
                },
              ),
            ),
          );
          clearimage();
          setState(() {
            _pilihDokumen = null;
          });
        } catch (e) {
          print("Error decoding JSON: $e");
          ScaffoldMessenger.of(this.context).showSnackBar(
            const SnackBar(
              content: Text("Terjadi kesalahan pada format data"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Tangani respons error dari API
        final errorResponse =
            await response?.stream.bytesToString(); // Mengambil body error
        print('Error from API: ${response?.statusCode} $errorResponse');

        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            content: Text(
                'Upload gagal: ${response?.statusCode ?? 'Unknown Error'}. $errorResponse'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Tangani error koneksi atau error lain di sisi client
      print('Client-side error: $e');
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat upload: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    getKelamin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appbarIcon, //change your color here
        ),
        title: Text(
          'DOKUMEN',
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
      body: WillPopScope(
        onWillPop: () async {
          // Prevents the user from using the back button during progress
          return !_loading;
        },
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(children: [
                _peringatanpengajuan(),
                _paddingTop2(),
                _paddingTop2(),
                _formJenisDokumen(),
                _paddingTop2(),
                _paddingTop2(),
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
                        ? const Center()
                        // Container(
                        //     color: Colors.white,
                        //     // height: MediaQuery.of(context).size.height * 0.95,
                        //     child: const Center(
                        //       child: CircularProgressIndicator(),
                        //     ),
                        //   )
                        : const Center()
                  ],
                ),
                _paddingTop2(),
                _paddingTop2(),
                _paddingTop2(),
                _loginButton(),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return _loading
        ? Column(
            children: [
              SizedBox(
                width: mediaQueryData.size.width,
                height: mediaQueryData.size.height * 0.07,
                child: ElevatedButton(
                  onPressed: () async {
                    // upload(_selectedFile!);
                  },
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
        : Column(
            children: [
              SizedBox(
                width: mediaQueryData.size.width,
                height: mediaQueryData.size.height * 0.07,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_pilihDokumen == null) {
                      ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 2),
                        elevation: 6.0,
                        behavior: SnackBarBehavior.floating,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.error,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: mediaQueryData.size.width * 0.01,
                            ),
                            const Text(
                              'Pilih Jenis Dokumen',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.red,
                        action: SnackBarAction(
                          label: 'GAGAL',
                          textColor: Colors.white,
                          onPressed: () {
                            if (kDebugMode) {
                              print('Gagal');
                            }
                          },
                        ),
                      ));
                    } else if (_selectedFile == null) {
                      ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 2),
                        elevation: 6.0,
                        behavior: SnackBarBehavior.floating,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.error,
                              size: 28,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: mediaQueryData.size.width * 0.01,
                            ),
                            const Text(
                              'Pilih Gambar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.red,
                        action: SnackBarAction(
                          label: 'GAGAL',
                          textColor: Colors.white,
                          onPressed: () {
                            if (kDebugMode) {
                              print('Gagal');
                            }
                          },
                        ),
                      ));
                    } else {
                      _uploadData();
                    }
                  },
                  child: const Text(
                    'SIMPAN',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
          );
  }

  Widget _peringatanpengajuan() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return Container(
      padding: EdgeInsets.all(15.0),
      height: mediaQueryData.size.height * 0.13,
      decoration: BoxDecoration(
        color: Colors.lightBlue[600],
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0.0, 5.0),
              blurRadius: 7.0),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Dokumen Wajib Pengajuan",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
              )
            ],
          ),
          _paddingTop2(),
          Text(
            "1. KTP \n2. Foto identitas",
            style: TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _paddingTop2() {
    return Padding(
      padding:
          EdgeInsets.only(top: MediaQuery.of(this.context).size.height * 0.01),
    );
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

  Widget _formJenisDokumen() {
    return Container(
      width: MediaQuery.of(this.context).size.width,
      child: Column(
        children: <Widget>[
          Container(
            decoration: decorationTextField,
            child: DropdownButtonFormField(
              isDense: true,
              decoration: InputDecoration(
                prefixIcon:
                    Icon(Icons.document_scanner, color: Colors.brown[800]),
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[400],
                ),
              ),
              hint: Text('Pilih Jenis Dokumen'),
              isExpanded: true,
              items: dokumenAPI.map(
                (item0) {
                  return DropdownMenuItem(
                    child: Text(item0['nama'].toString()),
                    value: item0['id'].toString(),
                  );
                },
              ).toList(),
              onChanged: (val) async {
                setState(() {
                  _pilihDokumen = val as String;
                  print("KLIK");
                  print(_pilihDokumen);
                });

                // Wait for getKecamatan() to complete before rebuilding the widget
              },
              value: _pilihDokumen,
            ),
          )
        ],
      ),
    );
  }
}
