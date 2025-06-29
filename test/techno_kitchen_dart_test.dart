import 'dart:convert';
import 'dart:io';

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

    setUp(() {
      client = TechnoKitchenClient.defaultValues();
      tzdata.initializeTimeZones();
    });

    test('QR Code Test', () async {
      final qrFile = File('test/qr_code.txt');
      expect(await qrFile.exists(), isTrue, reason: 'File qr_code.txt not found');

      final qrCode = (await qrFile.readAsString()).trim();
      expect(qrCode.isNotEmpty, isTrue, reason: 'qrCode is empty');

      final result = await client.qrApi(qrCode);

      print(jsonEncode(result));

      expect(result, isA<Map<String, dynamic>>());
      
      expect(result.containsKey('errorID'), isTrue,
          reason: 'Missing  errorID');
      expect(result.containsKey('userID'), isTrue,
          reason: 'Missing userID');

      expect(result['errorID'], equals(0),
          reason: 'errorID should be 0 for successful response');
    });
  });
}
