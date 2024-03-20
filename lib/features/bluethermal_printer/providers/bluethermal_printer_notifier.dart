import 'dart:developer';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BluethermalPrinterNotifier extends StateNotifier<List<BluetoothDevice>> {
  final BlueThermalPrinter _blueThermalPrinter;

  BluethermalPrinterNotifier(this._blueThermalPrinter) : super([]);

  void getPairedDevices() async {
    final devices = await _blueThermalPrinter.getBondedDevices();
    log(devices.toString(), name: 'Paired Devices');
    state = devices;
  }
}
