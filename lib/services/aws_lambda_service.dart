import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AWSLambdaService {
  Future<bool> sendOTPVerificationEmail(String email, int otp) async {
    await http.post(
      Uri.https('77fbkbndbv3ftq3lj57bfjmfx40ndxrj.lambda-url.us-west-2.on.aws', '/', {
        'email': email,
        'otp': otp.toString(),
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'email': email,
        'otp': otp,
      }).codeUnits,
    );

    return true;
  }

  Future<bool> getMatches(String id) async {
    final response = await http.post(
      Uri.https('7uetyhcxradhyc3zz6um6foj440lcbdy.lambda-url.us-west-2.on.aws', '/', {
        'userId': id,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': id,
      }).codeUnits,
    );

    return true;
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

  Future<bool> sendOTPVerificationEmailOld(String email, int otp) async {
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
}

final awsLambdaService = AWSLambdaService();
