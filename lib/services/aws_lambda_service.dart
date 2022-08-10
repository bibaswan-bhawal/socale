import 'dart:convert';

import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AWSLambdaService {
  static AWSSigV4Signer signer = AWSSigV4Signer(
    credentialsProvider: AWSCredentialsProvider(
      AWSCredentials(
        dotenv.get('AWS_ACCESS_KEY_ID'),
        dotenv.get('AWS_SECRET_ACCESS_KEY'),
      ),
    ),
  );
  static const region = 'us-west-2';
  final scope = AWSCredentialScope(
    region: region,
    service: AWSService.lambda,
  );

  Future<bool> sendOTPVerificationEmail(String email, int otp) async {
    final request = AWSHttpRequest(
      method: AWSHttpMethod.post,
      uri: Uri.https(
          '77fbkbndbv3ftq3lj57bfjmfx40ndxrj.lambda-url.us-west-2.on.aws', '/', {
        'email': email,
        'otp': otp.toString(),
      }),
      headers: const {
        AWSHeaders.contentType: 'application/x-amz-json-1.1',
      },
      body: json.encode({
        'email': email,
        'otp': otp,
      }).codeUnits,
    );
    final signedRequest = await signer.sign(
      request,
      credentialScope: scope,
    );
    final resp = await signedRequest.send();
    final respBody = await resp.decodeBody();

    if (respBody is! String) {
      final responseMap = JsonDecoder().convert(respBody);
      print(responseMap);
      if (responseMap.containsKey('success') && responseMap["success"]) {
        return true;
      }
    } else {
      print(respBody);
    }

    return false;
  }
}

final awsLambdaService = AWSLambdaService();