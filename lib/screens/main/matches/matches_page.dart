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
    var size = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: CarouselSlider(
            options: CarouselOptions(
              height: constraints.maxHeight,
              viewportFraction: 1,
            ),
            items: matchesProvider.when(
              data: (data) {
                List<Widget> list = [];
                data.forEach((key, value) {
                  print(key.id);
                  list.add(
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: MatchCard(
                        size: Size(constraints.maxWidth * 0.90, constraints.maxHeight * 0.8),
                        user: key,
                        match: value,
                        isFront: true,
                      ),
                    ),
                  );
                });

                print(list.length);
                return list;
              },
              loading: () {
                return [
                  SizedBox(
                    width: 54,
                    height: 54,
                    child: CircularProgressIndicator(),
                  ),
                ];
              },
              error: (Object error, StackTrace? stackTrace) {
                return [
                  Text("error fetching matches"),
                ];
              },
            ),
          ),
        );
      },
    );
  }
}
