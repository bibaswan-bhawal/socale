import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MatchPercentageConverter {
  String convertPercentageToString(int percentage) {
    if (percentage >= 90) {
      return "Legendary Match";
    }

    if (percentage >= 71) {
      return "Very High Match";
    }

    if (percentage >= 51) {
      return "High Match";
    }

    return "Common Match";
  }

  ui.Gradient convertPercentageToGradient(int percentage) {
    if (percentage >= 90) {
      return ui.Gradient.linear(
        const Offset(0, 0),
        const Offset(150, 20),
        <Color>[
          Color(0xFF36D1DC),
          Color(0xFF5B86E5),
        ],
      );
    }

    if (percentage >= 71) {
      return ui.Gradient.linear(
        const Offset(0, 0),
        const Offset(150, 20),
        <Color>[
          Color(0xFFF827DE),
          Color(0xFF7D6FFF),
          Color(0xFFF827DE),
        ],
        <double>[0, 0.5, 1.0],
        TileMode.mirror,
      );
    }

    if (percentage >= 51) {
      return ui.Gradient.linear(
        const Offset(0, 0),
        const Offset(550, 0),
        <Color>[
          Color(0xFFFFAD0D),
          Color(0xFF90E45E),
        ],
        [0, 0.5],
        TileMode.decal,
      );
    }

    return ui.Gradient.linear(
      const Offset(0, 0),
      const Offset(150, 20),
      <Color>[
        Color(0xFF7761FF),
        Color(0xFFEA7171),
        Color(0xFFFFF1F1),
      ],
      [0, 0.5, 1.0],
    );
  }

  List<Color> convertPercentageToColorList(int percentage) {
    if (percentage >= 90) {
      return <Color>[
        Color(0xFF36D1DC),
        Color(0xFF5B86E5),
      ];
    }

    if (percentage >= 71) {
      return <Color>[
        Color(0xFFF827DE),
        Color(0xFF7D6FFF),
        Color(0xFFF827DE),
      ];
    }

    if (percentage >= 51) {
      return <Color>[
        Color(0xFFFFAD0D),
        Color(0xFF90E45E),
      ];
    }

    return <Color>[
      Color(0xFF7761FF),
      Color(0xFFEA7171),
      Color(0xFFFFF1F1),
    ];
  }
}

final matchPercentageConverter = MatchPercentageConverter();
