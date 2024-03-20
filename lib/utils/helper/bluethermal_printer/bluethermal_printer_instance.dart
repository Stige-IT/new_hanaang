import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bluethermalProvider = Provider<BlueThermalPrinter>((ref) {
  return BlueThermalPrinter.instance ;
});
