Map statusColor = {
  ///[payment status]
  "Sudah Dibayar": "done",
  "Dibayar Sebagian": "partial",
  "Belum Dibayar": "not",

  ///[taken status]
  "Sudah Diambil": "done",
  "Diambil Sebagian": "partial",
  "Belum Diambil": "not",
};

checkStatus(String status) {
  MapEntry result =
  statusColor.entries.firstWhere((data) => data.key == status);
  return result.value;
}