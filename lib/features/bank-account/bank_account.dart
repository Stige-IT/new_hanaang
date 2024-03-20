import 'package:admin_hanaang/features/bank-account/provider/bank-account_provider.dart';
import 'package:admin_hanaang/features/bank-account/provider/bank-account_state.dart';
import 'package:admin_hanaang/views/components/dialog_loading.dart';
import 'package:admin_hanaang/views/components/dialog_widget.dart';
import 'package:admin_hanaang/views/components/error_button_widget.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/helper/formatted_currency.dart';
import '../../../views/components/card_bank.dart';

part "ui/bank_account_screen.dart";
part "ui/widgets/dialog_form_bank_account.dart";