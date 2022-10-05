import 'dart:convert';

import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AWSLambdaService {
  Future<bool> sendOTPVerificationEmail(String email, int otp) async {
    AWSSigV4Signer signer = AWSSigV4Signer(
      credentialsProvider: AWSCredentialsProvider(
        AWSCredentials(
          dotenv.get('AWS_ACCESS_KEY_ID'),
          dotenv.get('AWS_SECRET_ACCESS_KEY'),
        ),
      ),
    );

    const region = 'us-west-2';
    final scope = AWSCredentialScope(
      region: region,
      service: AWSService.lambda,
    );

    final request = AWSHttpRequest(
      method: AWSHttpMethod.post,
      uri: Uri.https('77fbkbndbv3ftq3lj57bfjmfx40ndxrj.lambda-url.us-west-2.on.aws', '/', {
        'email': email,
        'otp': otp.toString(),
      }),
      headers: const {
        'content-type': 'application/x-amz-json-1.1',
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

    AWSBaseHttpResponse resp = await signedRequest.send().response;
    String respBody = await resp.decodeBody();

    final responseMap = JsonDecoder().convert(respBody);
    if (responseMap.containsKey('success') && responseMap["success"]) {
      return true;
    }

    return false;
  }

  Future<bool> getMatches(String id) async {
    AWSSigV4Signer signer = AWSSigV4Signer(
      credentialsProvider: AWSCredentialsProvider(
        AWSCredentials(
          dotenv.get('AWS_ACCESS_KEY_ID'),
          dotenv.get('AWS_SECRET_ACCESS_KEY'),
        ),
      ),
    );

    final scope = AWSCredentialScope(
      region: 'us-west-2',
      service: AWSService.lambda,
    );

    final createRequest = AWSHttpRequest.post(
      Uri.https('7uetyhcxradhyc3zz6um6foj440lcbdy.lambda-url.us-west-2.on.aws', '/', {
        'userId': id,
      }),
      body: json.encode({'userId': id}).codeUnits,
      headers: {
        AWSHeaders.host: '7uetyhcxradhyc3zz6um6foj440lcbdy.lambda-url.us-west-2.on.aws',
        AWSHeaders.contentLength: json.encode({'userId': id}).codeUnits.length.toString(),
        AWSHeaders.contentType: 'application/x-amz-json-1.1',
      },
    );

    final signedCreateRequest = await signer.sign(
      createRequest,
      credentialScope: scope,
    );

    try {
      final createResponse = await signedCreateRequest.send().response;
      String body = await createResponse.decodeBody();

      final responseMap = jsonDecode(body);
      if (responseMap.containsKey('success') && responseMap["success"]) {
        print("GOT MATCHES with status code: ${responseMap['statusCode']} and data: ${responseMap['matchedIds']}");
        return false;
      }
    } catch (e) {
      print("Something went wrong: $e");
    }

    return false;
    return false;
  }

  Future<bool> getMatchesOld(String id) async {
    AWSSigV4Signer signer = AWSSigV4Signer(
      credentialsProvider: AWSCredentialsProvider(
        AWSCredentials(
          dotenv.get('AWS_ACCESS_KEY_ID'),
          dotenv.get('AWS_SECRET_ACCESS_KEY'),
        ),
      ),
    );

    const region = 'us-west-2';
    final scope = AWSCredentialScope(
      region: region,
      service: AWSService.lambda,
    );

    final request = AWSHttpRequest(
      method: AWSHttpMethod.post,
      uri: Uri.https('7uetyhcxradhyc3zz6um6foj440lcbdy.lambda-url.us-west-2.on.aws', '/', {
        'userId': id,
      }),
      headers: const {
        'content-type': 'application/x-amz-json-1.1',
      },
      body: json.encode({'userId': id}).codeUnits,
    );

    final signedRequest = await signer.sign(
      request,
      credentialScope: scope,
    );
    try {
      final resp = await signedRequest.send();
      // String respBody = await resp.decodeBody();
      //
      // final responseMap = jsonDecode(respBody);
      // if (responseMap.containsKey('success') && responseMap["success"]) {
      //   print("GOT MATCHES");
      //   return false;
      // }
    } catch (e) {
      print("Something went wrong: $e");
    }

    return false;
  }
}

final awsLambdaService = AWSLambdaService();
