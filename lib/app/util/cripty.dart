import 'dart:convert';
import 'package:crypto/crypto.dart';

class Cripty {
  
  Cripty._();

  static String generetedSha256Hash(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
    //sha256.convert(utf8.encode(password)).toString();
  }
}
