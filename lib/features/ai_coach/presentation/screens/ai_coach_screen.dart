import 'package:flutter/material.dart';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:discipline_os/core/theme/theme_extensions.dart';
import 'package:discipline_os/features/ai_coach/presentation/widgets/pattern_discovery_card.dart';
import 'package:discipline_os/features/ai_coach/presentation/widgets/micro_challenge_card.dart';
import 'package:discipline_os/features/ai_coach/presentation/widgets/distraction_heatmap.dart';
import 'package:discipline_os/features/ai_coach/presentation/widgets/daily_pulse_card.dart';
import 'package:discipline_os/features/ai_coach/presentation/widgets/consistency_flow_chart.dart';
import 'package:discipline_os/features/ai_coach/presentation/widgets/quick_action_button.dart';

class AiCoachScreen extends StatefulWidget {
  const AiCoachScreen({super.key});

  @override
  State<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends State<AiCoachScreen> {
  @override
  Widget build(BuildContext context) {
    final tokens = DisciplineTokens.of(context);

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(tokens),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.marginMobile),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    _buildHeaderSection(),
                    const SizedBox(height: 48),
                    _buildPatternAndChallengeRow(tokens),
                    const SizedBox(height: 48),
                    _buildAnalyticsRow(tokens),
                    const SizedBox(height: 32),
                    _buildQuickActions(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(DisciplineTokens tokens) {
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
                    color: AppColors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/avatar.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceContainer,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'DisciplineOS',
                style: AppTypography.headlineLgMobile.copyWith(
                  color: AppColors.onSurface,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Evening, Alex.',
          style: AppTypography.headlineLgMobile.copyWith(
            color: AppColors.onSurface,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Your performance architecture is stabilizing. I've noticed a recurring friction point in your afternoon cycles.",
          style: AppTypography.bodyLg.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPatternAndChallengeRow(DisciplineTokens tokens) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: PatternDiscoveryCard(
                  title: 'The Afternoon Resistance',
                  description:
                      "I've observed a 42% drop in cognitive focus between 2:30 PM and 4:00 PM. This correlates strongly with your high-glucose lunch selections yesterday and today. Your sleep latency also increases on these days, suggesting a metabolic rebound effect that disrupts your deep work architecture.",
                  tags: const [
                    PatternTag(
                      icon: Icons.restaurant,
                      color: AppColors.primary,
                      label: 'Sugar Intake High',
                    ),
                    PatternTag(
                      icon: Icons.bedtime,
                      color: AppColors.recoveryRose,
                      label: 'Sleep Quality: -14%',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 4,
                child: MicroChallengeCard(
                  title: 'Analog Initiation',
                  description:
                      'Start tomorrow with 15 minutes of offline reading. No screens until 8:15 AM.',
                  onCommit: () {},
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            PatternDiscoveryCard(
              title: 'The Afternoon Resistance',
              description:
                  "I've observed a 42% drop in cognitive focus between 2:30 PM and 4:00 PM. This correlates strongly with your high-glucose lunch selections yesterday and today. Your sleep latency also increases on these days, suggesting a metabolic rebound effect that disrupts your deep work architecture.",
              tags: const [
                PatternTag(
                  icon: Icons.restaurant,
                  color: AppColors.primary,
                  label: 'Sugar Intake High',
                ),
                PatternTag(
                  icon: Icons.bedtime,
                  color: AppColors.recoveryRose,
                  label: 'Sleep Quality: -14%',
                ),
              ],
            ),
            const SizedBox(height: 24),
            MicroChallengeCard(
              title: 'Analog Initiation',
              description:
                  'Start tomorrow with 15 minutes of offline reading. No screens until 8:15 AM.',
              onCommit: () {},
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnalyticsRow(DisciplineTokens tokens) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                child: DistractionHeatmap(
                  data: [
                    [0.1, 0.2, 0.4, 0.1, 0.6, 0.8, 0.2],
                    [0.05, 0.1, 0.3, 0.9, 0.2, 0.1, 0.05],
                    [0.1, 0.1, 0.4, 0.1, 0.1, 0.1, 0.1],
                    [0.2, 0.05, 0.1, 0.2, 0.1, 0.05, 0.1],
                  ],
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: DailyPulseCard(
                  quote:
                      'A day of quiet persistence. The morning was clear, but the shadows of fatigue grew long by mid-afternoon. Still, the discipline held.',
                  flowLevel: 3,
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: ConsistencyFlowChart(
                  values: [0.4, 0.6, 0.5, 0.8, 0.95, 0.65, 1.0],
                ),
              ),
            ],
          );
        }

        return Column(
          children: const [
            DistractionHeatmap(
              data: [
                [0.1, 0.2, 0.4, 0.1, 0.6, 0.8, 0.2],
                [0.05, 0.1, 0.3, 0.9, 0.2, 0.1, 0.05],
                [0.1, 0.1, 0.4, 0.1, 0.1, 0.1, 0.1],
                [0.2, 0.05, 0.1, 0.2, 0.1, 0.05, 0.1],
              ],
            ),
            SizedBox(height: 24),
            DailyPulseCard(
              quote:
                  'A day of quiet persistence. The morning was clear, but the shadows of fatigue grew long by mid-afternoon. Still, the discipline held.',
              flowLevel: 3,
            ),
            SizedBox(height: 24),
            ConsistencyFlowChart(
              values: [0.4, 0.6, 0.5, 0.8, 0.95, 0.65, 1.0],
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Row(
          children: [
            QuickActionButton(
              icon: Icons.forum,
              label: 'Ask AI Coach',
              color: AppColors.primary,
              onPressed: () {},
            ),
            const SizedBox(width: 16),
            QuickActionButton(
              icon: Icons.self_improvement,
              label: 'Quick Reflection',
              color: AppColors.auraViolet,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
