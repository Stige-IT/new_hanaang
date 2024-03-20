
import 'package:flutter/material.dart';

bool isTabletType(){
  final size = MediaQueryData.fromView(WidgetsBinding.instance.window).size;
  const double tabletThreshold = 600;
  return size.width >= tabletThreshold;
}