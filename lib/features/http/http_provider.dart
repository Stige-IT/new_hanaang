import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';

final httpProvider = Provider<IOClient>((ref) {
  return IOClient();
});
