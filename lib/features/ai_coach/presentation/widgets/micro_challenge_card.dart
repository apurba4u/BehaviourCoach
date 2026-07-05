import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class MicroChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onCommit;

  const MicroChallengeCard({
    super.key,
    required this.title,
    required this.description,
    this.onCommit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassSurface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          Text(
            title,
            style: AppTypography.headlineLgMobile.copyWith(
              fontSize: 22,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: _CommitButton(onPressed: onCommit),
          ),
        ],
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
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
          child: const Icon(
            Icons.rocket_launch,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'CHALLENGER',
          style: AppTypography.labelMono.copyWith(
            color: AppColors.primary,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

class _CommitButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _CommitButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Commit to Challenge',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
