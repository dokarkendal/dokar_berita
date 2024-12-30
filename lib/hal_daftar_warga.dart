import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async'; //NOTE  api syn
import 'dart:convert'; //NOTE api to json
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'config/api_config.dart';
import 'style/styleset.dart';

class HalLoginWarga extends StatefulWidget {
  const HalLoginWarga({Key? key}) : super(key: key);

  @override
  State<HalLoginWarga> createState() => _HalLoginWargaState();
}

class _HalLoginWargaState extends State<HalLoginWarga> {
  //NOTE Boolean
  // ignore: unused_field
  bool _isLoggedIn = false;
  // bool _isInAsyncCall = false;
  bool _obscureText = true;
  bool loadingdaftar = false;
  var _pilihKota;
  var _pilihKecamatan;
  var _pilihDesa;
  List namaKota = [];
  List namaKecamatan = [];
  List namaDesa = [];

  // final _formKey = GlobalKey<FormState>();

  // void _toggle() {
  //   setState(
  //     () {
  //       _obscureText = !_obscureText;
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    this.getKota();
  }

  Future<void> daftarWarga() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(
      () {
        loadingdaftar = true;
      },
    );
    Future.delayed(Duration(seconds: 2), () async {
      final response = await http.post(
          Uri.parse(
              "${ApiConfig.baseUrl}/webservice/android/account/Daftarwarganew/"),
          headers: ApiConfig.headers,
          body: {
            "nik": nik.text,
            "nama": nama.text,
            "email": email.text,
            "hp": hp.text,
            "username": username.text,
            "password": password.text,
            "kota": _pilihKota,
            "kecamatan": _pilihKecamatan,
            "desa": _pilihDesa,
          });
      var daftarWargaJSON = json.decode(response.body);
      if (daftarWargaJSON['Status'] == 'Sukses') {
        // SharedPreferences pref = await SharedPreferences.getInstance();
        // pref.setBool("_isLoggedIn", true);
        setState(() {
          loadingdaftar = false;
          Navigator.pop(context);
        });
        Clipboard.setData(
          ClipboardData(text: "NIK: ${nik.text}\nPassword: ${password.text}"),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              daftarWargaJSON['Notif'],
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                print('ULANGI snackbar');
              },
            ),
          ),
        );
        print(daftarWargaJSON);
        // Navigator.pop(context);
      } else if (daftarWargaJSON['Status'] == 'Gagal') {
        // SharedPreferences pref = await SharedPreferences.getInstance();
        // pref.setBool("_isLoggedIn", false);
        setState(() {
          loadingdaftar = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              daftarWargaJSON['Notif'],
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'ULANGI',
              textColor: Colors.white,
              onPressed: () {
                print('ULANGI snackbar');
              },
            ),
          ),
        );
        print(daftarWargaJSON);
        // Navigator.pop(context);
      }
    });
  }

  Future<void> getKota() async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/webservice/android/dashbord/kabupaten"),
      );

      if (response.statusCode == 200) {
        var getkota = json.decode(response.body);
        if (mounted) {
          setState(() {
            namaKota = getkota ?? [];
            print(getkota);
          });
        }
      } else {
        // Tangani error HTTP
        print('Gagal memuat data kota. Status code: ${response.statusCode}');
        if (mounted) {
          setState(() {
            namaKota = [];
          });
        }
      }
    } catch (e) {
      print('Error saat mengambil data kota: $e');
      if (mounted) {
        setState(() {
          namaKota = [];
        });
      }
    }
  }

  Future<void> getKecamatan() async {
    // Pastikan kota sudah dipilih
    if (_pilihKota == null) {
      print('Pilih kota terlebih dahulu');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConfig.baseUrl}/webservice/android/dashbord/KecamatanByKab/$_pilihKota'),
      );

      if (response.statusCode == 200) {
        var getKecamatan = json.decode(response.body);

        if (mounted) {
          setState(() {
            // Reset pilihan kecamatan dan desa
            _pilihKecamatan = null;
            _pilihDesa = null;
            namaDesa = [];

            // Set nama kecamatan
            namaKecamatan = getKecamatan is List ? getKecamatan : [];
            print(namaKecamatan);
          });
        }
      } else {
        print(
            'Gagal memuat data kecamatan. Status code: ${response.statusCode}');
        if (mounted) {
          setState(() {
            namaKecamatan = [];
            _pilihKecamatan = null;
          });
        }
      }
    } catch (e) {
      print('Error saat mengambil data kecamatan: $e');
      if (mounted) {
        setState(() {
          namaKecamatan = [];
          _pilihKecamatan = null;
        });
      }
    }
  }

  Future<void> getDesa() async {
    // Pastikan kecamatan sudah dipilih
    if (_pilihKecamatan == null) {
      print('Pilih kecamatan terlebih dahulu');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            "${ApiConfig.baseUrl}/webservice/android/dashbord/desa/$_pilihKecamatan"),
      );

      if (response.statusCode == 200) {
        var getDesa = json.decode(response.body);

        if (mounted) {
          setState(() {
            // Reset pilihan desa
            _pilihDesa = null;

            // Set nama desa
            namaDesa = getDesa is List ? getDesa : [];
            print(namaDesa);
          });
        }
      } else {
        print('Gagal memuat data desa. Status code: ${response.statusCode}');
        if (mounted) {
          setState(() {
            namaDesa = [];
            _pilihDesa = null;
          });
        }
      }
    } catch (e) {
      print('Error saat mengambil data desa: $e');
      if (mounted) {
        setState(() {
          namaDesa = [];
          _pilihDesa = null;
        });
      }
    }
  }

  // Future _login() async {
  //   setState(
  //     () {
  //       _isInAsyncCall = true;
  //     },
  //   );
  //   Future.delayed(Duration(seconds: 1), () async {});
  // }

//NOTE - Controller
  TextEditingController nik = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController hp = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          // Prevents the user from using the back button during progress
          return !loadingdaftar;
        },
        child: Stack(
          children: [
            _logo(),
            Padding(
              padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.07),
              child: _textjudul(),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[50],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: mediaQueryData.size.height * 0.02,
                  right: mediaQueryData.size.height * 0.02,
                  bottom: mediaQueryData.size.height * 0.02,
                  // top: mediaQueryData.size.height * 0.01,
                ),
                child: Container(
                  child: ListView(
                    children: [
                      _formNIK(),
                      _paddingTop2(),
                      _formNama(),
                      _paddingTop2(),
                      _formHp(),
                      _paddingTop2(),
                      _formEmail(),
                      _paddingTop2(),
                      _formUsername(),
                      _paddingTop2(),
                      _formPassword(),
                      _paddingTop2(),
                      _formKota(),
                      _paddingTop2(),
                      _formKecamatan(),
                      _paddingTop2(),
                      _formDesa(),
                      _paddingTop2(),
                      _paddingTop2(),
                      _tombolDaftar(),
                      _paddingTop2(),
                      _privacy(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tombolDaftar() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return loadingdaftar
        ? Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: mediaQueryData.size.height * 0.07,
                child: ElevatedButton(
                  onPressed: () async {},
                  style: ElevatedButton.styleFrom(
                    // padding: EdgeInsets.all(15.0),
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // <-- Radius
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            height: mediaQueryData.size.height * 0.07,
            child: ElevatedButton(
              onPressed: () async {
                print(nik);
                print(nama);
                print(hp);
                print(email);
                print(username);
                print(password);
                print(namaKota);
                print(namaKecamatan);
                print(namaDesa);
                if (nik.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Nik masih kosong',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                    action: SnackBarAction(
                      label: 'ULANGI',
                      textColor: Colors.white,
                      onPressed: () {
                        print('ULANGI snackbar');
                      },
                    ),
                  ));
                } else if (nama.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Nama masih kosong',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                    action: SnackBarAction(
                      label: 'ULANGI',
                      textColor: Colors.white,
                      onPressed: () {
                        print('ULANGI snackbar');
                      },
                    ),
                  ));
                } else if (hp.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'No Hp masih kosong',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                    action: SnackBarAction(
                      label: 'ULANGI',
                      textColor: Colors.white,
                      onPressed: () {
                        print('ULANGI snackbar');
                      },
                    ),
                  ));
                } else if (email.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Email masih kosong',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                    action: SnackBarAction(
                      label: 'ULANGI',
                      textColor: Colors.white,
                      onPressed: () {
                        print('ULANGI snackbar');
                      },
                    ),
                  ));
                } else if (username.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Username masih kosong',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                    action: SnackBarAction(
                      label: 'ULANGI',
                      textColor: Colors.white,
                      onPressed: () {
                        print('ULANGI snackbar');
                      },
                    ),
                  ));
                } else if (_validatePassword(password.text).isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Password tidak memenuhi kriteria',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                    action: SnackBarAction(
                      label: 'ULANGI',
                      textColor: Colors.white,
                      onPressed: () {
                        print('ULANGI snackbar');
                      },
                    ),
                  ));
                } else if (_pilihKota == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Kota masih kosong',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                    action: SnackBarAction(
                      label: 'ULANGI',
                      textColor: Colors.white,
                      onPressed: () {
                        print('ULANGI snackbar');
                      },
                    ),
                  ));
                } else if (_pilihKecamatan == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Kecamatan masih kosong',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                    action: SnackBarAction(
                      label: 'ULANGI',
                      textColor: Colors.white,
                      onPressed: () {
                        print('ULANGI snackbar');
                      },
                    ),
                  ));
                } else if (_pilihDesa == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Desa masih kosong',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                    action: SnackBarAction(
                      label: 'ULANGI',
                      textColor: Colors.white,
                      onPressed: () {
                        print('ULANGI snackbar');
                      },
                    ),
                  ));
                } else {
                  daftarWarga();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15.0),
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // <-- Radius
                ),
              ),
              child: Text(
                'DAFTAR',
                style: TextStyle(
                  color: Colors.brown[800],
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          );
  }

  Widget _privacy() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Dengan daftar, saya menyetujui"),
          Padding(
            padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.01),
          ),
          GestureDetector(
            onTap: () async {
              //LINK Privacy dokar
              final Uri url =
                  Uri.parse('https://dokar.kendalkab.go.id/privacy');
              if (!await launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              )) {
                throw 'Could not launch $url';
              }
            },
            child: Text(
              "Syarat & Ketentuan",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _paddingTop2() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
    );
  }

  //NOTE - form NIK
  Widget _formNIK() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: nik,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(16),
              ],
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.credit_card_rounded,
                    color: Colors.brown[800],
                  ),
                  hintText: 'NIK',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  counterText: ''),
              // maxLength: 16,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'NIK tidak boleh kosong';
                }
                if (value!.length != 16) {
                  return 'NIK harus memiliki 16 digit';
                }
                return null; // Return null to indicate the input is valid
              },
            ),
          ),
        ],
      ),
    );
  }

  //NOTE - form NIK
  Widget _formNama() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: nama,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.brown[800],
                ),
                hintText: 'Nama',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? validateHp(String? value) {
    if (value?.isEmpty ?? true) {
      return 'No. HP tidak boleh kosong';
    }

    final hpRegex =
        r'^[0-9]{9,13}$'; // Regular expression for Indonesian phone number validation
    final regExp = RegExp(hpRegex);
    if (!regExp.hasMatch(value!)) {
      return 'No. HP tidak valid';
    }

    return null; // Return null to indicate the input is valid
  }

  Widget _formHp() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: hp,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.phone_android,
                  color: Colors.brown[800],
                ),
                hintText: 'No. HP',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validateHp,
            ),
          ),
        ],
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex =
        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$'; // Regular expression for email validation
    final regExp = RegExp(emailRegex);
    if (!regExp.hasMatch(value!)) {
      return 'Email tidak valid';
    }

    return null; // Return null to indicate the input is valid
  }

  Widget _formEmail() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.mail,
                  color: Colors.brown[800],
                ),
                hintText: 'Email',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validateEmail,
            ),
          ),
        ],
      ),
    );
  }

  Widget _formUsername() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: username,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(16),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.brown[800],
                ),
                hintText: 'NIK',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == nik.text) {
                  return null; // Return null to indicate the input is valid
                } else {
                  return 'NIK tidak sama';
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _formPassword() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: password,
              obscureText: _obscureText,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.brown[800],
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                ),
                hintText: 'Password',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
              validator: (value) {
                final errors = _validatePassword(value ?? '');
                return errors.isNotEmpty
                    ? errors.first
                    : null; // Hanya tampilkan error pertama
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _passwordStrength(password.text),
          ),
        ],
      ),
    );
  }

  List<String> _validatePassword(String value) {
    List<String> errors = [];
    if (value.isEmpty) {
      errors.add('Password tidak boleh kosong');
    }
    if (value.length < 8) {
      errors.add('Password minimal 8 karakter');
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      errors.add('Password harus mengandung huruf besar');
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      errors.add('Password harus mengandung huruf kecil');
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      errors.add('Password harus mengandung angka');
    }
    if (!value.contains(RegExp(r'[!@#$%^&*()_+=-{};:"<>,./?~`|]'))) {
      errors.add('Password harus mengandung karakter spesial');
    }
    if (!_checkUniqueChars(value)) {
      errors.add('Password harus mengandung minimal 2 karakter unik');
    }
    return errors;
  }

  bool _checkUniqueChars(String value) {
    // Cek jumlah karakter spesial yang unik
    final uniqueChars =
        value.replaceAll(RegExp(r'[a-zA-Z0-9]'), '').split('').toSet();
    return uniqueChars.length >= 1;
  }

  Widget _passwordStrength(String value) {
    // ignore: unused_local_variable
    final errors = _validatePassword(value);
    final passwordChecks = [
      value.isNotEmpty,
      value.length >= 8,
      value.contains(RegExp(r'[A-Z]')),
      value.contains(RegExp(r'[a-z]')),
      value.contains(RegExp(r'[0-9]')),
      _checkUniqueChars(value),
    ];

    final checkLabels = [
      'Tidak kosong',
      'Min 8 karakter',
      'Huruf besar',
      'Huruf kecil',
      'Mengandung angka',
      'Minimal 1 karakter unik'
    ];

    // Hitung jumlah validasi yang lolos
    final passedChecks = passwordChecks.where((check) => check).length;

    // Tentukan level kekuatan password
    String strengthText;
    Color strengthColor;
    if (passedChecks <= 4) {
      strengthText = 'Lemah 👀';
      strengthColor = Colors.red;
    } else if (passedChecks <= 5) {
      strengthText = 'Sedang 👍';
      strengthColor = Colors.orange;
    } else {
      strengthText = 'Kuat 🔒';
      strengthColor = Colors.green;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Kekuatan Password: ',
              style: TextStyle(
                color: strengthColor,
              ),
            ),
            Text(
              strengthText,
              style: TextStyle(
                color: strengthColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            passwordChecks.length,
            (index) => Row(
              children: [
                Icon(
                  passwordChecks[index] ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: passwordChecks[index] ? Colors.green : Colors.red,
                ),
                SizedBox(width: 8),
                Text(
                  checkLabels[index],
                  style: TextStyle(
                    color: passwordChecks[index] ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _formKota() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Container(
            decoration: decorationTextField,
            child: DropdownButtonFormField<String>(
              isDense: true,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.location_city,
                  color: Colors.brown[800],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[400],
                ),
              ),
              hint: Text('Pilih Kota'),
              isExpanded: true,
              items: namaKota.map(
                (item) {
                  return DropdownMenuItem(
                    child: Text(item['nama'].toString()),
                    value: item['kode'].toString(),
                  );
                },
              ).toList(),
              onChanged: (val) {
                setState(() {
                  _pilihKota = val;
                  _pilihKecamatan = null; // Reset kecamatan
                  _pilihDesa = null; // Reset desa
                  namaKecamatan.clear(); // Kosongkan list kecamatan
                  namaDesa.clear(); // Kosongkan list desa
                });

                getKecamatan();
              },
              value: _pilihKota,
              validator: (value) {
                if (value == null) {
                  return 'Harap pilih kota';
                }
                return null;
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _formKecamatan() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Container(
            decoration: decorationTextField,
            child: DropdownButtonFormField<String>(
              isDense: true,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.location_city,
                  color: Colors.brown[800],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[400],
                ),
              ),
              hint: Text('Pilih Kecamatan'),
              isExpanded: true,
              // Pastikan dropdown hanya muncul jika ada kecamatan
              items: namaKecamatan.isEmpty
                  ? null
                  : namaKecamatan.map(
                      (item) {
                        return DropdownMenuItem(
                          child: Text(item['kecamatan'].toString()),
                          value: item['kode'].toString(),
                        );
                      },
                    ).toList(),
              onChanged: (val) {
                setState(() {
                  _pilihKecamatan = val;
                  _pilihDesa = null; // Reset desa saat memilih kecamatan baru
                  namaDesa.clear(); // Kosongkan list desa
                });

                getDesa();
              },
              value: _pilihKecamatan,
              validator: (value) {
                if (value == null) {
                  return 'Harap pilih kecamatan';
                }
                return null;
              },
              // Nonaktifkan dropdown jika tidak ada kecamatan
              // isExpanded: true,
              disabledHint: _pilihKota == null
                  ? Text('Pilih Kota Terlebih Dahulu')
                  : Text('Tidak Ada Kecamatan'),
            ),
          )
        ],
      ),
    );
  }

  Widget _formDesa() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Container(
            decoration: decorationTextField,
            child: DropdownButtonFormField<String>(
              isDense: true,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.location_city,
                  color: Colors.brown[800],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[400],
                ),
              ),
              hint: Text('Pilih Desa'),
              isExpanded: true,
              // Pastikan dropdown hanya muncul jika ada desa
              items: namaDesa.isEmpty
                  ? null
                  : namaDesa.map(
                      (item) {
                        return DropdownMenuItem(
                          child: Text(item['desa'].toString()),
                          value: item['kode'].toString(),
                        );
                      },
                    ).toList(),
              onChanged: (val) {
                setState(() {
                  _pilihDesa = val;
                });
              },
              value: _pilihDesa,
              validator: (value) {
                if (value == null) {
                  return 'Harap pilih desa';
                }
                return null;
              },
              // Nonaktifkan dropdown jika tidak ada desa
              disabledHint: _pilihKecamatan == null
                  ? Text('Pilih Kecamatan Terlebih Dahulu')
                  : Text('Tidak Ada Desa'),
            ),
          )
        ],
      ),
    );
  }

  //NOTE Header Dokar
  Widget _logo() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              "assets/images/gold2.png",
            ),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter),
      ),
    );
  }

//NOTE Judul
  Widget _textjudul() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
          left: mediaQueryData.size.height * 0.03,
          right: mediaQueryData.size.height * 0.03,
          bottom: mediaQueryData.size.height * 0.03,
          // top: mediaQueryData.size.height * 0.010,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AutoSizeText(
              "Daftar Warga",
              minFontSize: 16,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
                color: Colors.brown[800],
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
