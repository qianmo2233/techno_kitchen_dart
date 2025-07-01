import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:techno_kitchen_dart/techno_kitchen_dart.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// A client for interacting with the SDGB API,
/// including CHIME QR code authentication and secure game data communication.
class TechnoKitchenClient {
  // --- Configuration Parameters ---

  /// AES encryption key (must match the server's key).
  String aesKey = "a>32bVP7v<63BVLkY[xM>daZ1s9MBP<R";

  /// AES initialization vector (must be 16 bytes).
  String aesIv = "d6xHIKq]1J]Dt^ue";

  /// Obfuscation parameter used in API hash calculation.
  String obfuscateParam = "B44df8yT";

  /// Keychip ID, typically identifying a specific machine.
  String keychipID = "A63E-01C28055905";

  /// Salt used in the SHA-256 hash for authentication.
  String salt = "XcW5FW4cPArBXEk4vzKz3CIrMuA5EVVW";

  /// Open game ID, typically used to identify the game.
  String openGameID = "MAID";

  /// Endpoint for CHIME QR code authentication.
  String chimeEndpoint = "http://ai.sys-allnet.cn/wc_aime/api/get_data";

  /// Endpoint for encrypted and compressed title server requests.
  String titleEndpoint = "https://maimai-gm.wahlap.com:42081/Maimai2Servlet/mE2s3Jhd/";

  /// Constructs a [TechnoKitchenClient] with custom parameters.
  TechnoKitchenClient(
    this.aesKey,
    this.aesIv,
    this.obfuscateParam,
    this.keychipID,
    this.salt,
    this.openGameID,
    this.chimeEndpoint,
    this.titleEndpoint,
  );

  /// Constructs a [TechnoKitchenClient] with default parameters.
  /// 
  /// Support Version: CN 1.50
  TechnoKitchenClient.defaultValues();

  /// Sends a QR code authentication request to the Chime server.
  ///
  /// This is typically used to verify AIME card login.
  ///
  /// [qrCode]: CHIME QR code string.
  /// 
  /// QRCode Structure: SGWCMAID<16-digit timestamp YYMMDDHHMMSS><64-character QR code>
  ///
  /// Returns a `Map<String, dynamic>` containing the server's response data.
  Future<Map<String, dynamic>> qrApi(String qrCode) async {
    // Ensure QR code is within valid length
    if (qrCode.length > 64) {
      qrCode = qrCode.substring(qrCode.length - 64);
    }

    // Get current timestamp in Asia/Tokyo timezone
    tzdata.initializeTimeZones();
    final tokyo = tz.getLocation('Asia/Tokyo');
    final now = tz.TZDateTime.now(tokyo);
    final timeStamp = DateFormat("yyMMddHHmmss").format(now);

    // Calculate authentication key using SHA256
    final authKey = sha256
        .convert(utf8.encode(keychipID + timeStamp + salt))
        .toString()
        .toUpperCase();

    // Compose POST body
    final param = {
      "chipID": keychipID,
      "openGameID": openGameID,
      "key": authKey,
      "qrCode": qrCode,
      "timestamp": timeStamp,
    };

    // Custom headers required by the server
    final headers = {
      "Contention": "Keep-Alive",
      "Host": "ai.sys-allnet.cn",
      "User-Agent": "WC_AIME_LIB",
    };

    final res = await http.post(
      Uri.parse(chimeEndpoint),
      headers: headers,
      body: jsonEncode(param),
    );

    if (res.statusCode != 200) {
      throw Exception("Response error: ${res.statusCode}");
    }

    return jsonDecode(res.body);
  }

  /// Sends encrypted and compressed game data to the title server.
  ///
  /// [data]: Raw JSON or string content to be sent.
  /// [useApi]: API endpoint name (without hashing).
  /// [userId]: User identifier used in headers for authentication.
  ///
  /// Returns the decrypted string response from the server.
  Future<String> sdgbApi(String data, String useApi, int userId) async {
  final aes = AESPKCS7(aesKey, aesIv);

  // Encrypt and compress the payload
  final compressedData = ZLibEncoder().encode(utf8.encode(data));
  final encryptedData = aes.encryptBytes(Uint8List.fromList(compressedData));

  // Generate obfuscated API hash
  final hashApi = getHashApi(useApi, "MaimaiChn", obfuscateParam);

  // Send request to title server
  http.Response response;
  try {
    // Send request to title server
    response = await http.post(
      Uri.parse(titleEndpoint + hashApi),
      headers: {
        "User-Agent": "$hashApi#$userId",
        "Content-Type": "application/json",
        "Mai-Encoding": "1.50",
        "Accept-Encoding": "",
        "Charset": "UTF-8",
        "Content-Encoding": "deflate",
        "Expect": "100-continue",
      },
      body: encryptedData,
    );
  } on SocketException catch (e) {
    throw Exception("Network error: Unable to connect to server.\n$e");
  } on Exception catch (e) {
    throw Exception("Unexpected error: $e");
  }

  if (response.statusCode != 200) {
    throw Exception("Response error: ${response.statusCode}\n${response.body}");
  }

  // Decrypt and decompress server response
  final decrypted = aes.decryptBytes(response.bodyBytes);
  final decompressed = ZLibDecoder().decodeBytes(decrypted);
  return utf8.decode(decompressed);
}
}