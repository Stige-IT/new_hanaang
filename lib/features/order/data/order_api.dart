part of "../order.dart";

final orderProvider = Provider<OrderApi>((ref) {
  return OrderApi(ref.watch(httpRequestProvider), ref.watch(httpProvider),
      ref.watch(storageProvider));
});

class OrderApi {
  final HttpRequestClient _http;
  final IOClient http;
  final SecureStorage storage;

  OrderApi(this._http, this.http, this.storage);

  Future<Either<String, ResponseData>> getOrders({
    String? paymentStatus,
    String? takeOrderStatus,
    int? page,
  }) async {
    final role = await storage.getRoleName();
    String url = "$BASEURL/$role/order?page=$page";
    if (paymentStatus != "all") {
      url += "&paymentStatus=$paymentStatus";
    }
    if (takeOrderStatus != "all") {
      url += "&orderTakingStatus=$takeOrderStatus";
    }
    final response = await _http.get(url);
    return response.fold(
      (error) => Left(error),
      (response) {
        return Right(
          ResponseData<List<OrderData>>.fromJson(
            response,
            (response['data'] as List)
                .map((e) => OrderData.fromJson(e))
                .toList(),
          ),
        );
      },
    );
  }

  Future<Either<String, ResponseData>> searchOrders({String? query}) async {
    final role = await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/order/search?search=$query");
    final token = await storage.read("token");

    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      int currentPage = jsonDecode(response.body)['meta']['current_page'];
      int lastPage = jsonDecode(response.body)['meta']['last_page'];
      int total = jsonDecode(response.body)['meta']['total'];
      List<OrderData> data = result.map((e) => OrderData.fromJson(e)).toList();
      return Right(ResponseData(
        data: data,
        currentPage: currentPage,
        lastPage: lastPage,
        total: total,
      ));
    } else {
      return const Left("gagal mengambil data orders");
    }
  }

  Future<Either<String, OrderDetailData>> getOrderById(String id) async {
    final role = await storage.getRoleName();
    Uri url = Uri.parse("$BASEURL/$role/order/show/$id");
    final token = await storage.read("token");

    Map<String, String> header = {"Authorization": "Bearer $token"};

    Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      OrderDetailData result =
          OrderDetailData.fromJson(jsonDecode(response.body)['data']);
      return Right(result);
    } else {
      return const Left("gagal mengambil data orders");
    }
  }

  Future<Either<String, bool>> createOrder(
    String userId, {
    required int quantity,
    int orderTaken = 0,
    String paymentMethod = '',
    int nominal = 0,
    File? proofOfPayment,
  }) async {
    final role = await storage.getRoleName();
    final url = "$BASEURL/$role/order/create";
    Map<String, String> data = {
      "user_id": userId,
      "quantity": quantity.toString(),
      "order_taken": orderTaken.toString(),
      "payment_method": paymentMethod,
      "nominal": nominal.toString(),
    };

    final response = await _http.multipart(
      "POST",
      url,
      data: data,
      file: proofOfPayment,
      fieldFile: "proof_of_payment",
    );
    return response.fold(
      (error) => Left(error),
      (r) => const Right(true),
    );
  }

  Future<Either<String, bool>> editOrder(String orderId,
      {required String message, required int quantity}) async {
    final role = await storage.getRoleName();
    final token = await storage.read('token');
    Uri url = Uri.parse("$BASEURL/$role/order/update/$orderId");

    Map<String, String> header = {"Authorization": "Bearer $token"};
    Map data = {
      "after_change": quantity,
      "message": message,
    };

    final response = await http.post(url, body: data, headers: header);
    if (response.statusCode == 200) {
      return const Right(true);
    }
    return const Left("Gagal mengedit pesanan");
  }

  // get transaction history
  Future<Either<String, List<DetailTransaction>>> getTransactions(
      String orderId) async {
    final role = await storage.getRoleName();
    final String url = "$BASEURL/$role/order/$orderId/transaction";
    final response = await _http.get(url);
    return response.fold(
      (error) => Left(error),
      (response) {
        List result = response['data'];
        List<DetailTransaction> data =
            result.map((e) => DetailTransaction.fromJson(e)).toList();
        return Right(data);
      },
    );
  }

  Future<Either<String, List<MessageOrder>>> getMessageOrder(
      String orderId) async {
    final role = await storage.getRoleName();
    final token = await storage.read('token');
    Uri url = Uri.parse("$BASEURL/$role/change-message/$orderId");

    Map<String, String> header = {"Authorization": "Bearer $token"};
    final response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body)['data'];
      List<MessageOrder> data =
          result.map((e) => MessageOrder.fromJson(e)).toList();
      return Right(data);
    }
    return const Left("Gagal mengambil data deksripsi pesanan");
  }

  Future<Either<String, MessageOrder>> getDetailMessageOrder(
      String messageOrderId) async {
    final role = await storage.getRoleName();
    final token = await storage.read('token');
    Uri url = Uri.parse("$BASEURL/$role/change-message/show/$messageOrderId");

    Map<String, String> header = {"Authorization": "Bearer $token"};
    final response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body)['data'];
      MessageOrder data = MessageOrder.fromJson(result);
      return Right(data);
    }
    return const Left("Gagal mengambil data detail deksripsi pesanan");
  }
}
