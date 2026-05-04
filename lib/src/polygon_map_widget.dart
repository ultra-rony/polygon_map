import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:polygon_map/polygon_map.dart';

class PolygonMap extends StatelessWidget {
  /// Controller that manages polygons, points and map state
  final PolygonMapController controller;

  /// Initial map center position
  final LatLng initialCenter;

  /// Initial zoom level of the map
  final double initialZoom;

  /// Stroke width of polygon borders
  final double borderStrokeWidth;

  /// Dash pattern segments for dashed borders
  final List<double> segments;

  /// Color of the active (selected) polygon
  final Color activeColor;

  /// Color of marker icons
  final Color iconColor;

  /// Background color of floating action buttons
  final Color floatingButtonBg;

  /// Whether to show floating action buttons
  final bool isFabButton;

  final String? urlTemplate;
  final MapTypeEnum mapType;
  final String? userAgentPackageName;

  const PolygonMap({
    super.key,

    /// Required controller
    required this.controller,

    /// Default zoom level
    this.initialZoom = 11.5,

    /// Default map center
    this.initialCenter = const LatLng(34.052235, -118.243683),

    /// Default polygon border width
    this.borderStrokeWidth = 3,

    /// Default dashed line pattern
    this.segments = const [8, 4],

    /// Default active polygon color
    this.activeColor = Colors.redAccent,

    /// Default icon color for markers
    this.iconColor = Colors.grey,

    /// Default FAB background color
    this.floatingButtonBg = Colors.white,

    /// Show FAB by default
    this.isFabButton = true,
    this.urlTemplate,
    this.mapType = MapTypeEnum.topo,
    this.userAgentPackageName,
  });

  @override
  Widget build(BuildContext context) {
    /// Rebuild UI when controller notifies listeners
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          body: _buildMap(),
          floatingActionButton: isFabButton ? _buildFAB() : null,
        );
      },
    );
  }

  /// Builds map widget with polygons, markers and interaction logic
  Widget _buildMap() {
    return FlutterMap(
      mapController: controller.mapController,

      options: MapOptions(

        /// Initial map center position
        initialCenter: initialCenter,

        onMapReady: () {
          controller.setMapReady();
        },

        /// Initial zoom level
        initialZoom: initialZoom,

        /// Enable all gestures (zoom, pan, rotate)
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),

        /// Handle tap events on map
        onTap: (_, latlng) {
          if (controller.isEditing) return;

          final previousIndex = controller.currentPolygonIndex;

          controller.selectPolygonByTap(latlng);

          final selectedIndex = controller.currentPolygonIndex;

          final polygon =
          controller.polygons.isNotEmpty &&
              selectedIndex >= 0 &&
              selectedIndex < controller.polygons.length
              ? controller.polygons[selectedIndex]
              : null;

          if (polygon == null) {
            controller.addPolygon();
            controller.addPoint(latlng);
            return;
          }

          if (previousIndex != selectedIndex) {
            controller.addPoint(latlng);
            return;
          }

          if (polygon.points.length >= 2) {
            controller.insertPointInPolygon(latlng);
          } else {
            controller.addPoint(latlng);
          }
        },
      ),

      children: [

        /// OpenStreetMap tile layer
        TileLayer(
          urlTemplate: urlTemplate ?? mapType.urlTemplate,
          userAgentPackageName: userAgentPackageName ?? "com.example.app",
        ),

        /// Polygon rendering layer
        PolygonLayer(
          polygons: controller.polygons

          /// Only render valid polygons (3+ points)
              .where((p) => p.points.length >= 3)
              .map(
                (p) =>
                Polygon(

                  /// Polygon vertex points
                  points: p.points,

                  /// Fill color (active vs inactive state)
                  color: p == controller.currentPolygon
                      ? activeColor.withValues(alpha: 0.4)
                      : p.borderColor.withValues(alpha: 0.1),

                  /// Border color depending on selection
                  borderColor: p == controller.currentPolygon
                      ? activeColor
                      : p.borderColor,

                  /// Border thickness
                  borderStrokeWidth: borderStrokeWidth,

                  /// Dashed border when editing mode is enabled
                  pattern: controller.isEditing
                      ? StrokePattern.dashed(segments: segments)
                      : const StrokePattern.solid(),
                ),
          )
              .toList(),
        ),

        /// Marker layer for polygon points
        MarkerLayer(
          markers: List.generate(controller.currentPoints.length, (index) {
            return Marker(

              /// Marker position
              point: controller.currentPoints[index],

              /// Marker size
              width: 40,
              height: 40,

              /// Marker UI and interactions
              child: GestureDetector(

                /// Move point while dragging (only in edit mode)
                onPanUpdate: controller.isEditing
                    ? (d) => controller.movePoint(index, d.delta)
                    : null,

                /// Remove point on long press
                onLongPress: () => controller.removePoint(index),

                /// Marker icon
                child: Icon(
                  controller.isEditing
                      ? Icons.square_outlined
                      : Icons.location_on,
                  color: activeColor,
                  size: 30,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  /// Builds floating action buttons (add/edit/clear/delete)
  Widget _buildFAB() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        /// Add new polygon button
        FloatingActionButton(
          backgroundColor: floatingButtonBg,
          heroTag: 'add',
          mini: true,
          onPressed: controller.addPolygon,
          child: Icon(Icons.add_box, color: iconColor),
        ),

        const SizedBox(height: 10),

        /// Toggle edit mode button
        FloatingActionButton(
          backgroundColor: floatingButtonBg,
          heroTag: 'edit',
          mini: true,
          onPressed: controller.toggleEditing,
          child: Icon(
            controller.isEditing ? Icons.edit_off : Icons.edit,
            color: iconColor,
          ),
        ),

        const SizedBox(height: 10),

        /// Clear current polygon points
        FloatingActionButton(
          backgroundColor: floatingButtonBg,
          heroTag: 'clear',
          mini: true,
          onPressed: controller.clearPolygon,
          child: Icon(Icons.delete, color: iconColor),
        ),

        const SizedBox(height: 10),

        /// Delete selected polygon entirely
        FloatingActionButton(
          backgroundColor: floatingButtonBg,
          heroTag: 'delete',
          mini: true,
          onPressed: controller.deletePolygon,
          child: Icon(Icons.layers_clear, color: iconColor),
        ),

        const SizedBox(height: 10),

        /// Zoom controls
        FloatingActionButton(
          backgroundColor: floatingButtonBg,
          heroTag: 'zoom_in',
          mini: true,
          onPressed: controller.zoomIn,
          child: Icon(Icons.zoom_in, color: iconColor),
        ),

        const SizedBox(height: 10),

        FloatingActionButton(
          backgroundColor: floatingButtonBg,
          heroTag: 'zoom_out',
          mini: true,
          onPressed: controller.zoomOut,
          child: Icon(Icons.zoom_out, color: iconColor),
        ),
      ],
    );
  }
}
