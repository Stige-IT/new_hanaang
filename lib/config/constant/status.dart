Map statusPayment = {
  "Semua": StatusPayment.all.value,
  "Belum dibayar": StatusPayment.belumDibayar.value,
  "Sebagian dibayar": StatusPayment.sebagianDibayar.value,
  "Sudah dibayar": StatusPayment.sudahDibayar.value,
};

Map statusTakeOrder = {
  "Semua": StatusTakeOrder.all.value,
  "Belum diambil": StatusTakeOrder.belumDiambil.value,
  "Sebagian diambil": StatusTakeOrder.sebagianDiambil.value,
  "Sudah diambil": StatusTakeOrder.sudahDiambil.value,
};

enum StatusPayment{
  all("all"),
  belumDibayar("372e4c17-9b03-43d6-9037-9f9fb7a4d6a9"),
  sebagianDibayar("9760e7a8-3d16-4158-bfc3-811f41c56406"),
  sudahDibayar("1e6c77f7-1b09-4608-8b03-4641b68c4439");

  const StatusPayment(this.value);
  final String value;
}

enum StatusTakeOrder{
  all("all"),
  belumDiambil("372e4c17-9b03-43d6-9037-9f9fb7a4d6a9"),
  sebagianDiambil("9760e7a8-3d16-4158-bfc3-811f41c56406"),
  sudahDiambil("1e6c77f7-1b09-4608-8b03-4641b68c4439");

  const StatusTakeOrder(this.value);
  final String value;
}