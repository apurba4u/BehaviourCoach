import 'package:discipline_os/config/supabase_config.dart';
import 'package:discipline_os/core/widgets/floating_dock.dart';
import 'package:discipline_os/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:discipline_os/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:discipline_os/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:discipline_os/features/ai_coach/presentation/screens/ai_coach_screen.dart';
import 'package:discipline_os/features/daily_reflection/presentation/screens/daily_reflection_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// DisciplineOS Route Configuration
class RouteConfig {
  RouteConfig._();

  static final router = GoRouter(
    initialLocation: '/sign-in',
    redirect: (context, state) {
      final session = SupabaseConfig.auth.currentSession;
      final isAuthRoute = state.matchedLocation == '/sign-in' ||
          state.matchedLocation == '/sign-up';

      if (session == null && !isAuthRoute) {
        return '/sign-in';
      }

      if (session != null && isAuthRoute) {
        return '/insights';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithDock(child: child);
        },
        routes: [
          GoRoute(
            path: '/insights',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: '/coach',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AiCoachScreen(),
            ),
          ),
          GoRoute(
            path: '/reflections',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DailyReflectionScreen(),
            ),
          ),
        ],
      ),
    ],
  );
}

class ScaffoldWithDock extends StatelessWidget {
  final Widget child;

  const ScaffoldWithDock({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    var currentIndex = 0;
    if (location.startsWith('/coach')) currentIndex = 1;
    if (location.startsWith('/reflections')) currentIndex = 2;

    return Scaffold(
      body: child,
      bottomNavigationBar: FloatingDock(
        currentIndex: currentIndex,
        items: const [
          DockItem(icon: Icons.query_stats, label: 'Insights'),
          DockItem(icon: Icons.smart_toy, label: 'Coach'),
          DockItem(icon: Icons.auto_stories, label: 'Reflections'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/insights');
            case 1:
              context.go('/coach');
            case 2:
              context.go('/reflections');
          }
        },
      ),
    );
  }
}
