import 'package:amplify_flutter/amplify_flutter.dart';

class MutateService {
  Future<Model?> createModel(Model model) async {
    try {
      await Amplify.DataStore.save(model);
      return model;
    } catch (_) {
      return null;
    }
  }

  Future<Model?> updateModel(Model model) async {
    try {
      await Amplify.DataStore.save(model);
      return model;
    } catch (_) {
      return null;
    }
  }
}

final MutateService mutateService = MutateService();
