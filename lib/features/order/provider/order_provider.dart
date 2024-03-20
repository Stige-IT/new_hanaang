part of "../order.dart";

///[*state provider]

final paymentStatusProvider = StateProvider.autoDispose<String>((ref) => "all");
final takeOrderStatusProvider =
    StateProvider.autoDispose<String>((ref) => "all");

///[*state notifier]
final orderNotifier = StateNotifierProvider.autoDispose<OrderNotifier,
    BaseState<List<OrderData>>>((ref) {
  return OrderNotifier(ref.watch(orderProvider),
      paymentStatus: ref.watch(paymentStatusProvider),
      takingOrderStatus: ref.watch(takeOrderStatusProvider));
});

final orderByIdNotifier =
    StateNotifierProvider<OrderByIdNotifier, States<OrderDetailData>>((ref) {
  return OrderByIdNotifier(ref.watch(orderProvider));
});

final createOrderNotifier =
    StateNotifierProvider.autoDispose<CreateOrderNotifier, States>((ref) {
  return CreateOrderNotifier(ref.watch(orderProvider), ref);
});

final totalOrderNotifier =
    StateNotifierProvider.autoDispose<TotalOrderNotifier, States<int>>((ref) {
  return TotalOrderNotifier(ref.watch(orderProvider));
});

final editOrderNotifier =
    StateNotifierProvider.autoDispose<EditOrderNotifier, States>((ref) {
  return EditOrderNotifier(ref.watch(orderProvider), ref);
});

// temp transaction for print
final isPrintValueProvider = StateProvider.autoDispose<bool>((ref) => false);

final tempTransactionProvider = StateNotifierProvider.autoDispose<
    TempTransactionNotifier, List<DetailTransaction>>((ref) {
  return TempTransactionNotifier();
});

final orderTransactionNotifier =
    NotifierProvider<OrderTransactionNotifier, States<List<DetailTransaction>>>(
        OrderTransactionNotifier.new);

final messageOrderNotifier =
    StateNotifierProvider<MessageOrderNotifier, States<List<MessageOrder>>>(
        (ref) {
  return MessageOrderNotifier(ref.watch(orderProvider));
});

final detailMessageOrderNotifier =
    StateNotifierProvider<DetailMessageOrderNotifier, States<MessageOrder>>(
        (ref) {
  return DetailMessageOrderNotifier(ref.watch(orderProvider));
});
