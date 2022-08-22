import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/match_card/match_card.dart';
import 'package:socale/screens/main/matches/card_provider.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart' as p;

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
    final provider = p.Provider.of<CardProvider>(context, listen: false);
    provider.setRef(ref);
    getMatches();
  }

  @override
  Widget build(BuildContext context) {
    final matchesProvider = ref.watch(matchAsyncController);
    var size = MediaQuery.of(context).size;

    Widget buildCard(context) {
      final provider = p.Provider.of<CardProvider>(context);
      List<Widget> list = [Text("BOB")];

      if (matchesProvider.hasValue) {
        list = [];
        if (matchesProvider.value!.isNotEmpty) {
          matchesProvider.value!.forEach(
            (user, match) {
              list.add(
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: size.width,
                  height: size.height * 0.75,
                  child: MatchCard(
                    size: Size(size.width, size.height * 0.75),
                    user: user,
                    match: match,
                    isFront: matchesProvider.value!.keys.last == user,
                  ),
                ),
              );
            },
          );
        } else {
          list = [
            Text(
              "No more matches",
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 24),
            )
          ];
        }
      } else if (matchesProvider.isLoading) {
        list = [
          CircularProgressIndicator(),
        ];
      }

      return Stack(
        children: list,
      );
    }

    return Center(
      child: buildCard(context),
    );
  }
}
