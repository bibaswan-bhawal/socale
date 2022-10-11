import 'dart:math';

import 'package:flutter/material.dart';
import 'package:socale/components/shimmer.dart';
import 'package:socale/components/shimmer_loading.dart';

import '../utils/constraints/constraints.dart';
import '../values/colors.dart';

class ChatLoading extends StatefulWidget {
  const ChatLoading({Key? key}) : super(key: key);

  @override
  State<ChatLoading> createState() => _ChatLoadingState();
}

class _ChatLoadingState extends State<ChatLoading> {
  List<double> randomHeights = [
    (Random().nextInt(60)).toDouble(),
    (Random().nextInt(60)).toDouble(),
    (Random().nextInt(60)).toDouble(),
    (Random().nextInt(60)).toDouble(),
    (Random().nextInt(60)).toDouble(),
    (Random().nextInt(60)).toDouble(),
    (Random().nextInt(60)).toDouble(),
    (Random().nextInt(60)).toDouble(),
    (Random().nextInt(60)).toDouble(),
    (Random().nextInt(60)).toDouble()
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Container(
              width: size.width,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xFF1D1C17),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 70),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Shimmer(
              linearGradient: ColorValues.shimmerGradientDark,
              min: -0.5,
              max: 1.5,
              duration: 3000,
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  reverse: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ShimmerLoading(
                      isLoading: true,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: index % 3 == 0 ? 15 : 5),
                        child: Align(
                          alignment: index % 3 == 0
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                bottomLeft: index % 3 == 0
                                    ? Radius.circular(0)
                                    : Radius.circular(25),
                                bottomRight: index % 3 == 0
                                    ? Radius.circular(25)
                                    : Radius.circular(0),
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                            ),
                            width: size.width * 0.6,
                            height: 40 + randomHeights[index],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ),
        Shimmer(
          max: 1,
          min: -0.5,
          duration: 2000,
          linearGradient: ColorValues.shimmerGradientDark,
          child: Material(
            elevation: 4,
            child: Container(
              height: constraints.chatPageAppBarHeight,
              width: size.width,
              color: Color(0xFF292B2F),
              child: Padding(
                padding: EdgeInsets.only(top: 40, left: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      splashColor: Colors.transparent,
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                    ),
                    ShimmerLoading(
                      isLoading: true,
                      child: ClipOval(
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerLoading(
                            isLoading: true,
                            child: Container(
                              margin: EdgeInsets.only(top: 18, bottom: 8),
                              width: 180,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          ShimmerLoading(
                            isLoading: true,
                            child: Container(
                              margin: EdgeInsets.only(),
                              width: 135,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
