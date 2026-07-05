import 'package:flutter/material.dart';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:discipline_os/core/widgets/glass_card.dart';
import 'package:discipline_os/features/dashboard/domain/entities/dashboard_entity.dart';

/// Focus Today Section Widget
/// Displays today's goals
class FocusTodaySection extends StatelessWidget {
  final List<DashboardGoal> goals;
  final String identityLevel;
  final bool isEmpty;

  const FocusTodaySection({
    super.key,
    required this.goals,
    this.identityLevel = 'novice',
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Focus Today',
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            Text(
              'Identity: ${_formatIdentityLevel(identityLevel)}',
              style: AppTypography.labelMono.copyWith(
                color: AppColors.primary,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (isEmpty)
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.add_task,
                    color: AppColors.onSurfaceVariant,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No goals set for today',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create goals to track your daily focus',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...goals.map((goal) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.4),
                          ),
                        ),
                        child: goal.progress >= 1.0
                            ? Icon(
                                Icons.check,
                                color: AppColors.primary,
                                size: 16,
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goal.title,
                              style: AppTypography.bodyMd.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.onSurface,
                              ),
                            ),
                            if (goal.targetValue != null)
                              Text(
                                '${goal.currentValue}/${goal.targetValue} ${goal.unit ?? ''}',
                                style: AppTypography.labelMono.copyWith(
                                  fontSize: 11,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
      ],
    );
  }

  String _formatIdentityLevel(String level) {
    switch (level) {
      case 'novice':
        return 'Novice';
      case 'practitioner':
        return 'Practitioner';
      case 'architect':
        return 'Architect';
      case 'master':
        return 'Master';
      default:
        return level[0].toUpperCase() + level.substring(1);
    }
  }
}
