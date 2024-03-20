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

Map nameStatus = {
  ///[payment status]
  "Sudah Dibayar": "Sudah dibayar",
  "Dibayar Sebagian": "Sebagian dibayar",
  "Belum Dibayar": "Belum dibayar",

  ///[taken status]
  "Sudah Diambil": "Sudah diambil",
  "Diambil Sebagian": "Sebagian diambil",
  "Belum Diambil": "Belum diambil",
};

String checkStatus(String? status) {
  const not = MapEntry("none", "none");
  MapEntry? result = statusColor.entries
      .firstWhere((data) => data.key == status, orElse: () => not);
  return result.value;
}

checkNamed(String status) {
  const not = MapEntry("none", "tidak ada");
  MapEntry? result = nameStatus.entries
      .firstWhere((data) => data.key == status, orElse: () => not);
  return result.value;
}

Map statusRetur = {
  "Diproses": null,
  "Disetujui": "partial",
  "Ditolak": "not",
  "Selesai": "done",
};

checkStatusRetur(String status) {
  MapEntry result =
      statusRetur.entries.firstWhere((element) => element.key == status);
  return result.value;
}
