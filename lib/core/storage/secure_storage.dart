import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ISecureStore {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> clear();
}

class SecureStore implements ISecureStore {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm:
          KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      preferencesKeyPrefix: "",
      resetOnError: false,
      sharedPreferencesName: "",
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_CBC_PKCS7Padding,
    ),
  );

  static const kAccessToken = 'access_token';

  @override
  Future<void> write(String k, String v) => _storage.write(key: k, value: v);

  @override
  Future<String?> read(String k) => _storage.read(key: k);

  @override
  Future<void> delete(String k) => _storage.delete(key: k);

  @override
  Future<void> clear() async {
    _storage.deleteAll();
  }
}
