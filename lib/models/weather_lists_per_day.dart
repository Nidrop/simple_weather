import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_weather/models/load_controller.dart';
import 'package:simple_weather/entities/weather_timestamp.dart';

part 'weather_lists_per_day.g.dart';

@riverpod
AsyncValue<List<List<WeatherTimestamp>>> weatherListsPerDay(
    WeatherListsPerDayRef ref) {
  final weatherList = ref.watch(asyncLoadControllerProvider);

  return weatherList.when(
    data: (data) {
      const int days = 4;
      List<List<WeatherTimestamp>> res = [];
      for (int i = 0; i < days; i++) {
        List<WeatherTimestamp> l = [];
        res.add(l);
      }

      final today = DateTime.now();

      for (final v in data) {
        final vdate = v.time;
        final diff = ref
            .read(asyncLoadControllerProvider.notifier)
            .daysBetween(today, vdate);
        if (diff < days) {
          res[diff].add(v);
        }
      }

      final res2 = AsyncData(res);
      return res2;
    },
    loading: () => const AsyncLoading(),
    error: (error, stackTrace) => AsyncError(error, stackTrace),
  );
}
