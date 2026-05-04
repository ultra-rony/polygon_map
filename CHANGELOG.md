# Changelog

All notable changes to this project will be documented in this file.

The format is based on https://keepachangelog.com/en/1.0.0/

---

## [0.0.6] - 2026-05-04

### Added
- Improved test coverage for controller and widget
- Additional edge case handling in polygon operations

### Improved
- Code quality and internal structure

---

## [0.0.5] - 2026-05-04

### Added
- Unit tests for `PolygonMapController`
- Model tests for `PolygonModel`
- Utility tests for `MapTypeEnum`
- Basic widget tests for `PolygonMap`

---

## [0.0.4] - 2026-05-04

### Added
- Interactive polygon creation and editing
- `PolygonMapController` for managing state
- Point-in-polygon detection
- Insert point between polygon edges

### Improved
- Border color generation using HSL
- State update handling

### Fixed
- Polygon deletion edge cases
- Index safety checks

---

## [0.0.3]

### Added
- `MapTypeEnum` with multiple tile providers
- URL template extension for map types

---

## [0.0.2]

### Added
- Polygon rendering
- Marker support
- Editing mode (move/remove points)

---

## [0.0.1]

### Added
- Initial release
- Basic map integration with `flutter_map`