import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weather/screens/home_page.dart';

void main() {
  runApp(const ProviderScope(
      child: MaterialApp(
    title: "Simple Weather",
    home: HomePage(),
  )));
}
