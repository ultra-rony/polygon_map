import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:polygon_map/src/models/polygon_model.dart';

class PolygonMapController extends ChangeNotifier {
  final MapController mapController = MapController();

  /// CAMERA (important for correct move/insert operations)
  MapCamera? camera;

  bool _mapReady = false;
  int? _lastTappedPolygonIndex;
  DateTime? _lastTapTime;

  void setMapReady() {
    _mapReady = true;
  }

  /// STATE
  final List<PolygonModel> _polygons = [];

  /// Immutable access to polygons list
  List<PolygonModel> get polygons => List.unmodifiable(_polygons);

  int _currentPolygonIndex = -1;

  /// Currently selected polygon index
  int get currentPolygonIndex => _currentPolygonIndex;

  /// Edit mode flag
  bool isEditing = false;

  /// EVENTS (useful for pub.dev package integration)
  void Function(PolygonModel)? onPolygonChanged;
  void Function(LatLng)? onPointAdded;
  void Function(int index)? onPolygonSelected;

  bool isSecondTapOnSamePolygon(int index) {
    final now = DateTime.now();

    final isSame = _lastTappedPolygonIndex == index;

    final isFastTap =
        _lastTapTime != null &&
            now.difference(_lastTapTime!) < const Duration(milliseconds: 400);

    _lastTappedPolygonIndex = index;
    _lastTapTime = now;

    return isSame && isFastTap;
  }

  // -----------------------------
  // CURRENT POLYGON SAFE ACCESS
  // -----------------------------

  /// Safely returns current polygon
  PolygonModel? get currentPolygon {
    if (_polygons.isEmpty) return null;

    if (_currentPolygonIndex < 0 || _currentPolygonIndex >= _polygons.length) {
      return null;
    }

    return _polygons[_currentPolygonIndex];
  }

  void setPolygons(List<PolygonModel> polygons) {
    _polygons
      ..clear()
      ..addAll(polygons);

    _currentPolygonIndex = _polygons.isEmpty ? -1 : 0;

    notifyListeners();
  }

  /// Returns points of current polygon
  List<LatLng> get currentPoints => currentPolygon?.points ?? [];

  // -----------------------------
  // POLYGON OPERATIONS
  // -----------------------------

  /// Creates a new empty polygon and selects it
  void addPolygon() {
    _polygons.add(
      PolygonModel(
        points: [],
        borderColor: _generateBorderColor(_polygons.length),
      ),
    );

    _currentPolygonIndex = _polygons.length - 1;
    notifyListeners();
  }

  /// Select polygon by index
  void selectPolygon(int index) {
    if (index < 0 || index >= _polygons.length) return;

    _currentPolygonIndex = index;
    onPolygonSelected?.call(index);

    notifyListeners();
  }

  /// Delete currently selected polygon
  void deletePolygon() {
    if (_polygons.isEmpty) return;

    _polygons.removeAt(_currentPolygonIndex);

    if (_polygons.isEmpty) {
      _currentPolygonIndex = -1;
    } else {
      _currentPolygonIndex = _currentPolygonIndex.clamp(
        0,
        _polygons.length - 1,
      );
    }

    notifyListeners();
  }

  /// Clear all points of current polygon
  void clearPolygon() {
    final p = currentPolygon;
    if (p == null) return;

    p.points.clear();

    _notifyChange();
  }

  // -----------------------------
  // POINT OPERATIONS
  // -----------------------------

  /// Add point to current polygon
  void addPoint(LatLng point) {
    final p = currentPolygon;
    if (p == null) return;

    p.points.add(point);

    onPointAdded?.call(point);
    _notifyChange();
  }

  /// Remove point by index
  void removePoint(int index) {
    final p = currentPolygon;
    if (p == null) return;
    if (index < 0 || index >= p.points.length) return;

    p.points.removeAt(index);

    _notifyChange();
  }

  /// Move point using screen delta (dragging)
  void movePoint(int index, Offset delta) {
    final p = currentPolygon;
    final cam = camera ?? mapController.camera;

    if (p == null) return;
    if (index < 0 || index >= p.points.length) return;

    final screen = cam.latLngToScreenOffset(p.points[index]);
    final newScreen = screen + delta;

    p.points[index] = cam.screenOffsetToLatLng(newScreen);

    _notifyChange();
  }

  // -----------------------------
  // EDIT MODE
  // -----------------------------

  /// Toggle edit mode
  void toggleEditing() {
    isEditing = !isEditing;
    notifyListeners();
  }

  // -----------------------------
  // HIT TEST (POINT IN POLYGON)
  // -----------------------------

  /// Checks if a point is inside a polygon (ray casting algorithm)
  bool isPointInsidePolygon(LatLng point, List<LatLng> polygon) {
    int intersections = 0;

    final px = point.longitude;
    final py = point.latitude;

    for (int i = 0; i < polygon.length; i++) {
      final j = (i + 1) % polygon.length;

      final xi = polygon[i].longitude;
      final yi = polygon[i].latitude;

      final xj = polygon[j].longitude;
      final yj = polygon[j].latitude;

      final intersect =
          ((yi > py) != (yj > py)) &&
          (px < (xj - xi) * (py - yi) / (yj - yi + 1e-12) + xi);

      if (intersect) intersections++;
    }

    return intersections % 2 == 1;
  }

  /// Select polygon by tapping inside it
  void selectPolygonByTap(LatLng point) {
    for (int i = 0; i < _polygons.length; i++) {
      final polygon = _polygons[i];

      if (polygon.points.length < 3) continue;

      if (isPointInsidePolygon(point, polygon.points)) {
        selectPolygon(i);
        return;
      }
    }
  }

  // -----------------------------
  // INSERT POINT (BETWEEN SEGMENTS)
  // -----------------------------

  /// Inserts a point into closest polygon edge
  void insertPointInPolygon(LatLng tap) {
    final p = currentPolygon;
    final cam = camera ?? mapController.camera;

    if (p == null || p.points.length < 2) return;

    double minDist = double.infinity;
    int insertIndex = -1;

    final tapScreen = cam.latLngToScreenOffset(tap);

    for (int i = 0; i < p.points.length; i++) {
      final a = cam.latLngToScreenOffset(p.points[i]);
      final b = cam.latLngToScreenOffset(p.points[(i + 1) % p.points.length]);

      final dist = _distanceToSegmentScreen(tapScreen, a, b);

      if (dist < minDist) {
        minDist = dist;
        insertIndex = i + 1;
      }
    }

    if (insertIndex != -1) {
      p.points.insert(insertIndex, tap);
      _notifyChange();
    }
  }

  // -----------------------------
  // DISTANCE CALCULATION (SCREEN SPACE)
  // -----------------------------

  /// Distance from point to segment in screen space
  double _distanceToSegmentScreen(Offset p, Offset a, Offset b) {
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;

    if (dx == 0 && dy == 0) {
      return (p - a).distance;
    }

    final t = ((p.dx - a.dx) * dx + (p.dy - a.dy) * dy) / (dx * dx + dy * dy);

    final clamped = t.clamp(0.0, 1.0);

    final cx = a.dx + clamped * dx;
    final cy = a.dy + clamped * dy;

    final d = Offset(p.dx - cx, p.dy - cy);

    return d.distance;
  }

  // -----------------------------
  // INTERNAL NOTIFY HELPER
  // -----------------------------

  /// Notifies listeners and external callbacks
  void _notifyChange() {
    onPolygonChanged?.call(currentPolygon!);
    notifyListeners();
  }

  void zoomIn() {
    if (!_mapReady) return;

    final cam = mapController.camera;

    final zoom = (cam.zoom + 1).clamp(1.0, 18.0);

    mapController.move(cam.center, zoom);
    notifyListeners();
  }

  void zoomOut() {
    if (!_mapReady) return;

    final cam = mapController.camera;

    final zoom = (cam.zoom - 1).clamp(1.0, 18.0);

    mapController.move(cam.center, zoom);
    notifyListeners();
  }

  Color _generateBorderColor(int seed) {
    final hue = (seed * 47) % 360;

    return HSLColor.fromAHSL(1.0, hue.toDouble(), 1, 0.55).toColor();
  }
}
