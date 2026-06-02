import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
export 'myprofile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/myProfile.dart';
import 'package:http/http.dart' as http;
import 'package:new_minicab_driver/Data/api_service.dart';

class MyprofileWidget extends StatefulWidget {
  const MyprofileWidget({super.key, required this.did});

  final String? did;

  @override
  _MyprofileWidgetState createState() => _MyprofileWidgetState();
}

class _MyprofileWidgetState extends State<MyprofileWidget> {
  late MyprofileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    myProfile();
    _model = createModel(context, () => MyprofileModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<List<Driver>> myProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');

    if (dId == null) {
      print('d_id not found in shared preferences.');
      return [];
    }

    final uri = Uri.parse(ApiService.driverViewProfile);
    final response = await http.post(uri, body: {'d_id': dId.toString()});

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      List<Driver> profileData =
          data.map((item) => Driver.fromJson(item)).cast<Driver>().toList();
      print('the data is ${profileData[0].dAddress}');
      prefs.setString('d_address', profileData[0].dAddress ?? '');
      prefs.setString('d_post_code', profileData[0].postCode ?? '');
      return profileData;
    } else {
      print('Error: ${response.reasonPhrase}');
      return []; // Return an empty list in case of an error.
    }
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
      onTap:
          () =>
              _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: context.appTheme.primaryBackground,
        body: FutureBuilder<List<Driver>>(
          future: myProfile(),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Driver>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.appTheme.primary,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final driverData = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            16.0,
                            12.0,
                            0.0,
                            0.0,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_rounded),
                            color: Colors.blue,
                            // color:
                            //     context.appTheme.primaryBackground,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 140.0,
                      child: Stack(
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.00, 0.00),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0.0,
                                12.0,
                                0.0,
                                0.0,
                              ),
                              child: Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color:
                                      context.appTheme.secondaryBackground,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: context.appTheme.primary,
                                    width: 3.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    2.0,
                                    2.0,
                                    2.0,
                                    2.0,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child:
                                        driverData!.isNotEmpty &&
                                                driverData[0].dPic != null
                                            ? Image.network(
                                              'https://atiqramzan.online/img/drivers/${driverData[0].dPic}',
                                              width: 100.0,
                                              height: 100.0,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Image.asset(
                                                  'assets/images/user.png',
                                                  width: 100.0,
                                                  height: 100.0,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            )
                                            : Image.asset(
                                              'assets/images/user.png',
                                              width: 100.0,
                                              height: 100.0,
                                              fit: BoxFit.cover,
                                            ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        0.0,
                        16.0,
                        0.0,
                        12.0,
                      ),
                      child: Text(
                        driverData[0].dName ?? "",
                        textAlign: TextAlign.center,
                        style: context.appTheme.headlineSmall.override(
                          fontFamily: 'Outfit',
                          color: context.appTheme.primary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        0.0,
                        0.0,
                        0.0,
                        20.0,
                      ),
                      child: Text(
                        driverData[0].dEmail ?? "",
                        style: context.appTheme.titleSmall.override(
                          fontFamily: 'Readex Pro',
                          color: context.appTheme.primaryText,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 650.0,
                      decoration: BoxDecoration(
                        color: context.appTheme.secondaryBackground,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3.0,
                            color: Color(0x33000000),
                            offset: Offset(0.0, -1.0),
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0.0),
                          bottomRight: Radius.circular(0.0),
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          16.0,
                          16.0,
                          16.0,
                          20.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0.0,
                                0.0,
                                0.0,
                                12.0,
                              ),
                              child: Text(
                                'Profile',
                                style:
                                    context.appTheme.headlineSmall,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0.0,
                                0.0,
                                0.0,
                                8.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      8.0,
                                      16.0,
                                      8.0,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color:
                                          context.appTheme.secondaryText,
                                      size: 24.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0,
                                        0.0,
                                        12.0,
                                        0.0,
                                      ),
                                      child: Text(
                                        'Name',
                                        textAlign: TextAlign.start,
                                        style:
                                            context.appTheme.bodyMedium,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    driverData[0].dName ?? "",
                                    textAlign: TextAlign.center,
                                    style: context.appTheme.bodyMedium.override(
                                      fontFamily: 'Readex Pro',
                                      color:
                                          context.appTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0.0,
                                0.0,
                                0.0,
                                8.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      8.0,
                                      16.0,
                                      8.0,
                                    ),
                                    child: Icon(
                                      Icons.phone_enabled,
                                      color:
                                          context.appTheme.secondaryText,
                                      size: 24.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0,
                                        0.0,
                                        12.0,
                                        0.0,
                                      ),
                                      child: Text(
                                        'Phone Number',
                                        textAlign: TextAlign.start,
                                        style:
                                            context.appTheme.bodyMedium,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    driverData[0].dPhone ?? "",
                                    textAlign: TextAlign.center,
                                    style: context.appTheme.bodyMedium.override(
                                      fontFamily: 'Readex Pro',
                                      color:
                                          context.appTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0.0,
                                0.0,
                                0.0,
                                8.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      8.0,
                                      16.0,
                                      8.0,
                                    ),
                                    child: Icon(
                                      Icons.email,
                                      color:
                                          context.appTheme.secondaryText,
                                      size: 24.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0,
                                        0.0,
                                        12.0,
                                        0.0,
                                      ),
                                      child: Text(
                                        'Email',
                                        textAlign: TextAlign.start,
                                        style:
                                            context.appTheme.bodyMedium,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    driverData[0].dEmail ?? "",
                                    textAlign: TextAlign.center,
                                    style: context.appTheme.bodyMedium.override(
                                      fontFamily: 'Readex Pro',
                                      color:
                                          context.appTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0.0,
                                0.0,
                                0.0,
                                8.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      8.0,
                                      16.0,
                                      8.0,
                                    ),
                                    child: Icon(
                                      Icons.language_rounded,
                                      color:
                                          context.appTheme.secondaryText,
                                      size: 24.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0,
                                        0.0,
                                        12.0,
                                        0.0,
                                      ),
                                      child: Text(
                                        'Language',
                                        textAlign: TextAlign.start,
                                        style:
                                            context.appTheme.bodyMedium,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    driverData[0].dLanguage ?? "",
                                    textAlign: TextAlign.center,
                                    style: context.appTheme.bodyMedium.override(
                                      fontFamily: 'Readex Pro',
                                      color:
                                          context.appTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0.0,
                                0.0,
                                0.0,
                                8.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      8.0,
                                      16.0,
                                      8.0,
                                    ),
                                    child: Icon(
                                      Icons.man,
                                      color:
                                          context.appTheme.secondaryText,
                                      size: 24.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0,
                                        0.0,
                                        12.0,
                                        0.0,
                                      ),
                                      child: Text(
                                        'Gender',
                                        textAlign: TextAlign.start,
                                        style:
                                            context.appTheme.bodyMedium,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    driverData[0].dGender ?? "",
                                    textAlign: TextAlign.center,
                                    style: context.appTheme.bodyMedium.override(
                                      fontFamily: 'Readex Pro',
                                      color:
                                          context.appTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0.0,
                                0.0,
                                0.0,
                                8.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      8.0,
                                      16.0,
                                      8.0,
                                    ),
                                    child: Icon(
                                      Icons.home,
                                      color:
                                          context.appTheme.secondaryText,
                                      size: 24.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      0.0,
                                      12.0,
                                      0.0,
                                    ),
                                    child: Text(
                                      'Address',
                                      textAlign: TextAlign.start,
                                      style:
                                          context.appTheme.bodyMedium,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${driverData[0].dAddress}',
                                      textAlign: TextAlign.right,
                                      style: context.appTheme.bodyMedium.override(
                                        fontFamily: 'Readex Pro',
                                        color:
                                            context.appTheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0.0,
                                0.0,
                                0.0,
                                8.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      8.0,
                                      16.0,
                                      8.0,
                                    ),
                                    child: Icon(
                                      Icons.numbers_outlined,
                                      color:
                                          context.appTheme.secondaryText,
                                      size: 24.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0,
                                        0.0,
                                        12.0,
                                        0.0,
                                      ),
                                      child: Text(
                                        'Postal Code',
                                        textAlign: TextAlign.start,
                                        style:
                                            context.appTheme.bodyMedium,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    driverData[0].postCode ?? "",
                                    textAlign: TextAlign.center,
                                    style: context.appTheme.bodyMedium.override(
                                      fontFamily: 'Readex Pro',
                                      color:
                                          context.appTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0.0,
                                0.0,
                                0.0,
                                8.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      8.0,
                                      16.0,
                                      8.0,
                                    ),
                                    child: Icon(
                                      Icons.explicit_outlined,
                                      color:
                                          context.appTheme.secondaryText,
                                      size: 24.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0,
                                        0.0,
                                        12.0,
                                        0.0,
                                      ),
                                      child: Text(
                                        'License Authority',
                                        textAlign: TextAlign.start,
                                        style:
                                            context.appTheme.bodyMedium,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    driverData[0].dLicence ?? "",
                                    textAlign: TextAlign.center,
                                    style: context.appTheme.bodyMedium.override(
                                      fontFamily: 'Readex Pro',
                                      color:
                                          context.appTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Generated code for this Row Widget...
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0,
                                10,
                                0,
                                8,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FFButtonWidget(
                                    onPressed: () async {
                                      context.pushNamed('editProfile');
                                    },
                                    text: 'Edit Profile',
                                    options: FFButtonOptions(
                                      width:
                                          MediaQuery.sizeOf(context).width *
                                          0.45,
                                      height: 50,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        24,
                                        0,
                                        24,
                                        0,
                                      ),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                            0,
                                            0,
                                            0,
                                            0,
                                          ),
                                      color:
                                          context.appTheme.primary,
                                      textStyle: context.appTheme.titleSmall.override(
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white,
                                      ),
                                      elevation: 3,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  // FFButtonWidget(
                                  //   onPressed: () async {
                                  //     context.pushNamed('Reviews');
                                  //   },
                                  //   text: 'Reviews',
                                  //   options: FFButtonOptions(
                                  //     width:
                                  //         MediaQuery.sizeOf(context).width * 0.45,
                                  //     height: 50,
                                  //     padding: EdgeInsetsDirectional.fromSTEB(
                                  //         24, 0, 24, 0),
                                  //     iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  //         0, 0, 0, 0),
                                  //     color: context.appTheme.success,
                                  //     textStyle: context.appTheme
                                  //         .titleSmall
                                  //         .override(
                                  //           fontFamily: 'Readex Pro',
                                  //           color: Colors.white,
                                  //         ),
                                  //     elevation: 3,
                                  //     borderSide: BorderSide(
                                  //       color: Colors.transparent,
                                  //       width: 1,
                                  //     ),
                                  //     borderRadius: BorderRadius.circular(8),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
