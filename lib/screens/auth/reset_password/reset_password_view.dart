import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/screens/auth/reset_password/reset_password_screen.dart';

abstract class ResetPasswordView extends ConsumerStatefulWidget {
  const ResetPasswordView({super.key});

  static List<ResetPasswordViewState> allResetPasswordViews(BuildContext context) {
    final result = <ResetPasswordViewState>[];

    void visitor(Element element) {
      if (element.widget is ResetPasswordView) {
        final resetPasswordViewElement = element as StatefulElement;

        final ResetPasswordViewState resetPasswordViewState = resetPasswordViewElement.state as ResetPasswordViewState;

        result.add(resetPasswordViewState);
      }
      // Don't perform transitions across different Animated Page Views.
      if (element.widget is ResetPasswordScreen) return;

      element.visitChildren(visitor);
    }

    context.visitChildElements(visitor);

    return result;
  }
}

abstract class ResetPasswordViewState extends ConsumerState<ResetPasswordView> {
  Future<bool> onNext();

  Future<bool> onBack();
}
