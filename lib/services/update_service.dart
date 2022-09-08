import 'package:amplify_api/model_mutations.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:socale/models/User.dart';

class UpdateService {
  Future<void> updateTodo(User newUser) async {
    final request = ModelMutations.update(newUser);
    final response = await Amplify.API.mutate(request: request).response;
  }
}

final updateService = UpdateService();
