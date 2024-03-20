import 'package:admin_hanaang/features/cashback/provider/cashback_provider.dart';
import 'package:admin_hanaang/models/cashback.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/views/components/dialog_loading.dart';
import 'package:admin_hanaang/views/components/dialog_widget.dart';
import 'package:admin_hanaang/views/components/error_button_widget.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../utils/helper/formatted_currency.dart';
import '../../../views/components/dropdown_container.dart';
import '../../../views/components/snackbar.dart';
import '../../config/constant/type_user.dart';

part "ui/setting_cashback_screen.dart";
part "ui/widgets/datatable_cashback_widget.dart";
part "ui/widgets/dialog_form_cashback.dart";