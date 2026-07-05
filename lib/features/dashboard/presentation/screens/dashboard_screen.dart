import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:discipline_os/core/theme/theme_extensions.dart';
import 'package:discipline_os/features/auth/presentation/providers/auth_provider.dart';
import 'package:discipline_os/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:discipline_os/features/dashboard/presentation/widgets/active_focus_session_card.dart';
import 'package:discipline_os/features/dashboard/presentation/widgets/ai_insight_card.dart';
import 'package:discipline_os/features/dashboard/presentation/widgets/discipline_score_aura.dart';
import 'package:discipline_os/features/dashboard/presentation/widgets/focus_today_section.dart';
import 'package:discipline_os/features/dashboard/presentation/widgets/momentum_card.dart';
import 'package:discipline_os/features/dashboard/presentation/widgets/recent_reflection_card.dart';
import 'package:discipline_os/features/dashboard/presentation/widgets/weekly_audit_card.dart';

/// Dashboard Screen
/// Main home screen displaying user's behavioral overview
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboard();
    });
  }

  void _loadDashboard() {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId != null) {
      ref.read(dashboardNotifierProvider.notifier).loadDashboard(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardNotifierProvider);
    final tokens = DisciplineTokens.of(context);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final userId = ref.read(currentUserProvider).value?.id;
            if (userId != null) {
              await ref
                  .read(dashboardNotifierProvider.notifier)
                  .refreshDashboard(userId);
            }
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(context, dashboardState, tokens),
              ),
              SliverToBoxAdapter(
                child: _buildContent(context, dashboardState, tokens),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    DashboardDataState state,
    DisciplineTokens tokens,
  ) {
    final data = state.data;
    final isLoading = state.state == DashboardState.loading;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.marginMobile,
        vertical: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: data?.avatarUrl != null
                    ? ClipOval(
                        child: Image.network(
                          data!.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
                        ),
                      )
                    : _buildDefaultAvatar(),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    isLoading ? 'Loading...' : (data?.displayName ?? 'User'),
                    style: AppTypography.headlineLgMobile.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceContainer,
      ),
      child: const Icon(
        Icons.person,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    DashboardDataState state,
    DisciplineTokens tokens,
  ) {
    final data = state.data;
    final isLoading = state.state == DashboardState.loading;
    final isError = state.state == DashboardState.error;

    if (isError) {
      return _buildErrorState(state.error ?? 'Failed to load dashboard');
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: tokens.marginMobile),
      child: Column(
        children: [
          const SizedBox(height: 16),
          DisciplineScoreAura(
            score: data?.disciplineScore ?? 0,
            changeText: data != null
                ? 'Your consistency is ${data.momentumScore > 0 ? "+" : ""}${data.momentumScore}% compared to last week.'
                : '',
            isEmpty: data == null && !isLoading,
          ),
          const SizedBox(height: 48),
          AiInsightCard(
            title: data?.dailyInsightTitle,
            content: data?.dailyInsightContent,
            tip: data?.dailyInsightTip,
            isEmpty: data?.dailyInsightTitle == null,
          ),
          const SizedBox(height: 24),
          if (data?.hasActiveFocusSession == true)
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: ActiveFocusSessionCard(
                title: data?.activeFocusSessionTitle,
                minutesRemaining: data?.activeFocusSessionMinutesRemaining,
                isActive: true,
              ),
            ),
          Row(
            children: [
              Expanded(
                child: MomentumCard(
                  momentumScore: data?.momentumScore ?? 0,
                  isEmpty: data == null,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: WeeklyAuditCard(
                  consistencyPercentage: data?.weeklyConsistency ?? 0,
                  isEmpty: data == null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          FocusTodaySection(
            goals: data?.todayGoals ?? [],
            identityLevel: data?.identityLevel ?? 'novice',
            isEmpty: data?.todayGoals.isEmpty ?? true,
          ),
          const SizedBox(height: 24),
          RecentReflectionCard(
            reflection: data?.recentReflection,
            isEmpty: data?.recentReflection == null,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadDashboard,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
