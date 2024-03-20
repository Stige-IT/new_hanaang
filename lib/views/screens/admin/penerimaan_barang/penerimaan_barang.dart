import 'dart:developer';

import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:admin_hanaang/utils/helper/formatted_currency.dart';
import 'package:admin_hanaang/views/components/empty_widget.dart';
import 'package:admin_hanaang/views/components/error_button_widget.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../config/theme.dart';
import '../../../../features/material/provider/material_provider.dart';
import '../../../../features/penerimaan_barang/provider/penerimaan_barang_provider.dart';
import '../../../../models/material_model.dart';
import '../../../components/appbar_admin.dart';
import '../../../components/dropdown_container.dart';
import '../../../components/form_input.dart';
import '../../../components/loading_in_button.dart';
import '../../../components/snackbar.dart';
import '../components/endrawer/endrawer_widget.dart';

part 'main_penerimaan_barang/penerimaan_barang_screen.dart';
part "detail_penerimaan_barang/detail_penerimaan_barang_screen.dart";
part 'form_penerimaan_barang/form_penerimaan_barang_screen.dart';