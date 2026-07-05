import 'package:flutter/material.dart';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:discipline_os/core/widgets/glass_card.dart';

/// Active Focus Session Card Widget
/// Displays the currently running focus session
class ActiveFocusSessionCard extends StatelessWidget {
  final String? title;
  final int? minutesRemaining;
  final bool isActive;

  const ActiveFocusSessionCard({
    super.key,
    this.title,
    this.minutesRemaining,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isActive) return const SizedBox.shrink();

    return GlassCard(
      showGlow: true,
      glowColor: AppColors.primary,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.2),
            ),
            child: Icon(
              Icons.timer,
              color: AppColors.primary,
              fill: 1,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ACTIVE SESSION',
                  style: AppTypography.labelMono.copyWith(
                    fontSize: 10,
                    color: AppColors.primary,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title ?? 'Focus Session',
                  style: AppTypography.bodyMd.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          if (minutesRemaining != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${minutesRemaining!}m left',
                style: AppTypography.labelMono.copyWith(
                  fontSize: 12,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
