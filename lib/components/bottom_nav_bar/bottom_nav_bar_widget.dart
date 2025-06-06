import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bottom_nav_bar_model.dart';
export 'bottom_nav_bar_model.dart';

class BottomNavBarWidget extends StatefulWidget {
  const BottomNavBarWidget({super.key});

  @override
  State<BottomNavBarWidget> createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  late BottomNavBarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BottomNavBarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Visibility(
      visible: valueOrDefault<bool>(
        FFAppState().isOnline,
        true,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 1.0, 0.0, 1.0),
              child: Container(
                width: double.infinity,
                height: 80.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: Image.asset(
                      'assets/images/Untitled_design_(7).png',
                    ).image,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        logFirebaseEvent('BOTTOM_NAV_BAR_Column_84z54ijb_ON_TAP');
                        logFirebaseEvent('Column_navigate_to');
        
                        context.goNamed(HomePageWidget.routeName);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home_outlined,
                            color: Color(0xFF5D3B23),
                            size: 24.0,
                          ),
                          Text(
                            FFLocalizations.of(context).getText(
                              'h4nu73o1' /* Homhhhe */,
                            ),
                            style:
                                FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF5D3B23),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                      lineHeight: 1.5,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        logFirebaseEvent('BOTTOM_NAV_BAR_Column_bhd5azkk_ON_TAP');
                        logFirebaseEvent('Column_navigate_to');
        
                        context.goNamed(SearchPageWidget.routeName);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_sharp,
                            color: Color(0xFF5D3B23),
                            size: 24.0,
                          ),
                          Text(
                            FFLocalizations.of(context).getText(
                              '63c94nca' /* Search */,
                            ),
                            style:
                                FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF5D3B23),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                      lineHeight: 1.5,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 8.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            logFirebaseEvent(
                                'BOTTOM_NAV_BAR_Column_3rtalg7q_ON_TAP');
                            logFirebaseEvent('Column_backend_call');
                            _model.radio = await LaravelGroup.postsListCall.call(
                              token: FFAppState().Token,
                              postTypeId: '12',
                            );
        
                            if ((_model.radio?.succeeded ?? true)) {
                              logFirebaseEvent('Column_update_app_state');
                              FFAppState().currentAudioTrack =
                                  LaravelGroup.postsListCall
                                      .dataList(
                                        (_model.radio?.jsonBody ?? ''),
                                      )!
                                      .firstOrNull!;
                              FFAppState().audioUrl = getJsonField(
                                LaravelGroup.postsListCall
                                    .dataList(
                                      (_model.radio?.jsonBody ?? ''),
                                    )!
                                    .firstOrNull,
                                r'''$.data''',
                              ).toString();
                              FFAppState().AudioPlayerList = LaravelGroup
                                  .postsListCall
                                  .dataList(
                                    (_model.radio?.jsonBody ?? ''),
                                  )!
                                  .where((e) =>
                                      getJsonField(
                                        e,
                                        r'''$.language''',
                                      ) ==
                                      functions.stringTOJson(
                                          FFLocalizations.of(context)
                                              .languageCode))
                                  .toList()
                                  .cast<dynamic>();
                              FFAppState().AudioPlayerSongIndex = 0;
                              FFAppState().RadioPlaylist =
                                  LaravelGroup.postsListCall
                                      .dataList(
                                        (_model.radio?.jsonBody ?? ''),
                                      )!
                                      .toList()
                                      .cast<dynamic>();
                              FFAppState().update(() {});
                            }
        
                            safeSetState(() {});
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 0.0, 0.0),
                                child: Icon(
                                  Icons.radio_outlined,
                                  color: Color(0xFF5D3B23),
                                  size: 24.0,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    'rtjm3l36' /* Radio */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .fontStyle,
                                        ),
                                        color: Color(0xFF5D3B23),
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                        lineHeight: 1.5,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        logFirebaseEvent('BOTTOM_NAV_BAR_Column_o9ie9gra_ON_TAP');
                        logFirebaseEvent('Column_navigate_to');
        
                        context.pushNamed(LibraryWidget.routeName);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FFIcons.kbook,
                            color: Color(0xFF5D3B23),
                            size: 22.0,
                          ),
                          Text(
                            FFLocalizations.of(context).getText(
                              '7qqon4ry' /* Library */,
                            ),
                            style:
                                FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF5D3B23),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                      lineHeight: 1.5,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        logFirebaseEvent('BOTTOM_NAV_BAR_Column_jzts95d8_ON_TAP');
                        logFirebaseEvent('Column_navigate_to');
        
                        context.goNamed(ProfilePageWidget.routeName);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_outline_sharp,
                            color: Color(0xFF5D3B23),
                            size: 24.0,
                          ),
                          Text(
                            FFLocalizations.of(context).getText(
                              'u24p03rd' /* Profile */,
                            ),
                            style:
                                FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF5D3B23),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                      lineHeight: 1.5,
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
    );
  }
}
