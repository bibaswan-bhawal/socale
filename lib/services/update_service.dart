import 'package:amplify_api/model_mutations.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:socale/models/User.dart';

class UpdateService {
  Future<bool> updateUser(User newUser) async {
    try {
      await Amplify.DataStore.save(newUser).whenComplete(() => print("data uploaded"));
      return true;
    } catch (e) {
      rethrow;
    }
  }
}

final updateService = UpdateService();
