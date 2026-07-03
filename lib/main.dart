import 'package:discipline_os/app.dart';
import 'package:discipline_os/config/env_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.init();

  runApp(
    const ProviderScope(
      child: DisciplineOSApp(),
    ),
  );
}
