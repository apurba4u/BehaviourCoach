import 'package:flutter/material.dart';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:discipline_os/core/widgets/glass_card.dart';
import 'package:discipline_os/features/dashboard/domain/entities/dashboard_entity.dart';

/// Recent Reflection Card Widget
/// Displays the most recent reflection summary
class RecentReflectionCard extends StatelessWidget {
  final DashboardReflection? reflection;
  final bool isEmpty;

  const RecentReflectionCard({
    super.key,
    this.reflection,
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
            children: [
              Icon(
                Icons.edit_note,
                color: AppColors.auraViolet,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'RECENT REFLECTION',
                style: AppTypography.labelMono.copyWith(
                  fontSize: 10,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isEmpty)
            Text(
              'No reflections yet. Start your first reflection to track your emotional journey.',
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
            )
          else ...[
            Row(
              children: [
                _buildMoodIndicator(reflection!.mood),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    reflection!.content ?? 'No content',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurface,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _formatDate(reflection!.recordedAt),
              style: AppTypography.labelMono.copyWith(
                fontSize: 11,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMoodIndicator(String mood) {
    IconData icon;
    Color color;

    switch (mood.toLowerCase()) {
      case 'calm':
        icon = Icons.filter_drama;
        color = AppColors.tertiary;
        break;
      case 'stable':
        icon = Icons.circle;
        color = AppColors.primary;
        break;
      case 'focused':
        icon = Icons.center_focus_strong;
        color = AppColors.auraViolet;
        break;
      case 'high_energy':
        icon = Icons.bolt;
        color = AppColors.warningAmber;
        break;
      case 'restless':
        icon = Icons.air;
        color = AppColors.recoveryRose;
        break;
      default:
        icon = Icons.circle;
        color = AppColors.onSurfaceVariant;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
