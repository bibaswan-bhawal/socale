import 'package:amplify_api/model_mutations.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:socale/models/User.dart';

class UpdateService {
  Future<bool> updateUser(User newUser) async {
    Amplify.DataStore.save(newUser);
    return true;
  }
}

final updateService = UpdateService();
