class LocationCoordinate {
  final double latitude;
  final double longitude;
  const LocationCoordinate(this.latitude, this.longitude);
  @override
  String toString() => 'LocationCoordinate($latitude, $longitude)';
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationCoordinate &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;
  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
