import 'package:flutter/material.dart';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:discipline_os/core/widgets/glass_card.dart';

/// Weekly Audit Card Widget
/// Displays the weekly consistency percentage
class WeeklyAuditCard extends StatelessWidget {
  final int consistencyPercentage;
  final bool isEmpty;

  const WeeklyAuditCard({
    super.key,
    required this.consistencyPercentage,
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'WEEKLY AUDIT',
                style: AppTypography.labelMono.copyWith(
                  fontSize: 10,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Icon(
                Icons.calendar_view_week,
                color: AppColors.tertiary,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(7, (index) {
              final isActive = isEmpty
                  ? false
                  : index < (consistencyPercentage / 100 * 7).round();
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.tertiary
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            'CONSISTENCY',
            style: AppTypography.labelMono.copyWith(
              fontSize: 11,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Text(
            isEmpty ? '--' : '$consistencyPercentage%',
            style: AppTypography.bodyMd.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}
