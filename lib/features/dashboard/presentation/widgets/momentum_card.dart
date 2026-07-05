import 'package:flutter/material.dart';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:discipline_os/core/widgets/glass_card.dart';

/// Momentum Card Widget
/// Displays the behavioral momentum score
class MomentumCard extends StatelessWidget {
  final int momentumScore;
  final bool isEmpty;

  const MomentumCard({
    super.key,
    required this.momentumScore,
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
                'MOMENTUM',
                style: AppTypography.labelMono.copyWith(
                  fontSize: 10,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Icon(Icons.trending_up, color: AppColors.primary, size: 16),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 64,
            child: isEmpty
                ? Center(
                    child: Text(
                      'No data yet',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(5, (index) {
                      final heights = [0.3, 0.45, 0.6, 0.85, 1.0];
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary
                                .withOpacity(0.2 + heights[index] * 0.8),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          height: 64 * heights[index],
                        ),
                      );
                    }),
                  ),
          ),
          const SizedBox(height: 12),
          Text(
            isEmpty
                ? '--'
                : '${momentumScore > 0 ? "+" : ""}$momentumScore pts',
            style: AppTypography.bodyMd.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
