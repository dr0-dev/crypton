import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart' as pointy;
import 'package:crypton/crypton.dart';

/// [Keypair] using RSA Algorithm
class RSAKeypair implements Keypair {
  RSAPrivateKey _privateKey;
  RSAPublicKey _publicKey;

  /// Create a [RSAKeypair] using an [RSAPrivateKey]
  RSAKeypair(this._privateKey) : _publicKey = _privateKey.publicKey;

  /// Generate a random [RSAKeypair]
  RSAKeypair.fromRandom() {
    var keyParams =
        pointy.RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 12);

    var fortunaRandom = pointy.FortunaRandom();
    var random = Random.secure();
    var seeds = <int>[];
    for (var i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    fortunaRandom.seed(pointy.KeyParameter(Uint8List.fromList(seeds)));

    var randomParams = pointy.ParametersWithRandom(keyParams, fortunaRandom);
    var generator = pointy.RSAKeyGenerator();
    generator.init(randomParams);

    var pair = generator.generateKeyPair();
    pointy.RSAPublicKey publicKey = pair.publicKey;
    pointy.RSAPrivateKey privateKey = pair.privateKey;

    _publicKey = RSAPublicKey(publicKey.modulus, publicKey.exponent);
    _privateKey = RSAPrivateKey(
        privateKey.modulus, privateKey.exponent, privateKey.p, privateKey.q);
  }

  /// Get the [RSAPublicKey] associated [RSAPrivateKey]
  @override
  RSAPublicKey get publicKey => _publicKey;

  /// Get the [RSAPrivateKey] associated [RSAPublicKey]
  @override
  RSAPrivateKey get privateKey => _privateKey;
}
