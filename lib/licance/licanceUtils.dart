import 'package:encrypt/encrypt.dart';
import 'package:intl/intl.dart';

class LicenseUtils {
  static final Key baseKey = Key.fromUtf8('12345678901234567890123456789012'); // 32 bytes for AES-256
  static final IV baseIV = IV.fromLength(16); // 16 bytes for AES

  String generateDateKey() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS');
    final currentDate = formatter.format(now);
    return currentDate;
  }

  String encryptKey(String key) {
    try {
      final iv = IV.fromLength(16); // Generate a new IV
      final encrypter = Encrypter(AES(baseKey, mode: AESMode.cbc));
      final encrypted = encrypter.encrypt(key, iv: iv);
      // Combine IV and encrypted data (base64 encoding)
      final encryptedData = '${iv.base64}:${encrypted.base64}';
      print('Encrypted data (Base64): $encryptedData');
      return encryptedData;
    } catch (e) {
      print('Error encrypting key: $e');
      return '';
    }
  }

  String decryptKey(String encryptedData) {
    try {
      final parts = encryptedData.split(':');
      final iv = IV.fromBase64(parts[0]);
      final encryptedKey = parts[1];
      final encrypter = Encrypter(AES(baseKey, mode: AESMode.cbc));
      final decrypted = encrypter.decrypt64(encryptedKey, iv: iv);
      print('Decrypted data: $decrypted');
      return decrypted;
    } catch (e) {
      print('Error decrypting key: $e');
      return '';
    }
  }
}

void main() {
  final utils = LicenseUtils();

  // Generate a date key
  final dateKey = utils.generateDateKey();
  print('Generated Date Key: $dateKey');

  // Encrypt the date key
  final encryptedKey = utils.encryptKey(dateKey);
  print('Encrypted Key: $encryptedKey');

  // Decrypt the encrypted key
  final decryptedKey = utils.decryptKey(encryptedKey);
  print('Decrypted Key: $decryptedKey');

  // Check if decrypted key matches the original
  if (dateKey == decryptedKey) {
    print('Encryption and decryption are successful!');
  } else {
    print('There was an issue with encryption or decryption.');
  }
}
