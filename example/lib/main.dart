import 'package:flutter/material.dart';
import 'package:polygon_map/polygon_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = PolygonMapController();

  @override
  void initState() {
    super.initState();

    controller.addListener(_onControllerChanged);

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

  void _onControllerChanged() {
    debugPrint("last polygon: ${controller.polygons.last.points}");
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PolygonMap(
          controller: controller,
          mapType: MapTypeEnum.esriSatellite,
        ),
      ),
    );
  }
}
