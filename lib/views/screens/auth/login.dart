import 'dart:developer';

import 'package:admin_hanaang/config/theme.dart';
import 'package:admin_hanaang/utils/helper/check_device_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../features/auth/provider/auth_provider.dart';
import '../../components/appbar.dart';
import '../../components/form_input.dart';
import '../../components/loading_in_button.dart';
import '../../components/navigation_widget.dart';
import '../../components/snackbar.dart';

part "login_screen.dart";
part "components/auth_page_widget.dart";
part "components/mobile_view.dart";
part "components/tablet_view.dart";