import 'package:admin_hanaang/models/bonus.dart';

class BonusState {
  final List<Bonus>? data;
  final bool? isLoading;
  final String? error;

  BonusState({this.data, this.isLoading, this.error});

  factory BonusState.noState() => BonusState(isLoading: false);
  factory BonusState.loading() => BonusState(isLoading: true);

  factory BonusState.finished(List<Bonus> data) {
    return BonusState(data: data, isLoading: false);
  }
}
