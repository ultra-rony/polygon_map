import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:polygon_map/polygon_map.dart';

void main() {
  late PolygonMapController controller;

  // Create a fresh controller before each test
  setUp(() {
    controller = PolygonMapController();
  });

  test('initial state is empty', () {
    // Controller should start with no polygons
    expect(controller.polygons.isEmpty, true);

    // No polygon is selected initially
    expect(controller.currentPolygonIndex, -1);

    // Current polygon should be null
    expect(controller.currentPolygon, null);
  });

  test('addPolygon creates new polygon and selects it', () {
    controller.addPolygon();

    // One polygon should be created
    expect(controller.polygons.length, 1);

    // It should be selected automatically
    expect(controller.currentPolygonIndex, 0);

    // Current polygon should not be null
    expect(controller.currentPolygon, isNotNull);
  });

  test('addPoint adds point to current polygon', () {
    controller.addPolygon();

    final point = LatLng(10, 10);
    controller.addPoint(point);

    // Point should be added to current polygon
    expect(controller.currentPoints.length, 1);
    expect(controller.currentPoints.first, point);
  });

  test('removePoint removes point correctly', () {
    controller.addPolygon();

    controller.addPoint(LatLng(1, 1));
    controller.addPoint(LatLng(2, 2));

    // Remove first point
    controller.removePoint(0);

    // Only one point should remain
    expect(controller.currentPoints.length, 1);

    // Remaining point should be the second one
    expect(controller.currentPoints.first.latitude, 2);
  });

  test('clearPolygon removes all points', () {
    controller.addPolygon();

    controller.addPoint(LatLng(1, 1));
    controller.addPoint(LatLng(2, 2));

    controller.clearPolygon();

    // All points should be cleared
    expect(controller.currentPoints.isEmpty, true);
  });

  test('deletePolygon removes polygon', () {
    controller.addPolygon();
    controller.addPolygon();

    controller.deletePolygon();

    // One polygon should remain after deletion
    expect(controller.polygons.length, 1);
  });

  test('toggleEditing switches mode', () {
    // Initially editing is disabled
    expect(controller.isEditing, false);

    controller.toggleEditing();
    expect(controller.isEditing, true);

    controller.toggleEditing();
    expect(controller.isEditing, false);
  });

  test('selectPolygon sets correct index', () {
    controller.addPolygon();
    controller.addPolygon();

    controller.selectPolygon(1);

    // Selected polygon index should be updated
    expect(controller.currentPolygonIndex, 1);
  });

  test('isPointInsidePolygon works correctly', () {
    // Define a simple square polygon
    final polygon = [
      LatLng(0, 0),
      LatLng(0, 10),
      LatLng(10, 10),
      LatLng(10, 0),
    ];

    final inside = LatLng(5, 5);
    final outside = LatLng(20, 20);

    // Point inside the polygon should return true
    expect(controller.isPointInsidePolygon(inside, polygon), true);

    // Point outside should return false
    expect(controller.isPointInsidePolygon(outside, polygon), false);
  });
}