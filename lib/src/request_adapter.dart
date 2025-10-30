import 'package:dotenv/dotenv.dart';

class RequestAdapter {
  /// AES encryption key (must match the server's key).
  final String aesKey;

  /// AES initialization vector (must be 16 bytes).
  final String aesIv;

  /// Obfuscation parameter used in API hash calculation.
  final String obfuscateParam;

  /// Keychip ID, typically identifying a specific machine.
  final String keychipID;

  /// Salt used in the SHA-256 hash for authentication.
  final String salt;

  /// Open game ID, typically used to identify the game.
  final String openGameID;

  /// Endpoint for CHIME QR code authentication.
  final String chimeEndpoint;

  /// Endpoint for encrypted and compressed title server requests.
  final String titleEndpoint;

  RequestAdapter({
    required this.aesKey,
    required this.aesIv,
    required this.obfuscateParam,
    required this.keychipID,
    required this.salt,
    required this.openGameID,
    required this.chimeEndpoint,
    required this.titleEndpoint,
  });

  /// Construct from a given [DotEnv] instance
  factory RequestAdapter.fromEnv(DotEnv env) {
    return RequestAdapter(
      aesKey: env['AES_KEY'] ?? '',
      aesIv: env['AES_IV'] ?? '',
      obfuscateParam: env['OBFUSCATE_PARAM'] ?? '',
      keychipID: env['KEYCHIP_ID'] ?? '',
      salt: env['SALT'] ?? '',
      openGameID: env['OPEN_GAME_ID'] ?? '',
      chimeEndpoint: env['CHIME_ENDPOINT'] ?? '',
      titleEndpoint: env['TITLE_ENDPOINT'] ?? '',
    );
  }
}
