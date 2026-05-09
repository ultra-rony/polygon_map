import 'map_type_enum.dart';

extension MapTypeExtension on MapTypeEnum {
  String get urlTemplate {
    switch (this) {
      case MapTypeEnum.osm:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

      case MapTypeEnum.cartoLight:
        return 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png';

      case MapTypeEnum.cartoDark:
        return 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png';

      case MapTypeEnum.esriStreet:
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}';

      case MapTypeEnum.esriSatellite:
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

      case MapTypeEnum.topo:
        return 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png';
    }
  }
}