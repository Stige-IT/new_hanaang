import 'package:admin_hanaang/features/price_product/provider/price_product_provider.dart';
import 'package:admin_hanaang/models/price_product.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/views/components/dialog_loading.dart';
import 'package:admin_hanaang/views/components/dialog_widget.dart';
import 'package:admin_hanaang/views/components/error_button_widget.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../utils/helper/formatted_currency.dart';
import '../../../views/components/dropdown_container.dart';
import '../../config/constant/type_user.dart';

part "ui/widgets/dialog_form_price_product.dart";
part "ui/widgets/datatable_price_product_widget.dart";
part "ui/setting_harga_produk_screen.dart";