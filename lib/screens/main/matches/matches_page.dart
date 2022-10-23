import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:socale/components/match_card/end_card.dart';
import 'package:socale/components/match_card/match_card.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:socale/values/colors.dart';

class MatchPage extends ConsumerStatefulWidget {
  const MatchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends ConsumerState<MatchPage> {
  CarouselController carouselController = CarouselController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final matchesProvider = ref.watch(matchAsyncController);

    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(top: mediaQuery.padding.top),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Image.asset(
              'assets/images/socale_logo_bw.png',
              height: 50,
              fit: BoxFit.fitHeight,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CarouselSlider(
                        carouselController: carouselController,
                        options: CarouselOptions(
                          height: constraints.maxHeight - 40,
                          viewportFraction: 1,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, _) => setState(() => pageIndex = index),
                        ),
                        items: matchesProvider.when(data: (data) {
                          List<Widget> matchCards = [];

                          data.forEach(
                            (user, matchData) {
                              matchCards.add(
                                LayoutBuilder(
                                  builder: (BuildContext context, BoxConstraints constraints) {
                                    return MatchCard(
                                      size: Size(constraints.maxWidth, constraints.maxHeight),
                                      user: user,
                                      match: matchData,
                                    );
                                  },
                                ),
                              );
                            },
                          );

                          matchCards.add(
                            LayoutBuilder(
                              builder: (BuildContext context, BoxConstraints constraints) {
                                return EndCard(
                                  size: Size(constraints.maxWidth, constraints.maxHeight),
                                );
                              },
                            ),
                          );
                          return matchCards;
                        }, error: (Object error, StackTrace? stackTrace) {
                          return [
                            Center(
                              child: Text("There was an error getting your matches"),
                            ),
                          ];
                        }, loading: () {
                          return [
                            Center(
                              child: SizedBox(
                                height: 54,
                                width: 54,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          ];
                        }),
                      ),
                      Container(
                        height: 20,
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: ColorValues.socaleDarkOrange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AnimatedSmoothIndicator(
                          activeIndex: pageIndex,
                          count: 5,
                          onDotClicked: (index) {
                            carouselController.animateToPage(index);
                          },
                          effect: ExpandingDotsEffect(
                            expansionFactor: 1.4,
                            dotHeight: 10,
                            dotWidth: 40,
                            dotColor: ColorValues.elementColor.withOpacity(0.25),
                            activeDotColor: ColorValues.elementColor.withOpacity(0.70),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
