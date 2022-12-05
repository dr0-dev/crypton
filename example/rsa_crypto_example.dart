import 'dart:convert';

import 'package:crypton/crypton.dart';

String chunkSplit(String str) {
  return RegExp(".{0,76}")
      .allMatches(str)
      .map((e) => str.substring(e.start, e.end))
      .where((element) => element.isNotEmpty)
      .join("\r\n");
}

String decrypt(String privateKeyString, String content) {
  var rsaPrivateKey = RSAPrivateKey.fromString(privateKeyString);
  var decryptedContent = rsaPrivateKey.decrypt(content, oap: true);
  return decryptedContent;
}

void main() {
  // encryptDecrypt();

  String privateKeyString = "MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAIGoUumaGw8AfgRH2whzRGx/AO9ePMa4bpdW4GD5MU/LJWFppE9XNgWQKZK+7oUfM1uORiahZAZc1WDS7Ukup0TeXDFQ23yUUb416dma7vP7ZSI4P4CguMLjtqvUOnpf5tSCaBwMAowpp0yk+qYBYXsV+mkBIzLXk7ImFSDhIaD9AgMBAAECgYAZM2A6K0vLFKtppZW7BLxt4hmKbOSfM0W7gJVIA+dDvRZc4q2fBjJnzmdmMFon4bKXvwV/iKrqWazXjuez669y+k2xPjHvY9xg17R1At8UtZ9xF+kCh3ipNzeGUBoJkA8bLtBAdbEZ0Dc9f/O+858u+geXMzwjyrbEBJbPk2VEAQJBAMN6tG+yAdd7pJMgM0nxamoIbTQpCckalOA1dYS1Sb9DEChhzbbvxfDnEC4putou0vUkqgyeQz6hi0c9VHo0t4ECQQCpzLdddeXcUDzYQr3slQoi8bwQJOKify0C4w40Lku3fz7JS37jffF8IuEyvc7UHNv0fSHRSCQTFhyDYiUwH4d9AkACErANKy8X0Oja4pGIrDW7sCEwV2sSJeUER6zaXm3MyHJIa1kaIorP1jN2udyQacS08tGW1qrR5Das57qYnSyBAkBip/1KIjxBu6T+ihjLovTWxNleD/BWNcozSTVxgAyiOx6B2omJKB3s4F80GjBX8cSi0ymY7W94X3qFo7qzsT4JAkARMBgDta+SuUQ/LD2tvnmhBxofg3Xoh5VLLFV530g/FncjDty8TBlZBkAmiu+t9SfFSFwco/IW/yjLwwInql/3";
  var decrypted = decrypt(privateKeyString, "OcqieEapEXBAWFhG4yFsjv97lTHWjkQ+6Arz+wnLExcm1pOJSPF67o6faQoX7zRmO3EW7BvsiFI9KhiPZngK7n7c/59i8wfVnYl+bc+OwGNkldb/XifVzqvipr5PpdmHmd0KZSr1qtJdPvAM51D1HE4jw/9PR+vtINV9CoZ5dYE=");

  print("DECRYPTED $decrypted");
}

void encryptDecrypt() {
  final rsaKeypair = RSAKeypair.fromRandom();
  // final message = DateTime.now().millisecondsSinceEpoch.toRadixString(16);

  String message = "PROVA";

  final privateKeyString = rsaKeypair.privateKey.toString();

  var publicKeyCoreTmp = rsaKeypair.publicKey.toString();
  var publicKeyCore = chunkSplit(publicKeyCoreTmp);
  var publicKey = "-----BEGIN PUBLIC KEY-----\n" + publicKeyCore + "\n-----END PUBLIC KEY-----";

  // final publicKeyString = rsaKeypair.publicKey.toString();
  final encrypted = rsaKeypair.publicKey.encrypt(message, oap: true);
  final decrypted = rsaKeypair.privateKey.decrypt(encrypted, oap: true);

  print('Your Private Key\n $privateKeyString\n---');
  print('Your Public Key\n $publicKey\n---');

  final bytes = utf8.encode(publicKey);
  final publicKey64 = base64.encode(bytes);

  print('Your Public Key in base64\n $publicKey64\n---');
  print('Encrypted Message\n $encrypted\n---');
  print('Decrypted Message\n $decrypted\n---');

  if (decrypted == message) {
    print('The Message was successfully decrypted!');
  } else {
    print('Failed to decrypted the Message!');
  }
}
