import 'package:flutter/material.dart';
import 'package:socale/components/buttons/button.dart';
import 'package:socale/components/buttons/link_button.dart';

class ActionGroup extends StatelessWidget {
  final List<Button> actions;

  const ActionGroup({super.key, required this.actions});

  List<Widget> buildActions() {
    List<Widget> actionGroup = [];

    for (Button action in actions) {
      actionGroup.add(action);
      if (action != actions.last && action is! LinkButton) actionGroup.add(const SizedBox(height: 14));
    }

    return actionGroup;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: buildActions(),
      ),
    );
  }
}
