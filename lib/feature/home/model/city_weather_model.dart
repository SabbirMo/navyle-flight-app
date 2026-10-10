class CityWeatherModel {
  final String? cityName;
  final String? temperature;
  final String? condition;
  final String? localTime;
  final String? date;
  final String? iconAsset;

  const CityWeatherModel({
    this.cityName,
    this.temperature,
    this.condition,
    this.localTime,
    this.date,
    this.iconAsset,
  });

  CityWeatherModel copyWith({
    String? cityName,
    String? temperature,
    String? condition,
    String? localTime,
    String? date,
    String? iconAsset,
  }) {
    return CityWeatherModel(
      cityName: cityName ?? this.cityName,
      temperature: temperature ?? this.temperature,
      condition: condition ?? this.condition,
      localTime: localTime ?? this.localTime,
      date: date ?? this.date,
      iconAsset: iconAsset ?? this.iconAsset,
    );
  }
}
