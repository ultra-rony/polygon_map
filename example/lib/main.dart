import 'package:flutter/material.dart';
import 'package:polygon_map/polygon_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  // Entry point of the Flutter application
  runApp(const PolygonEditorApp());
}

class PolygonEditorApp extends StatelessWidget {
  const PolygonEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Polygon Map Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const PolygonMapScreen(),
    );
  }
}

class PolygonMapScreen extends StatefulWidget {
  const PolygonMapScreen({super.key});

  @override
  State<PolygonMapScreen> createState() => _PolygonMapScreenState();
}

class _PolygonMapScreenState extends State<PolygonMapScreen> {
  // Controller that manages polygons and map interactions
  final controller = PolygonMapController();

  @override
  void initState() {
    super.initState();

    // Listen to controller changes (polygons, points, etc.)
    controller.addListener(_onControllerChanged);

    // Set initial polygon data
    controller.setPolygons([
      PolygonModel(
        borderColor: Colors.red,
        points: [
          LatLng(34.0925, -118.2750),
          LatLng(34.0925, -118.2050),
          LatLng(34.0225, -118.1950),
          LatLng(34.0125, -118.2050),
          LatLng(34.0125, -118.2750),
        ],
      ),
    ]);
  }

  // Callback triggered whenever controller state changes
  void _onControllerChanged() {
    debugPrint("last polygon: ${controller.polygons.last.points}");
  }

  @override
  void dispose() {
    // Remove listener to prevent memory leaks
    controller.removeListener(_onControllerChanged);

    // Dispose controller resources
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PolygonMap(
          controller: controller,
          // Use satellite map tiles
          mapType: MapTypeEnum.esriSatellite,
          initialZoom: 11.5,
          initialCenter: const LatLng(34.052235, -118.243683),
        ),
      ),
    );
  }
}
