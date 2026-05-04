import 'package:flutter_test/flutter_test.dart';
import 'package:polygon_map/polygon_map.dart';

void main() {
  test('MapTypeEnum returns correct URLs', () {
    // Verify that OpenStreetMap type returns correct URL template
    expect(
      MapTypeEnum.osm.urlTemplate,
      contains('openstreetmap'),
    );

    // Verify that Topographic map type returns correct URL template
    expect(
      MapTypeEnum.topo.urlTemplate,
      contains('opentopomap'),
    );
  });
}