import 'package:discipline_os/config/route_config.dart';
import 'package:discipline_os/core/theme/app_theme.dart';
import 'package:discipline_os/core/widgets/error_boundary.dart';
import 'package:flutter/material.dart';

/// DisciplineOS Application
class DisciplineOSApp extends StatelessWidget {
  const DisciplineOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: MaterialApp.router(
        title: 'DisciplineOS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: RouteConfig.router,
      ),
    );
  }
}
