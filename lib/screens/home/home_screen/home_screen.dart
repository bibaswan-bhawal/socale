import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:socale/theme/colors.dart';
import 'package:socale/theme/size_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: SocaleColors.bottomNavigationBarColor,
        height: MediaQuery.of(context).padding.bottom +
            kBottomNavigationBarHeight +
            sText * 8,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.home,
                color: SocaleColors.highlightColor,
                size: sText * 8,
              ),
              Icon(Icons.group,
                  color: SocaleColors.unHighighlitedBottomBarItemColor,
                  size: sText * 8),
              Transform.translate(
                offset: Offset(0, -sText * 8),
                child: Container(
                  decoration: ShapeDecoration(
                    color: SocaleColors.bottomNavigationBarColor,
                    shape: PolygonShapeBorder(
                      border: DynamicBorderSide(
                        style: BorderStyle.solid,
                        width: 1,
                        gradient: SocaleGradients.mainBackgroundGradient,
                      ),
                      sides: 3,
                      cornerRadius: 30.toPercentLength,
                      cornerStyle: CornerStyle.rounded,
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(sText * 8),
                    child: Icon(
                      Icons.crop_square_sharp,
                      color: SocaleColors.highlightColor,
                      size: sText * 6,
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.bar_chart,
                color: SocaleColors.unHighighlitedBottomBarItemColor,
                size: sText * 8,
              ),
              Icon(
                Icons.account_circle,
                color: SocaleColors.unHighighlitedBottomBarItemColor,
                size: sText * 8,
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: TextButton(
            onPressed: () async {
              // TODO: Remove this
              await FirebaseAuth.instance.signOut();
              print('Signed out');
            },
            child: Text('Sign Out')),
      ),
    );
  }
}
