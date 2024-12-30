import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart'; // Import package async
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  Future<dynamic> loginWarga(String username, String password) async {
    try {
      final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/webservice/android/login/warganew'),
          headers: ApiConfig.headers,
          body: {
            "username": username,
            "password": password,
          });

      return json.decode(response.body);
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  static Future<http.StreamedResponse?> uploadDataDukungWarga(
    File file,
    String uid,
    String keterangan,
  ) async {
    try {
      // ignore: deprecated_member_use
      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      var uri = Uri.parse(
          "${ApiConfig.baseUrl}/webservice/android/account/UploadDatadukung");
      var request = http.MultipartRequest("POST", uri);
      var multipartFile = http.MultipartFile("file", stream, length,
          filename: basename(file.path));

      request.fields['uid'] = uid;
      request.fields['keterangan'] = keterangan;
      request.files.add(multipartFile);

      var response = await request.send();
      return response; // Mengembalikan StreamedResponse
    } catch (e) {
      print('Error during upload: $e');
      return null; // Mengembalikan null jika terjadi error
    }
  }

  static Future<Map<String, dynamic>?> editAkunWarga() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse(
          "${ApiConfig.baseUrl}/webservice/android/account/DatawargabyUid"),
      body: {
        "uid": pref.getString("uid") ?? "",
      }, // Handle null uid
    );

    if (response.statusCode == 200) {
      try {
        var decodedResponse = json.decode(response.body);
        if (decodedResponse != null && decodedResponse["Data"] != null) {
          return decodedResponse["Data"];
        } else {
          print("Data tidak ditemukan dalam response: ${response.body}");
          return null; // Mengembalikan null jika "Data" tidak ada
        }
      } catch (e) {
        print("Error decoding JSON: $e, Response Body: ${response.body}");
        return null; // Mengembalikan null jika terjadi error decoding
      }
    } else {
      print(
          "Request gagal dengan status: ${response.statusCode}, Body: ${response.body}");
      return null; // Mengembalikan null jika request gagal
    }
  }
}
