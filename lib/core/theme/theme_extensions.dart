import 'package:flutter/material.dart';

/// DisciplineOS Design Tokens
class DisciplineTokens extends ThemeExtension<DisciplineTokens> {
  final double spacingUnit;
  final double gutter;
  final double marginMobile;
  final double marginDesktop;
  final double dockHeight;
  final double containerMaxWidth;
  final double borderRadiusSm;
  final double borderRadiusDefault;
  final double borderRadiusMd;
  final double borderRadiusLg;
  final double borderRadiusXl;
  final double borderRadiusFull;

  const DisciplineTokens({
    this.spacingUnit = 8,
    this.gutter = 24,
    this.marginMobile = 20,
    this.marginDesktop = 40,
    this.dockHeight = 72,
    this.containerMaxWidth = 1200,
    this.borderRadiusSm = 4,
    this.borderRadiusDefault = 8,
    this.borderRadiusMd = 12,
    this.borderRadiusLg = 16,
    this.borderRadiusXl = 24,
    this.borderRadiusFull = 9999,
  });

  @override
  DisciplineTokens copyWith({
    double? spacingUnit,
    double? gutter,
    double? marginMobile,
    double? marginDesktop,
    double? dockHeight,
    double? containerMaxWidth,
    double? borderRadiusSm,
    double? borderRadiusDefault,
    double? borderRadiusMd,
    double? borderRadiusLg,
    double? borderRadiusXl,
    double? borderRadiusFull,
  }) {
    return DisciplineTokens(
      spacingUnit: spacingUnit ?? this.spacingUnit,
      gutter: gutter ?? this.gutter,
      marginMobile: marginMobile ?? this.marginMobile,
      marginDesktop: marginDesktop ?? this.marginDesktop,
      dockHeight: dockHeight ?? this.dockHeight,
      containerMaxWidth: containerMaxWidth ?? this.containerMaxWidth,
      borderRadiusSm: borderRadiusSm ?? this.borderRadiusSm,
      borderRadiusDefault: borderRadiusDefault ?? this.borderRadiusDefault,
      borderRadiusMd: borderRadiusMd ?? this.borderRadiusMd,
      borderRadiusLg: borderRadiusLg ?? this.borderRadiusLg,
      borderRadiusXl: borderRadiusXl ?? this.borderRadiusXl,
      borderRadiusFull: borderRadiusFull ?? this.borderRadiusFull,
    );
  }

  @override
  DisciplineTokens lerp(DisciplineTokens? other, double t) {
    if (other is! DisciplineTokens) return this;
    return DisciplineTokens(
      spacingUnit: spacingUnit + (other.spacingUnit - spacingUnit) * t,
      gutter: gutter + (other.gutter - gutter) * t,
      marginMobile: marginMobile + (other.marginMobile - marginMobile) * t,
      marginDesktop: marginDesktop + (other.marginDesktop - marginDesktop) * t,
      dockHeight: dockHeight + (other.dockHeight - dockHeight) * t,
      containerMaxWidth:
          containerMaxWidth + (other.containerMaxWidth - containerMaxWidth) * t,
      borderRadiusSm:
          borderRadiusSm + (other.borderRadiusSm - borderRadiusSm) * t,
      borderRadiusDefault: borderRadiusDefault +
          (other.borderRadiusDefault - borderRadiusDefault) * t,
      borderRadiusMd:
          borderRadiusMd + (other.borderRadiusMd - borderRadiusMd) * t,
      borderRadiusLg:
          borderRadiusLg + (other.borderRadiusLg - borderRadiusLg) * t,
      borderRadiusXl:
          borderRadiusXl + (other.borderRadiusXl - borderRadiusXl) * t,
      borderRadiusFull:
          borderRadiusFull + (other.borderRadiusFull - borderRadiusFull) * t,
    );
  }

  static DisciplineTokens of(BuildContext context) {
    return Theme.of(context).extension<DisciplineTokens>() ?? const DisciplineTokens();
  }
}

/// Spacing helpers
extension SpacingExtensions on BuildContext {
  double get spacingUnit => DisciplineTokens.of(this).spacingUnit;
  double get gutter => DisciplineTokens.of(this).gutter;
  double get marginMobile => DisciplineTokens.of(this).marginMobile;
  double get marginDesktop => DisciplineTokens.of(this).marginDesktop;
  double get dockHeight => DisciplineTokens.of(this).dockHeight;
  double get containerMaxWidth => DisciplineTokens.of(this).containerMaxWidth;

  double spacing(double multiplier) => spacingUnit * multiplier;
}
