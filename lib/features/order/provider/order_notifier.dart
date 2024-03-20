part of "../order.dart";

class OrderNotifier extends StateNotifier<BaseState<List<OrderData>>> {
  OrderNotifier(
    this.api, {
    required this.paymentStatus,
    required this.takingOrderStatus,
  }) : super(const BaseState());

  final OrderApi api;
  final String paymentStatus;
  final String takingOrderStatus;

  Future<void> getOrders({
    int? page,
    bool? makeLoading,
    bool? isMore = false,
    bool? isDataTable = false,
  }) async {
    if (makeLoading != null && makeLoading) {
      state = state.copyWith(isLoading: true);
    }
    try {
      final result = await api.getOrders(
        paymentStatus: paymentStatus,
        takeOrderStatus: takingOrderStatus,
        page: page ?? state.page,
      );
      result.fold(
        (error) => state = state.copyWith(
            error: error, isLoading: false, isLoadingMore: false),
        (response) => state = state.copyWith(
          data: isMore! && !isDataTable!
              ? [...state.data!, response.data]
              : response.data,
          page: response.currentPage!,
          lastPage: response.lastPage!,
          error: null,
          isLoading: false,
          isLoadingMore: false,
        ),
      );
    } catch (exception) {
      state = state.copyWith(
        error: exceptionTomessage(exception),
        isLoading: false,
        isLoadingMore: false,
      );
    }
  }

  void refresh() async {
    state = state.copyWith(page: 1);
    getOrders(makeLoading: true);
  }

  Future nextOrders({bool? isDataTable, bool? makeLoading}) async {
    state = state.copyWith(page: state.page + 1, isLoadingMore: true);
    getOrders(makeLoading: makeLoading, isMore: true, isDataTable: isDataTable);
  }

  Future prevOrders() async {
    state = state.copyWith(page: state.page - 1, isLoadingMore: true);
    getOrders(makeLoading: true, isMore: true, isDataTable: true);
  }

  Future searchOrders({String? query}) async {
    try {
      final result = await api.searchOrders(query: query);
      result.fold(
        (errorMessage) => state = state.copyWith(error: errorMessage),
        (response) => state = state = state.copyWith(
          data: response.data,
          page: response.currentPage!,
          lastPage: response.lastPage!,
          error: null,
          isLoading: false,
        ),
      );
    } catch (exception) {
      state = state.copyWith(
        error: exceptionTomessage(exception),
        isLoading: false,
        isLoadingMore: false,
      );
    }
  }
}

class OrderByIdNotifier extends StateNotifier<States<OrderDetailData>> {
  OrderByIdNotifier(this.api) : super(States.noState());

  final OrderApi api;

  Future getOrdersById(String id) async {
    state = States.loading();
    try {
      final result = await api.getOrderById(id);
      result.fold(
        (error) => state = States.error(error),
        (data) => state = States.finished(data),
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
    }
  }
}

class CreateOrderNotifier extends StateNotifier<States> {
  final OrderApi _orderApi;
  final Ref ref;

  CreateOrderNotifier(this._orderApi, this.ref) : super(States.noState());

  Future<bool> create(
    String userId, {
    required int quantity,
    int orderTaken = 0,
    String paymentMethod = '',
    int nominal = 0,
    File? proofOfPayment,
  }) async {
    state = States.loading();
    try {
      final result = await _orderApi.createOrder(
        userId,
        quantity: quantity,
        orderTaken: orderTaken,
        paymentMethod: paymentMethod,
        nominal: nominal,
        proofOfPayment: proofOfPayment,
      );
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (success) {
          ref.read(totalOrderNotifier.notifier).getTotalOrders();
          state = States.noState();
          return true;
        },
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
      return false;
    }
  }
}

class TotalOrderNotifier extends StateNotifier<States<int>> {
  final OrderApi _orderApi;

  TotalOrderNotifier(this._orderApi) : super(States.noState());

  Future<void> getTotalOrders() async {
    state = States.loading();
    try {
      final result = await _orderApi.getOrders();
      result.fold(
        (error) => state = States.error(error),
        (response) => state = States.finished(response.total),
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
    }
  }
}

class EditOrderNotifier extends StateNotifier<States> {
  final OrderApi _orderApi;
  final Ref ref;

  EditOrderNotifier(this._orderApi, this.ref) : super(States.noState());

  Future<bool> edit(
    String orderId, {
    required int quantity,
    required String message,
  }) async {
    state = States.loading();
    try {
      final result = await _orderApi.editOrder(orderId,
          message: message, quantity: quantity);
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (success) {
          ref.read(orderByIdNotifier.notifier).getOrdersById(orderId);
          state = States.noState();
          return false;
        },
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
      return false;
    }
  }
}

// state temp for print
class TempTransactionNotifier extends StateNotifier<List<DetailTransaction>> {
  TempTransactionNotifier() : super([]);

  void add(DetailTransaction transaction) {
    state = [...state, transaction];
  }

  void remove(DetailTransaction transaction) {
    state = state.where((element) => element != transaction).toList();
  }

  bool isAlready(DetailTransaction transaction) {
    return state.contains(transaction);
  }

  void clear() {
    state = [];
  }
}

// notifier get transaction history
class OrderTransactionNotifier
    extends Notifier<States<List<DetailTransaction>>> {
  @override
  States<List<DetailTransaction>> build() => States.noState();

  Future<void> get(String orderId) async {
    state = States.loading();
    try {
      final result = await ref.watch(orderProvider).getTransactions(orderId);
      state = result.fold(
        (error) => States.error(error),
        (data) => States.finished(data),
      );
    } catch (e) {
      state = States.error(exceptionTomessage(e));
    }
  }
}

class MessageOrderNotifier extends StateNotifier<States<List<MessageOrder>>> {
  final OrderApi _orderApi;

  MessageOrderNotifier(this._orderApi) : super(States.noState());

  void getMessage(String orderId) async {
    state = States.loading();
    try {
      final result = await _orderApi.getMessageOrder(orderId);
      result.fold(
        (error) => state = States.error(error),
        (data) => state = States.finished(data),
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
    }
  }
}

class DetailMessageOrderNotifier extends StateNotifier<States<MessageOrder>> {
  final OrderApi _orderApi;

  DetailMessageOrderNotifier(this._orderApi) : super(States.noState());

  void getMessage(String messageOrderId) async {
    state = States.loading();
    try {
      final result = await _orderApi.getDetailMessageOrder(messageOrderId);
      result.fold(
        (error) => state = States.error(error),
        (data) => state = States.finished(data),
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
    }
  }
}
