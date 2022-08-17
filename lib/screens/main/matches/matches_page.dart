import 'package:flutter/material.dart';
import 'package:socale/components/match_card/match_card.dart';
import 'package:provider/provider.dart';
import 'package:socale/screens/main/matches/card_provider.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({Key? key}) : super(key: key);

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildCard(context) {
      final provider = Provider.of<CardProvider>(context);
      final _text = provider.text;

      return Stack(
        children: _text
            .map(
              (text) => Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                width: size.width,
                height: size.height * 0.75,
                child: MatchCard(
                  size: Size(size.width, size.height * 0.75),
                  text: text,
                  isFront: _text.last == text,
                ),
              ),
            )
            .toList(),
      );
    }

    return Center(
      child: buildCard(context),
    );
  }
}
