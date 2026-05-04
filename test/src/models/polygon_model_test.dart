import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:polygon_map/polygon_map.dart';

void main() {
  test('PolygonModel stores points and color', () {
    // Create a polygon model with one point and a border color
    final model = PolygonModel(
      points: [LatLng(1, 1)],
      borderColor: Colors.red,
    );

    // Verify that the point list is stored correctly
    expect(model.points.length, 1);

    // Verify that the border color is stored correctly
    expect(model.borderColor, Colors.red);
  });
}