import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage{
  final _storage = FlutterSecureStorage();
  static String accessToken = "";
  static String refreshToken = "";

  Future writeSecureData(String key, String value)  async {

    accessToken = value;
    var writeData = await _storage.write(key: key, value: value);

    return writeData;
  }
  Future readSecureData(String key) async {
    var readData = await _storage.read(key: key);
    return readData;
  }
  Future deleteSecureData(String key) async{
    var deleteData = await _storage.delete(key: key);
    return deleteData;
  }

  setTokens(String access, String refresh) {
    accessToken = access;
    refreshToken = refresh;
  }

  String getAccessToken() {
    return accessToken;
  }

  String getRefreshToken() {
    return refreshToken;
  }
}