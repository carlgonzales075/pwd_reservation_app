import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

GeoPoint convertPointToGeoPoint(String point) {
  // Remove the "POINT (" prefix and ")" suffix
  point = point.replaceAll("POINT (", "").replaceAll(")", "");

  // Split the string by space to get longitude and latitude
  List<String> coordinates = point.split(" ");

  // Parse the values to double
  double longitude = double.parse(coordinates[0]);
  double latitude = double.parse(coordinates[1]);

  // Return the GeoPoint
  return GeoPoint(latitude: latitude, longitude: longitude);
}