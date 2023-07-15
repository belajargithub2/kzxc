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
}