import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socale/auth/auth_repository.dart';

import '../models/User.dart';
import '../utils/enums/onboarding_fields.dart';
import 'aws_lambda_service.dart';

@lazySingleton
class OnboardingService {
  final _amplifyCognitoUser = Amplify.Auth.getCurrentUser();
  int? otp;

  Future<bool> checkIfUserIsOnboarded() async {
    final userId = (await _amplifyCognitoUser).userId;
    final user = await Amplify.DataStore.query(
      User.classType,
      where: User.ID.eq(userId),
    );

    return user.isNotEmpty;
  }

  Future<OnboardingStep> getOnboardingStep() async {
    final userId = (await _amplifyCognitoUser).userId;

    if (await Hive.boxExists(userId)) {
      final box = await Hive.openBox(userId);
      try {
        return OnboardingStep.values.byName(box.get('onboardingStep'));
      } catch (e) {
        return OnboardingStep.started;
      }
    } else {
      return OnboardingStep.started;
    }
  }

  Future<void> setOnboardingStep(OnboardingStep step) async {
    final userId = (await _amplifyCognitoUser).userId;

    final box = await Hive.openBox(userId);
    await box.put('onboardingStep', step.name);
  }

  Future<void> clearAll() async {
    final userId = (await _amplifyCognitoUser).userId;

    final box = await Hive.openBox(userId);
    await box.clear();
  }

  Future<bool> generateOTPAndSendEmail(String schoolEmail) async {
    otp = Random().nextInt(10000 - 1000) + 1000;
    return await awsLambdaService.sendOTPVerificationEmail(schoolEmail, otp!);
  }

  bool verifyOTP(int code) {
    if (otp == code) {
      otp = null;
      return true;
    }
    return false;
  }

  Future<void> setSchoolEmail(String schoolEmail) async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('schoolEmail', schoolEmail);
    await setOnboardingStep(OnboardingStep.biographics);
  }

  Future<void> setAcademicInclination(int academicInclination) async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('academicInclination', academicInclination);
    await setOnboardingStep(OnboardingStep.biographics);
  }

  Future<void> setBiographics(String firstName, String lastName,
      DateTime dateOfBirth, DateTime graduationMonth) async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('firstName', firstName);
    await box.put('lastName', lastName);
    await box.put('dateOfBirth', dateOfBirth);
    await box.put('graduationMonth', graduationMonth);
    await setOnboardingStep(OnboardingStep.collegeInfo);
  }

  Future<void> setCollegeInfo(
      List<String> major, List<String> minor, List<String> college) async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('major', major);
    await box.put('minor', minor);
    await box.put('college', college);
    await setOnboardingStep(OnboardingStep.skills);
  }

  Future<void> setAcademicInterests(List<String> academicInterests) async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('academicInterests', academicInterests);
    await setOnboardingStep(OnboardingStep.leisureInterests);
  }

  Future<void> setSkills(List<String> skills) async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('skills', skills);
    await setOnboardingStep(OnboardingStep.careerGoals);
  }

  Future<void> setCareerGoals(List<String> careerGoals) async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('careerGoals', careerGoals);
    await setOnboardingStep(OnboardingStep.selfDescription);
  }

  Future<void> setSelfDescription(List<String> selfDescription) async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('selfDescription', selfDescription);
    await setOnboardingStep(OnboardingStep.academicInterests);
  }

  Future<void> setLeisureInterests(List<String> leisureInterests) async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('leisureInterests', leisureInterests);
    await setOnboardingStep(OnboardingStep.idealFriendDescription);
  }

  Future<void> setIdealFriendDescription(String idealFriendDescription) async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('idealFriendDescription', idealFriendDescription);
    await setOnboardingStep(OnboardingStep.biographics);
  }

  Future<void> setSituationalDecisions(List<int> situationalDecisions) async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('situationalDecisions', situationalDecisions);
    await setOnboardingStep(OnboardingStep.avatarSelection);
  }

  Future<void> setAvatarSelection(Uint8List avatarSelection) async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('avatarSelection', avatarSelection);
    await setOnboardingStep(OnboardingStep.completed);
  }

  Future<bool> createOnboardedUser() async {
    final cognitoUser = await _amplifyCognitoUser;
    final userId = cognitoUser.userId;
    final box = await Hive.openBox(userId);
    if (!_checkIfFieldExistsLocally(box, 'onboardingStep') ||
        !_checkIfFieldExistsLocally(box, 'schoolEmail') ||
        !_checkIfFieldExistsLocally(box, 'academicInclination') ||
        !_checkIfFieldExistsLocally(box, 'firstName') ||
        !_checkIfFieldExistsLocally(box, 'lastName') ||
        !_checkIfFieldExistsLocally(box, 'dateOfBirth') ||
        !_checkIfFieldExistsLocally(box, 'graduationMonth') ||
        !_checkIfFieldExistsLocally(box, 'major') ||
        !_checkIfFieldExistsLocally(box, 'academicInterests') ||
        !_checkIfFieldExistsLocally(box, 'skills') ||
        !_checkIfFieldExistsLocally(box, 'careerGoals') ||
        !_checkIfFieldExistsLocally(box, 'selfDescription') ||
        !_checkIfFieldExistsLocally(box, 'leisureInterests') ||
        !_checkIfFieldExistsLocally(box, 'idealFriendDescription') ||
        !_checkIfFieldExistsLocally(box, 'situationalDecisions') ||
        !_checkIfFieldExistsLocally(box, 'college')) {
      return false;
    }

    List<AuthUserAttribute>? attributes =
        await AuthRepository().fetchCurrentUserAttributes();

    if (attributes == null) {
      return false;
    }

    final newUser = User(
      email: attributes
          .where((element) => element.userAttributeKey.toString() == 'email')
          .elementAt(0)
          .value,
      id: userId,
      schoolEmail: box.get('schoolEmail'),
      academicInclination: box.get('academicInclination'),
      firstName: box.get('firstName'),
      lastName: box.get('lastName'),
      dateOfBirth: TemporalDate(box.get('dateOfBirth')),
      graduationMonth: TemporalDate(box.get('graduationMonth')),
      major: box.get('major'),
      academicInterests: box.get('academicInterests'),
      skills: box.get('skills'),
      careerGoals: box.get('careerGoals'),
      selfDescription: box.get('selfDescription'),
      leisureInterests: box.get('leisureInterests'),
      idealFriendDescription: box.get('idealFriendDescription'),
      situationalDecisions: box.get('situationalDecisions'),
      college: box.get('college')[0],
      minor: [],
      publicKey: 'htrthrt',
      privateKey: [53453],
      matches: [],
      rooms: [],
    );

    // try {
    //   await Amplify.DataStore.clear();
    // } on Exception catch (error) {
    //   print('Error clearing DataStore: $error');
    // }

    // try {
    //   final posts = await Amplify.DataStore.query(User.classType);
    //   print('Users: $posts');
    // } on DataStoreException catch (e) {
    //   print('Query failed: $e');
    // }

    try {
      await Amplify.DataStore.save(newUser);
    } on Exception catch (error) {
      print('Error saving to DataStore: $error');
    }

    // File profilePictureFile = (await File((await getTemporaryDirectory()).path)
    //     .create())
    //   ..writeAsBytesSync(box.get('avatarSelection') as Uint8List);
    // if (await imageService.uploadProfilePicture(profilePictureFile)) {
    //
    //   return true;
    // }
    return true;
  }

  bool _checkIfFieldExistsLocally(Box box, String key) {
    if (!box.isOpen) {
      throw Exception('Hive box is not open');
    }
    if (box.get(key) == null) {
      return false;
    }
    return true;
  }
}

final onboardingService = OnboardingService();
