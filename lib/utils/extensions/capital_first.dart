extension CapitalFormat on String {
  capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
