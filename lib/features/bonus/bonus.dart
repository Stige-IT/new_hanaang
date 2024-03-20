import 'package:admin_hanaang/features/bonus/provider/bonus_provider.dart';
import 'package:admin_hanaang/models/bonus.dart';
import 'package:admin_hanaang/views/components/dialog_loading.dart';
import 'package:admin_hanaang/views/components/dialog_widget.dart';
import 'package:admin_hanaang/views/components/error_button_widget.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../views/components/dropdown_container.dart';
import '../../config/constant/type_user.dart';

part "ui/setting_bonus_screen.dart";
part "ui/widgets/datatable_bonus_widget.dart";
part "ui/widgets/dialog_form_bonus.dart";