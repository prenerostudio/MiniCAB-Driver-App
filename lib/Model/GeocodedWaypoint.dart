class Geo {
  List<GeocodedWaypoint>? geocodedWaypoints;
  List<Route>? routes;
  String? status;

  Geo({
    this.geocodedWaypoints,
    this.routes,
    this.status,
  });

}

class GeocodedWaypoint {
  String? geocoderStatus;
  bool? partialMatch;
  String? placeId;
  List<String>? types;

  GeocodedWaypoint({
    this.geocoderStatus,
    this.partialMatch,
    this.placeId,
    this.types,
  });

}

class Route {
  Bounds? bounds;
  String? copyrights;
  List<Leg>? legs;
  Polyline? overviewPolyline;
  String? summary;
  List<dynamic>? warnings;
  List<dynamic>? waypointOrder;

  Route({
    this.bounds,
    this.copyrights,
    this.legs,
    this.overviewPolyline,
    this.summary,
    this.warnings,
    this.waypointOrder,
  });

}

class Bounds {
  Northeast? northeast;
  Northeast? southwest;

  Bounds({
    this.northeast,
    this.southwest,
  });

}

class Northeast {
  double? lat;
  double? lng;

  Northeast({
    this.lat,
    this.lng,
  });

}

class Leg {
  Distance? distance;
  Duration? duration;
  String? endAddress;
  Northeast? endLocation;
  String? startAddress;
  Northeast? startLocation;
  List<Step>? steps;
  List<dynamic>? trafficSpeedEntry;
  List<dynamic>? viaWaypoint;

  Leg({
    this.distance,
    this.duration,
    this.endAddress,
    this.endLocation,
    this.startAddress,
    this.startLocation,
    this.steps,
    this.trafficSpeedEntry,
    this.viaWaypoint,
  });

}

class Distance {
  String? text;
  int? value;

  Distance({
    this.text,
    this.value,
  });

}

class Step {
  Distance? distance;
  Distance? duration;
  Northeast? endLocation;
  String? htmlInstructions;
  Polyline? polyline;
  Northeast? startLocation;
  String? travelMode;
  String? maneuver;

  Step({
    this.distance,
    this.duration,
    this.endLocation,
    this.htmlInstructions,
    this.polyline,
    this.startLocation,
    this.travelMode,
    this.maneuver,
  });

}

class Polyline {
  String? points;

  Polyline({
    this.points,
  });

}
