import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/gap.dart';

class AccountScreen extends ConsumerWidget {
  final String userId;
  const AccountScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                        value: true,
                        onChanged: (value) {},
                      ),
                      Text('View mode'),
                    ],
                  )
                ],
              ),
              Gap(height: 2),
              CircleAvatar()
            ],
          ),
        ),
      ),
    );
  }
}
