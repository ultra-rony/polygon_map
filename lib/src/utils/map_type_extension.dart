import 'map_type_enum.dart';

extension MapTypeExtension on MapTypeEnum {
  String get urlTemplate => switch (this) {
    MapTypeEnum.osm => 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

    MapTypeEnum.cartoLight =>
      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',

    MapTypeEnum.cartoDark =>
      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',

    MapTypeEnum.esriStreet =>
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',

    MapTypeEnum.esriSatellite =>
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',

    MapTypeEnum.topo => 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
  };
}
