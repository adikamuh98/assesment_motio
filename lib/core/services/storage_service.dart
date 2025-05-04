import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._internal();
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  static SecureStorageService get instance => _instance;

  static final AndroidOptions _androidOptions = const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  final FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: _androidOptions,
  );

  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> readSecureData(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAllSecureData() async {
    await _storage.deleteAll();
  }
}

class SecureKey {
  static final String token = 'token';
}
