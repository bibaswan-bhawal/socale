import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:socale/models/ModelProvider.dart';

class FetchService {
  Future<List<User>?> fetchAllUsers() async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final users = await Amplify.DataStore.query(
      User.classType,
      where: User.ID.ne(userId),
    );

    return users;
  }
}
