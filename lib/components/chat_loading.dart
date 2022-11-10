import 'package:flutter/material.dart';
import 'package:socale/components/shimmer.dart';
import 'package:socale/components/shimmer_loading.dart';

import '../values/colors.dart';

class ChatLoading extends StatefulWidget {
  final bool isLoading;
  const ChatLoading({Key? key, required this.isLoading}) : super(key: key);

  @override
  State<ChatLoading> createState() => _ChatLoadingState();
}

class _ChatLoadingState extends State<ChatLoading> {
  List<double> randomHeights = [40, 55, 25, 34, 41, 60, 10, 13, 37, 52];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double barHeight = size.height * 0.1;

    return Stack(
      children: [
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
                      isLoading: widget.isLoading,
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
              height: barHeight + MediaQuery.of(context).padding.top * 0.5,
              width: size.width,
              color: Color(0xFF292B2F),
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      splashColor: Colors.transparent,
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: (barHeight / 2) * 0.6,
                      ),
                    ),
                    ShimmerLoading(
                      isLoading: widget.isLoading,
                      child: ClipOval(
                        child: Container(
                          width: barHeight / 2,
                          height: barHeight / 2,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.035),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShimmerLoading(
                            isLoading: widget.isLoading,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 6),
                              width: 160,
                              height: barHeight * 0.2,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          ShimmerLoading(
                            isLoading: widget.isLoading,
                            child: Container(
                              margin: EdgeInsets.only(),
                              width: 120,
                              height: barHeight * 0.12,
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
              height: size.height * 0.1,
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
      ],
    );
  }
}
