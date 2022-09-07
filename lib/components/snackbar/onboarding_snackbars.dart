import 'package:flutter/material.dart';

class OnboardingSnackBar {
  void addMoreSkillsSnack(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final errorSnackBar = SnackBar(
      content: Text(
        "Add at least 3 skills",
        textAlign: TextAlign.left,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  void addMoreAcademicInterestsSnack(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final errorSnackBar = SnackBar(
      content: Text(
        "Add at least 3 academic interests",
        textAlign: TextAlign.left,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  void addMoreCareerGoalsSnack(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final errorSnackBar = SnackBar(
      content: Text(
        "Add at least 3 career goals",
        textAlign: TextAlign.left,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  void addSelfDescriptionsSnack(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final errorSnackBar = SnackBar(
      content: Text(
        "Add at least 3 descriptors",
        textAlign: TextAlign.left,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  void addMoreHobbiesSnack(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final errorSnackBar = SnackBar(
      content: Text(
        "Add at least 3 hobbies",
        textAlign: TextAlign.left,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  void addFriendSnack(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final errorSnackBar = SnackBar(
      content: Text(
        "Please describe your ideal friend",
        textAlign: TextAlign.left,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }
}

final onboardingSnackBar = OnboardingSnackBar();
