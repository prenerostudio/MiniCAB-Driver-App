import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();

  static const String siteBaseUrl = 'https://atiqramzan.online';
  static const String apiBaseUrl = '$siteBaseUrl/api';
  static const String driverBaseUrl = '$apiBaseUrl/driver';
  static const String bookerBaseUrl = '$apiBaseUrl/booker';
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

  static String mapboxMapPreviewUrl(double lat, double lng) {
    return Uri.https('www.mapbox.com', '/mapbox-gl-js/example/simple-map/', {
      'center': '$lng,$lat',
      'zoom': '14',
    }).toString();
  }

  static String mapboxDirectionsWebUrl({
    required double destinationLat,
    required double destinationLng,
    required double currentLat,
    required double currentLng,
  }) {
    return Uri.https('www.mapbox.com', '/directions/', {
      'origin': '$currentLng,$currentLat',
      'destination': '$destinationLng,$destinationLat',
      'profile': 'driving',
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
  static const String driverAcceptedBids = '$driverBaseUrl/accepted-bids.php';
  static const String driverAcceptedJobDetails =
      '$driverBaseUrl/accepted-job-details.php';
  static const String driverAcceptedJobs = '$driverBaseUrl/accepted-jobs.php';
  static const String driverAcceptedJobsToday =
      '$driverBaseUrl/accepted-jobs-today.php';
  static const String driverAcceptedTimeSlot =
      '$driverBaseUrl/accepted-time-slot.php';
  static const String driverAcceptJob = '$driverBaseUrl/accept-job.php';
  static const String driverAcceptTimeSlot =
      '$driverBaseUrl/accept-time-slot.php';
  static const String driverAccountsTotalDueBalance =
      '$driverBaseUrl/accounts/total-due-balance.php';
  static const String driverActivityFetchVehicles =
      '$driverBaseUrl/activity/fetch-vehicles.php';
  static const String driverActivityOnlineStatus =
      '$driverBaseUrl/activity/online-status.php';
  static const String driverActivityRealLocation =
      '$driverBaseUrl/activity/real-location.php';
  static const String driverAddBankAccount =
      '$driverBaseUrl/add-bank-account.php';
  static const String driverAddFares = '$driverBaseUrl/add-fares.php';
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
  static const String driverBidDetails = '$driverBaseUrl/bid-details.php';
  static const String driverBidHistory = '$driverBaseUrl/bid-history.php';
  static const String driverBidList = '$driverBaseUrl/bid-list.php';
  static const String driverBidNow = '$driverBaseUrl/bid-now.php';
  static const String driverCalculateWaitingTime =
      '$driverBaseUrl/calculate-waiting-time.php';
  static const String driverCancelBooking = '$driverBaseUrl/cancel-booking.php';
  static const String driverCheckAddressProof =
      '$driverBaseUrl/check-address-proof.php';
  static const String driverCheckAddressProof1 =
      '$driverBaseUrl/check-address-proof-1.php';
  static const String driverCheckAddressProof2 =
      '$driverBaseUrl/check-address-proof-2.php';
  static const String driverCheckDLicenseBack =
      '$driverBaseUrl/check-d-license-back.php';
  static const String driverCheckDLicenseFront =
      '$driverBaseUrl/check-d-license-front.php';
  static const String driverCheckDrivingLicense =
      '$driverBaseUrl/check-driving-license.php';
  static const String driverCheckDvlaCode =
      '$driverBaseUrl/check-dvla-code.php';
  static const String driverCheckExtraDocument =
      '$driverBaseUrl/check-extra-document.php';
  static const String driverCheckFareStatus =
      '$driverBaseUrl/check-fare-status.php';
  static const String driverCheckInsurance =
      '$driverBaseUrl/check-insurance.php';
  static const String driverCheckInsuranceSchedule =
      '$driverBaseUrl/check-insurance-schedule.php';
  static const String driverCheckJobStatus =
      '$driverBaseUrl/check-job-status.php';
  static const String driverCheckLogBook = '$driverBaseUrl/check-log-book.php';
  static const String driverCheckLoginToken =
      '$driverBaseUrl/check-login-token.php';
  static const String driverCheckMotCertificate =
      '$driverBaseUrl/check-mot-certificate.php';
  static const String driverCheckNationalInsurance =
      '$driverBaseUrl/check-national-insurance.php';
  static const String driverCheckPco = '$driverBaseUrl/check-pco.php';
  static const String driverCheckPcoLicense =
      '$driverBaseUrl/check-pco-license.php';
  static const String driverCheckPictures = '$driverBaseUrl/check-pictures.php';
  static const String driverCheckRentalAgreement =
      '$driverBaseUrl/check-rental-agreement.php';
  static const String driverCheckRoadTax = '$driverBaseUrl/check-road-tax.php';
  static const String driverCheckVPicBack =
      '$driverBaseUrl/check-v-pic-back.php';
  static const String driverCheckVPicFront =
      '$driverBaseUrl/check-v-pic-front.php';
  static const String driverCompleteJob = '$driverBaseUrl/complete-job.php';
  static const String driverCompleteTimeSlot =
      '$driverBaseUrl/complete-time-slot.php';
  static const String driverDocumentsCheckVehicleDocuments =
      '$driverBaseUrl/documents/check-vehicle-documents.php';
  static const String driverEarningLastJob =
      '$driverBaseUrl/earning-last-job.php';
  static const String driverEarningLastWeek =
      '$driverBaseUrl/earning-last-week.php';
  static const String driverEarningToday = '$driverBaseUrl/earning-today.php';
  static const String driverEditBid = '$driverBaseUrl/edit-bid.php';
  static const String driverEndBreak = '$driverBaseUrl/end-break.php';
  static const String driverFetchFares = '$driverBaseUrl/fetch-fares.php';
  static const String driverFetchReviews = '$driverBaseUrl/fetch-reviews.php';
  static const String driverFetchTimeSlot =
      '$driverBaseUrl/fetch-time-slot.php';
  static const String driverFetchTimeSlots =
      '$driverBaseUrl/fetch-time-slots.php';
  static const String driverFetchVehicles = '$driverBaseUrl/fetch-vehicles.php';
  static const String driverInvoiceDetails =
      '$driverBaseUrl/invoice-details.php';
  static const String driverJobHistory = '$driverBaseUrl/job-history.php';
  static const String driverJobsAcceptedJobsToday =
      '$driverBaseUrl/jobs/accepted-jobs-today.php';
  static const String driverJobsCheckJobStatus =
      '$driverBaseUrl/jobs/check-job-status.php';
  static const String driverJobsUpcomingJobs =
      '$driverBaseUrl/jobs/upcoming-jobs.php';
  static const String driverOnlineStatus = '$driverBaseUrl/online-status.php';
  static const String driverOnRide = '$driverBaseUrl/on-ride.php';
  static const String driverOpenBookings = '$driverBaseUrl/open-bookings.php';
  static const String driverPassengerWaiting =
      '$driverBaseUrl/passenger-waiting.php';
  static const String driverRealLocation = '$driverBaseUrl/real-location.php';
  static const String driverRegister = '$driverBaseUrl/register.php';
  static const String driverReport = '$driverBaseUrl/report.php';
  static const String driverSelectBooking = '$driverBaseUrl/select-booking.php';
  static const String driverSignin = '$driverBaseUrl/signin.php';
  static const String driverStartBreak = '$driverBaseUrl/start-break.php';
  static const String driverTimeslotsAcceptTimeSlot =
      '$driverBaseUrl/timeslots/accept-time-slot.php';
  static const String driverTimeslotsCompleteTimeSlot =
      '$driverBaseUrl/timeslots/complete-time-slot.php';
  static const String driverTimeslotsFetchTimeSlot =
      '$driverBaseUrl/timeslots/fetch-time-slot.php';
  static const String driverTimeslotsRejectTimeSlot =
      '$driverBaseUrl/timeslots/reject-time-slot.php';
  static const String driverTotalDueBalance =
      '$driverBaseUrl/total-due-balance.php';
  static const String driverTotalEarningsLastWeek =
      '$driverBaseUrl/total-earnings-last-week.php';
  static const String driverUpcomingJobs = '$driverBaseUrl/upcoming-jobs.php';
  static const String driverUpcomingNextWeek =
      '$driverBaseUrl/upcoming-next-week.php';
  static const String driverUpdateProfile = '$driverBaseUrl/update-profile.php';
  static const String driverUploadAddressProof =
      '$driverBaseUrl/upload-address-proof.php';
  static const String driverUploadDrivingLicense =
      '$driverBaseUrl/upload-driving-license.php';
  static const String driverUploadDvla = '$driverBaseUrl/upload-dvla.php';
  static const String driverUploadExtra = '$driverBaseUrl/upload-extra.php';
  static const String driverUploadInsSche =
      '$driverBaseUrl/upload-ins-sche.php';
  static const String driverUploadInsurance =
      '$driverBaseUrl/upload-insurance.php';
  static const String driverUploadLicenseBack =
      '$driverBaseUrl/upload-license-back.php';
  static const String driverUploadLicenseFront =
      '$driverBaseUrl/upload-license-front.php';
  static const String driverUploadLogBook =
      '$driverBaseUrl/upload-log-book.php';
  static const String driverUploadMot = '$driverBaseUrl/upload-mot.php';
  static const String driverUploadNi = '$driverBaseUrl/upload-ni.php';
  static const String driverUploadPa1 = '$driverBaseUrl/upload-pa1.php';
  static const String driverUploadPa2 = '$driverBaseUrl/upload-pa2.php';
  static const String driverUploadPco = '$driverBaseUrl/upload-pco.php';
  static const String driverUploadRentalAgreement =
      '$driverBaseUrl/upload-rental-agreement.php';
  static const String driverUploadRoadTax =
      '$driverBaseUrl/upload-road-tax.php';
  static const String driverUploadVehiclePictureBack =
      '$driverBaseUrl/upload-vehicle-picture-back.php';
  static const String driverUploadVehiclePictureFront =
      '$driverBaseUrl/upload-vehicle-picture-front.php';
  static const String driverUploadVehiclePictures =
      '$driverBaseUrl/upload-vehicle-pictures.php';
  static const String driverUploadVpco = '$driverBaseUrl/upload-vpco.php';
  static const String driverViewProfile = driverAuthenticationViewProfile;
  static const String driverWayToPickup = '$driverBaseUrl/way-to-pickup.php';
  static const String driverZones = '$driverBaseUrl/zones.php';

  static String driverImageUrl(String? path) =>
      '$siteBaseUrl/img/drivers/${path ?? ''}';
}
