import 'dart:convert';

import 'package:dotenv/dotenv.dart';
import 'package:techno_kitchen_dart/techno_kitchen_dart.dart';
import 'package:timezone/data/latest_10y.dart' as tzdata;

/// Example usage of Techno Kitchen Dart API client.
///
/// ⚠️ DO NOT USE YOUR MAIN ACCOUNT.
///
/// The server-side API may change at any time,
/// which could make this library temporarily incompatible with newer versions.
/// However, you can still use it by customizing the parameters of
/// the TechnoKitchenClient to adapt to the latest API behavior.
///
/// This example shows how to:
/// 1. Send a QR code login request
/// 2. Fetch user preview information
///
/// You must replace the sample QR code and user ID with valid test values.
void main() async {
  // Initialize time zones (required by some API logic)
  tzdata.initializeTimeZones();

  // Create an instance of the main API handler
  final technoKitchen = TechnoKitchen.fromEnv(DotEnv()..load());
  final client = technoKitchen.client;

  // === Step 1: Get UserId by QR Code ===
  //
  // Replace with a valid QR code string.
  // Format: SGWCMAID<16-digit timestamp YYMMDDHHMMSS><64-character code>
  //
  // Example:
  final qrCode =
      'SGWCMAID250721114514A3CD1B92DB405AC9A0ED4C1B9E4AD0CDA23BE4C191D93C92BA0BD9A2C3D1EBCA';

  try {
    final qrResponse = await client.qrApi(qrCode);

    print('QR Login Response:');
    print(jsonEncode(qrResponse));

    if (qrResponse['errorID'] != 0) {
      print('QR login failed with errorID: ${qrResponse['errorID']}');
      return;
    }

    final userId = qrResponse['userID'];
    print('Got user ID: $userId');

    // === Step 2: Fetch User Preview Info ===
    final preview = await technoKitchen.preview(userId);
    print('User Preview:');
    print(preview);
  } catch (e) {
    print('An error occurred: $e');
  }

  // More operations can be found in the TechnoKitchen class,
  // such as login, logout, fetching music data, etc.
  // And you can you can use the client directly for API calls.
}
