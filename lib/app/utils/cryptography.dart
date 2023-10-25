import 'package:encrypt/encrypt.dart';

class Cryptography {
  static const String _key = '%C*F-JaNcRfUjXn2r5u8x/A?D(G+KbPe';

  static String encrypt(String text){
    final key = Key.fromUtf8(_key);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(text, iv: iv);

    return encrypted.base64;
  }

  static String decrypt(String text){
    final key = Key.fromUtf8(_key);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final decrypted = encrypter.decrypt64(text, iv: iv);

    return decrypted;
  }

  static String encryptFernet(plainText){
    final key = Key.fromUtf8(_key);
    final fernet = Fernet(key);
    final encrypter = Encrypter(fernet);
    var fernetEncrypted = encrypter.encrypt(plainText);
    return fernetEncrypted.base64; // random cipher text
  }

  static String decryptFernet(plainText){
    final key = Key.fromUtf8(_key);
    final fernet = Fernet(key);
    final encrypter = Encrypter(fernet);
    return encrypter.decrypt64(plainText);
  }
}