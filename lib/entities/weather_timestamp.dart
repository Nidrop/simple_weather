import 'package:hive/hive.dart';

part 'weather_timestamp.g.dart';

@HiveType(typeId: 1)
class WeatherTimestamp {
  WeatherTimestamp(
      {required this.time,
      required this.description,
      required this.temperature,
      required this.temperatureFeels,
      required this.icon});

  @HiveField(0)
  DateTime time;
  @HiveField(1)
  String description;
  @HiveField(2)
  double temperature;
  @HiveField(3)
  double temperatureFeels;
  @HiveField(4)
  String icon;
}
