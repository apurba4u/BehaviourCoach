import 'dart:ui';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

/// DisciplineOS Glass Card Component
/// Renders a frosted glass effect with backdrop blur
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final bool showGlow;
  final Color glowColor;
  final double opacity;
  final Border? border;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.showGlow = false,
    this.glowColor = AppColors.primary,
    this.opacity = 0.4,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = DisciplineTokens.of(context);
    final effectiveRadius = borderRadius ?? tokens.borderRadiusXl;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.glassSurface.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(effectiveRadius),
        border: border ??
            Border.all(
              color: AppColors.outline.withValues(alpha: 0.15),
              width: 1,
            ),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.15),
                  blurRadius: 40,
                  spreadRadius: -10,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: padding ?? EdgeInsets.all(tokens.gutter),
            child: child,
          ),
        ),
      ),
    );
  }
}
