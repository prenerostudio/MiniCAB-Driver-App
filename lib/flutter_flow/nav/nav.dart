import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mini_cab/BidHistory/bid_history_filter_widget.dart';

import 'package:mini_cab/otp%202/otp2_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../Acount Statements/acount_statements_widget.dart';
import '../../All Docoments/all_docoments_widget.dart';

import '../../JobHistoryDetails/job_history_details_widget.dart';
import '../../NameFullScreen/name_full_screen_widget.dart';
import '../../NationalInsuranceNumber/national_insurance_number_widget.dart';

import '../../ProofofAddressTwo/proofof_address_two_widget.dart';
import '../../SplashScreen/splashScreen_widget.dart';

import '../../VehicleInsurance/vehicle_insurance_widget.dart';

import '../../account_Details/account_Details_widget.dart';
import '../../add_account/add_account_widget.dart';
import '../../add_card/add_card_widget.dart';
import '../../add_vehicle/add_vehicle_widget.dart';
import '../../bids_history/bids_history_widget.dart';
import '/auth/base_auth_user_provider.dart';

import '/index.dart';
import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => appStateNotifier.showSplashImage
          ? Builder(
              builder: (context) => Container(
                color: Colors.white,
                child: Center(
                  child: Image.asset(
                    'assets/images/app_launcher_icon.png',
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            )
          : SplashScreenWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.showSplashImage
              ? Builder(
                  builder: (context) => Container(
                    color: Colors.white,
                    child: Center(
                      child: Image.asset(
                        'assets/images/app_launcher_icon.png',
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        height: MediaQuery.sizeOf(context).height * 0.5,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                )
              : SplashScreenWidget(),
        ),
        FFRoute(
          name: 'Home',
          path: '/home',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'Home')
              : NavBarPage(
                  initialPage: 'Home',
                  page: HomeWidget(),
                ),
        ),
        FFRoute(
          name: 'changepassword',
          path: '/changepassword',
          builder: (context, params) => ChangepasswordWidget(),
        ),
        FFRoute(
          name: 'Myprofile',
          path: '/myprofile',
          builder: (context, params) => MyprofileWidget(
            did: params.getParam('did', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'Zones',
          path: '/zones',
          builder: (context, params) => ZonesWidget(),
        ),
        FFRoute(
          name: 'Signup',
          path: '/signup',
          builder: (context, params) => SignupWidget(),
        ),
        FFRoute(
          name: 'Welcome',
          path: '/welcome',
          builder: (context, params) => WelcomeWidget(),
        ),

        FFRoute(
          name: 'Documents',
          path: '/documents',
          builder: (context, params) => DocumentsWidget(),
        ),

        FFRoute(
          name: 'editProfile',
          path: '/editProfile',
          builder: (context, params) => EditProfileWidget(),
        ),

        // FFRoute(
        //   name: 'AcountStatements',
        //   path: '/acount_statements',
        //   builder: (context, params) => AcountStatementsWidget(),
        // ),
        FFRoute(
          name: 'AcountStatements',
          path: '/acount_statements',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'AcountStatements')
              : NavBarPage(
                  initialPage: 'AcountStatements',
                  page: AcountStatementsWidget(),
                ),
        ),
        FFRoute(
          name: 'AllDocoments',
          path: '/all_docoments',
          builder: (context, params) => AllDocomentsWidget(),
        ),

        FFRoute(
          name: 'jobshistory',
          path: '/jobshistory',
          builder: (context, params) => JobshistoryWidget(
            did: params.getParam('did', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'JobHistoryDetails',
          path: '/job_history_details',
          builder: (context, params) => JobHistoryDetailsWidget(
            did: params.getParam('did', ParamType.String),
            pickup: params.getParam('pickup', ParamType.String),
            dropoff: params.getParam('dropoff', ParamType.String),
            bookId: params.getParam('bookId', ParamType.String),
            date: params.getParam('date', ParamType.String),
            time: params.getParam('time', ParamType.String),
            passanger: params.getParam('passanger', ParamType.String),
            cId: params.getParam('cId', ParamType.String),
            cName: params.getParam('cName', ParamType.String),
            cNotes: params.getParam('cNotes', ParamType.String),
            cNumber: params.getParam('cNumber', ParamType.String),
            fare: params.getParam('fare', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'onWay',
          path: '/onWay',
          builder: (context, params) => OnWayWidget(
              // did: params.getParam('did', ParamType.String),
              // jobid: params.getParam('jobid', ParamType.String),
              // pickup: params.getParam('pickup', ParamType.String),
              // dropoff: params.getParam('dropoff', ParamType.String),
              // cName: params.getParam('cName', ParamType.String),
              // note: params.getParam('note', ParamType.String),
              // fare: params.getParam('fare', ParamType.String),
              // distance: params.getParam('distance', ParamType.String),
              // pickTime: params.getParam('pickTime', ParamType.String),
              // pickDate: params.getParam('pickDate', ParamType.String),
              // passenger: params.getParam('passenger', ParamType.String),
              // cnumber: params.getParam('cnumber', ParamType.String),
              // luggage: params.getParam('luggage', ParamType.String),
              // cemail: params.getParam('cemail', ParamType.String),
              ),
        ),
        FFRoute(
          name: 'Login',
          path: '/login',
          builder: (context, params) => LoginWidget(),
        ),
        FFRoute(
          name: 'PaymentEntery',
          path: '/paymentEntery',
          builder: (context, params) => PaymentEnteryWidget(
            jobid: params.getParam('jobid', ParamType.String),
            did: params.getParam('did', ParamType.String),
            fare: params.getParam('fare', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'Bids',
          path: '/bids',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'Bids')
              : NavBarPage(
                  initialPage: 'Bids',
                  page: BidsWidget(),
                ),
        ),
        FFRoute(
          name: 'AddVehicle',
          path: '/addVehicle',
          builder: (context, params) => AddVehicleWidget(),
        ),

        FFRoute(
          name: 'AccountDetails',
          path: '/accountDetails',
          builder: (context, params) => AccountDetailsWidget(
            Id: params.getParam('Id', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'BidsHistory',
          path: '/bidsHistory',
          builder: (context, params) => BidsHistoryWidget(
            did: params.getParam('did', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'NameFullScreen',
          path: '/name_full_screen',
          builder: (context, params) => NameFullScreenWidget(
            name: params.getParam('name', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'BidHistoryFilter',
          path: '/bid_history_filter',
          builder: (context, params) => BidHistoryFilterWidget(),
        ),
        FFRoute(
          name: 'Pob',
          path: '/pob',
          builder: (context, params) => PobWidget(
              // did: params.getParam('did', ParamType.String),
              // jobid: params.getParam('jobid', ParamType.String),
              // pickup: params.getParam('pickup', ParamType.String),
              // dropoff: params.getParam('dropoff', ParamType.String),
              // cName: params.getParam('cName', ParamType.String),
              // fare: params.getParam('fare', ParamType.String),
              // note: params.getParam('note', ParamType.String),
              // distance: params.getParam('distance', ParamType.String),
              // pickTime: params.getParam('pickTime', ParamType.String),
              // pickDate: params.getParam('pickDate', ParamType.String),
              // passenger: params.getParam('passenger', ParamType.String),
              // cnumber: params.getParam('cnumber', ParamType.String),
              // luggage: params.getParam('luggage', ParamType.String),
              // cemail: params.getParam('cemail', ParamType.String),
              ),
        ),
        FFRoute(
          name: 'invoiecs',
          path: '/invoiecs',
          builder: (context, params) => InvoiecsWidget(
            did: params.getParam('did', ParamType.String),
            jobid: params.getParam('jobid', ParamType.String),
            parking: params.getParam('parking', ParamType.String),
            waiting: params.getParam('waiting', ParamType.String),
            tolls: params.getParam('tolls', ParamType.String),
            fare: params.getParam('fare', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'Otp',
          path: '/otp',
          builder: (context, params) => OtpWidget(
            name: params.getParam('name', ParamType.String),
            phoneNumber: params.getParam('phoneNumber', ParamType.String),
            email: params.getParam('email', ParamType.String),
            password: params.getParam('password', ParamType.String),
            licenseAuth: params.getParam('licenseAuth', ParamType.String),
            varifyId: params.getParam('varifyId', ParamType.String),
            dropDownValue2: params.getParam('dropDownValue2', ParamType.String),
          ),
        ),
        FFRoute(
            name: 'Otp2',
            path: '/otp2',
            builder: (context, params) => Otp2Widget(
                  phoneNumber: params.getParam('phoneNumber', ParamType.String),
                  varifyId: params.getParam('varifyId', ParamType.String),
                )),
        FFRoute(
          name: 'Upcomming',
          path: '/upcomming',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'Upcomming')
              : UpcommingWidget(),
        ),
        FFRoute(
          name: 'Dashboard',
          path: '/dashboard',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'Dashboard')
              : NavBarPage(
                  initialPage: 'Dashboard',
                  page: DashboardWidget(),
                ),
        ),
        FFRoute(
          name: 'bidDetails',
          path: '/bidDetails',
          builder: (context, params) => BidDetailsWidget(
            bidId: params.getParam('bidId', ParamType.String),
          ),
        ),

        FFRoute(
          name: 'ProofofAddressTwo',
          path: '/proofof_address_two',
          builder: (context, params) => ProofofAddressTwoWidget(),
        ),

        FFRoute(
          name: 'NationalInsuranceNumber',
          path: '/national_insurance_number',
          builder: (context, params) => NationalInsuranceNumberWidget(),
        ),

        FFRoute(
          name: 'VehicleInsurance',
          path: '/vehicle_insurance',
          builder: (context, params) => VehicleInsuranceWidget(),
        ),

        FFRoute(
          name: 'Addcard',
          path: '/add_card',
          builder: (context, params) => AddcardWidget(),
        ),
        FFRoute(
          name: 'AddAccount',
          path: '/add_account',
          builder: (context, params) => AddAccountWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, [
    bool isList = false,
  ]) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.location);
            return '/welcome';
          }
          return null;
        },
        pageBuilder: (context, state) {
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Image.asset(
                      'assets/images/app_launcher_icon.png',
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder: PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).transitionsBuilder,
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouter.of(context).location;
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}
