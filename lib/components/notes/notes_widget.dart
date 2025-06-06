import '/backend/api_requests/api_calls.dart';
import '/components/custom_message/custom_message_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'notes_model.dart';
export 'notes_model.dart';

class NotesWidget extends StatefulWidget {
  const NotesWidget({
    super.key,
    required this.post,
  });

  final dynamic post;

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  late NotesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotesModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5.0, 10.0, 5.0, 0.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFEFDBB6),
                        Color(0xFFFAEDD6),
                        Color(0xFFFEF7E7),
                        Color(0xFFEFDBB6),
                        Color(0xFFFAEDD6)
                      ],
                      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                      begin: AlignmentDirectional(0.31, -1.0),
                      end: AlignmentDirectional(-0.31, 1.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              logFirebaseEvent(
                                  'NOTES_COMP_Container_jp6c3wx3_ON_TAP');
                              logFirebaseEvent('Container_bottom_sheet');
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 0.0, 4.0),
                                child: Container(
                                  width: 60.0,
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 20.0, 24.0, 20.0),
                            child: FutureBuilder<ApiCallResponse>(
                              future: LaravelGroup.getNotePostCall.call(
                                token: FFAppState().Token,
                                postId: getJsonField(
                                  widget.post,
                                  r'''$.id''',
                                ).toString(),
                                noteId: functions
                                    .getDropdownIdInt(
                                        getJsonField(
                                          widget.post,
                                          r'''$.id''',
                                        ),
                                        FFAppState().Notes.toList(),
                                        'post_id')
                                    ?.toString(),
                              ),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SizedBox(
                                      width: 50.0,
                                      height: 50.0,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          FlutterFlowTheme.of(context)
                                              .davysGray,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                final containerGetNotePostResponse =
                                    snapshot.data!;

                                return Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.65,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFEF8EB),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 12.0, 24.0, 20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'ice792ps' /* Notes Taker */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF232323),
                                                fontSize: 20.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Divider(
                                          thickness: 1.0,
                                          color: Color(0xFFD9D9D9),
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: 340.0,
                                            height: double.infinity,
                                            child:
                                                custom_widgets.RichTextEditor(
                                              width: 340.0,
                                              height: double.infinity,
                                              currentHtml: getJsonField(
                                                        containerGetNotePostResponse
                                                            .jsonBody,
                                                        r'''$.data.note''',
                                                      ) !=
                                                      null
                                                  ? getJsonField(
                                                      containerGetNotePostResponse
                                                          .jsonBody,
                                                      r'''$.data.note''',
                                                    ).toString()
                                                  : '',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFFFEF8EB),
                              border: Border.all(
                                color: Color(0xFFBEE3E1),
                              ),
                            ),
                            child: Builder(
                              builder: (context) => Padding(
                                padding: EdgeInsets.all(24.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    logFirebaseEvent(
                                        'NOTES_COMP_Container_h25u5d2l_ON_TAP');
                                    if (FFAppState()
                                            .Notes
                                            .where((e) =>
                                                getJsonField(
                                                  e,
                                                  r'''$.post_id''',
                                                ) ==
                                                getJsonField(
                                                  widget.post,
                                                  r'''$.id''',
                                                ))
                                            .toList()
                                            .length !=
                                        0) {
                                      logFirebaseEvent(
                                          'Container_update_component_state');
                                      _model.loader = true;
                                      safeSetState(() {});
                                      logFirebaseEvent(
                                          'Container_backend_call');
                                      _model.update = await LaravelGroup
                                          .updateNoteCall
                                          .call(
                                        token: FFAppState().Token,
                                        id: getJsonField(
                                          widget.post,
                                          r'''$.id''',
                                        ).toString(),
                                        note: FFAppState().textFromHtmlEditor,
                                        noteId: getJsonField(
                                          FFAppState()
                                              .Notes
                                              .where((e) =>
                                                  getJsonField(
                                                    e,
                                                    r'''$.post_id''',
                                                  ) ==
                                                  getJsonField(
                                                    widget.post,
                                                    r'''$.id''',
                                                  ))
                                              .toList()
                                              .firstOrNull,
                                          r'''$.id''',
                                        ).toString(),
                                      );

                                      if ((_model.update?.succeeded ?? true)) {
                                        logFirebaseEvent(
                                            'Container_alert_dialog');
                                        await showDialog(
                                          context: context,
                                          builder: (dialogContext) {
                                            return Dialog(
                                              elevation: 0,
                                              insetPadding: EdgeInsets.zero,
                                              backgroundColor:
                                                  Colors.transparent,
                                              alignment:
                                                  AlignmentDirectional(0.0, 0.0)
                                                      .resolve(
                                                          Directionality.of(
                                                              context)),
                                              child: WebViewAware(
                                                child: CustomMessageWidget(
                                                  message: ' Note Updated',
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                      logFirebaseEvent(
                                          'Container_update_component_state');
                                      _model.loader = false;
                                      safeSetState(() {});
                                    } else {
                                      logFirebaseEvent(
                                          'Container_update_component_state');
                                      _model.loader = true;
                                      safeSetState(() {});
                                      logFirebaseEvent(
                                          'Container_backend_call');
                                      _model.note =
                                          await LaravelGroup.notePostCall.call(
                                        id: getJsonField(
                                          widget.post,
                                          r'''$.id''',
                                        ).toString(),
                                        token: FFAppState().Token,
                                        note: functions.multiLinesToSingle(
                                            FFAppState().textFromHtmlEditor),
                                      );

                                      if ((_model.note?.succeeded ?? true)) {
                                        logFirebaseEvent(
                                            'Container_alert_dialog');
                                        await showDialog(
                                          context: context,
                                          builder: (dialogContext) {
                                            return Dialog(
                                              elevation: 0,
                                              insetPadding: EdgeInsets.zero,
                                              backgroundColor:
                                                  Colors.transparent,
                                              alignment:
                                                  AlignmentDirectional(0.0, 0.0)
                                                      .resolve(
                                                          Directionality.of(
                                                              context)),
                                              child: WebViewAware(
                                                child: CustomMessageWidget(
                                                  message: ' Note Added',
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        logFirebaseEvent(
                                            'Container_alert_dialog');
                                        await showDialog(
                                          context: context,
                                          builder: (alertDialogContext) {
                                            return WebViewAware(
                                              child: AlertDialog(
                                                content: Text(getJsonField(
                                                  (_model.note?.jsonBody ?? ''),
                                                  r'''$.message''',
                                                ).toString()),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }

                                      logFirebaseEvent(
                                          'Container_update_component_state');
                                      _model.loader = false;
                                      safeSetState(() {});
                                    }

                                    logFirebaseEvent('Container_bottom_sheet');
                                    Navigator.pop(context);
                                    logFirebaseEvent('Container_backend_call');
                                    _model.noteslist =
                                        await LaravelGroup.notesListCall.call(
                                      token: FFAppState().Token,
                                    );

                                    logFirebaseEvent(
                                        'Container_update_app_state');
                                    FFAppState().Notes = LaravelGroup
                                        .notesListCall
                                        .notesList(
                                          (_model.noteslist?.jsonBody ?? ''),
                                        )!
                                        .toList()
                                        .cast<dynamic>();
                                    safeSetState(() {});

                                    safeSetState(() {});
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: Image.asset(
                                          'assets/images/Frame_1410149479g_1_(1)_(1).png',
                                        ).image,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (!_model.loader)
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                '8yqmz2oh' /* Update */,
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFF232323),
                                                    fontSize: 18.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                        if (_model.loader)
                                          Lottie.asset(
                                            'assets/jsons/PXeYFN70bN.json',
                                            width: 100.0,
                                            height: 50.0,
                                            fit: BoxFit.cover,
                                            animate: true,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(1.0, -1.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    logFirebaseEvent('NOTES_COMP_Container_tus68cdd_ON_TAP');
                    logFirebaseEvent('Container_dismiss_dialog');
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryText,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Icon(
                      Icons.close,
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      size: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
