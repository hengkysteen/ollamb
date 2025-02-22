import 'dart:io';
import 'package:flutter/foundation.dart';

final DESKTOP_PATH = '${Platform.environment['HOME']}/.ollamb';

const String? DB_PATH = kIsWeb ? null : 'db/';
