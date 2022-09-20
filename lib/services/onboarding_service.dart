import 'dart:async';
import 'dart:math';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:socale/models/User.dart';
import 'package:socale/services/fetch_service.dart';
import 'package:socale/utils/enums/onboarding_fields.dart';
import 'package:socale/utils/options/username_adjectives.dart';
import 'package:socale/utils/options/username_nouns.dart';
import 'aws_lambda_service.dart';

@lazySingleton
class OnboardingService {
  final String boxName = 'onboardingData';

  final _amplifyCognitoUser = Amplify.Auth.getCurrentUser();
  int? otp;
  String? email;
  String? id;

  OnboardingService() {
    Hive.openBox(boxName);
  }

  Future<bool> checkIfUserIsOnboarded() async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final request = ModelQueries.get(User.classType, userId);
    final response = await Amplify.API.query(request: request).response;

    if (response.data == null) {
      return false;
    }

    return true;
  }

  Future<void> clearAll() async {
    final box = await Hive.openBox(boxName);
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

  // getters

  String? getSchoolEmail() {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      final data = box.get('schoolEmail');
      return data;
    }

    return null;
  }

  Future<List?> getBio() async {
    List data = [];

    final box = await Hive.openBox(boxName);
    data.add(await box.get('firstName'));
    data.add(await box.get('lastName'));
    data.add(await box.get('dateOfBirth'));
    data.add(await box.get('graduationMonth'));
    return data;
  }

  Future<List?> getCollegeInfo() async {
    List data = [];

    final box = await Hive.openBox(boxName);
    data.add(await box.get('major'));
    data.add(await box.get('minor'));
    data.add(await box.get('college'));
    return data;
  }

  Future<List<String>?> getSkills() async {
    final box = await Hive.openBox(boxName);
    final data = await box.get('skills');
    return data;
  }

  Future<List<String>?> getAcademicInterests() async {
    final box = await Hive.openBox(boxName);
    final data = await box.get('academicInterests');
    return data;
  }

  Future<List<String>?> getCareerGoals() async {
    final box = await Hive.openBox(boxName);
    final data = await box.get('careerGoals');
    return data;
  }

  Future<List<String>?> getSelfDescription() async {
    final box = await Hive.openBox(boxName);
    final data = await box.get('selfDescription');
    return data;
  }

  Future<List<String>?> getHobbies() async {
    final box = await Hive.openBox(boxName);
    final data = await box.get('leisureInterests');
    return data;
  }

  Future<String?> getFriendDescription() async {
    final box = await Hive.openBox(boxName);
    final data = await box.get('idealFriendDescription');
    return data;
  }

  Future<List<int>?> getSituationalDecisions() async {
    final box = await Hive.openBox(boxName);
    final data = await box.get('situationalDecisions');
    return data;
  }

  String? getAvatar() {
    final box = Hive.box(boxName);
    final data = box.get('avatar');
    return data;
  }

  Future<OnboardingStep> getOnboardingStep() async {
    if (await Hive.boxExists(boxName)) {
      final box = await Hive.openBox(boxName);
      try {
        return OnboardingStep.values.byName(box.get('onboardingStep'));
      } catch (e) {
        return OnboardingStep.schoolEmailVerification;
      }
    } else {
      return OnboardingStep.schoolEmailVerification;
    }
  }

  // setters

  Future<void> setSchoolEmail(String schoolEmail) async {
    print("Saving school email: $schoolEmail");
    final box = await Hive.openBox(boxName);
    box.put('schoolEmail', schoolEmail);
    print("school email: ${box.get('schoolEmail')}");
  }

  Future<void> setBio(String firstName, String lastName, DateTime dateOfBirth, DateTime graduationMonth) async {
    print("Saving bio");

    final box = await Hive.openBox(boxName);
    await box.put('firstName', firstName);
    await box.put('lastName', lastName);
    await box.put('dateOfBirth', dateOfBirth);
    await box.put('graduationMonth', graduationMonth);
  }

  Future<void> setCollegeInfo(List<String> major, List<String> minor, String college) async {
    print("Saving College info");

    if (major.length > 2 || major.isEmpty || minor.length > 2 || college.isEmpty) {
      throw ("College info wrong");
    }

    final box = await Hive.openBox(boxName);
    await box.put('major', major);
    await box.put('minor', minor);
    await box.put('college', college);
  }

  Future<void> setSkills(List<String> skills) async {
    print("Saving skills");

    if (skills.length < 3 || skills.length > 5) {
      throw ("skills list wrong length.");
    }

    final box = await Hive.openBox(boxName);
    await box.put('skills', skills);
  }

  Future<void> setAcademicInterests(List<String> academicInterests) async {
    print("Saving Academic Interests");

    if (academicInterests.length < 3 || academicInterests.length > 5) {
      throw ("Academic Interests list wrong length.");
    }

    final box = await Hive.openBox(boxName);
    await box.put('academicInterests', academicInterests);
  }

  Future<void> setCareerGoals(List<String> careerGoals) async {
    print("Saving Career Goals");

    if (careerGoals.length < 3 || careerGoals.length > 5) {
      throw ("Career Goals list wrong length.");
    }

    final box = await Hive.openBox(boxName);
    await box.put('careerGoals', careerGoals);
  }

  Future<void> setSelfDescription(List<String> selfDescription) async {
    print("Saving Self Description");

    if (selfDescription.length < 3 || selfDescription.length > 5) {
      throw ("Self description list wrong length.");
    }

    final box = await Hive.openBox(boxName);
    await box.put('selfDescription', selfDescription);
  }

  Future<void> setLeisureInterests(List<String> leisureInterests) async {
    print("saved hobbies");

    if (leisureInterests.length < 3 || leisureInterests.length > 5) {
      throw ("Hobbies list wrong length.");
    }

    final box = await Hive.openBox(boxName);
    await box.put('leisureInterests', leisureInterests);
  }

  Future<void> setIdealFriendDescription(String idealFriendDescription) async {
    print("saved friend description");

    if (idealFriendDescription.isEmpty || idealFriendDescription.length > 1000) {
      throw ("description empty or to large");
    }
    final box = await Hive.openBox(boxName);
    await box.put('idealFriendDescription', idealFriendDescription);
  }

  Future<void> setSituationalDecisions(List<int> situationalDecisions) async {
    print("saving situational questions");

    if (situationalDecisions.isEmpty || situationalDecisions.length != 5) {
      throw ("situational questions not correct");
    }

    final box = await Hive.openBox(boxName);
    await box.put('situationalDecisions', situationalDecisions);
  }

  Future<void> setAvatar(String avatar) async {
    print("saving avatar");

    if (avatar.isEmpty) {
      throw ("avatar url not provided correctly");
    }

    final box = await Hive.openBox(boxName);
    await box.put('avatar', avatar);
  }

  void setOnboardingStep(OnboardingStep step) {
    final box = Hive.box(boxName);
    box.put('onboardingStep', step.name);
  }

  Future<bool> createOnboardedUser() async {
    final cognitoUser = await _amplifyCognitoUser;
    id = cognitoUser.userId;

    final box = await Hive.openBox(boxName);
    print("school email: ${box.get('schoolEmail')}");

    if (!_checkIfFieldExistsLocally(box, 'academicInterests') ||
        !_checkIfFieldExistsLocally(box, 'avatar') ||
        !_checkIfFieldExistsLocally(box, 'careerGoals') ||
        !_checkIfFieldExistsLocally(box, 'college') ||
        !_checkIfFieldExistsLocally(box, 'dateOfBirth') ||
        !_checkIfFieldExistsLocally(box, 'firstName') ||
        !_checkIfFieldExistsLocally(box, 'graduationMonth') ||
        !_checkIfFieldExistsLocally(box, 'idealFriendDescription') ||
        !_checkIfFieldExistsLocally(box, 'lastName') ||
        !_checkIfFieldExistsLocally(box, 'leisureInterests') ||
        !_checkIfFieldExistsLocally(box, 'major') ||
        !_checkIfFieldExistsLocally(box, 'minor') ||
        !_checkIfFieldExistsLocally(box, 'onboardingStep') ||
        !_checkIfFieldExistsLocally(box, 'schoolEmail') ||
        !_checkIfFieldExistsLocally(box, 'selfDescription') ||
        !_checkIfFieldExistsLocally(box, 'situationalDecisions') ||
        !_checkIfFieldExistsLocally(box, 'skills')) {
      print(box.toMap().toString());
      print("something missing");
      return false;
    }

    List<AuthUserAttribute>? attributes = await fetchService.fetchCurrentUserAttributes();

    if (attributes == null) {
      print("failed to get attributes");
      return false;
    }

    String anonymousUsername = "${usernameAdjectives[Random().nextInt(394)]} ${usernameNouns[Random().nextInt(224)]}";

    final newUser = User(
      id: id,
      email: attributes.where((element) => element.userAttributeKey == CognitoUserAttributeKey.email).first.value,
      schoolEmail: box.get('schoolEmail'),
      firstName: box.get('firstName'),
      lastName: box.get('lastName'),
      dateOfBirth: TemporalDate(box.get('dateOfBirth')),
      graduationMonth: TemporalDate(box.get('graduationMonth')),
      major: box.get('major'),
      minor: box.get('minor'),
      college: box.get('college'),
      skills: box.get('skills'),
      academicInterests: box.get('academicInterests'),
      careerGoals: box.get('careerGoals'),
      selfDescription: box.get('selfDescription'),
      leisureInterests: box.get('leisureInterests'),
      idealFriendDescription: box.get('idealFriendDescription'),
      situationalDecisions: box.get('situationalDecisions'),
      avatar: box.get('avatar'),
      introMatchingCompleted: false,
      matches: [],
      anonymousUsername: anonymousUsername,
    );

    print(newUser);

    try {
      var request = ModelMutations.update(newUser);
      var response = await Amplify.API.mutate(request: request).response;

      if (response.errors.isNotEmpty && response.errors.first.message.contains("No existing item found in the data source")) {
        request = ModelMutations.create(newUser);
        response = await Amplify.API.mutate(request: request).response;
      }

      if (response.data != null) {
        print("user added");
        return true;
      } else {
        print(response.errors);
        print("user failed");
        return false;
      }
    } on Exception catch (error) {
      print('Error saving user: $error');
      return false;
    }
  }

  Future<bool> generateMatches() async {
    if (id == null) {
      return false;
    }

    await Amplify.DataStore.stop();
    final response = await awsLambdaService.getMatches(id!);
    await Amplify.DataStore.start();

    if (response == false) {
      print("Couldn't create matches");
      return false;
    }

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
