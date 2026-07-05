import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:discipline_os/core/widgets/glass_card.dart';
import 'package:discipline_os/features/focus_session/domain/entities/focus_session_entity.dart';
import 'package:discipline_os/features/focus_session/presentation/providers/focus_session_provider.dart';

/// Ambient Sound Selector Widget
/// Allows user to select ambient sounds during focus session
class AmbientSoundSelector extends ConsumerWidget {
  const AmbientSoundSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSound = ref.watch(selectedAmbientSoundProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ATMOSPHERIC FEED',
              style: AppTypography.labelMono.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 0.1,
              ),
            ),
            Text(
              'HI-RES AUDIO',
              style: AppTypography.labelMono.copyWith(
                fontSize: 10,
                color: AppColors.primary.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: AmbientSound.values.map((sound) {
              final isSelected = selectedSound == sound;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    ref.read(selectedAmbientSoundProvider.notifier).state =
                        sound;
                  },
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: isSelected
                        ? Border.all(
                            color: AppColors.primary.withValues(alpha: 0.5),
                          )
                        : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getIconForSound(sound),
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          sound.displayName,
                          style: AppTypography.bodyMd.copyWith(
                            fontSize: 14,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  IconData _getIconForSound(AmbientSound sound) {
    switch (sound) {
      case AmbientSound.oceanDeep:
        return Icons.waves;
      case AmbientSound.blackForest:
        return Icons.forest;
      case AmbientSound.whiteNoise:
        return Icons.grain;
      case AmbientSound.midnightStorm:
        return Icons.thunderstorm;
    }
  }
}
