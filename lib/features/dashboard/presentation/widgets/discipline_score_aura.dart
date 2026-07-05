import 'package:flutter/material.dart';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:discipline_os/core/widgets/aura_ring.dart';

/// Discipline Score Aura Widget
/// Displays the main discipline score with aura ring visualization
class DisciplineScoreAura extends StatelessWidget {
  final int score;
  final String changeText;
  final bool isEmpty;

  const DisciplineScoreAura({
    super.key,
    required this.score,
    this.changeText = '',
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuraRing(
          value: isEmpty ? 0 : score / 100,
          size: 256,
          strokeWidth: 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEmpty ? '--' : '$score',
                style: AppTypography.displayLg.copyWith(
                  fontSize: 64,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                'DAILY SCORE',
                style: AppTypography.labelMono.copyWith(
                  color: AppColors.primary,
                  fontSize: 11,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        if (isEmpty)
          Text(
            'Complete activities to build your discipline score',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          )
        else if (changeText.isNotEmpty)
          Text(
            changeText,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}
