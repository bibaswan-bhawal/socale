import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/match_card/match_card.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:flutter/material.dart';

class MatchPage extends ConsumerStatefulWidget {
  const MatchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends ConsumerState<MatchPage> {
  getMatches() async {
    final user = await Amplify.Auth.getCurrentUser();
    ref.read(matchAsyncController.notifier).setMatches(user.userId);
  }

  @override
  void initState() {
    super.initState();
    getMatches();
  }

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
                  return CarouselSlider(
                    options: CarouselOptions(
                      height: constraints.maxHeight,
                      viewportFraction: 1,
                      enableInfiniteScroll: false,
                    ),
                    items: matchesProvider.when(data: (data) {
                      List<Widget> matchCards = [];

                      data.forEach((user, matchData) {
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
                      });

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