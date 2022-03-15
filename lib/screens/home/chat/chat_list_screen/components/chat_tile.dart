import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../theme/colors.dart';
import '../../../../../theme/size_config.dart';
import '../../../../../theme/text_styles.dart';
import '../../../../components/gap.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({Key? key, this.message}) : super(key: key);

  final dynamic message;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Get.toNamed('/chat'),
      title: Container(
        height: sx * 11,
        width: sy * 80,
        padding: EdgeInsets.symmetric(
          vertical: sx * 2,
          horizontal: sy * 3,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          color: SocaleColors.bottomNavigationBarColor,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: sx * 4,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                FirebaseAuth.instance.currentUser!.photoURL!,
              ),
            ),
            Gap(width: 3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ronin',
                    style: SocaleTextStyles.chatHeading,
                  ),
                  Gap(height: 1),
                  Expanded(
                    child: Text(
                      message!.toString().length > 100
                          ? message!.toString().substring(0, 100) + '...'
                          : message!.toString(),
                      overflow: TextOverflow.fade,
                      style: SocaleTextStyles.supportingText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
