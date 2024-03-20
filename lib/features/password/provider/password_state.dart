class PasswordState {
  final bool isLoading;
  final String? error;

  PasswordState({required this.isLoading, this.error});

  factory PasswordState.noState() => PasswordState(isLoading: false);

  factory PasswordState.loading() => PasswordState(isLoading: true);

  factory PasswordState.error(String error) =>
      PasswordState(isLoading: false, error: error);
}
