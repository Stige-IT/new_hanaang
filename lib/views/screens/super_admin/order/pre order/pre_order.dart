import 'dart:io';

import 'package:admin_hanaang/config/theme.dart';
import 'package:admin_hanaang/features/pre_order_users/provider/pre_order_user_provider.dart';
import 'package:admin_hanaang/models/pre_order_user.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/views/components/dialog_loading.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../../features/bonus/provider/bonus_provider.dart';
import '../../../../../features/cashback/provider/cashback_provider.dart';
import '../../../../../features/image_picker/image_picker.dart';
import '../../../../../utils/helper/formatted_currency.dart';
import '../../../../components/form_input.dart';
import '../../../../components/modal_bottom_image_picker_option.dart';
import '../../../../components/snackbar.dart';
import '../../../../components/tile_result.dart';
import 'widget/card_pre_order_user.dart';
import '../../../../components/empty_widget.dart';
import '../../../../components/failure_widget.dart';


part "pre_order_users_screen.dart";
part 'form/form_preorder_screen.dart';
part 'form/draggable_widget.dart';
part 'form/quantity_widget.dart';