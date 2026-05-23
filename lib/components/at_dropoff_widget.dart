import '/components/customer_details_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
// import 'package:styled_divider/styled_divider.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'at_dropoff_model.dart';
export 'at_dropoff_model.dart';

class AtDropoffWidget extends StatefulWidget {
  const AtDropoffWidget({
    super.key,
    required this.date,
    required this.time,
    required this.passenger,
    required this.cName,
    required this.cNumber,
    required this.pickup,
    required this.dropoff,
    required this.fare,
  });

  final String? date;
  final String? time;
  final String? passenger;
  final String? cName;
  final String? cNumber;
  final String? pickup;
  final String? dropoff;
  final String? fare;

  @override
  State<AtDropoffWidget> createState() => _AtDropoffWidgetState();
}

class _AtDropoffWidgetState extends State<AtDropoffWidget> {
  late AtDropoffModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AtDropoffModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 1,
      decoration: BoxDecoration(
        color: context.appTheme.secondaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 86,
            decoration: BoxDecoration(
              color: Color(0xFF1C1F28),
              border: Border.all(color: Color(0xFF1C1F28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 30,
                  child: Divider(
                    thickness: 1,
                    color: context.appTheme.secondaryBackground,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                8,
                                0,
                                0,
                                0,
                              ),
                              child: Text(
                                'Close',
                                style: context.appTheme.titleMedium.override(
                                  fontFamily: 'Open Sans',
                                  color: context.appTheme.info,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                enableDrag: false,
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: CustomerDetailsWidget(
                                      cNumber: '${widget.cNumber}',
                                      cemail: '',
                                      cname: '',
                                    ),
                                  );
                                },
                              ).then((value) => safeSetState(() {}));
                            },
                            child: Icon(
                              Icons.clear,
                              color: context.appTheme.accent4,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 5, 0),
                      child: Icon(
                        Icons.access_time_filled_rounded,
                        color: Color(0xFF5B68F5),
                        size: 20,
                      ),
                    ),
                    Text(
                      '${widget.time}',
                      style: context.appTheme.titleLarge.override(
                        fontFamily: 'Open Sans',
                        color: context.appTheme.secondaryBackground,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SELECT',
                        style: context.appTheme.titleLarge.override(
                          fontFamily: 'Open Sans',
                          color:
                              context.appTheme.secondaryBackground,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                        child: VerticalDivider(
                          width: 40,
                          thickness: 3,
                          color: Color(0xFF5B68F5),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 5, 0),
                        child: FaIcon(
                          FontAwesomeIcons.userFriends,
                          color: Color(0xFF5B68F5),
                          size: 18,
                        ),
                      ),
                      Text(
                        '1',
                        style: context.appTheme.titleLarge.override(
                          fontFamily: 'Open Sans',
                          color:
                              context.appTheme.secondaryBackground,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.person_sharp,
                      color: Color(0xFF5B68F5),
                      size: 26,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                      child: Text(
                        'Aukse Kadi',
                        style: context.appTheme.titleMedium.override(
                          fontFamily: 'Open Sans',
                          color: context.appTheme.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: CustomerDetailsWidget(
                              cNumber: '',
                              cemail: '',
                              cname: '',
                            ),
                          );
                        },
                      ).then((value) => safeSetState(() {}));
                    },
                    child: Icon(
                      Icons.keyboard_control_rounded,
                      color: context.appTheme.primaryText,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Opacity(
            opacity: 0.3,
            child: SizedBox(
              width: 280,
              child: Divider(
                height: 50,
                thickness: 1,
                color: context.appTheme.secondaryText,
              ),
            ),
          ),
          Stack(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 98,
                  decoration: BoxDecoration(
                    color: context.appTheme.secondaryBackground,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Opacity(
                        opacity: 0.6,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color:
                                  context.appTheme.secondaryBackground,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color:
                                    context.appTheme.secondaryText,
                                width: 2,
                              ),
                            ),
                            alignment: AlignmentDirectional(0, 0),
                            child: Text(
                              'B',
                              style: context.appTheme.bodyMedium.override(
                                fontFamily: 'Open Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 15, 0, 0),
                          child: Text(
                            'City University Of London, 10 Northampton Square, London, \nEC1V OHB',
                            textAlign: TextAlign.start,
                            style: context.appTheme.titleMedium.override(
                              fontFamily: 'Open Sans',
                              color: context.appTheme.primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(17, 20, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [SizedBox(height: 65)],
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 49,
                decoration: BoxDecoration(color: Color(0xFF5B68F5)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Opacity(
                      opacity: 0.6,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: context.appTheme.info,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: context.appTheme.info,
                              width: 2,
                            ),
                          ),
                          alignment: AlignmentDirectional(0, 0),
                          child: Text(
                            'A',
                            style: context.appTheme.bodyMedium.override(
                              fontFamily: 'Open Sans',
                              color: context.appTheme.secondaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Text(
                        '34, Bohun Grove, BARNET EN4 8UA',
                        style: context.appTheme.titleMedium.override(
                          fontFamily: 'Open Sans',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Opacity(
                      opacity: 0.4,
                      child: SizedBox(
                        width: 120,
                        child: Divider(
                          thickness: 1,
                          color: context.appTheme.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
                Opacity(
                  opacity: 0.5,
                  child: Icon(
                    Icons.add_circle_outline,
                    color: context.appTheme.secondaryText,
                    size: 26,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Opacity(
                      opacity: 0.4,
                      child: SizedBox(
                        width: 120,
                        child: Divider(
                          thickness: 1,
                          color: context.appTheme.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 100,
            decoration: BoxDecoration(color: Color(0xFF1C1F28)),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PAY BY',
                      style: context.appTheme.bodyMedium.override(
                        fontFamily: 'Open Sans',
                        color: context.appTheme.primaryBackground,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.moneyBillWaveAlt,
                          color: Color(0xFF5B68F5),
                          size: 28,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                          child: Text(
                            'Cash',
                            style: context.appTheme.bodyMedium.override(
                              fontFamily: 'Open Sans',
                              color:
                                  context.appTheme.primaryBackground,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                      child: Text(
                        'CLIENT PAYS',
                        style: context.appTheme.bodyMedium.override(
                          fontFamily: 'Open Sans',
                          color: context.appTheme.primaryBackground,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            '£40.62',
                            style: context.appTheme.titleLarge.override(
                              fontFamily: 'Open Sans',
                              color:
                                  context.appTheme.primaryBackground,
                            ),
                          ),
                          Text(
                            'Inc, VAT',
                            style: context.appTheme.bodyMedium.override(
                              fontFamily: 'Open Sans',
                              color:
                                  context.appTheme.primaryBackground,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Opacity(
                      opacity: 0.4,
                      child: SizedBox(
                        width: 120,
                        child: Divider(
                          thickness: 1,
                          color: context.appTheme.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
                Opacity(
                  opacity: 0.5,
                  child: Icon(
                    Icons.add_circle_outline,
                    color: context.appTheme.secondaryText,
                    size: 26,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Opacity(
                      opacity: 0.4,
                      child: SizedBox(
                        width: 120,
                        child: Divider(
                          thickness: 1,
                          color: context.appTheme.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                FlutterFlowIconButton(
                  borderColor: Color(0xFF5B68F5),
                  borderRadius: 30,
                  borderWidth: 1,
                  buttonSize: 48,
                  fillColor: Color(0xFF5B68F5),
                  icon: FaIcon(
                    FontAwesomeIcons.ellipsisH,
                    color: context.appTheme.secondaryBackground,
                    size: 24,
                  ),
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                ),
                FFButtonWidget(
                  onPressed: () {
                    print('Button pressed ...');
                  },
                  text: 'AT DROP OFF',
                  options: FFButtonOptions(
                    width: MediaQuery.sizeOf(context).width * 0.85,
                    height: 49,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: Color(0xFF1C1F28),
                    textStyle: context.appTheme.titleSmall.override(
                      fontFamily: 'Open Sans',
                      color: Colors.white,
                    ),
                    elevation: 3,
                    borderSide: BorderSide(color: Colors.transparent, width: 1),
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
