import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class DistractionHeatmap extends StatelessWidget {
  final List<List<double>> data;
  final String peakDrift;
  final String context;

  const DistractionHeatmap({
    super.key,
    required this.data,
    this.peakDrift = '14:42 PM',
    this.context = 'DIGITAL NOISE',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DISTRACTION HEATMAP',
                style: AppTypography.labelMono.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 0.1,
                ),
              ),
              Icon(
                Icons.analytics,
                color: AppColors.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildGrid(),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemCount: data.expand((row) => row).length,
      itemBuilder: (context, index) {
        final row = index ~/ 7;
        final col = index % 7;
        final value =
            row < data.length && col < data[row].length ? data[row][col] : 0.0;
        return Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: value * 0.9 + 0.05),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
    );
  }

  Widget _buildLegend() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PEAK DRIFT:',
              style: AppTypography.labelMono.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
            Text(
              peakDrift,
              style: AppTypography.labelMono.copyWith(
                color: AppColors.primary,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'CONTEXT:',
              style: AppTypography.labelMono.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
            Text(
              context.toUpperCase(),
              style: AppTypography.labelMono.copyWith(
                color: AppColors.onSurface,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
