import 'package:flutter/material.dart';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:discipline_os/core/widgets/glass_card.dart';

class AiSynthesisCard extends StatelessWidget {
  final String? text;

  const AiSynthesisCard({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -40,
            width: 128,
            height: 128,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.auraViolet.withValues(alpha: 0.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.auraViolet.withValues(alpha: 0.3),
                    blurRadius: 60,
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.psychology,
                    color: AppColors.auraViolet,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI SYNTHESIS',
                    style: AppTypography.labelMono.copyWith(
                      color: AppColors.auraViolet,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                text ??
                    '"A day of high cognitive focus followed by a gentle evening wind-down. Your energy signature suggests a preference for deep work in the early afternoon."',
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.onSurface,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildDot(1),
                  const SizedBox(width: 4),
                  _buildDot(0.5),
                  const SizedBox(width: 4),
                  _buildDot(0.2),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDot(double opacity) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.auraViolet.withValues(alpha: opacity),
      ),
    );
  }
}
