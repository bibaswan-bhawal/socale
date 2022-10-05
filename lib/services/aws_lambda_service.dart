import 'dart:convert';
import 'package:http/http.dart' as http;

class AWSLambdaService {
  Future<bool> sendOTPVerificationEmail(String email, int otp) async {
    final response = await http.post(
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
}

final awsLambdaService = AWSLambdaService();
