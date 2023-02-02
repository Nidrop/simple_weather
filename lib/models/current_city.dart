import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_city.g.dart';

@riverpod
class CurrentCity extends _$CurrentCity {
  @override
  String build() {
    return "Gomel";
  }

  void changeCity(String city) {
    if (state != city) {
      state = city;
    }
  }

  void updateCache() {
    var cacheBox = Hive.box("cache");
    cacheBox.put("currentCity", state);
  }
}
