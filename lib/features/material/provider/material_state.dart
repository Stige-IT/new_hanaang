


class MaterialState<T> {
  final List<T>? data;
  final String? error;
  final bool isLoading;

  MaterialState({this.data, required this.isLoading, this.error});

  factory MaterialState.finished({List<T>? data}) {
    return MaterialState(data: data, isLoading: false);
  }

  factory MaterialState.noState() {
    return MaterialState(isLoading: false);
  }

  factory MaterialState.loading() {
    return MaterialState(isLoading: true);
  }
  factory MaterialState.error(String error) {
    return MaterialState(isLoading: false, error: error);
  }
}
