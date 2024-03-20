import 'dart:async';
import 'package:admin_hanaang/utils/helper/navigation_first_role.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/utils/helper/check_device_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/user/provider/user_provider.dart';
import '../../components/navigation_widget.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../../config/theme.dart';


part 'splash_screen.dart';
part 'components/tablet_view.dart';
part 'components/mobile_view.dart';