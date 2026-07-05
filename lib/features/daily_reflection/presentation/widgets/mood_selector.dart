import 'package:flutter/material.dart';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';

enum MoodType {
  calm,
  stable,
  focused,
  highEnergy,
  restless,
}

extension MoodTypeExtension on MoodType {
  String get label {
    switch (this) {
      case MoodType.calm:
        return 'Calm';
      case MoodType.stable:
        return 'Stable';
      case MoodType.focused:
        return 'Focused';
      case MoodType.highEnergy:
        return 'High Energy';
      case MoodType.restless:
        return 'Restless';
    }
  }

  IconData get icon {
    switch (this) {
      case MoodType.calm:
        return Icons.filter_drama;
      case MoodType.stable:
        return Icons.circle;
      case MoodType.focused:
        return Icons.psychology;
      case MoodType.highEnergy:
        return Icons.bolt;
      case MoodType.restless:
        return Icons.air;
    }
  }
}

class MoodSelector extends StatelessWidget {
  final MoodType? selectedMood;
  final ValueChanged<MoodType?> onMoodChanged;

  const MoodSelector({
    super.key,
    this.selectedMood,
    required this.onMoodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EMOTIONAL STATE',
          style: AppTypography.labelMono.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: MoodType.values.map((mood) {
              final isSelected = selectedMood == mood;
              return GestureDetector(
                onTap: () => onMoodChanged(isSelected ? null : mood),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.auraViolet.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color:
                                  AppColors.auraViolet.withValues(alpha: 0.2),
                              blurRadius: 15,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    mood.icon,
                    color: isSelected
                        ? AppColors.auraViolet
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
