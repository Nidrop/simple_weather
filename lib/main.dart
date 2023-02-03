import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:simple_weather/entities/weather_timestamp.dart';
import 'package:simple_weather/screens/home_page.dart';

void initDatabase() async {
  await Hive.initFlutter();
  Hive.registerAdapter(WeatherTimestampAdapter());
  await Hive.openBox("cache");
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 30));
}

void main() {
  initDatabase();

  runApp(const ProviderScope(
      child: MaterialApp(
    title: "Simple Weather",
    home: HomePage(),
  )));
}
