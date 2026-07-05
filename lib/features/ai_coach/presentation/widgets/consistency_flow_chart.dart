import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class ConsistencyFlowChart extends StatelessWidget {
  final List<double> values;
  final String score;
  final String changePercent;

  const ConsistencyFlowChart({
    super.key,
    required this.values,
    this.score = '8.4',
    this.changePercent = '+12%',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassSurface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppColors.outline.withValues(alpha: 0.15),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CONSISTENCY FLOW',
            style: AppTypography.labelMono.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 24),
          _buildChart(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MON',
                style: AppTypography.labelMono.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
              Text(
                'TODAY',
                style: AppTypography.labelMono.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score,
                style: AppTypography.displayLg.copyWith(
                  color: AppColors.onSurface,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: AppColors.successEmerald,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      changePercent,
                      style: AppTypography.labelMono.copyWith(
                        color: AppColors.successEmerald,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return SizedBox(
      height: 96,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (index) {
          final value = values[index];
          final isLast = index == values.length - 1;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index < values.length - 1 ? 4 : 0,
              ),
              child: Container(
                height: value * 96,
                decoration: BoxDecoration(
                  color: isLast
                      ? AppColors.primary
                      : AppColors.primary.withValues(
                          alpha: 0.2 + (value * 0.7),
                        ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(2),
                  ),
                  boxShadow: isLast
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 15,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
