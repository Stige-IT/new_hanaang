class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? roleId;
  final String? error;
  final bool isLoading;

  AuthState({
    required this.isAuthenticated,
    required this.isLoading,
    this.roleId,
    this.token,
    this.error,
  });

  factory AuthState.authenticated(String token, String roleId) {
    return AuthState(
        isAuthenticated: true, token: token, roleId: roleId, isLoading: false);
  }

  factory AuthState.unAuthenticated() {
    return AuthState(isAuthenticated: false, token: null, isLoading: false);
  }

  factory AuthState.loading() {
    return AuthState(isAuthenticated: false, isLoading: true);
  }
}
