import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();

  static const String siteBaseUrl = 'https://www.minicaboffice.com/';
  static const String apiBaseUrl = '$siteBaseUrl/api';
  static const String driverBaseUrl = '$apiBaseUrl/driver';
  static const String bookerBaseUrl = '$apiBaseUrl/booker';
  static const String googleMapsApiBaseUrl =
      'https://maps.googleapis.com/maps/api';
  static const String googleDirectionsEndpoint =
      '$googleMapsApiBaseUrl/directions/json';
  static const String googleGeocodeEndpoint =
      '$googleMapsApiBaseUrl/geocode/json';
  static const String mapboxDrivingTrafficEndpoint =
      'https://api.mapbox.com/directions/v5/mapbox/driving-traffic';

  static Uri uri(String endpoint) => Uri.parse(endpoint);

  static Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
  }) {
    return http.get(uri(endpoint), headers: headers);
  }

  static Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return http.post(
      uri(endpoint),
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  static http.MultipartRequest multipartRequest(
    String method,
    String endpoint,
  ) {
    return http.MultipartRequest(method, uri(endpoint));
  }

  static Uri googleGeocodeUri({
    required String address,
    required String apiKey,
  }) {
    return uri(
      googleGeocodeEndpoint,
    ).replace(queryParameters: {'address': address, 'key': apiKey});
  }

  static String googleDirectionsUrl({
    required String origin,
    required String destination,
    required String apiKey,
    bool alternatives = false,
  }) {
    return uri(googleDirectionsEndpoint)
        .replace(
          queryParameters: {
            'origin': origin,
            'destination': destination,
            if (alternatives) 'alternatives': 'true',
            'key': apiKey,
          },
        )
        .toString();
  }

  static String googleMapsSearchUrl(double lat, double lng) {
    return Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': '$lat,$lng',
    }).toString();
  }

  static String googleMapsNavigationUrl(double lat, double lng) {
    return Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': '$lat,$lng',
    }).toString();
  }

  static String wazeNavigationUrl({
    required double destinationLat,
    required double destinationLng,
    required double currentLat,
    required double currentLng,
  }) {
    return Uri.https('www.waze.com', '/ul', {
      'll': '$destinationLat,$destinationLng',
      'navigate': 'yes',
      'from': '$currentLat,$currentLng',
    }).toString();
  }

  static String tomTomRouteUrl({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
    required String apiKey,
    bool traffic = false,
  }) {
    return Uri.https(
      'api.tomtom.com',
      '/routing/1/calculateRoute/$originLat,$originLng:$destinationLat,$destinationLng/json',
      {'key': apiKey, if (traffic) 'traffic': 'true'},
    ).toString();
  }

  static Uri mapboxDrivingTrafficUri({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
    required String accessToken,
  }) {
    return uri(
      '$mapboxDrivingTrafficEndpoint/$originLng,$originLat;$destinationLng,$destinationLat',
    ).replace(
      queryParameters: {
        'geometries': 'geojson',
        'overview': 'full',
        'steps': 'true',
        'voice_instructions': 'true',
        'banner_instructions': 'true',
        'access_token': accessToken,
      },
    );
  }

  static const String bookerAddCard = '$bookerBaseUrl/add-card.php';
  static const String driverAcceptedBids =
      '$driverBaseUrl/bids/accepted-bids.php';
  static const String driverAcceptedJobDetails =
      '$driverBaseUrl/accepted-job-details.php';
  static const String driverAcceptedJobs =
      '$driverBaseUrl/jobs/accepted-jobs.php';
  static const String driverAcceptedJobsToday =
      '$driverBaseUrl/jobs/accepted-jobs-today.php';
  static const String driverAcceptedTimeSlot =
      '$driverBaseUrl/timeslots/accepted-time-slot.php';
  static const String driverAcceptJob = '$driverBaseUrl/jobs/accept-job.php';
  static const String driverAcceptTimeSlot =
      '$driverBaseUrl/timeslots/accept-time-slot.php';
  static const String driverAccountsTotalDueBalance =
      '$driverBaseUrl/accounts/total-due-balance.php';
  static const String driverActivityFetchVehicles =
      '$driverBaseUrl/activity/fetch-vehicles.php';
  static const String driverActivityOnlineStatus =
      '$driverBaseUrl/activity/online-status.php';
  static const String driverActivityRealLocation =
      '$driverBaseUrl/activity/real-location.php';
  static const String driverAddBankAccount =
      '$driverBaseUrl/accounts/add-bank-account.php';
  static const String driverAddFares = '$driverBaseUrl/jobs/add-fares.php';
  static const String driverAddVehicle = '$driverBaseUrl/add-vehicle.php';
  static const String driverAssignJob = '$driverBaseUrl/assign-job.php';
  static const String driverAuthenticationCheckLoginToken =
      '$driverBaseUrl/authentication/check-login-token.php';
  static const String driverAuthenticationRegister =
      '$driverBaseUrl/authentication/register.php';
  static const String driverAuthenticationSignin =
      '$driverBaseUrl/authentication/signin.php';
  static const String driverAuthenticationViewProfile =
      '$driverBaseUrl/authentication/view-profile.php';
  static const String driverBidDetails = '$driverBaseUrl/bids/bid-details.php';
  static const String driverBidHistory = '$driverBaseUrl/bids/bid-history.php';
  static const String driverBidList = '$driverBaseUrl/bids/bid-list.php';
  static const String driverBidNow = '$driverBaseUrl/bids/bid-now.php';
  static const String driverCalculateWaitingTime =
      '$driverBaseUrl/jobs/calculate-waiting-time.php';
  static const String driverCancelBooking =
      '$driverBaseUrl/jobs/cancel-booking.php';

  static const String driverCompleteJob =
      '$driverBaseUrl/jobs/complete-job.php';
  static const String driverCompleteTimeSlot =
      '$driverBaseUrl/timeslots/complete-time-slot.php';
  static const String driverDocumentsCheckVehicleDocuments =
      '$driverBaseUrl/documents/check-vehicle-documents.php';
  static const String driverEarningLastJob =
      '$driverBaseUrl/accounts/earning-last-job.php';
  static const String driverEarningLastWeek =
      '$driverBaseUrl/accounts/earning-last-week.php';
  static const String driverEarningToday =
      '$driverBaseUrl/accounts/earning-today.php';
  static const String driverEditBid = '$driverBaseUrl/bids/edit-bid.php';
  static const String driverEndBreak = '$driverBaseUrl/activity/end-break.php';
  static const String driverFetchFares = '$driverBaseUrl/jobs/fetch-fares.php';
  static const String driverFetchReviews =
      '$driverBaseUrl/activity/fetch-reviews.php';
  static const String driverFetchTimeSlot =
      '$driverBaseUrl/timeslots/fetch-time-slots.php';

  static const String driverFetchVehicles =
      '$driverBaseUrl/activity/fetch-vehicles.php';
  static const String driverInvoiceDetails =
      '$driverBaseUrl/accounts/invoice-details.php';
  static const String driverJobHistory = '$driverBaseUrl/jobs/job-history.php';
  static const String driverJobsAcceptedJobsToday =
      '$driverBaseUrl/jobs/accepted-jobs-today.php';
  static const String driverJobsCheckJobStatus =
      '$driverBaseUrl/jobs/check-job-status.php';
  static const String driverJobsUpcomingJobs =
      '$driverBaseUrl/jobs/upcoming-jobs.php';
  static const String driverOnlineStatus =
      '$driverBaseUrl/activity/online-status.php';
  static const String driverOnRide = '$driverBaseUrl/jobs/on-ride.php';
  static const String driverOpenBookings = '$driverBaseUrl/open-bookings.php';
  static const String driverPassengerWaiting =
      '$driverBaseUrl/jobs/passenger-waiting.php';
  static const String driverRealLocation =
      '$driverBaseUrl/activity/real-location.php';
  static const String driverRegister =
      '$driverBaseUrl/authentication/register.php';
  static const String driverReport = '$driverBaseUrl/accounts/report.php';
  static const String driverSelectBooking = '$driverBaseUrl/select-booking.php';
  static const String driverSignin = '$driverBaseUrl/authentication/signin.php';
  static const String driverStartBreak =
      '$driverBaseUrl/activity/start-break.php';
  static const String driverTimeslotsAcceptTimeSlot =
      '$driverBaseUrl/timeslots/accept-time-slot.php';
  static const String driverTimeslotsCompleteTimeSlot =
      '$driverBaseUrl/timeslots/complete-time-slot.php';
  static const String driverTimeslotsFetchTimeSlot =
      '$driverBaseUrl/timeslots/fetch-time-slot.php';
  static const String driverTimeslotsRejectTimeSlot =
      '$driverBaseUrl/timeslots/reject-time-slot.php';
  static const String driverTotalDueBalance =
      '$driverBaseUrl/accounts/total-due-balance.php';
  static const String driverTotalEarningsLastWeek =
      '$driverBaseUrl/accounts/total-earnings-last-week.php';
  static const String driverUpcomingJobs =
      '$driverBaseUrl/jobs/upcoming-jobs.php';
  static const String driverUpcomingNextWeek =
      '$driverBaseUrl/jobs/upcoming-next-week.php';
  static const String driverUpdateProfile =
      '$driverBaseUrl/authentication/update-profile.php';
  static const String driverUploadAddressProof =
      '$driverBaseUrl/documents/driver/upload-address-proof.php';
  static const String driverUploadDrivingLicense =
      '$driverBaseUrl/documents/driver/upload-driving-license.php';
  static const String driverUploadDvla =
      '$driverBaseUrl/documents/driver/upload-dvla.php';
  static const String driverUploadExtra =
      '$driverBaseUrl/documents/driver/upload-extra.php';
  static const String driverUploadInsSche =
      '$driverBaseUrl/documents/vehicle/upload-ins-sche.php';
  static const String driverUploadInsurance =
      '$driverBaseUrl/documents/vehicle/upload-insurance.php';

  static const String driverUploadLogBook =
      '$driverBaseUrl/documents/vehicle/upload-log-book.php';
  static const String driverUploadMot =
      '$driverBaseUrl/documents/vehicle/upload-mot.php';
  static const String driverUploadNi =
      '$driverBaseUrl/documents/driver/upload-ni.php';

  static const String driverUploadPco =
      '$driverBaseUrl/documents/driver/upload-pco.php';
  static const String driverUploadRentalAgreement =
      '$driverBaseUrl/documents/vehicle/upload-rental-agreement.php';
  static const String driverUploadRoadTax =
      '$driverBaseUrl/documents/vehicle/upload-road-tax.php';
  static const String driverUploadVehiclePictureBack =
      '$driverBaseUrl/documents/vehicle/upload-vehicle-picture-back.php';
  static const String driverUploadVehiclePictureFront =
      '$driverBaseUrl/udocuments/vehicle/pload-vehicle-picture-front.php';
  static const String driverUploadVehiclePictures =
      '$driverBaseUrl/documents/vehicle/upload-vehicle-pictures.php';
  static const String driverUploadVpco =
      '$driverBaseUrl/documents/vehicle/upload-vpco.php';
  static const String driverViewProfile = driverAuthenticationViewProfile;
  static const String driverWayToPickup =
      '$driverBaseUrl/jobs/way-to-pickup.php';
  static const String driverZones = '$driverBaseUrl/zones.php';

  static String driverImageUrl(String? path) =>
      '$siteBaseUrl/img/drivers/${path ?? ''}';
}
