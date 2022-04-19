import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socale/models/user_data.dart';
import 'package:socale/riverpods/account/account_screen_providers.dart';
import 'package:socale/riverpods/global/user_data_provider.dart';
import 'package:socale/screens/home/account/components/account_chill_card.dart';
import 'package:socale/theme/colors.dart';
import 'package:socale/theme/size_config.dart';

import '../../../components/gap.dart';
import '../components/account_care_about_card.dart';
import '../components/account_personality_card.dart';

class AccountScreen extends HookConsumerWidget {
  final String userId;
  const AccountScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditModeEnabled = ref.watch(editModeStatusProvider);
    final userData = ref.watch(userDataProvider(userId));
    return Container(
      color: SocaleColors.homeBackgroundColor,
      child: Center(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sy * 2,
              vertical: sx * 2,
            ),
            child: userData.when(
              data: (data) => data != null
                  ? _dataLoadedScreen(data, isEditModeEnabled, ref)
                  : _userNotFoundScreen(),
              error: (error, stack) => Text('An unexpected error occurred'),
              loading: () => CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dataLoadedScreen(
      UserData userData, bool isEditModeEnabled, WidgetRef ref) {
    final chillCardHeight = useState(sx * 100);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('Basic info'),
              Gap(width: 2),
              Text('More info'),
              Spacer(),
              Column(
                children: [
                  Switch.adaptive(
                    value: isEditModeEnabled,
                    onChanged: (value) =>
                        ref.read(editModeStatusProvider.notifier).state = value,
                  ),
                  Text('Edit mode'),
                ],
              )
            ],
          ),
          Gap(height: 2),
          CircleAvatar(
            backgroundImage: NetworkImage(userData.imageUrl),
            radius: (sy * 40) / 2,
          ),
          Gap(height: 2),
          Text('Hi ' + userData.firstName + '! How are you doing?'),
          Text('We hope you are making great connections!'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('You are...'),
              Visibility(
                visible: isEditModeEnabled,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                maintainInteractivity: false,
                child: GestureDetector(
                  child: Icon(Icons.edit),
                ),
              ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: sy,
            children: [
              Chip(label: Text('17')),
              Chip(label: Text('Dartmouth')),
              Chip(label: Text('Computer Science')),
              Chip(label: Text('\'26')),
              Chip(label: Text('Male')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('I am...'),
              Visibility(
                visible: isEditModeEnabled,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                maintainInteractivity: false,
                child: GestureDetector(
                  child: Icon(Icons.edit),
                ),
              ),
            ],
          ),
          AccountPersonalityCard(emoji: '🎮', title: 'Gamer'),
          Gap(height: 1),
          AccountPersonalityCard(emoji: '🎉', title: 'Party Animal'),
          Gap(height: 1),
          AccountPersonalityCard(emoji: '🦉', title: 'Night Owl'),
          Gap(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Chill about...'),
              Visibility(
                visible: isEditModeEnabled,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                maintainInteractivity: false,
                child: GestureDetector(
                  child: Icon(Icons.edit),
                ),
              ),
            ],
          ),
          SizedBox(
            height: chillCardHeight.value.toDouble(),
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                AccountChillCard(
                  title: 'Weed Friendly',
                  height: chillCardHeight,
                ),
                Gap(width: 4),
                AccountChillCard(title: 'Weed Friendly'),
                Gap(width: 4),
                AccountChillCard(title: 'Weed Friendly'),
                Gap(width: 4),
                AccountChillCard(title: 'Weed Friendly'),
                Gap(width: 4),
                AccountChillCard(title: 'Weed Friendly'),
                Gap(width: 4),
                AccountChillCard(title: 'Weed Friendly'),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('I care a lot about...'),
              Visibility(
                visible: isEditModeEnabled,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                maintainInteractivity: false,
                child: GestureDetector(
                  child: Icon(Icons.edit),
                ),
              ),
            ],
          ),
          AccountCareAboutCard(),
          Gap(height: 1),
          AccountCareAboutCard(),
          Gap(height: 1),
          AccountCareAboutCard(),
          Gap(height: 1),
        ],
      ),
    );
  }

  Widget _userNotFoundScreen() {
    return Text('User not found');
  }
}
