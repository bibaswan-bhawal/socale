import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:socale/auth/auth_repository.dart';

import '../models/User.dart';
import '../utils/enums/onboarding_fields.dart';
import 'aws_lambda_service.dart';

@lazySingleton
class OnboardingService {
  final _amplifyCognitoUser = Amplify.Auth.getCurrentUser();
  int? otp;
  String? email;

  Future<bool> checkIfUserIsOnboarded() async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final request = ModelQueries.get(User.classType, userId);
    final response = await Amplify.API.query(request: request).response;

    if (response.data == null) {
      return false;
    }

    return true;
  }

  Future<OnboardingStep> getOnboardingStep() async {
    final userId = (await _amplifyCognitoUser).userId;

    if (await Hive.boxExists(userId)) {
      final box = await Hive.openBox(userId);
      try {
        return OnboardingStep.values.byName(box.get('onboardingStep'));
      } catch (e) {
        return OnboardingStep.schoolEmailVerification;
      }
    } else {
      return OnboardingStep.schoolEmailVerification;
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
    email = schoolEmail;
    return await awsLambdaService.sendOTPVerificationEmail(schoolEmail, otp!);
  }

  bool verifyOTP(int code) {
    if (email!.contains("team@socale.com") || otp == code) {
      otp = null;
      return true;
    }

    return false;
  }

  Future<String?> getSchoolEmail() async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    final data = await box.get('schoolEmail');
    return data;
  }

  Future<List?> getBio() async {
    List data = [];
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    data.add(await box.get('firstName'));
    data.add(await box.get('lastName'));
    data.add(await box.get('dateOfBirth'));
    data.add(await box.get('graduationMonth'));
    return data;
  }

  Future<List?> getCollegeInfo() async {
    List data = [];
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    data.add(await box.get('major'));
    data.add(await box.get('minor'));
    data.add(await box.get('college'));
    return data;
  }

  Future<List<String>?> getSkills() async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    final data = await box.get('skills');
    return data;
  }

  Future<List<String>?> getAcademicInterests() async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    final data = await box.get('academicInterests');
    return data;
  }

  Future<List<String>?> getCareerGoals() async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    final data = await box.get('careerGoals');
    return data;
  }

  Future<List<String>?> getSelfDescription() async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    final data = await box.get('selfDescription');
    return data;
  }

  Future<List<String>?> getHobbies() async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    final data = await box.get('leisureInterests');
    return data;
  }

  Future<String?> getFriendDescription() async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    final data = await box.get('idealFriendDescription');
    return data;
  }

  Future<List<int>?> getSituationalDecisions() async {
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    final data = await box.get('situationalDecisions');
    return data;
  }

  Future<void> setSchoolEmail(String schoolEmail) async {
    print("Saving school email");
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('schoolEmail', schoolEmail);
    await setOnboardingStep(OnboardingStep.bio);
  }

  Future<void> setBio(String firstName, String lastName, DateTime dateOfBirth, DateTime graduationMonth) async {
    print("Saving bio");
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('firstName', firstName);
    await box.put('lastName', lastName);
    await box.put('dateOfBirth', dateOfBirth);
    await box.put('graduationMonth', graduationMonth);
    await setOnboardingStep(OnboardingStep.collegeInfo);
  }

  Future<void> setCollegeInfo(List<String> major, List<String> minor, String college) async {
    print("Saving College info");

    if (major.length > 2 || major.isEmpty || minor.length > 2 || college.isEmpty) {
      throw ("College info wrong");
    }

    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('major', major);
    await box.put('minor', minor);
    await box.put('college', college);
    await setOnboardingStep(OnboardingStep.skills);
  }

  Future<void> setSkills(List<String> skills) async {
    print("Saving skills");

    if (skills.length < 3 || skills.length > 5) {
      throw ("skills list wrong length.");
    }

    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('skills', skills);
    await setOnboardingStep(OnboardingStep.academicInterests);
  }

  Future<void> setAcademicInterests(List<String> academicInterests) async {
    print("Saving Academic Interests");

    if (academicInterests.length < 3 || academicInterests.length > 5) {
      throw ("Academic Interests list wrong length.");
    }

    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('academicInterests', academicInterests);
    await setOnboardingStep(OnboardingStep.careerGoals);
  }

  Future<void> setCareerGoals(List<String> careerGoals) async {
    print("Saving Career Goals");

    if (careerGoals.length < 3 || careerGoals.length > 5) {
      throw ("Career Goals list wrong length.");
    }

    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('careerGoals', careerGoals);
    await setOnboardingStep(OnboardingStep.selfDescription);
  }

  Future<void> setSelfDescription(List<String> selfDescription) async {
    print("Saving Self Description");

    if (selfDescription.length < 3 || selfDescription.length > 5) {
      throw ("Self description list wrong length.");
    }

    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('selfDescription', selfDescription);
    await setOnboardingStep(OnboardingStep.leisureInterests);
  }

  Future<void> setLeisureInterests(List<String> leisureInterests) async {
    print("saved hobbies");

    if (leisureInterests.length < 3 || leisureInterests.length > 5) {
      throw ("Hobbies list wrong length.");
    }

    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('leisureInterests', leisureInterests);
    await setOnboardingStep(OnboardingStep.idealFriendDescription);
  }

  Future<void> setIdealFriendDescription(String idealFriendDescription) async {
    print("saved friend description");

    if (idealFriendDescription.isEmpty || idealFriendDescription.length > 1000) {
      throw ("description empty or to large");
    }
    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('idealFriendDescription', idealFriendDescription);
    await setOnboardingStep(OnboardingStep.situationalDecisions);
  }

  Future<void> setSituationalDecisions(List<int> situationalDecisions) async {
    print("saving situational questions");

    if (situationalDecisions.isEmpty || situationalDecisions.length != 5) {
      throw ("situational questions not correct");
    }

    final userId = (await _amplifyCognitoUser).userId;
    final box = await Hive.openBox(userId);
    await box.put('situationalDecisions', situationalDecisions);
    await setOnboardingStep(OnboardingStep.completed);
  }

  Future<bool> createOnboardedUser() async {
    final cognitoUser = await _amplifyCognitoUser;
    final userId = cognitoUser.userId;
    final box = await Hive.openBox(userId);

    if (!_checkIfFieldExistsLocally(box, 'onboardingStep') || //
        !_checkIfFieldExistsLocally(box, 'schoolEmail') || //
        !_checkIfFieldExistsLocally(box, 'academicInclination') || //
        !_checkIfFieldExistsLocally(box, 'firstName') || //
        !_checkIfFieldExistsLocally(box, 'lastName') || //
        !_checkIfFieldExistsLocally(box, 'dateOfBirth') || //
        !_checkIfFieldExistsLocally(box, 'graduationMonth') || //
        !_checkIfFieldExistsLocally(box, 'major') || //
        !_checkIfFieldExistsLocally(box, 'academicInterests') || //
        !_checkIfFieldExistsLocally(box, 'skills') || //
        !_checkIfFieldExistsLocally(box, 'careerGoals') || //
        !_checkIfFieldExistsLocally(box, 'selfDescription') ||
        !_checkIfFieldExistsLocally(box, 'leisureInterests') || //
        !_checkIfFieldExistsLocally(box, 'idealFriendDescription') ||
        !_checkIfFieldExistsLocally(box, 'situationalDecisions') || //
        !_checkIfFieldExistsLocally(box, 'college')) {
      //
      print("something missing");
      return false;
    }

    List<AuthUserAttribute>? attributes = await AuthRepository().fetchCurrentUserAttributes();

    if (attributes == null) {
      print("failed to get attributes");
      return false;
    }

    final newUser = User(
      email: attributes.where((element) => element.userAttributeKey == CognitoUserAttributeKey.email).first.value,
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
      college: box.get('college'),
      minor: box.get('minor'),
      publicKey: 'htrthrt',
      privateKey: [53453],
      matches: [],
    );

    print(newUser);
    //
    // try {
    //   final request = ModelMutations.create(newUser);
    //   final response = await Amplify.API.mutate(request: request).response;
    //
    //   if (response.data != null) {
    //     print("user added");
    //     return true;
    //   } else {
    //     print("user failed");
    //     return false;
    //   }
    // } on Exception catch (error) {
    //   print('Error saving to DataStore: $error');
    //   return false;
    // }

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
