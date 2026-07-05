import 'package:flutter/material.dart';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';

class EnergySlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const EnergySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (value * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'COGNITIVE FUEL',
              style: AppTypography.labelMono.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 0.1,
              ),
            ),
            Text(
              '$percentage%',
              style: AppTypography.labelMono.copyWith(
                color: AppColors.auraViolet,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 8,
            activeTrackColor: Colors.transparent,
            inactiveTrackColor: Colors.transparent,
            thumbColor: AppColors.auraViolet,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
            overlayShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
            overlayColor: Colors.transparent,
          ),
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.auraViolet.withValues(alpha: 0.5),
                          AppColors.auraViolet,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.auraViolet.withValues(alpha: 0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Slider(
                  value: value,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
