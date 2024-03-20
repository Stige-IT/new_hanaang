import 'dart:convert';
import 'dart:io';

import 'package:admin_hanaang/features/http/http_provider.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/models/detail_transaction.dart';
import 'package:admin_hanaang/models/message_order.dart';
import 'package:admin_hanaang/models/order.dart';
import 'package:admin_hanaang/models/order_detail.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../../models/response_data.dart';
import '../../config/router/router_config.dart';
import '../../utils/helper/failure_exception.dart';
import '../../views/components/appbar.dart';
import '../../views/components/card_total_users.dart';
import '../../views/components/navigation_widget.dart';
import '../../views/components/tile.dart';
import '../http/http_request_client.dart';
import '../pre_order_users/provider/pre_order_user_provider.dart';
import '../retur/provider/retur_provider.dart';
import '../state.dart';
import '../storage/service/storage_service.dart';

part "data/order_api.dart";

part "provider/order_provider.dart";
part "provider/order_notifier.dart";

part "ui/order_screen.dart";
