class ResponseData<T> {
  final T? data;
  final int? total;
  final int? currentPage;
  final int? lastPage;

  ResponseData(
      {required this.data,
      this.total = 0,
      this.currentPage = 0,
      this.lastPage = 0});

  factory ResponseData.fromJson(Map<String, dynamic> json, T data) {
    return ResponseData(
      data: data,
      total: json['meta']['total'],
      currentPage: json['meta']['current_page'],
      lastPage: json['meta']['last_page'],
    );
  }
}
