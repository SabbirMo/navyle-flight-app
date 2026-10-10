import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/home/model/city_weather_model.dart';

export 'package:navyla_flight_app/feature/home/model/city_weather_model.dart';

class CityWeatherNotifier extends Notifier<CityWeatherModel> {
  @override
  CityWeatherModel build() {
    return const CityWeatherModel(
      cityName: 'Frankfurt',
      temperature: '24°C',
      condition: 'Partly cloudy',
      localTime: '9:41 AM',
      date: 'Tue, Apr 23',
    );
  }

  void updateWeather({
    String? cityName,
    String? temperature,
    String? condition,
    String? localTime,
    String? date,
    String? iconAsset,
  }) {
    state = state.copyWith(
      cityName: cityName,
      temperature: temperature,
      condition: condition,
      localTime: localTime,
      date: date,
      iconAsset: iconAsset,
    );
  }
}

final cityWeatherNotifierProvider =
    NotifierProvider<CityWeatherNotifier, CityWeatherModel>(
  CityWeatherNotifier.new,
);
