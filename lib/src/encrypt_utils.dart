import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

/// Provides AES encryption and decryption using CBC mode with manual PKCS7 padding.
class AESPKCS7 {
  final encrypt.Encrypter encrypter;
  final encrypt.IV iv;

  /// Creates an AESPKCS7 instance with the given [keyStr] and [ivStr].
  ///
  /// [keyStr] must be 16, 24, or 32 characters long for AES-128/192/256 respectively.
  /// [ivStr] must be 16 characters long.
  AESPKCS7(String keyStr, String ivStr)
      : encrypter = encrypt.Encrypter(
          encrypt.AES(
            encrypt.Key.fromUtf8(keyStr),
            mode: encrypt.AESMode.cbc,
            padding: null, // Padding is handled manually.  
          ),
        ),
        iv = encrypt.IV.fromUtf8(ivStr);

  /// Encrypts a UTF-8 [content] string and returns the raw encrypted bytes.
  Uint8List encryptText(String content) {
    final padded = _pkcs7Pad(Uint8List.fromList(utf8.encode(content)));
    return encrypter.encryptBytes(padded, iv: iv).bytes;
  }

  /// Encrypts binary [content] (e.g. compressed data) and returns the encrypted bytes.
  Uint8List encryptBytes(Uint8List content) {
    final padded = _pkcs7Pad(content);
    return encrypter.encryptBytes(padded, iv: iv).bytes;
  }

  /// Decrypts the raw encrypted [content] bytes and returns the original data as bytes.
  Uint8List decryptBytes(Uint8List content) {
    return Uint8List.fromList(
      encrypter.decryptBytes(encrypt.Encrypted(content), iv: iv),
    );
  }

  /// Applies PKCS7 padding to the input [bytes] to match the AES block size.
  Uint8List _pkcs7Pad(Uint8List bytes) {
    const blockSize = 16;
    final padLength = blockSize - (bytes.length % blockSize);
    return Uint8List.fromList([...bytes, ...List.filled(padLength, padLength)]);
  }

  /// Removes PKCS7 padding from the input [bytes].
  Uint8List pkcs7Unpad(Uint8List bytes) {
    final padLength = bytes.last;
    return bytes.sublist(0, bytes.length - padLength);
  }
}

/// Generates an MD5 hash for the given API request components.
///
/// This is used to obfuscate endpoint paths for server requests.
///
/// - [api]: the raw API endpoint.
/// - [text]: typically a string related to the game, such as `"MaimaiChn"`.
/// - [obfuscateParam]: the additional obfuscation salt.
///
/// Returns the MD5 hash as a lowercase hexadecimal string.
String getHashApi(String api, String text, String obfuscateParam) {
  return md5.convert(utf8.encode(api + text + obfuscateParam)).toString();
}