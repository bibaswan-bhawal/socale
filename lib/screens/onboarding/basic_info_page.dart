import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/cards/chip_card.dart';
import 'package:socale/providers/state_providers.dart';
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

  @override
  Widget build(BuildContext context) {
    final bottomPadding = 40 - MediaQuery.of(context).padding.bottom;

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
          const ChipCard(emptyMessage: 'Add your Major'),
        ],
      ),
    );
  }
}

class _DetailsPage extends StatelessWidget {
  final String message;
  const _DetailsPage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(message),
      ),
    );
  }
}
