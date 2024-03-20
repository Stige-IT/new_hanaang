part of "../shift.dart";

final shiftProvider = Provider<ShiftApi>((ref) {
  return ShiftApi(ref.watch(httpRequestProvider), ref.watch(storageProvider));
});

class ShiftApi {
  final HttpRequestClient _http;
  final SecureStorage _storage;

  ShiftApi(this._http, this._storage);

  // get status shift
  Future<Either<String, ShiftResponse>> getStatusShift() async {
    final role = await _storage.getRoleName();
    final url = "$BASEURL/$role/shift";
    final response = await _http.get(url);
    return response.fold(
          (error) => Left(error),
          (response) {
        final statusShift = (response['message']).toString();
        final isShift = statusShift.contains("shift aktif");
        String message = "-";
        if (isShift) {
          message = statusShift.split(' ').getRange(3, 5).join(' ');
        }
        return Right(
          ShiftResponse(
            status: isShift,
            message: message,
          ),
        );
      },
    );
  }

  // open shift
  Future<Either<String, bool>> openShift() async {
    final role = await _storage.getRoleName();
    final url = "$BASEURL/$role/open-shift";
    final response = await _http.post(url);
    return response.fold(
          (l) => Left(l),
          (r) => const Right(true),
    );
  }

  // close shift
  Future<Either<String, bool>> closeShift() async {
    final role = await _storage.getRoleName();
    final url = "$BASEURL/$role/close-shift";
    final response = await _http.post(url);
    return response.fold(
          (error) => Left(error),
          (success) => const Right(true),
    );
  }
}
