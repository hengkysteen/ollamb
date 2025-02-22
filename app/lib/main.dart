import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ollamb/src/app.dart';
import 'package:ollamb/src/core/dm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DM.init();
  runApp(const App());
}
