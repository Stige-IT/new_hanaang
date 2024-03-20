import 'dart:math';

import 'package:admin_hanaang/models/recipt_detail.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:admin_hanaang/utils/helper/formatted_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../../config/router/router_config.dart';
import '../../../../../config/theme.dart';
import '../../../../../features/material/provider/material_provider.dart';
import '../../../../../features/recipts/provider/recipt_provider.dart';
import '../../../../../models/item_reciept.dart';
import '../../../../../models/material_model.dart';
import '../../../../../models/recipt.dart';
import '../../../../components/dialog_loading.dart';
import '../../../../components/dropdown_container.dart';
import '../../../../components/empty_widget.dart';
import '../../../../components/error_button_widget.dart';
import '../../../../components/form_input.dart';
import '../../../../components/loading_in_button.dart';
import '../../../../components/navigation_widget.dart';
import '../../../../components/snackbar.dart';

part "recipt_screen/recipt_screen.dart";
part "recipt_screen/widget/card_reciep.dart";

part "detail_reciep/detail_recipt_screen.dart";

part "form_reciep/form_recipt_screen.dart";
part "form_reciep/widgets/list_of_items.dart";
part "form_reciep/widgets/bottom_sheet.dart";
part 'form_reciep/widgets/form.dart';
