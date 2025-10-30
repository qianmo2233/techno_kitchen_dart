import 'dart:convert';

import 'package:dotenv/dotenv.dart';
import 'package:techno_kitchen_dart/techno_kitchen_dart.dart';
import 'package:test/test.dart';
import 'package:timezone/data/latest_10y.dart' as tzdata;

/// Tests for the SDGB API using the TechnoKitchenClient.
///
/// You need to have a valid QR code in `test/qr_code.txt`
///
/// The QR code should be in the format: SGWCMAID<16-digit timestamp YYMMDDHHMMSS><64-character QR code>
///
/// USE TEST ACCOUNT ONLY.
/// WE ARE NOT RESIPONSIBLE FOR YOUR ACCOUNT.
void main() {
  group('SDGB API Test', () {
    late TechnoKitchenClient client;
    late TechnoKitchen technoKitchen;
    late DotEnv env;
    late final String qrCode;
    late final int userId;

    setUp(() {
      env = DotEnv()..load();
      technoKitchen = TechnoKitchen.fromEnv(env);
      client = technoKitchen.client;
      tzdata.initializeTimeZones();

      // Leave qrCode empty will be read from file
      qrCode = '';

      // Leave userId 0 will be set after QR code test
      userId = 0;
    });

    test('QR Code Test', () async {
      if (qrCode.isEmpty) {
        final qrCode = env['QR_CODE'];
        expect(qrCode, isNotNull, reason: 'QR_CODE undefined');
        expect(qrCode!.isNotEmpty, isTrue, reason: 'qrCode is empty');
      } else {
        print('Using provided QR code: $qrCode');
      }

      final result = await client.qrApi(qrCode);

      print(jsonEncode(result));

      expect(result, isA<Map<String, dynamic>>());

      expect(result.containsKey('errorID'), isTrue, reason: 'Missing errorID');
      expect(result.containsKey('userID'), isTrue, reason: 'Missing userID');

      expect(
        result['errorID'],
        equals(0),
        reason: 'errorID should be 0 for successful response',
      );
    });

    test("User Preview", () async {
      expect(
        userId,
        isNot(equals(0)),
        reason: 'userId should be set after QR code test or manually',
      );

      final previewResult = await technoKitchen.preview(userId);

      print(previewResult);

      expect(
        previewResult.isNotEmpty,
        isTrue,
        reason: 'Preview result should not be empty',
      );
    });
  });
}
