import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

import '../Data/api_service.dart';

const defaultMapboxAccessToken =
    'pk.eyJ1IjoicHJlbmVyb3N0dWRpb3MiLCJhIjoiY21vdTAxbDF0MDl5ZzJ0c2h1OWU5cXlvZyJ9.r18j8yamEjiEAmIsBwRnBw';
const _mapboxAccessToken = String.fromEnvironment(
  'MAPBOX_ACCESS_TOKEN',
  defaultValue: '',
);
const _legacyMapboxAccessToken = String.fromEnvironment(
  'ACCESS_TOKEN',
  defaultValue: '',
);

String get resolvedMapboxAccessToken =>
    _mapboxAccessToken.isNotEmpty
        ? _mapboxAccessToken
        : _legacyMapboxAccessToken.isNotEmpty
        ? _legacyMapboxAccessToken
        : defaultMapboxAccessToken;

Set<Factory<OneSequenceGestureRecognizer>> get mapboxGestureRecognizers => {
  Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
};

const mapboxBottomControlMargin = 112.0;

Future<void> configureMapboxControls(
  mapbox.MapboxMap mapboxMap, {
  double bottomMargin = mapboxBottomControlMargin,
}) async {
  await mapboxMap.compass.updateSettings(
    mapbox.CompassSettings(
      enabled: true,
      visibility: true,
      marginTop: 12,
      marginRight: 12,
    ),
  );
  await mapboxMap.scaleBar.updateSettings(
    mapbox.ScaleBarSettings(
      enabled: true,
      isMetricUnits: false,
      position: mapbox.OrnamentPosition.BOTTOM_LEFT,
      marginLeft: 12,
      marginBottom: bottomMargin,
    ),
  );
  await mapboxMap.logo.updateSettings(
    mapbox.LogoSettings(
      position: mapbox.OrnamentPosition.BOTTOM_LEFT,
      marginLeft: 12,
      marginBottom: bottomMargin,
    ),
  );
  await mapboxMap.attribution.updateSettings(
    mapbox.AttributionSettings(
      position: mapbox.OrnamentPosition.BOTTOM_RIGHT,
      marginRight: 12,
      marginBottom: bottomMargin,
    ),
  );
}

@immutable
class LatLng {
  const LatLng(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  bool get isValid =>
      latitude.isFinite &&
      longitude.isFinite &&
      latitude.abs() <= 90 &&
      longitude.abs() <= 180;

  String get storageValue => '$latitude,$longitude';

  mapbox.Point get mapboxPoint =>
      mapbox.Point(coordinates: mapbox.Position(longitude, latitude));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatLng &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() => 'LatLng(lat: $latitude, lng: $longitude)';
}

class MapboxRouteStep {
  const MapboxRouteStep({
    required this.endLocation,
    required this.instruction,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  final LatLng endLocation;
  final String instruction;
  final double distanceMeters;
  final double durationSeconds;
}

class MapboxRouteResult {
  const MapboxRouteResult({
    required this.points,
    required this.distanceText,
    required this.durationText,
    required this.steps,
  });

  final List<LatLng> points;
  final String distanceText;
  final String durationText;
  final List<MapboxRouteStep> steps;

  String get nextInstruction =>
      steps.isEmpty ? 'Route ready' : steps.first.instruction;
}

class MapboxRouteMarker {
  const MapboxRouteMarker({
    required this.id,
    required this.point,
    this.image,
    this.color = const Color(0xFF1F7A5B),
    this.iconSize = 0.48,
  });

  final String id;
  final LatLng point;
  final Uint8List? image;
  final Color color;
  final double iconSize;
}

Future<MapboxRouteResult?> fetchMapboxRoute({
  required LatLng origin,
  required LatLng destination,
}) async {
  if (!origin.isValid || !destination.isValid) {
    return null;
  }

  final response = await http.get(
    ApiService.mapboxDrivingTrafficUri(
      originLat: origin.latitude,
      originLng: origin.longitude,
      destinationLat: destination.latitude,
      destinationLng: destination.longitude,
      accessToken: resolvedMapboxAccessToken,
    ),
  );
  if (response.statusCode != 200) {
    return null;
  }

  final data = jsonDecode(response.body);
  if (data is! Map<String, dynamic>) {
    return null;
  }
  final routes = data['routes'];
  if (routes is! List || routes.isEmpty || routes.first is! Map) {
    return null;
  }

  final route = Map<String, dynamic>.from(routes.first as Map);
  final coordinates =
      route['geometry'] is Map &&
              (route['geometry'] as Map)['coordinates'] is List
          ? (route['geometry'] as Map)['coordinates'] as List
          : const [];
  final points =
      coordinates
          .whereType<List>()
          .where((point) => point.length >= 2)
          .map(
            (point) => LatLng(
              (point[1] as num).toDouble(),
              (point[0] as num).toDouble(),
            ),
          )
          .where((point) => point.isValid)
          .toList();

  final steps = <MapboxRouteStep>[];
  final legs = route['legs'];
  if (legs is List && legs.isNotEmpty && legs.first is Map) {
    final leg = Map<String, dynamic>.from(legs.first as Map);
    final rawSteps = leg['steps'];
    if (rawSteps is List) {
      for (final rawStep in rawSteps.whereType<Map>()) {
        final maneuver = rawStep['maneuver'];
        if (maneuver is! Map) {
          continue;
        }
        final location = maneuver['location'];
        if (location is! List || location.length < 2) {
          continue;
        }

        final point = LatLng(
          (location[1] as num).toDouble(),
          (location[0] as num).toDouble(),
        );
        if (!point.isValid) {
          continue;
        }

        steps.add(
          MapboxRouteStep(
            endLocation: point,
            instruction:
                maneuver['instruction']?.toString().trim().isNotEmpty == true
                    ? maneuver['instruction'].toString()
                    : 'Continue',
            distanceMeters: (rawStep['distance'] as num?)?.toDouble() ?? 0.0,
            durationSeconds: (rawStep['duration'] as num?)?.toDouble() ?? 0.0,
          ),
        );
      }
    }
  }

  return MapboxRouteResult(
    points: points.length > 1 ? points : [origin, destination],
    distanceText: formatMapboxDistance(
      (route['distance'] as num?)?.toDouble() ?? 0.0,
    ),
    durationText: formatMapboxDuration(
      (route['duration'] as num?)?.toDouble() ?? 0.0,
    ),
    steps: steps,
  );
}

String formatMapboxDistance(double meters) {
  if (meters <= 0) {
    return '--';
  }
  final miles = meters * 0.000621371;
  if (miles < 0.1) {
    return '${meters.round()} m';
  }
  return '${miles.toStringAsFixed(miles >= 10 ? 0 : 1)} mi';
}

String formatMapboxDuration(double seconds) {
  if (seconds <= 0) {
    return '--';
  }
  final minutes = (seconds / 60).round().clamp(1, 100000);
  if (minutes < 60) {
    return '$minutes min';
  }
  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;
  return remainingMinutes == 0
      ? '$hours hr'
      : '$hours hr $remainingMinutes min';
}

Future<Uint8List> loadResizedAssetBytes(
  String assetPath, {
  required int width,
  required int height,
}) async {
  final bytes = await rootBundle.load(assetPath);
  final codec = await ui.instantiateImageCodec(
    bytes.buffer.asUint8List(),
    targetWidth: width,
    targetHeight: height,
  );
  final frameInfo = await codec.getNextFrame();
  final byteData = await frameInfo.image.toByteData(
    format: ui.ImageByteFormat.png,
  );
  return byteData!.buffer.asUint8List();
}

Future<Uint8List> buildPinMarkerBytes(Color color) async {
  const width = 92;
  const height = 112;
  const center = Offset(width / 2, 38);
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final fill = Paint()..color = color;
  final shadow = Paint()..color = const Color(0x33000000);
  final highlight = Paint()..color = Colors.white;

  canvas.drawOval(
    Rect.fromCenter(
      center: const Offset(width / 2, 101),
      width: 34,
      height: 10,
    ),
    shadow,
  );

  final path =
      Path()
        ..addOval(Rect.fromCircle(center: center, radius: 32))
        ..moveTo(width / 2 - 14, 63)
        ..quadraticBezierTo(width / 2, 95, width / 2 + 14, 63)
        ..close();
  canvas.drawPath(path, fill);
  canvas.drawCircle(center, 16, highlight);
  canvas.drawCircle(center, 9, Paint()..color = color.withOpacity(0.9));

  final image = await recorder.endRecording().toImage(width, height);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return bytes!.buffer.asUint8List();
}

Future<Uint8List> buildDriverMarkerBytes({
  Color color = const Color(0xFF0E7C66),
  Color accentColor = const Color(0xFFE2A84F),
}) async {
  const markerWidth = 112;
  const markerHeight = 136;
  const center = Offset(markerWidth / 2, 52);
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final pinPath =
      Path()
        ..moveTo(markerWidth / 2, markerHeight - 8)
        ..cubicTo(47, 116, 16, 90, 16, 52)
        ..cubicTo(16, 26, 34, 8, markerWidth / 2, 8)
        ..cubicTo(78, 8, 96, 26, 96, 52)
        ..cubicTo(96, 90, 65, 116, markerWidth / 2, markerHeight - 8)
        ..close();

  canvas.drawPath(
    pinPath.shift(const Offset(0, 5)),
    Paint()
      ..color = const Color(0x33000000)
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 8),
  );
  canvas.drawPath(pinPath, Paint()..color = Colors.white);
  canvas.drawPath(
    pinPath,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = color,
  );

  canvas.drawCircle(center, 34, Paint()..color = color);
  canvas.drawCircle(
    center,
    27,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0x26FFFFFF),
  );

  const carIcon = Icons.local_taxi_rounded;
  final iconPainter = TextPainter(
    text: TextSpan(
      text: String.fromCharCode(carIcon.codePoint),
      style: TextStyle(
        color: Colors.white,
        fontFamily: carIcon.fontFamily,
        package: carIcon.fontPackage,
        fontSize: 42,
        height: 1,
      ),
    ),
    textDirection: ui.TextDirection.ltr,
  )..layout();
  iconPainter.paint(
    canvas,
    Offset(
      center.dx - iconPainter.width / 2,
      center.dy - iconPainter.height / 2,
    ),
  );

  canvas.drawCircle(
    const Offset(markerWidth / 2, markerHeight - 13),
    4,
    Paint()..color = accentColor,
  );

  final picture = recorder.endRecording();
  final image = await picture.toImage(markerWidth, markerHeight);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  picture.dispose();
  return byteData!.buffer.asUint8List();
}

class MapboxRouteMap extends StatefulWidget {
  const MapboxRouteMap({
    super.key,
    required this.center,
    this.route = const <LatLng>[],
    this.markers = const <MapboxRouteMarker>[],
    this.initialZoom = 14,
    this.routeColor = const Color(0xFF1E88E5),
    this.fitRoute = true,
    this.followCenter = false,
    this.showZoomButtons = true,
    this.enableLocationPuck = true,
    this.styleUri = mapbox.MapboxStyles.STANDARD,
    this.routePadding,
    this.onMapCreated,
  });

  final LatLng center;
  final List<LatLng> route;
  final List<MapboxRouteMarker> markers;
  final double initialZoom;
  final Color routeColor;
  final bool fitRoute;
  final bool followCenter;
  final bool showZoomButtons;
  final bool enableLocationPuck;
  final String styleUri;
  final mapbox.MbxEdgeInsets? routePadding;
  final ValueChanged<mapbox.MapboxMap>? onMapCreated;

  @override
  State<MapboxRouteMap> createState() => _MapboxRouteMapState();
}

class _MapboxRouteMapState extends State<MapboxRouteMap> {
  mapbox.MapboxMap? _mapboxMap;
  mapbox.PointAnnotationManager? _pointManager;
  mapbox.PolylineAnnotationManager? _polylineManager;
  final _markerImageCache = <int, Uint8List>{};
  bool _styleReady = false;
  String? _lastCameraSignature;

  @override
  void didUpdateWidget(covariant MapboxRouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_syncMap()));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        mapbox.MapWidget(
          styleUri: widget.styleUri,
          cameraOptions: mapbox.CameraOptions(
            center: widget.center.mapboxPoint,
            zoom: widget.initialZoom,
            pitch: 0,
          ),
          gestureRecognizers: mapboxGestureRecognizers,
          onMapCreated: _onMapCreated,
          onStyleLoadedListener: (_) async {
            _styleReady = true;
            await _syncMap();
          },
        ),
        if (widget.showZoomButtons)
          Positioned(
            top: 12,
            right: 12,
            child: Column(
              children: [
                _ZoomButton(icon: Icons.add, onPressed: () => _zoomBy(1)),
                const SizedBox(height: 8),
                _ZoomButton(icon: Icons.remove, onPressed: () => _zoomBy(-1)),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _onMapCreated(mapbox.MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    _pointManager = await mapboxMap.annotations.createPointAnnotationManager();
    _polylineManager =
        await mapboxMap.annotations.createPolylineAnnotationManager();
    await _configureMap(mapboxMap);
    widget.onMapCreated?.call(mapboxMap);
    await _syncMap();
  }

  Future<void> _configureMap(mapbox.MapboxMap mapboxMap) async {
    await mapboxMap.gestures.updateSettings(
      mapbox.GesturesSettings(
        rotateEnabled: true,
        pinchToZoomEnabled: true,
        scrollEnabled: true,
        pitchEnabled: true,
        doubleTapToZoomInEnabled: true,
        doubleTouchToZoomOutEnabled: true,
        quickZoomEnabled: true,
        pinchPanEnabled: true,
      ),
    );
    await configureMapboxControls(mapboxMap);
    await mapboxMap.location.updateSettings(
      mapbox.LocationComponentSettings(
        enabled: widget.enableLocationPuck,
        pulsingEnabled: widget.enableLocationPuck,
        showAccuracyRing: widget.enableLocationPuck,
        puckBearingEnabled: widget.enableLocationPuck,
        puckBearing: mapbox.PuckBearing.HEADING,
      ),
    );
  }

  Future<void> _syncMap() async {
    final pointManager = _pointManager;
    final polylineManager = _polylineManager;
    if (!_styleReady || pointManager == null || polylineManager == null) {
      return;
    }

    await pointManager.deleteAll();
    await polylineManager.deleteAll();

    final pointOptions = <mapbox.PointAnnotationOptions>[];
    for (final marker in widget.markers.where(
      (marker) => marker.point.isValid,
    )) {
      var image = marker.image;
      if (image == null) {
        final cacheKey = marker.color.value;
        image = _markerImageCache[cacheKey];
        if (image == null) {
          image = await buildPinMarkerBytes(marker.color);
          _markerImageCache[cacheKey] = image;
        }
      }
      pointOptions.add(
        mapbox.PointAnnotationOptions(
          geometry: marker.point.mapboxPoint,
          image: image,
          iconSize: marker.iconSize,
          iconAnchor: mapbox.IconAnchor.BOTTOM,
        ),
      );
    }
    if (pointOptions.isNotEmpty) {
      await pointManager.createMulti(pointOptions);
    }

    final route = widget.route
        .where((point) => point.isValid)
        .toList(growable: false);
    if (route.length > 1) {
      await polylineManager.create(
        mapbox.PolylineAnnotationOptions(
          geometry: mapbox.LineString(
            coordinates:
                route
                    .map(
                      (point) =>
                          mapbox.Position(point.longitude, point.latitude),
                    )
                    .toList(),
          ),
          lineColor: widget.routeColor.value,
          lineWidth: 6,
          lineOpacity: 0.95,
          lineBorderColor: Colors.white.value,
          lineBorderWidth: 1.5,
        ),
      );
    }

    if (widget.fitRoute && route.length > 1) {
      await _fitToPoints(route);
    } else if (widget.followCenter && widget.center.isValid) {
      await _moveToCenter();
    }
  }

  Future<void> _fitToPoints(List<LatLng> route) async {
    final mapboxMap = _mapboxMap;
    if (mapboxMap == null) {
      return;
    }

    final allPoints = <LatLng>[
      ...route,
      ...widget.markers
          .map((marker) => marker.point)
          .where((point) => point.isValid),
    ];
    final signature = allPoints
        .map(
          (point) =>
              '${point.latitude.toStringAsFixed(5)},${point.longitude.toStringAsFixed(5)}',
        )
        .join('|');
    if (_lastCameraSignature == signature) {
      return;
    }
    _lastCameraSignature = signature;

    final camera = await mapboxMap.cameraForCoordinatesPadding(
      allPoints.map((point) => point.mapboxPoint).toList(),
      mapbox.CameraOptions(bearing: 0, pitch: 0),
      widget.routePadding ??
          mapbox.MbxEdgeInsets(top: 80, left: 48, bottom: 96, right: 48),
      null,
      null,
    );
    await mapboxMap.flyTo(camera, mapbox.MapAnimationOptions(duration: 650));
  }

  Future<void> _moveToCenter() async {
    final mapboxMap = _mapboxMap;
    if (mapboxMap == null) {
      return;
    }
    final signature =
        'center:${widget.center.latitude.toStringAsFixed(5)},${widget.center.longitude.toStringAsFixed(5)}';
    if (_lastCameraSignature == signature) {
      return;
    }
    _lastCameraSignature = signature;

    await mapboxMap.flyTo(
      mapbox.CameraOptions(
        center: widget.center.mapboxPoint,
        zoom: widget.initialZoom,
        pitch: 0,
      ),
      mapbox.MapAnimationOptions(duration: 550),
    );
  }

  Future<void> _zoomBy(double delta) async {
    final mapboxMap = _mapboxMap;
    if (mapboxMap == null) {
      return;
    }

    await mapboxMap.cancelCameraAnimation();
    final state = await mapboxMap.getCameraState();
    final nextZoom = math.max(2.0, math.min(21.0, state.zoom + delta));
    await mapboxMap.easeTo(
      mapbox.CameraOptions(
        center: state.center,
        zoom: nextZoom,
        bearing: state.bearing,
        pitch: state.pitch,
      ),
      mapbox.MapAnimationOptions(duration: 180),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: const Color(0xFF18202A), size: 24),
        ),
      ),
    );
  }
}
