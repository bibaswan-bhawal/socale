import 'package:amplify_api/amplify_api.dart';
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

  Future<Model?> createModelRealTime(Model model) async {
    try {
      final request = ModelMutations.create(model);
      final response = await Amplify.API.mutate(request: request).response;

      final createdModel = response.data;
      if (createdModel == null) {
        safePrint('errors: ${response.errors}');
        return null;
      }

      safePrint('Mutation result: $createdModel');
      return createdModel;
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
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

  Future<Model?> updateModelRealTime(Model model) async {
    try {
      final request = ModelMutations.update(model);
      final response = await Amplify.API.mutate(request: request).response;

      final updatedModel = response.data;

      if (updatedModel == null) {
        safePrint('errors: ${response.errors}');
        return null;
      }

      safePrint('Mutation result: $updatedModel');
      return updatedModel;
    } catch (_) {
      return null;
    }
  }
}

final MutateService mutateService = MutateService();
