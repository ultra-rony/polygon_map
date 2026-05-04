# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [0.0.4] - 2026-05-04

### Added
- Interactive polygon creation and editing support
- `PolygonMapController` for managing polygons and map state
- Support for adding, removing, and inserting points dynamically
- Tap-to-select polygon functionality
- Point-in-polygon detection (ray casting algorithm)

### Improved
- Better color generation for polygon borders using HSL
- Cleaner state management and notifications
- More stable polygon selection logic

### Fixed
- Edge cases when deleting polygons
- Index handling when polygons list changes

---

## [0.0.3]

### Added
- Map type support via `MapTypeEnum`
- URL template extension for different tile providers
- Support for multiple map styles (OSM, Carto, Esri, Topo)

### Improved
- Code structure and separation into modules (`controller`, `models`, `utils`)

---

## [0.0.2]

### Added
- Polygon rendering with borders and fill colors
- Marker support for polygon points
- Basic editing mode (move/remove points)

---

## [0.0.1]

### Added
- Initial release of `polygon_map`
- Basic map integration using `flutter_map`
- Simple polygon drawing support