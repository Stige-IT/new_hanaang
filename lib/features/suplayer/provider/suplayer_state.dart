import 'package:admin_hanaang/models/suplayer.dart';

class SuplayerState {
  final List<Suplayer>? data;
  final String? error;
  final bool isLoading;

  SuplayerState({this.data, required this.isLoading, this.error});

  factory SuplayerState.finished(List<Suplayer> data) {
    return SuplayerState(data: data, isLoading: false);
  }

  factory SuplayerState.noState() {
    return SuplayerState(isLoading: false);
  }

  factory SuplayerState.loading() {
    return SuplayerState(isLoading: true);
  }
  factory SuplayerState.error(String error) {
    return SuplayerState(isLoading: false, error: error);
  }
}
