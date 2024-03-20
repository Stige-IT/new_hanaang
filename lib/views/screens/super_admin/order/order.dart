import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/order/order.dart';
import '../../../../utils/helper/checkStatusLabel.dart';
import '../../../components/empty_widget.dart';
import '../../../components/error_button_widget.dart';
import '../../../components/label.dart';
import '../../../components/loading_in_button.dart';

part 'order/detail_order_screen.dart';