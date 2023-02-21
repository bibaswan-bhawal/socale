import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:socale/components/buttons/Action_group.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/cards/chip_card.dart';
import 'package:socale/models/current_user.dart';
import 'package:socale/options/majors/ucsd_majors.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/utils/system_ui.dart';

class BasicInfoPage extends ConsumerStatefulWidget {
  const BasicInfoPage({Key? key}) : super(key: key);

  @override
  ConsumerState<BasicInfoPage> createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends ConsumerState<BasicInfoPage> {
  @override
  void initState() {
    super.initState();
    SystemUI.setSystemUIDark();
  }

  fetchData() async {
    final startTime = DateTime.now();

    CurrentUser currentUser = ref.read(currentUserProvider);

    final response = await http.get(
      Uri.parse('http://192.168.1.91:3000/post'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${currentUser.idToken.raw}',
      },
    );

    if (response.statusCode == 401) {
      if (kDebugMode) {
        print('Not Authorized');
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }

    final endTime = DateTime.now();

    if (kDebugMode) print('Total fetch time: ${endTime.difference(startTime).inMilliseconds}');
  }

  @override
  Widget build(BuildContext context) {
    fetchData();

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  AuthService.signOutUser();
                  ref.read(appStateProvider.notifier).signOut();
                },
                child: const Text('Sign Out'),
              ),
            ),
          ),
          const ChipCard(
            emptyMessage: 'Add your Major',
            height: 160,
            horizontalPadding: 30,
            options: ucsdMajors,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 36,
              bottom: 40 - MediaQuery.of(context).viewPadding.bottom,
            ),
            child: ActionGroup(
              actions: [
                GradientButton(
                  text: 'Continue',
                  onPressed: () {},
                  linearGradient: ColorValues.orangeButtonGradient,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
