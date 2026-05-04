import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polygon_map/polygon_map.dart';

void main() {
  testWidgets('PolygonMap renders without crash', (tester) async {
    // Create controller instance
    final controller = PolygonMapController();

    // Pump widget into the test environment
    await tester.pumpWidget(
      MaterialApp(
        home: PolygonMap(controller: controller),
      ),
    );

    // Verify that PolygonMap is rendered
    expect(find.byType(PolygonMap), findsOneWidget);
  });

  testWidgets('FAB buttons appear when enabled', (tester) async {
    final controller = PolygonMapController();

    await tester.pumpWidget(
      MaterialApp(
        home: PolygonMap(
          controller: controller,
          isFabButton: true, // explicitly enable FAB
        ),
      ),
    );

    // Verify that FloatingActionButtons are present
    expect(find.byType(FloatingActionButton), findsWidgets);
  });
}