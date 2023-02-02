import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cities.g.dart';

@riverpod
class Cities extends _$Cities {
  @override
  List<String> build() {
    return ["Gomel", "Minsk", "Brest"];
  }

  void loadCitiesWithoutCaching(List<String> cities) {
    state = cities;
  }

  void addCity(String city) {
    state = [...state, city];
    //state.add(city);
  }

  void removeCity(String city) {
    state = [
      for (final v in state)
        if (v != city) v,
    ];
    //state.remove(city);
  }

  void updateCache() {
    var cacheBox = Hive.box("cache");
    cacheBox.put("cities", state);
  }
}
