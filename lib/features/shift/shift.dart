
import 'dart:developer';

import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../http/http_request_client.dart';
import '../storage/service/storage_service.dart';

part "data/shift_api.dart";
part "models/shift.dart";

part "providers/shift_notifier.dart";
part "providers/shift_provider.dart";

part "ui/shift_screen.dart";