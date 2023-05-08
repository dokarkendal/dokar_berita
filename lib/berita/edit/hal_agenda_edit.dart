//ANCHOR package agenda edit
import 'dart:async'; // api syn
import 'dart:convert'; // api to json
import 'dart:io';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:async/async.dart'; //upload gambar
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; //akses galeri dan camera
import 'package:http/http.dart' as http; //api
// import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart'; //upload gambar path
import 'package:shared_preferences/shared_preferences.dart'; //save session
// import 'package:path_provider/path_provider.dart';
// import 'package:image/image.dart' as Img;
// import 'dart:math' as Math;
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
      {required this.cJudul,
      required this.cPenyelenggara,
      required this.cIsi,
      required this.cTanggalmulai,
      required this.cTanggalselesai,
      required this.cJammulai,
      required this.cJamselesai,
      required this.cGambar,
      required this.cIdAgenda});
  @override
  FormAgendaEditState createState() => FormAgendaEditState();
}

class FormAgendaEditState extends State<FormAgendaEdit> {
//ANCHOR variable agenda edit
  // File _image;
  String username = "";
  var _mySelection;
  bool _loadingagenda = false;
  List kategoriAdmin = [];
  final format = DateFormat("yyyy-MM-dd");
  final formatTime = DateFormat("HH:mm");
  final formKey = GlobalKey<FormState>();
  // bool _isInAsyncCall = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//ANCHOR controller agenda edit
  TextEditingController cJudul = TextEditingController();
  TextEditingController cPenyelenggara = TextEditingController();
  // TextEditingController cIsi = TextEditingController();
  TextEditingController cTanggalmulai = TextEditingController();
  TextEditingController cTanggalselesai = TextEditingController();
  TextEditingController cJammulai = TextEditingController();
  TextEditingController cJamselesai = TextEditingController();
  TextEditingController cIdAgenda = TextEditingController();
  TextEditingController cGambar = TextEditingController();
  late HtmlEditorController controller2;
  String? textToDisplay;
//ANCHOR input image size flutter agenda edit
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
        // aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
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

  // Future getImageGallery() async {
  //   // ignore: deprecated_member_use
  //   var imageFile = await ImagePicker.pickImage(
  //     source: ImageSource.gallery,
  //   );

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

//ANCHOR session agenda edit
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
    cJudul = TextEditingController(text: "${widget.cJudul}");
    cPenyelenggara = TextEditingController(text: "${widget.cPenyelenggara}");
    // cIsi = TextEditingController(text: "${widget.cIsi}");
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
  Future uploadGambarKegiatanEdit(File _selectedFile) async {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    setState(() {
      _loadingagenda = true;
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
        "http://dokar.kendalkab.go.id/webservice/android/agenda/editevent");

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile("image", stream, length,
        filename: basename(_selectedFile.path));
    request.fields['judul'] = cJudul.text;
    request.fields['penyelenggara'] = cPenyelenggara.text;
    request.fields['isi'] = textToDisplay ?? '';
    request.fields['tgl_mulai'] = cTanggalmulai.text;
    request.fields['tgl_selesai'] = cTanggalselesai.text;
    request.fields['jam_mulai'] = cJammulai.text;
    request.fields['jam_selesai'] = cJamselesai.text;
    request.fields['gambar_agenda'] = cGambar.text;
    request.fields['id_desa'] = pref.getString("IdDesa")!;
    request.fields['id_agenda'] = cIdAgenda.text;

    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Uploaded Succes");
      print(response);
      setState(
        () {
          _loadingagenda = false;
        },
      );
      // Navigator.of(this.context).pushNamedAndRemoveUntil(
      //     '/HalEventList', ModalRoute.withName('/EditSemua'));
      // StatusAlert.show(
      //   this.context,
      //   duration: Duration(seconds: 2),
      //   title: 'Sukses',
      //   subtitle: 'Event Berhasil di upload',
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
                  "Edit Agenda Sukses",
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
      // Navigator.pop(this.context);
      Future.delayed(Duration(seconds: 1), () async {
        Navigator.of(this.context).pushNamedAndRemoveUntil(
            '/HalEventList', ModalRoute.withName('/EditSemua'));
      });
      // Navigator.of(this.context).pushNamedAndRemoveUntil(
      //     '/HalEventList', ModalRoute.withName('/EditSemua'));
    } else {
      print("Upload Failed");
      setState(
        () {
          _loadingagenda = false;
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
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    setState(() {
      _loadingagenda = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (_mySelection == null) {
      final response = await http.post(
        Uri.parse(
            "http://dokar.kendalkab.go.id/webservice/android/agenda/editevent"),
        body: {
          "judul": cJudul.text,
          "penyelenggara": cPenyelenggara.text,
          "isi": textToDisplay ?? '',
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
          _loadingagenda = false;
        });
        // Navigator.of(this.context).pushNamedAndRemoveUntil(
        //     '/HalEventList', ModalRoute.withName('/EditSemua'));
        // StatusAlert.show(
        //   this.context,
        //   duration: Duration(seconds: 2),
        //   title: 'Sukses',
        //   subtitle: 'Event Berhasil di upload',
        //   configuration: IconConfiguration(icon: Icons.done),
        // );
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            elevation: 6.0,
            backgroundColor: Colors.blue,
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
                    "Edit Agenda Sukses",
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
        // Navigator.pop(this.context);
        Future.delayed(Duration(seconds: 1), () async {
          Navigator.of(this.context).pushNamedAndRemoveUntil(
              '/HalEventList', ModalRoute.withName('/EditSemua'));
        });
      } else {
        print("Upload Failed.");
        setState(() {
          _loadingagenda = false;
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
                          color: Colors.grey,
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
                          color: Colors.grey,
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
                      child: HtmlEditor(
                        controller: controller2,
                        htmlEditorOptions: HtmlEditorOptions(
                          mobileLongPressDuration: Duration.zero,
                          hint: 'Uraian Kegiatan',
                          initialText: widget.cIsi,
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
                      //     //contentPadding: EdgeInsets.only(top: 14.0),
                      //     prefixIcon: Icon(
                      //       Icons.library_books,
                      //       color: Colors.grey,
                      //     ),
                      //     hintText: 'Uraian Agenda',
                      //     hintStyle: decorationHint,
                      //   ),
                      // ),
                      ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
//ANCHOR  tanggal agenda edit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: decorationTextField,
                        width: mediaQueryData.size.width * 0.46,
                        // height: 60.0,
                        child: DateTimeField(
                          controller: cTanggalmulai,
                          format: format,
                          style: TextStyle(
                            fontSize: 12,
                          ),
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
                              color: Colors.grey,
                            ),
                            hintText: 'Tanggal Mulai',
                            hintStyle: decorationHint,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                      ),
                      //ANCHOR agenda tanggal edit
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: decorationTextField,
                        width: mediaQueryData.size.width * 0.46,
                        // height: 60.0,
                        child: DateTimeField(
                          controller: cTanggalselesai,
                          format: format,
                          style: TextStyle(
                            fontSize: 12,
                          ),
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
                              color: Colors.grey,
                            ),
                            hintText: 'Tanggal Selesai',
                            hintStyle: decorationHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 10.0),
                  // ),

                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
//ANCHOR input Jam selesai agenda edit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: decorationTextField,
                        // height: 60.0,
                        width: mediaQueryData.size.width * 0.46,
                        child: DateTimeField(
                          controller: cJammulai,
                          format: formatTime,
                          style: TextStyle(
                            fontSize: 13,
                          ),
                          onShowPicker: (context, currentValue) async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                              builder: (context, child) => MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child ?? const SizedBox(),
                              ),
                            );
                            return DateTimeField.convert(time);
                          },
                          decoration: InputDecoration(
                            border: decorationBorder,
                            //contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              Icons.access_time,
                              color: Colors.grey,
                            ),
                            hintText: 'Jam Mulai',
                            hintStyle: decorationHint,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                      ),
                      //ANCHOR input Jam selesai agenda edit
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: decorationTextField,
                        width: mediaQueryData.size.width * 0.46,
                        // height: 60.0,
                        child: DateTimeField(
                          controller: cJamselesai,
                          format: formatTime,
                          style: TextStyle(
                            fontSize: 13,
                          ),
                          onShowPicker: (context, currentValue) async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                              builder: (context, child) => MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child ?? const SizedBox(),
                              ),
                            );
                            return DateTimeField.convert(time);
                          },
                          decoration: InputDecoration(
                            border: decorationBorder,
                            prefixIcon: Icon(
                              Icons.access_time,
                              color: Colors.grey,
                            ),
                            hintText: 'Jam Selesai',
                            hintStyle: decorationHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),

//NOTE gambar agenda edit
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
                  //       ? Text("Pilih gambar.")
                  //       : Image.file(_image),
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
                  //       // color: Color(0xFFee002d),
                  //       // shape: RoundedRectangleBorder(
                  //       //   borderRadius: BorderRadius.circular(17.0),
                  //       // ),
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
                  //       // color: Color(0xFFee002d),
                  //       // shape: RoundedRectangleBorder(
                  //       //   borderRadius: BorderRadius.circular(17.0),
                  //       // ),
                  //     ),
                  //   ],
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  _loadingagenda
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
                              Icons.save,
                              color: Colors.white,
                            ),
                            label: Text(
                              "EDIT AGENDA",
                              style: TextStyle(
                                color: subtitle,
                              ),
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
                              } else if (cPenyelenggara.text.isEmpty ||
                                  cPenyelenggara.text == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                                    },
                                  ),
                                ));
                                // scaffoldKey.currentState.showSnackBar(snackBar);
                              } else if (cTanggalmulai.text.isEmpty ||
                                  cTanggalmulai.text == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                              } else if (cTanggalselesai.text.isEmpty ||
                                  cTanggalselesai.text == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                              } else if (cJammulai.text.isEmpty ||
                                  cJammulai.text == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                              } else if (cJamselesai.text.isEmpty ||
                                  cJamselesai.text == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                  fontSize: 13, fontWeight: FontWeight.bold, color: subtitle),
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
                  fontSize: 13, fontWeight: FontWeight.bold, color: subtitle),
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
