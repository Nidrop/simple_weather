import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weather/models/cities.dart';
import 'package:simple_weather/models/current_city.dart';
import 'package:simple_weather/models/load_controller.dart';
import 'package:simple_weather/screens/city_page.dart';
import 'package:simple_weather/widgets/weather_list.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCity = ref.watch(currentCityProvider);
    final cities = ref.watch(
        citiesProvider); //без этого результат почему-то сбрасывается в окне выбора города
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(currentCity),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => CityPage()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref
                    .read(asyncLoadControllerProvider.notifier)
                    .updateWeather(skipCache: true);
              },
            )
          ],
          bottom: const TabBar(tabs: [
            Tab(text: "today"),
            Tab(text: "1 day"),
            Tab(text: "2 day"),
            Tab(text: "3 day"),
          ]),
        ),
        body: const TabBarView(children: [
          WeatherList(day: 0),
          WeatherList(day: 1),
          WeatherList(day: 2),
          WeatherList(day: 3),
        ]),
      ),
    );
  }
}
