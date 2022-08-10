import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webcrypto/webcrypto.dart';

class EncryptionService {
  // It’s included in the message so that the decryption procedure can use it.
  final _amplifyCognitoUser = Amplify.Auth.getCurrentUser();

  final Uint8List iv =
      Uint8List.fromList(dotenv.get('ENCRYPTION_IV').codeUnits);

  Future<JsonWebKeyPair> generateKeys() async {
    final keyPair = await EcdhPrivateKey.generateKey(EllipticCurve.p256);
    final publicKeyJwk = await keyPair.publicKey.exportJsonWebKey();
    final privateKeyJwk = await keyPair.privateKey.exportJsonWebKey();
    final userId = (await _amplifyCognitoUser).userId;

    final encryptedPrivateKey = utf8.encode(
        Encrypter(AES(Key.fromUtf8(dotenv.get('AES_KEY') + userId)))
            .encrypt(json.encode(privateKeyJwk))
            .base64)
      ..insert(0, utf8.encode(generateRandomString(1))[0])
      ..insert(0, utf8.encode(generateRandomString(1))[0]);
    return JsonWebKeyPair(
      privateKey: encryptedPrivateKey,
      publicKey: json.encode(publicKeyJwk),
    );
  }

  Future<List<int>> deriveKey(
      List<int> encodedSenderJwk, String receiverJwk) async {
    final userId = (await _amplifyCognitoUser).userId;
    // Sender's key
    final senderJwk =
        Encrypter(AES(Key.fromUtf8(dotenv.get('AES_KEY') + userId))).decrypt64(
      utf8.decode(
        encodedSenderJwk
          ..removeAt(0)
          ..removeAt(0),
      ),
    );
    final senderPrivateKey = json.decode(senderJwk);
    final senderEcdhKey = await EcdhPrivateKey.importJsonWebKey(
      senderPrivateKey,
      EllipticCurve.p256,
    );

    // Receiver's key
    final receiverPublicKey = json.decode(receiverJwk);
    final receiverEcdhKey = await EcdhPublicKey.importJsonWebKey(
      receiverPublicKey,
      EllipticCurve.p256,
    );

    // Generating CryptoKey
    final derivedBits = await senderEcdhKey.deriveBits(256, receiverEcdhKey);
    return derivedBits;
  }

  Future<String> encryptMessage(String message, List<int> deriveKey) async {
    // Importing cryptoKey
    final aesGcmSecretKey = await AesGcmSecretKey.importRawKey(deriveKey);

    // Converting message into bytes
    final messageBytes = Uint8List.fromList(message.codeUnits);

    // Encrypting the message
    final encryptedMessageBytes =
        await aesGcmSecretKey.encryptBytes(messageBytes, iv);

    // Converting encrypted message into String
    final encryptedMessage = String.fromCharCodes(encryptedMessageBytes);
    return encryptedMessage;
  }

  Future<String> decryptMessage(
      String encryptedMessage, List<int> deriveKey) async {
    // Importing cryptoKey
    final aesGcmSecretKey = await AesGcmSecretKey.importRawKey(deriveKey);

    // Converting message into bytes
    final messageBytes = Uint8List.fromList(encryptedMessage.codeUnits);

    // Decrypting the message
    final decryptedMessageBytes =
        await aesGcmSecretKey.decryptBytes(messageBytes, iv);

    // Converting decrypted message into String
    final decryptedMessage = String.fromCharCodes(decryptedMessageBytes);
    return decryptedMessage;
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }
}

class JsonWebKeyPair {
  const JsonWebKeyPair({
    required this.privateKey,
    required this.publicKey,
  });

  final List<int> privateKey;
  final String publicKey;
}
