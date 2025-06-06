import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'create_play_list_widget.dart' show CreatePlayListWidget;
import 'package:flutter/material.dart';

class CreatePlayListModel extends FlutterFlowModel<CreatePlayListWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (Create Playlist)] action in Container widget.
  ApiCallResponse? playlist;
  // Stores action output result for [Backend Call - API (All Playlist)] action in Container widget.
  ApiCallResponse? allPlaylist;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
