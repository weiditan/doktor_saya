import 'package:encrypt/encrypt.dart';

final plainText = 'test';
final key = Key.fromUtf8('Doctor Saya 32 Keys.............');
final iv = IV.fromLength(16);

final encrypter = Encrypter(AES(key));

String encrypt(String text){
  final encrypted = encrypter.encrypt(text, iv: iv);
  return encrypted.base64;
}


String decrypt(String text){
  final encrypted = Encrypted.fromBase64(text);
  final decrypted = encrypter.decrypt(encrypted, iv: iv);
  return decrypted;
}
