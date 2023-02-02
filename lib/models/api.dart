import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_weather/api_keys.dart';

part 'api.g.dart';

class OpenWeatherMapApi {
  OpenWeatherMapApi(this.apiKey);

  final String apiKey;

  /*
  Uri forecast({required int days, required final String city}) {
    return Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$city&cnt=${days * 8}&appid=$apiKey&units=metric&lang=ru");
  }
  */
  String forecast(
      {required int days,
      required final String city,
      required final String lang}) {
    return "https://api.openweathermap.org/data/2.5/forecast?q=$city&cnt=${days * 8}&appid=$apiKey&units=metric&lang=$lang";
  }
}

@riverpod
OpenWeatherMapApi defaultApi(DefaultApiRef ref) {
  return OpenWeatherMapApi(ApiKeys.defaultOpenWeatherApiKey);
}
