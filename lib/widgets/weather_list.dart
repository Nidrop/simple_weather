import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weather/models/api.dart';
import 'package:simple_weather/models/current_city.dart';
import 'package:simple_weather/models/weather_lists_per_day.dart';

class WeatherList extends ConsumerWidget {
  const WeatherList({super.key, required this.day});

  final int day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherLists = ref.watch(weatherListsPerDayProvider);
    return weatherLists.when(
      data: (l) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          for (final weather in l[day])
            ListTile(
              leading: FastCachedImage(
                url: ref.read(defaultApiProvider).icon(weather.icon),
                fit: BoxFit.scaleDown,
                errorBuilder: (context, error, stackTrace) =>
                    const Text("image error"),
              ),
              title: Text("${weather.time}"),
              subtitle: Text(weather.description),
              trailing: Text("${weather.temperature}°C"),
            )
        ],
      ),
      error: (err, stack) => Text('Error: $err'),
      //error: (err, stack) => throw Exception(err),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
