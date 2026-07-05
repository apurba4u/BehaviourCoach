import 'dart:ui';

import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class PatternDiscoveryCard extends StatelessWidget {
  final String title;
  final String description;
  final List<PatternTag> tags;

  const PatternDiscoveryCard({
    super.key,
    required this.title,
    required this.description,
    this.tags = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.glassSurface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.auraViolet.withValues(alpha: 0.3),
                blurRadius: 40,
                spreadRadius: -10,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -96,
                right: -96,
                child: Container(
                  width: 256,
                  height: 256,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.auraViolet.withValues(alpha: 0.1),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    Text(
                      title,
                      style: AppTypography.headlineLg.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      description,
                      style: AppTypography.bodyLg.copyWith(
                        color: AppColors.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                    if (tags.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: tags.map(_buildTag).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.auraViolet.withValues(alpha: 0.2),
          ),
          child: const Icon(
            Icons.psychology,
            color: AppColors.auraViolet,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'EMPATHETIC COACH',
          style: AppTypography.labelMono.copyWith(
            color: AppColors.auraViolet,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(PatternTag tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(tag.icon, color: tag.color, size: 16),
          const SizedBox(width: 8),
          Text(
            tag.label,
            style: AppTypography.labelMono.copyWith(
              color: AppColors.onSurface,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class PatternTag {
  final IconData icon;
  final Color color;
  final String label;

  const PatternTag({
    required this.icon,
    required this.color,
    required this.label,
  });
}
