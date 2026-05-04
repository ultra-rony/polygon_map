import 'dart:ui';

import 'package:latlong2/latlong.dart';

/// Represents a single editable polygon on the map.
class PolygonModel {
  /// List of polygon vertices (geographic coordinates)
  List<LatLng> points;
  final Color borderColor;

  /// Creates a polygon with given points
  PolygonModel({required this.points, required this.borderColor});
}