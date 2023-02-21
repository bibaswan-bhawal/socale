import 'package:flutter/material.dart';

abstract class Paginator extends StatelessWidget {
  final int selectedPage;

  const Paginator({super.key, required this.selectedPage});
}
