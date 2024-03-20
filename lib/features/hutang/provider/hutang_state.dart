
class HutangState<T> {
  final List<T>? data;
  final String? error;
  final bool isLoading;

  HutangState({this.data, required this.isLoading, this.error});

  factory HutangState.finished(List<T> data) {
    return HutangState(data: data, isLoading: false);
  }

  factory HutangState.noState() {
    return HutangState(isLoading: false);
  }

  factory HutangState.loading() {
    return HutangState(isLoading: true);
  }
  factory HutangState.error(String error) {
    return HutangState(isLoading: false, error: error);
  }
}
