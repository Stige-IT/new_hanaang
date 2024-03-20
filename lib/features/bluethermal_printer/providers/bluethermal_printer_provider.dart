import 'package:admin_hanaang/features/bluethermal_printer/providers/bluethermal_printer_notifier.dart';
import 'package:admin_hanaang/utils/helper/bluethermal_printer/bluethermal_printer_instance.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bluerthermalNotifier = StateNotifierProvider<BluethermalPrinterNotifier,List<BluetoothDevice> >((ref) {
  return BluethermalPrinterNotifier(ref.watch(bluethermalProvider));
});

final bluetoothSelectedProvider = StateProvider<BluetoothDevice?>((ref) => null);

