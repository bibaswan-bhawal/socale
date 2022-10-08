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
  final String boxName = 'user_data';

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
    if (Hive.isBoxOpen(boxName)) {}
    final box = Hive.box(boxName);
    final data = box.get('selfDescription');
    return data;
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
    print("Saving school email: $schoolEmail");

    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('schoolEmail', schoolEmail);
      email = schoolEmail;
      print("school email: ${getSchoolEmail()}");
    }
  }

  Future<void> setBio(String firstName, String lastName, DateTime dateOfBirth, DateTime graduationMonth) async {
    print("Saving bio");
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('firstName', firstName);
      box.put('lastName', lastName);
      box.put('dateOfBirth', dateOfBirth);
      box.put('graduationMonth', graduationMonth);
      print("school email: ${getSchoolEmail()}");
    }
  }

  Future<void> setCollegeInfo(List<String> major, List<String> minor, String college) async {
    print("Saving College info");

    if (major.length > 2 || major.isEmpty || minor.length > 2 || college.isEmpty) {
      throw ("College info wrong");
    }
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('major', major);
      box.put('minor', minor);
      box.put('college', college);
      print("school email: ${getSchoolEmail()}");
    }
  }

  Future<void> setSkills(List<String> skills) async {
    print("Saving skills");

    if (skills.length < 3 || skills.length > 5) {
      throw ("skills list wrong length.");
    }
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('skills', skills);
      print("school email: ${getSchoolEmail()}");
    }
  }

  Future<void> setAcademicInterests(List<String> academicInterests) async {
    print("Saving Academic Interests");

    if (academicInterests.length < 3 || academicInterests.length > 5) {
      throw ("Academic Interests list wrong length.");
    }
    if (Hive.isBoxOpen(boxName)) {
      final box = await Hive.box(boxName);
      box.put('academicInterests', academicInterests);
      print("school email: ${getSchoolEmail()}");
    }
  }

  Future<void> setCareerGoals(List<String> careerGoals) async {
    print("Saving Career Goals");

    if (careerGoals.length < 3 || careerGoals.length > 5) {
      throw ("Career Goals list wrong length.");
    }
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('careerGoals', careerGoals);
      print("school email: ${getSchoolEmail()}");
    }
  }

  Future<void> setSelfDescription(List<String> selfDescription) async {
    print("Saving Self Description");

    if (selfDescription.length < 3 || selfDescription.length > 5) {
      throw ("Self description list wrong length.");
    }
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('selfDescription', selfDescription);
      print("school email: ${getSchoolEmail()}");
    }
  }

  Future<void> setLeisureInterests(List<String> leisureInterests) async {
    print("saved hobbies");

    if (leisureInterests.length < 3 || leisureInterests.length > 5) {
      throw ("Hobbies list wrong length.");
    }

    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('leisureInterests', leisureInterests);
      print("school email: ${getSchoolEmail()}");
    }
  }

  Future<void> setIdealFriendDescription(String idealFriendDescription) async {
    print("saved friend description");

    if (idealFriendDescription.isEmpty || idealFriendDescription.length > 1000) {
      throw ("description empty or to large");
    }

    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('idealFriendDescription', idealFriendDescription);
      print("school email: ${getSchoolEmail()}");
    }
  }

  Future<void> setSituationalDecisions(List<int> situationalDecisions) async {
    print("saving situational questions");

    if (situationalDecisions.isEmpty || situationalDecisions.length != 5) {
      throw ("situational questions not correct");
    }
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('situationalDecisions', situationalDecisions);
      print("school email: ${getSchoolEmail()}");
    }
  }

  Future<void> setAvatar(String avatar) async {
    print("saving avatar");

    if (avatar.isEmpty) {
      throw ("avatar url not provided correctly");
    }

    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('avatar', avatar);
      print("school email: ${getSchoolEmail()}");
    }
  }

  void setOnboardingStep(OnboardingStep step) {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      box.put('onboardingStep', step.name);
      print("school email: ${getSchoolEmail()}");
    }
  }

  Future<bool> createOnboardedUser() async {
    final cognitoUser = await _amplifyCognitoUser;
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
      print(box.toMap().toString());
      print("something missing");
      return false;
    }

    if (box.get('schoolEmail') == null && email == null) {
      print('school email missing');
      return false;
    }

    List<AuthUserAttribute>? attributes = await fetchService.fetchCurrentUserAttributes();

    if (attributes == null) {
      print("failed to get attributes");
      return false;
    }

    String anonymousUsername = "${capitalize(usernameAdjectives[Random().nextInt(394)])} ${capitalize(usernameNouns[Random().nextInt(224)])}";

    final newUser = User(
      id: id,
      email: attributes.where((element) => element.userAttributeKey == CognitoUserAttributeKey.email).first.value,
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

    print(newUser);

    try {
      List<User> userList = await Amplify.DataStore.query(User.classType, where: User.ID.eq(id));

      if(userList.isEmpty){
        await Amplify.DataStore.save(newUser);
      } else {
        for (User oldUser in userList){
          await Amplify.DataStore.delete(oldUser);
        }
        await Amplify.DataStore.save(newUser);
      }

      print("user added");
      return true;
    } catch (e) {
      print("Creating user failed: $e");
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

  String capitalize(String str) {
    return str.split(' ').map((word) => word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ');
  }
}

final onboardingService = OnboardingService();
