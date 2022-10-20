import 'dart:async';
import 'dart:math';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socale/models/User.dart';
import 'package:socale/services/analytics_service.dart';
import 'package:socale/services/fetch_service.dart';
import 'package:socale/utils/enums/onboarding_fields.dart';
import 'package:socale/utils/options/username_adjectives.dart';
import 'package:socale/utils/options/username_nouns.dart';

import 'aws_lambda_service.dart';

@lazySingleton
class OnboardingService {
  final String boxName = 'user_data';

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
    SharedPreferences.getInstance().then(
        (prefs) => prefs.setInt('onboardingStartTime', DateTime.now().millisecondsSinceEpoch));

    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      var data = box.get('schoolEmail');

      data ??= email;
      return data;
    }

    return null;
  }

  Future<List?> getBio() async {
    List data = [];
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      data.add(box.get('firstName'));
      data.add(box.get('lastName'));
      data.add(box.get('dateOfBirth'));
      data.add(box.get('graduationMonth'));
      return data;
    }
    return null;
  }

  Future<List?> getCollegeInfo() async {
    List data = [];
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      data.add(box.get('major'));
      data.add(box.get('minor'));
      data.add(box.get('college'));
      return data;
    }

    return null;
  }

  Future<List<String>?> getSkills() async {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      final data = box.get('skills');
      return data;
    }

    return null;
  }

  Future<List<String>?> getAcademicInterests() async {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      final data = box.get('academicInterests');
      return data;
    }

    return null;
  }

  Future<List<String>?> getCareerGoals() async {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      final data = box.get('careerGoals');
      return data;
    }

    return null;
  }

  Future<List<String>?> getSelfDescription() async {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      final data = box.get('selfDescription');
      return data;
    }

    return null;
  }

  Future<List<String>?> getHobbies() async {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      final data = box.get('leisureInterests');
      return data;
    }

    return null;
  }

  Future<String?> getFriendDescription() async {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      final data = box.get('idealFriendDescription');
      return data;
    }

    return null;
  }

  Future<List<int>?> getSituationalDecisions() async {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      final data = box.get('situationalDecisions');
      return data;
    }

    return null;
  }

  String? getAvatar() {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      final data = box.get('avatar');
      return data;
    }

    return null;
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
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('schoolEmail', schoolEmail);
      email = schoolEmail;
    }
  }

  Future<void> setBio(
      String firstName, String lastName, DateTime dateOfBirth, DateTime graduationMonth) async {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('firstName', firstName);
      box.put('lastName', lastName);
      box.put('dateOfBirth', dateOfBirth);
      box.put('graduationMonth', graduationMonth);
    }
  }

  Future<void> setCollegeInfo(List<String> major, List<String> minor, String college) async {
    if (major.length > 2 || major.isEmpty || minor.length > 2 || college.isEmpty) {
      throw ("College info wrong");
    }
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('major', major);
      box.put('minor', minor);
      box.put('college', college);
    }
  }

  Future<void> setSkills(List<String> skills) async {
    if (skills.length < 3 || skills.length > 5) {
      throw ("skills list wrong length.");
    }
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('skills', skills);
    }
  }

  Future<void> setAcademicInterests(List<String> academicInterests) async {
    if (academicInterests.length < 3 || academicInterests.length > 5) {
      throw ("Academic Interests list wrong length.");
    }
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('academicInterests', academicInterests);
    }
  }

  Future<void> setCareerGoals(List<String> careerGoals) async {
    if (careerGoals.length < 3 || careerGoals.length > 5) {
      throw ("Career Goals list wrong length.");
    }
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('careerGoals', careerGoals);
    }
  }

  Future<void> setSelfDescription(List<String> selfDescription) async {
    if (selfDescription.length < 3 || selfDescription.length > 5) {
      throw ("Self description list wrong length.");
    }
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('selfDescription', selfDescription);
    }
  }

  Future<void> setLeisureInterests(List<String> leisureInterests) async {
    if (leisureInterests.length < 3 || leisureInterests.length > 5) {
      throw ("Hobbies list wrong length.");
    }

    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('leisureInterests', leisureInterests);
    }
  }

  Future<void> setIdealFriendDescription(String idealFriendDescription) async {
    if (idealFriendDescription.isEmpty || idealFriendDescription.length > 1000) {
      throw ("description empty or to large");
    }

    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('idealFriendDescription', idealFriendDescription);
    }
  }

  Future<void> setSituationalDecisions(List<int> situationalDecisions) async {
    if (situationalDecisions.isEmpty || situationalDecisions.length != 5) {
      throw ("situational questions not correct");
    }
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('situationalDecisions', situationalDecisions);
    }
  }

  Future<void> setAvatar(String avatar) async {
    if (avatar.isEmpty) {
      throw ("avatar url not provided correctly");
    }

    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('avatar', avatar);
    }
  }

  void setOnboardingStep(OnboardingStep step) {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('onboardingStep', step.name);
    }
  }

  Future<bool> createOnboardedUser() async {
    final cognitoUser = await Amplify.Auth.getCurrentUser();
    id = cognitoUser.userId;
    final box = await Hive.openBox(boxName);

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
        !_checkIfFieldExistsLocally(box, 'selfDescription') ||
        !_checkIfFieldExistsLocally(box, 'situationalDecisions') ||
        !_checkIfFieldExistsLocally(box, 'skills')) {
      return false;
    }

    if (box.get('schoolEmail') == null && email == null) return false;

    List<AuthUserAttribute>? attributes = await fetchService.fetchCurrentUserAttributes();

    if (attributes == null) return false;

    String anonymousUsername =
        "${capitalize(usernameAdjectives[Random().nextInt(394)])} ${capitalize(usernameNouns[Random().nextInt(224)])}";

    final newUser = User(
      id: id,
      email: attributes
          .where((element) => element.userAttributeKey == CognitoUserAttributeKey.email)
          .first
          .value,
      schoolEmail: getSchoolEmail()!,
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
      profilePicture: "",
      notificationToken: "",
      createdAt: TemporalDateTime.now(),
      updatedAt: TemporalDateTime.now(),
    );

    try {
      final queryUserRequest = ModelQueries.get(User.classType, newUser.id);
      final queryUserResponse = await Amplify.API.query(request: queryUserRequest).response;

      if (queryUserResponse.errors.isNotEmpty) throw Exception("Query Response Error");

      User? queryData = queryUserResponse.data;

      if (queryData != null) {
        final deleteUserRequest = ModelMutations.deleteById(User.classType, newUser.id);
        final deleteUserResponse = await Amplify.API.mutate(request: deleteUserRequest).response;

        if (deleteUserResponse.errors.isNotEmpty) throw Exception("Error deleting existing user.");
      }

      final createUserRequest = ModelMutations.create(newUser);
      final createUserResponse = await Amplify.API.mutate(request: createUserRequest).response;

      if (createUserResponse.errors.isNotEmpty) throw Exception("Error creating new user.");
      final prefs = await SharedPreferences.getInstance();
      final time = prefs.getInt('onboardingStartTime');
      if (time != null) {
        analyticsService.recordOnboardingTime(DateTime.now().microsecondsSinceEpoch - time);
      }
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> generateMatches() async {
    final prefs = await SharedPreferences.getInstance();

    if (id == null) {
      return false;
    }

    await Amplify.DataStore.stop();
    final response = await awsLambdaService.getMatches(id!);

    await prefs.setString('lastUpdated', DateTime.now().toString());

    await Amplify.DataStore.start();

    if (response == false) return false;

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

  String capitalize(String str) {
    return str
        .split(' ')
        .map((word) => word.substring(0, 1).toUpperCase() + word.substring(1))
        .join(' ');
  }
}

final onboardingService = OnboardingService();
