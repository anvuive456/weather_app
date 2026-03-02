class LocationModel {
  final int id;
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String url;

//<editor-fold desc="Data Methods">
  const LocationModel({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.url,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocationModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          lat == other.lat &&
          lon == other.lon);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      region.hashCode ^
      country.hashCode ^
      lat.hashCode ^
      lon.hashCode ^
      url.hashCode;

  @override
  String toString() {
    return 'LocationModel{ id: $id, name: $name, region: $region, country: $country, lat: $lat, lon: $lon, url: $url,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'region': region,
      'country': country,
      'lat': lat,
      'lon': lon,
      'url': url,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] ?? -1,
      name: map['name'] ?? '',
      region: map['region'] ?? '',
      country: map['country'] ?? '',
      lat: map['lat'] ?? 0.0,
      lon: map['lon'] ?? 0.0,
      url: map['url'] ?? '',
    );
  }

//</editor-fold>
}
