import 'package:discipline_os/app.dart';
import 'package:discipline_os/config/env_config.dart';
import 'package:discipline_os/config/supabase_config.dart';
import 'package:discipline_os/core/connectivity/connectivity_service.dart';
import 'package:discipline_os/core/local/hive_service.dart';
import 'package:discipline_os/core/sync/sync_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.init();
  await SupabaseConfig.init();
  await HiveService.instance.init();
  await ConnectivityService.instance.init();
  SyncManager.instance.init();

  runApp(
    const ProviderScope(
      child: DisciplineOSApp(),
    ),
  );
}
