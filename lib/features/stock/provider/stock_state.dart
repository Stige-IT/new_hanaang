
class StockState {
  final int? stockTotal;
  final int? stockSold;
  final int? stockRetur;
  final int? stockRemaining;
  final String? error;
  final bool isLoading;

  StockState(
      {this.stockTotal,
      this.stockSold,
      this.stockRetur,
      this.stockRemaining,
      required this.isLoading,
      this.error});

  factory StockState.finished({
    int? total = 0,
    int? sold = 0,
    int? remaining = 0,
    int? retur = 0,
  }) {
    return StockState(
      stockTotal: total,
      stockSold: sold,
      stockRetur: retur,
      stockRemaining: remaining,
      isLoading: false,
    );
  }

  factory StockState.noState() {
    return StockState(isLoading: false);
  }

  factory StockState.loading() {
    return StockState(isLoading: true);
  }

  factory StockState.error(String error) {
    return StockState(isLoading: false, error: error);
  }
}
