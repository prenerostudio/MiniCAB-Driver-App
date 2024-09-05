import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:mini_cab/home/home_view_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import '../Data/links.dart';
import '../components/clientnotes_widget.dart';
import '../components/waydetails_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pob_model.dart';
export 'pob_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'dart:async';
import 'dart:convert';
import 'package:google_distance_matrix/google_distance_matrix.dart';

class PobWidget extends StatefulWidget {
  const PobWidget({
    Key? key,
    // required this.did,
    // required this.jobid,
    // required this.pickup,
    // required this.dropoff,
    // required this.cName,
    // required this.fare,
    // required this.distance,
    // required this.note,
    // required this.pickTime,
    // required this.pickDate,
    // required this.passenger,
    // required this.luggage,
    // required this.cnumber,
    // required this.cemail,
  }) : super(key: key);

  // final String? did;
  // final String? jobid;
  // final String? pickup;
  // final String? dropoff;
  // final String? cName;
  // final String? fare;
  // final String? distance;
  // final String? note;
  // final String? pickTime;
  // final String? pickDate;
  // final String? passenger;
  // final String? luggage;
  // final String? cnumber;
  // final String? cemail;

  @override
  _PobWidgetState createState() => _PobWidgetState();
}

class _PobWidgetState extends State<PobWidget> {
  late PobModel _model;
  late GoogleMapController mapController;
  late PolylinePoints polylinePoints;
  // Map<PolylineId, Polyline> polylines = {};
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  String distanceText = '';
  String durationText = '';
  late GoogleMapController _mapController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _kGoogle;
  late Timer _locationTimer;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  late Position _currentPosition;
  bool isLoading = false;
  double dropffLat = 0;
  double dropffLng = 0;
  double currentLatitude = 0;
  double currentLongitude = 0;
  String distance = '';

  List<Marker> markers = [];
  List<LatLng> _polylineCoordinates = [];
  @override
  void initState() {
    super.initState();
    loadata().then((s) {});
    sendOnRideRequest();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _setupMarkersAndPolylines();
    _model = createModel(context, () => PobModel());
  }

  double pickupLat = 0.0;
  double pickupLng = 0.0;
  final JobController myController = Get.put(JobController());

  String? did;
  String? jobid;
  String? pickup;
  String dropoff = '--';
  String? cName;
  String? fare;

  String? note;
  String? pickTime;
  String? pickDate;
  String? passenger;
  String? luggage;
  String? cnumber;
  String? cemail;
  Future loadata() async {
    // myController.jobDetails();
    SharedPreferences sp = await SharedPreferences.getInstance();
    // isWaiting = sp.getBool('isWaitingTrue') ?? false;
    setState(() {});
    // widget.did = sp.getString('did');
    // widget.jobid = sp.getString('jobId');
    // widget.pickup = sp.getString('pickup');
    // widget.dropoff = sp.getString('destination');
    // widget.cName = sp.getString('cName');
    // widget.fare = sp.getString('journeyFare');
    // widget.distance = sp.getString('journeyDistance');
    // widget.note = sp.getString('note');
    // widget.pickTime = sp.getString('pickTime');
    // widget.pickDate = sp.getString('pickDate');
    // widget.passenger = sp.getString('passenger');
    // widget.luggage = sp.getString('laggage');
    // widget.cnumber = sp.getString('cPhone');
    // widget.cemail = sp.getString('cEmail');
    await myController.acceptedJobDetails().then((value) {
      if (value != null) {
        print("after job details $value");
        did = value.dId;
        jobid = value.jobId;
        pickup = value.pickup;
        dropoff = value.destination;
        cName = value.cName;
        fare = value.journeyFare;
        distance = value.journeyDistance;
        note = value.note;
        pickTime = value.pickTime;
        pickDate = value.pickDate;
        passenger = value.passenger;
        luggage = value.luggage;
        cnumber = value.cPhone;
        cemail = value.cEmail;
      } else {
        print("No job details found.");
        // Handle the null case, e.g., show an error message, redirect, etc.
      }
    });
    getCoordinatesFromAddress(dropoff);
  }

  @override
  void dispose() {
    _model.dispose();
    _locationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            title: Text(
              'At DropOff',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Outfit',
                    color: FlutterFlowTheme.of(context).primary,
                    fontSize: 22,
                  ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 2,
          ),
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 0.87,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Stack(
                      children: [
                        isLoading
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          FlutterFlowTheme.of(context).primary),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Finding Route...',
                                      style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .primary),
                                    ),
                                  ],
                                ),
                              )
                            : buildMap(),
                        Align(
                          alignment: AlignmentDirectional(0.00, 1.00),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.30,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Wrap(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize
                                                .min, // Set this to MainAxisSize.min
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 10.0, 0.0, 10.0),
                                                child: Icon(
                                                  Icons.pin_drop_outlined,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 25,
                                                ),
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(10.0, 10.0, 0.0,
                                                          20.0),
                                                  child: Text(
                                                    '${dropoff}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          fontSize: 20.0,
                                                          letterSpacing: 1.5,
                                                        ),
                                                    overflow: TextOverflow
                                                        .ellipsis, // Handle text overflow with ellipsis
                                                    maxLines:
                                                        3, // Limit to a maximum of 2 lines
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 10, 10, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            FlutterFlowIconButton(
                                              borderColor: Color(0xFF5B68F5),
                                              borderWidth: 1,
                                              buttonSize: 48,
                                              fillColor: Color(0xFF5B68F5),
                                              icon: FaIcon(
                                                FontAwesomeIcons.ellipsisH,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                size: 24,
                                              ),
                                              onPressed: () async {
                                                await showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  enableDrag: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return Padding(
                                                      padding: MediaQuery
                                                          .viewInsetsOf(
                                                              context),
                                                      child: WaydetailsWidget(
                                                        time: '${pickTime}',
                                                        date: '${pickDate}',
                                                        passanger:
                                                            '${passenger}',
                                                        cName: '${cName}',
                                                        cnumber: '${cnumber}',
                                                        luggage: '${luggage}',
                                                        pickup: '${pickup}',
                                                        dropoff: '${dropoff}',
                                                        cNote: '${note}',
                                                        cemail: '${cemail}',
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));
                                              },
                                            ),
                                            FFButtonWidget(
                                              onPressed: () async {
                                                await showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  enableDrag: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return Padding(
                                                      padding: MediaQuery
                                                          .viewInsetsOf(
                                                              context),
                                                      child: ClientnotesWidget(
                                                        name: '${cName}',
                                                        notes: '${note}',
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));
                                              },
                                              text: 'VIEW NOTE',
                                              icon: FaIcon(
                                                FontAwesomeIcons.infoCircle,
                                                size: 21,
                                              ),
                                              options: FFButtonOptions(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.4,
                                                height: 45,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(24, 0, 24, 0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 0, 0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: Colors.white,
                                                        ),
                                                elevation: 3,
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            15, 20, 15, 0),
                                        child: SwipeButton(
                                          thumbPadding: EdgeInsets.all(3),
                                          thumb: Icon(
                                            Icons.chevron_right,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                          elevationThumb: 2,
                                          elevationTrack: 2,
                                          activeThumbColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryBackground,
                                          activeTrackColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Text(
                                            'AT DROP OFF'.toUpperCase(),
                                            style: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onSwipe: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text('AT DROP OFF'),
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                              ),
                                            );
                                          },
                                          onSwipeEnd: () async {
                                            SharedPreferences sp =
                                                await SharedPreferences
                                                    .getInstance();

                                            context.pushNamed(
                                              'PaymentEntery',
                                              queryParameters: {
                                                'jobid': serializeParam(
                                                    '${jobid}',
                                                    ParamType.String),
                                                'did': serializeParam(
                                                    '${did}', ParamType.String),
                                                'fare': serializeParam(
                                                    '${fare}',
                                                    ParamType.String),
                                              }.withoutNulls,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMap() {
    return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            _currentPosition?.latitude ?? 0.0,
            _currentPosition?.longitude ?? 0.0,
          ),
          zoom: 10,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: _onMapCreated,
        markers: {
          Marker(
              markerId: const MarkerId('Source'),
              position: LatLng(
                  _currentPosition!.latitude, _currentPosition!.longitude),
              icon: sourceicon),
          Marker(
              markerId: const MarkerId('destination'),
              position: LatLng(convertedLat, convertedLng),
              icon: destinationicon),
        },
        // markers: Set<Marker>.of(markers),
        polylines: polylines);
  }

  Future getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {});
        convertedLat = locations.first.latitude;
        convertedLng = locations.first.longitude;
        print(
            'convert Latitude: ${convertedLat}, convert longitude: ${convertedLng}');
        setcustommarkeritem();

        _getPolyline(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future _getPolyline(double destinationLat, double desLng) async {
    print('tapped');
    const apiKey =
        'AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA'; // Replace with your Google Maps API key
    var origin =
        '${_currentPosition!.latitude},${_currentPosition!.longitude}'; // Replace with your source coordinates
    var destination =
        // '31.414050,73.0613070'; // Replace with your destination coordinates // Replace with your destination coordinates
        '${destinationLat},${desLng}'; // Replace with your destination coordinates // Replace with your destination coordinates
    print("the polylines start");
    final response = await http.post(Uri.parse(// can be get and post request
        // 'https://maps.googleapis.com/maps/api/directions/json?origin=31.4064054,73.0413076&destination=31.6404050,73.2413070&key=AIzaSyBBSmpcyEaIojvZznYVNpCU0Htvdabe__Y'));
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey'));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = jsonDecode(response.body);
      // print(data);
      if (data.containsKey('routes') && data['routes'].isNotEmpty) {
        final route = data['routes'][0];
        if (route.containsKey('legs') && route['legs'].isNotEmpty) {
          final leg = route['legs'][0];
          setState(() {});
          if (leg.containsKey('distance')) {
            distance = leg['distance']['text'];
            // time.value = leg['duration']['text'];

            final points = route['overview_polyline']['points'];

            // Decode polyline points and add them to the map
            decodedPoints = PolylinePoints()
                .decodePolyline(points)
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();
            // polylines.value.clear();
            print("the polylines point is $points");
            polylines.add(Polyline(
              // patterns: [PatternItem.dash(20), PatternItem.gap(10)],
              // patterns: points,
              polylineId: const PolylineId('route'),
              color: Colors.blue,
              width: 5,
              points: decodedPoints,
            ));
          }
        }
      }
    }
  }

  double convertedLat = 0;
  double convertedLng = 0;
  void setcustommarkeritem() async {
    setState(() {});
    final Uint8List sourceImage =
        await getbytesfromimages('assets/images/car.png', 80, 80);
    final Uint8List destinationImage =
        await getbytesfromimages('assets/images/flag.png', 80, 80);

    sourceicon = BitmapDescriptor.fromBytes(sourceImage);
    destinationicon = BitmapDescriptor.fromBytes(destinationImage);
  }

  Future<Uint8List> getbytesfromimages(
      String path, int width, int height) async {
    setState(() {});
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  final apiKey = 'AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA';

  List<LatLng> decodedPoints = <LatLng>[];
  BitmapDescriptor sourceicon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationicon = BitmapDescriptor.defaultMarker;
  Future<void> sendOnRideRequest() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');
      print(dId);
      var request = http.MultipartRequest('POST',
          Uri.parse('https://minicaboffice.com/api/driver/on-ride.php'));
      request.fields.addAll({
        'd_id': dId.toString(),
      });
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        print('on Ride');
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  GoogleDistanceMatrix googleDistanceMatrix = GoogleDistanceMatrix();
  void _getDistanceMatrix() async {
    var distanceMatrix = await googleDistanceMatrix.getDistance(
      'AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA',
      origin: Coordinate(latitude: '-7.7665339', longitude: '110.3333601'),
      destination: Coordinate(latitude: '-7.7602694', longitude: '110.4051345'),
    );
    setState(() {
      distance = distanceMatrix as String;
      print(distance);
    });
  }

  String distance1 = '';
  String? originAddresses;
  String? destinationAddresses;
  String? duration;

  Future<String?> getDistanceMatrix() async {
    var request = await http.Request(
        'GET',
        Uri.parse(
            'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${pickup}&destinations=${dropoff}&key=AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA'));
    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var streamString = await response.stream.bytesToString();
        print(streamString);
        return streamString;
      } else {
        return response.reasonPhrase;
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<void> updateDistance() async {
    try {
      var result = await getDistanceMatrix();
      if (result != null) {
        final jsonResponse = json.decode(result);
        print(jsonResponse);
        originAddresses = jsonResponse['origin_addresses'][0];
        destinationAddresses = jsonResponse['destination_addresses'][0];
        distance1 = jsonResponse['rows'][0]['elements'][0]['distance']['text'];
        duration = jsonResponse['rows'][0]['elements'][0]['duration']['text'];
        print(
            "Origin: ${originAddresses}, Destination: $destinationAddresses, Distance: $distance1, Duration: $duration");
      }
    } catch (e) {
      setState(() {
        distance = 'Error: $e';
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        currentLatitude = position.latitude;
        currentLongitude = position.longitude;
      });
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  Future<void> _setupMarkersAndPolylines() async {
    setState(() {
      isLoading = true;
    });

    await _getCurrentLocation();

    if (currentLatitude != null && currentLongitude != null) {
      _kGoogle = CameraPosition(
        target: LatLng(currentLatitude, currentLongitude),
        zoom: 14,
      );

      _markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: LatLng(currentLatitude, currentLongitude),
          infoWindow: InfoWindow(
            title: 'Your Location',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }

    await getLocationFromAddress();

    List<LatLng> latLen = [
      LatLng(currentLatitude, currentLongitude),
      LatLng(dropffLat, dropffLng),
    ];

    for (int i = 0; i < latLen.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: latLen[i],
          infoWindow: InfoWindow(
            title: i == 0 ? 'Your Location' : 'Pickup Location',
          ),
          // icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }

    _polylines.add(
      Polyline(
        polylineId: PolylineId('1'),
        points: latLen,
        color: FlutterFlowTheme.of(context).primary,
        // Colors.deepOrange,
      ),
    );

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getLocationFromAddress() async {
    final apiKey = 'AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA';
    final apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
    final address = dropoff;
    final response = await http.post(
      Uri.parse('$apiUrl?address=$address&key=$apiKey'),
    );
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      if (decodedData['status'] == 'OK') {
        final results = decodedData['results'][0];
        final geometry = results['geometry'];
        final location = geometry['location'];
        dropffLat = location['lat'];
        dropffLng = location['lng'];
      } else {
        print('Error: ${decodedData['status']}');
      }
    } else {
      print('HTTP Request Error: ${response.statusCode}');
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    await _getCurrentLocation();
    await MapOptionDialog(context);
    setState(() {
      _mapController = controller;
    });

    final directionsService = DirectionsService();
    final request = DirectionsRequest(
      origin: '${_currentPosition?.latitude} ,${_currentPosition?.longitude}',
      destination: '${dropoff}',
    );
    print(request);
    directionsService.route(request,
        (DirectionsResult? response, DirectionsStatus? status) {
      if (status == DirectionsStatus.ok && response != null) {
        setState(() {
          final encodedPolyline = response.routes![0]?.overviewPolyline?.points;
          print('encoded    ${encodedPolyline}');
          if (encodedPolyline != null) {
            _polylineCoordinates = decodePolyline(encodedPolyline)!;
            print('polylineCoordinates ${_polylineCoordinates}');

            markers.add(
              Marker(
                markerId: MarkerId('origin'),
                position: LatLng(
                  response.routes![0]!.legs![0].startLocation!.latitude,
                  response.routes![0]!.legs![0].startLocation!.longitude,
                ),
              ),
            );
            markers.add(
              Marker(
                markerId: MarkerId('destination'),
                position: LatLng(
                  response.routes![0]!.legs![0].endLocation!.latitude,
                  response.routes![0]!.legs![0].endLocation!.longitude,
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ),
            );
          }
        });
      } else {
        print('Failed to fetch directions: $status');
      }
    });
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int lat = 0, lng = 0;

    while (index < encoded.length) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
      points.add(LatLng(latitude, longitude));
      print('lati ${latitude}');
    }
    return points;
  }

  Future MapOptionDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Map Option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: SizedBox(
                  width: 25,
                  height: 25,
                  child: Image.asset('assets/images/google.png'),
                ),
                title: Text('Using Google Maps'),
                onTap: () {
                  Navigator.pop(context);
                  MapUtils.navigateTo(dropffLat, dropffLng);
                },
              ),
              ListTile(
                leading: SizedBox(
                  width: 25,
                  height: 25,
                  child: Image.asset('assets/images/app_launcher_icon.png'),
                ),
                title: Text('Using Another App'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
