<p align="center">
    <img src="https://github.com/ultra-rony/polygon_map/blob/main/screenshots/logo.png?raw=true" height="250" width="250" alt="polygon_map" />
</p>

<p align="center">
    <a href="https://pub.dev/packages/polygon_map"><img src="https://img.shields.io/badge/pub-v0.0.6-blue" alt="Pub"></a>
    <a href="https://github.com/ultra-rony/polygon_map/releases"><img src="https://img.shields.io/badge/download-apk-blue" alt="apk"></a>
    <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
    <a href="https://pub.dev/packages/polygon_map/score"><img src="https://img.shields.io/badge/points-160/160-green" alt="Points"></a>
    <a href="https://www.donationalerts.com/r/ultra_rony"><img src="https://img.shields.io/badge/support-donate-yellow" alt="Donate"></a>
    <a href="https://pub.dev/packages/flutter_map"><img src="https://img.shields.io/badge/flutter_map-v8.3.0-blue" alt="flutter_map"></a>
    <a href="https://pub.dev/packages/latlong2"><img src="https://img.shields.io/badge/latlong2-v0.9.1-blue" alt="latlong2"></a>
</p>

# polygon_map
<p>
    polygon_map — a lightweight and easy-to-use package for working with map polygons. Create, edit, and display geometric areas with flexible customization.<br>
    <span style="font-size: 0.9em"> Please star the <a href="https://github.com/ultra-rony/polygon_map">repository</a> to support the project! </span>
</p>

## Screenshots

<p align="center">
  <img src="https://github.com/ultra-rony/polygon_map/blob/main/screenshots/1.png?raw=true" height="150" />
  <img src="https://github.com/ultra-rony/polygon_map/blob/main/screenshots/2.png?raw=true" height="150" />
</p>

<p align="center">
  <img src="https://github.com/ultra-rony/polygon_map/blob/main/screenshots/3.png?raw=true" height="150" />
  <img src="https://github.com/ultra-rony/polygon_map/blob/main/screenshots/4.png?raw=true" height="150" />
</p>

## Getting Started

To use this package, add it to your `pubspec.yaml`:

```yaml
dependencies:
  polygon_map: ^0.0.6
```

or run the command

```bash
flutter pub add polygon_map
```

## Using the player

```dart
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
```