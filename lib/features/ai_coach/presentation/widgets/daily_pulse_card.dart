import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class DailyPulseCard extends StatelessWidget {
  final String quote;
  final int flowLevel;
  final int maxFlowLevel;

  const DailyPulseCard({
    super.key,
    required this.quote,
    this.flowLevel = 3,
    this.maxFlowLevel = 4,
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
          _buildHeader(),
          const SizedBox(height: 16),
          Text(
            '"$quote"',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurface,
              fontStyle: FontStyle.italic,
              height: 1.6,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.outline,
                  width: 0.5,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SUBJECTIVE FLOW',
                  style: AppTypography.labelMono.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                _buildFlowIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.edit_note,
          color: AppColors.auraViolet,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'DAILY PULSE',
          style: AppTypography.labelMono.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildFlowIndicator() {
    final heights = [12.0, 16.0, 20.0, 12.0];
    return Row(
      children: List.generate(maxFlowLevel, (index) {
        final isActive = index < flowLevel;
        return Padding(
          padding: EdgeInsets.only(right: index < maxFlowLevel - 1 ? 4 : 0),
          child: Container(
            width: 4,
            height: heights[index],
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.auraViolet
                  : AppColors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(9999),
            ),
          ),
        );
      }),
    );
  }
}
