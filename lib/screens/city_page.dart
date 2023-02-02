import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weather/models/cities.dart';
import 'package:simple_weather/models/current_city.dart';
import 'package:simple_weather/models/load_controller.dart';

class CityPage extends ConsumerWidget {
  CityPage({super.key});

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cities = ref.watch(citiesProvider);
    return Scaffold(
      appBar: AppBar(
          title: Container(
        //width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add_box),
                  onPressed: () {
                    ref
                        .read(citiesProvider.notifier)
                        .addCity(textController.text);
                    ref.read(citiesProvider.notifier).updateCache();
                    textController.clear();
                  },
                ),
                hintText: 'Add city',
                border: InputBorder.none),
          ),
        ),
      )),
      body: ListView(children: [
        //for (final v in ref.read(citiesProvider.notifier).state)
        for (final v in cities)
          ListTile(
            title: Text(v),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref.read(citiesProvider.notifier).removeCity(v);
                ref.read(citiesProvider.notifier).updateCache();
              },
            ),
            onTap: () {
              ref.read(currentCityProvider.notifier).changeCity(v);
              ref.read(currentCityProvider.notifier).updateCache();
              ref
                  .read(asyncLoadControllerProvider.notifier)
                  .updateWeather(skipCache: true);
              Navigator.of(context).pop();
            },
          )
      ]),
    );
  }
}
