import 'package:flutter/material.dart';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:discipline_os/core/widgets/glass_card.dart';

class ReflectionHistoryCard extends StatelessWidget {
  final String dateLabel;
  final String content;
  final IconData moodIcon;
  final Color moodColor;
  final VoidCallback? onTap;

  const ReflectionHistoryCard({
    super.key,
    required this.dateLabel,
    required this.content,
    this.moodIcon = Icons.sentiment_satisfied,
    this.moodColor = AppColors.auraViolet,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: GlassCard(
              padding: EdgeInsets.zero,
              child: Center(
                child: Text(
                  dateLabel,
                  style: AppTypography.labelMono.copyWith(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content,
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        moodIcon,
                        size: 14,
                        color: moodColor,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.article,
                        size: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
