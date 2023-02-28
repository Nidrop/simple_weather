import 'dart:convert';

//import 'package:deep_pick/deep_pick.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_weather/models/api.dart';
import 'package:simple_weather/entities/weather_timestamp.dart';
import 'package:http/http.dart' as http;
import 'package:simple_weather/models/cities.dart';

import 'current_city.dart';
//import 'package:dio/dio.dart';

part 'load_controller.g.dart';

@riverpod
class AsyncLoadController extends _$AsyncLoadController {
  Future<List<WeatherTimestamp>> _loadWeatherInternal(
      {bool skipCache = false}) async {
    if (skipCache) {
      return _fetchWeather();
    }
    var cacheBox =
        await Hive.openBox("cache"); //Hive.box("cache") почему-то не работает
    dynamic cachedList = cacheBox.get("forecast");
    dynamic currentCity = cacheBox.get("currentCity");
    dynamic cities = cacheBox.get("cities");
    if (_isCacheActual(cachedList, currentCity, cities)) {
      final cc = currentCity as String;
      final c = (cities as List<dynamic>).cast<String>();

      ref.read(currentCityProvider.notifier).changeCity(cc);
      ref.read(citiesProvider.notifier).loadCities(c);

      List<WeatherTimestamp> cl = cachedList.cast<WeatherTimestamp>();
      return cl;
    } else {
      return _fetchWeather();
    }
  }

  bool _isCacheActual(dynamic cachedList, dynamic currentCity, dynamic cities) {
    if (cachedList == null || currentCity == null || cities == null) {
      return false;
    }

    List<WeatherTimestamp> cl = cachedList.cast<WeatherTimestamp>();
    final today = DateTime.now();
    final DateTime firstCachedDay = cl.first.time;
    if (daysBetween(today, firstCachedDay) != 0) {
      return false;
    }

    return true;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Future<List<WeatherTimestamp>> _fetchWeather() async {
    final currentCity = ref.read(currentCityProvider.notifier).state;
    final request = ref
        .read(defaultApiProvider)
        .forecast(days: 4, city: currentCity, lang: "ru");

    final response = await http.get(Uri.parse(request));
    final json = jsonDecode(response.body);

    List<WeatherTimestamp> res = [];
    final list = json["list"] as List;
    for (final v in list) {
      final time = DateTime.parse(v["dt_txt"] as String);
      final temperature = (v["main"]["temp"] as num).toDouble();
      final temperatureFeels = (v["main"]["feels_like"] as num).toDouble();
      final weather = (v["weather"] as List).first;
      final description = weather["description"] as String;
      final icon = weather["icon"] as String;
      res.add(WeatherTimestamp(
          time: time,
          description: description,
          temperature: temperature,
          temperatureFeels: temperatureFeels,
          icon: icon));
    }
    /*
    final List<WeatherTimestamp> list = pick(json, "list").asListOrThrow((p) {
      //final weather = p("weather").asListOrThrow((p2) => Map<String,dynamic>.from(other)).first;
      return WeatherTimestamp(
        time: p("dt_txt").required().asStringOrThrow(),
        temperature: p("main", "temp").required().asDoubleOrThrow(),
        description: "no",
      );
    });
    */

    _updateCache(res);

    return res;
  }

  void _updateCache(List<WeatherTimestamp> l) {
    var cacheBox = Hive.box("cache");
    cacheBox.put("forecast", l);
  }

  Future<void> _initDatabase() async {
    await Hive.initFlutter("simple_weather");
    Hive.registerAdapter(WeatherTimestampAdapter());
    await Hive.openBox("cache");
    await FastCachedImageConfig.init(
        subDir: "simple_weather", clearCacheAfter: const Duration(days: 90));
  }

  @override
  FutureOr<List<WeatherTimestamp>> build() async {
    await _initDatabase(); //обязательно await
    return _loadWeatherInternal();
  }

  Future<void> updateWeather({bool skipCache = false}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _loadWeatherInternal(skipCache: skipCache);
    });
  }
}
