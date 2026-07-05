import 'package:flutter/material.dart';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:discipline_os/core/widgets/glass_card.dart';

/// AI Insight Card Widget
/// Displays the daily AI-generated insight
class AiInsightCard extends StatelessWidget {
  final String? title;
  final String? content;
  final String? tip;
  final bool isEmpty;

  const AiInsightCard({
    super.key,
    this.title,
    this.content,
    this.tip,
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      showGlow: true,
      glowColor: AppColors.auraViolet,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.smart_toy,
                color: AppColors.auraViolet,
                size: 20,
                fill: 1,
              ),
              const SizedBox(width: 8),
              Text(
                'EMPATHETIC COACH',
                style: AppTypography.labelMono.copyWith(
                  color: AppColors.auraViolet,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isEmpty) ...[
            Text(
              'Daily Insight',
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Complete your first reflection to receive personalized AI insights about your behavioral patterns.',
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ] else ...[
            Text(
              title ?? 'Daily Insight',
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content ?? '',
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            if (tip != null && tip!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip!,
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
