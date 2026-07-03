# DisciplineOS Flutter Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use compose:subagent (recommended) or compose:execute to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a production-quality Flutter implementation of DisciplineOS — an AI-powered behavioral operating system — by translating the existing HTML/UX designs into pixel-perfect Flutter screens.

**Architecture:** Flutter app with a clean feature-first folder structure. Each screen is an isolated widget with its own state. Shared components (glass cards, aura rings, floating dock) live in a common widgets library. State management via Riverpod. Design tokens extracted from DESIGN.md.

**Tech Stack:** Flutter 3.x, Dart, Riverpod (state), GoRouter (navigation), Google Fonts (Hanken Grotesk, Inter, JetBrains Mono), CustomPaint (Aura Rings, charts), AnimatedContainer (breathing effects)

---

## Global Constraints

- All UI must match `uiux/` HTML files pixel-perfect — no redesigning
- Colors from `uiux/silent_intelligence/DESIGN.md` — exact hex values
- Typography: Hanken Grotesk (headlines), Inter (body), JetBrains Mono (data/labels)
- Dark mode only — obsidian (#09090B) background
- Glass card style: `rgba(39, 39, 42, 0.4)` background, `blur(20px)`, subtle border
- Feature-by-feature commits with CHANGELOG.md updates
- Run `flutter analyze` after each task — zero errors required

---

## File Structure

```
lib/
├── main.dart
├── app.dart                          # MaterialApp, theme, routing
├── core/
│   ├── theme/
│   │   ├── app_colors.dart           # All color tokens from DESIGN.md
│   │   ├── app_typography.dart       # Font families + text styles
│   │   └── app_theme.dart            # ThemeData configuration
│   ├── widgets/
│   │   ├── glass_card.dart           # Reusable glass-morphism card
│   │   ├── aura_ring.dart            # Circular progress with glow
│   │   ├── floating_dock.dart        # Bottom navigation bar
│   │   ├── material_icon.dart        # Material Symbols wrapper
│   │   └── ambient_blob.dart         # Background gradient blobs
│   └── constants/
│       └── spacing.dart              # 8px unit system
├── features/
│   ├── insights_dashboard/
│   │   ├── presentation/
│   │   │   ├── insights_dashboard_screen.dart
│   │   │   ├── widgets/
│   │   │   │   ├── discipline_score_aura.dart
│   │   │   │   ├── ai_insight_card.dart
│   │   │   │   ├── momentum_chart.dart
│   │   │   │   └── weekly_audit_grid.dart
│   │   └── data/
│   │       └── mock_data.dart
│   ├── focus_session/
│   │   ├── presentation/
│   │   │   ├── focus_session_screen.dart
│   │   │   └── widgets/
│   │   │       ├── timer_aura.dart
│   │   │       ├── ambient_sound_selector.dart
│   │   │       └── daily_log_card.dart
│   │   └── data/
│   │       └── mock_data.dart
│   ├── ai_coach/
│   │   ├── presentation/
│   │   │   ├── ai_coach_screen.dart
│   │   │   └── widgets/
│   │   │       ├── pattern_discovery_card.dart
│   │   │       ├── micro_challenge_card.dart
│   │   │       ├── distraction_heatmap.dart
│   │   │       └── consistency_flow_chart.dart
│   │   └── data/
│   │       └── mock_data.dart
│   ├── behavioral_analytics/
│   │   ├── presentation/
│   │   │   ├── behavioral_analytics_screen.dart
│   │   │   └── widgets/
│   │   │       ├── streak_aura_ring.dart
│   │   │       ├── score_trend_chart.dart
│   │   │       ├── behavioral_consistency_chart.dart
│   │   │       └── ai_pattern_detection_cards.dart
│   │   └── data/
│   │       └── mock_data.dart
│   ├── behavioral_archive/
│   │   ├── presentation/
│   │   │   ├── behavioral_archive_screen.dart
│   │   │   └── widgets/
│   │   │       ├── calendar_heatmap.dart
│   │   │       ├── focus_vs_distraction_bars.dart
│   │   │       └── daily_timeline.dart
│   │   └── data/
│   │       └── mock_data.dart
│   ├── daily_reflection/
│   │   ├── presentation/
│   │   │   ├── daily_reflection_screen.dart
│   │   │   └── widgets/
│   │   │       ├── mood_selector.dart
│   │   │       ├── energy_slider.dart
│   │   │       ├── reflection_text_area.dart
│   │   │       └── reflection_history.dart
│   │   └── data/
│   │       └── mock_data.dart
│   ├── profile_identity/
│   │   ├── presentation/
│   │   │   ├── profile_identity_screen.dart
│   │   │   └── widgets/
│   │   │       ├── profile_header.dart
│   │   │       ├── achievements_scroll.dart
│   │   │       ├── ai_intelligence_core.dart
│   │   │       ├── vault_section.dart
│   │   │       └── guardrails_section.dart
│   │   └── data/
│   │       └── mock_data.dart
│   └── ambient_shader/
│       └── presentation/
│           └── ambient_shader_widget.dart
└── navigation/
    └── app_router.dart              # GoRouter configuration
```

---

## Task 1: Flutter Project Setup

**Covers:** Foundation

**Files:**
- Create: `pubspec.yaml`
- Create: `lib/main.dart`
- Create: `lib/app.dart`
- Create: `lib/core/theme/app_colors.dart`
- Create: `lib/core/theme/app_typography.dart`
- Create: `lib/core/theme/app_theme.dart`
- Create: `lib/core/constants/spacing.dart`
- Create: `CHANGELOG.md`

- [ ] **Step 1: Create Flutter project**

```bash
cd "/Users/apurbaovi/Desktop/Project/Behaviour Coach"
flutter create --org com.disciplineos --project-name discipline_os .
```

- [ ] **Step 2: Update pubspec.yaml with dependencies**

```yaml
name: discipline_os
description: AI-Powered Behavioral Operating System
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
  flutter_riverpod: ^2.4.9
  go_router: ^14.2.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1

flutter:
  uses-material-design: true
```

- [ ] **Step 3: Create app_colors.dart**

```dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Core surfaces
  static const obsidian = Color(0xFF09090B);
  static const surface = Color(0xFF131315);
  static const surfaceDim = Color(0xFF131315);
  static const surfaceBright = Color(0xFF39393B);
  static const surfaceContainerLowest = Color(0xFF0E0E10);
  static const surfaceContainerLow = Color(0xFF1C1B1D);
  static const surfaceContainer = Color(0xFF201F22);
  static const surfaceContainerHigh = Color(0xFF2A2A2C);
  static const surfaceContainerHighest = Color(0xFF353437);
  static const glassSurface = Color(0xFF27272A);
  static const deepCharcoal = Color(0xFF18181B);

  // Primary (Discipline Blue)
  static const primary = Color(0xFFADC6FF);
  static const onPrimary = Color(0xFF002E6A);
  static const primaryContainer = Color(0xFF4D8EFF);
  static const onPrimaryContainer = Color(0xFF00285D);
  static const primaryFixed = Color(0xFFD8E2FF);
  static const primaryFixedDim = Color(0xFFADC6FF);

  // Secondary (Aura Violet)
  static const secondary = Color(0xFFD0BCFF);
  static const onSecondary = Color(0xFF3C0091);
  static const secondaryContainer = Color(0xFF571BC1);
  static const onSecondaryContainer = Color(0xFFC4ABFF);
  static const auraViolet = Color(0xFF8B5CF6);

  // Tertiary (Success/Recovery)
  static const tertiary = Color(0xFF4EDEA3);
  static const onTertiary = Color(0xFF003824);
  static const tertiaryContainer = Color(0xFF00A572);
  static const successEmerald = Color(0xFF10B981);

  // Error
  static const error = Color(0xFFFFB4AB);
  static const onError = Color(0xFF690005);
  static const errorContainer = Color(0xFF93000A);

  // Semantic
  static const warningAmber = Color(0xFFF59E0B);
  static const recoveryRose = Color(0xFFFB7185);

  // Text
  static const onSurface = Color(0xFFE5E1E4);
  static const onSurfaceVariant = Color(0xFFC2C6D6);
  static const outline = Color(0xFF8C909F);
  static const outlineVariant = Color(0xFF424754);
  static const background = Color(0xFF131315);
  static const onBackground = Color(0xFFE5E1E4);
}
```

- [ ] **Step 4: Create app_typography.dart**

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextStyle displayLg = GoogleFonts.hankenGrotesk(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    height: 56 / 48,
    letterSpacing: -0.02,
  );

  static TextStyle headlineLg = GoogleFonts.hankenGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 40 / 32,
    letterSpacing: -0.01,
  );

  static TextStyle headlineLgMobile = GoogleFonts.hankenGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    height: 36 / 28,
  );

  static TextStyle bodyLg = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
  );

  static TextStyle bodyMd = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static TextStyle labelMono = GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 16 / 13,
    letterSpacing: 0.05,
  );
}
```

- [ ] **Step 5: Create spacing.dart**

```dart
class Spacing {
  Spacing._();

  static const double unit = 8;
  static const double gutter = 24;
  static const double marginMobile = 20;
  static const double marginDesktop = 40;
  static const double dockHeight = 72;
  static const double containerMaxWidth = 1200;
}
```

- [ ] **Step 6: Create app_theme.dart**

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.obsidian,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        tertiary: AppColors.tertiary,
        error: AppColors.error,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
      ),
    );
  }
}
```

- [ ] **Step 7: Create main.dart and app.dart**

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: DisciplineOSApp(),
    ),
  );
}
```

```dart
// lib/app.dart
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'navigation/app_router.dart';

class DisciplineOSApp extends StatelessWidget {
  const DisciplineOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DisciplineOS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
```

- [ ] **Step 8: Create CHANGELOG.md**

```markdown
# Changelog

All notable changes to DisciplineOS will be documented in this file.

## [1.0.0] - 2026-07-03

### Added
- Flutter project initialization
- Design system tokens (colors, typography, spacing)
- Dark theme configuration
```

- [ ] **Step 9: Verify build**

```bash
cd "/Users/apurbaovi/Desktop/Project/Behaviour Coach"
flutter analyze
flutter build apk --debug
```

- [ ] **Step 10: Commit**

```bash
git add pubspec.yaml lib/main.dart lib/app.dart lib/core/ CHANGELOG.md
git commit -m "feat: initialize Flutter project with design system tokens"
```

---

## Task 2: Core Widgets (Glass Card, Aura Ring, Floating Dock)

**Covers:** Reusable components

**Files:**
- Create: `lib/core/widgets/glass_card.dart`
- Create: `lib/core/widgets/aura_ring.dart`
- Create: `lib/core/widgets/floating_dock.dart`
- Create: `lib/core/widgets/ambient_blob.dart`
- Create: `lib/navigation/app_router.dart`

- [ ] **Step 1: Create glass_card.dart**

```dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final bool showGlow;
  final Color glowColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 24,
    this.showGlow = false,
    this.glowColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.glassSurface.withOpacity(0.4),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.outline.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: glowColor.withOpacity(0.15),
                  blurRadius: 40,
                  spreadRadius: -10,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Create aura_ring.dart**

```dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AuraRing extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color color;
  final Color glowColor;
  final Widget? child;

  const AuraRing({
    super.key,
    required this.value,
    this.size = 256,
    this.strokeWidth = 4,
    this.color = AppColors.primary,
    this.glowColor = AppColors.primary,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow effect
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: glowColor.withOpacity(0.3),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
          // Background circle
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              value: value,
              strokeWidth: strokeWidth,
              color: color,
              backgroundColor: AppColors.outline.withOpacity(0.1),
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double value;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;

  _RingPainter({
    required this.value,
    required this.strokeWidth,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final foregroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final sweepAngle = 2 * pi * value;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
```

- [ ] **Step 3: Create floating_dock.dart**

```dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/spacing.dart';

class FloatingDock extends StatelessWidget {
  final int currentIndex;
  final List<DockItem> items;
  final ValueChanged<int> onTap;

  const FloatingDock({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: Spacing.dockHeight,
        margin: const EdgeInsets.symmetric(horizontal: Spacing.marginMobile),
        decoration: BoxDecoration(
          color: AppColors.glassSurface.withOpacity(0.6),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isActive = index == currentIndex;
                return GestureDetector(
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    decoration: isActive
                        ? BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(999),
                          )
                        : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'JetBrains Mono',
                            letterSpacing: 0.1,
                            color: isActive
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class DockItem {
  final IconData icon;
  final String label;

  const DockItem({
    required this.icon,
    required this.label,
  });
}
```

- [ ] **Step 4: Create app_router.dart**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/insights',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithDock(child: child);
      },
      routes: [
        GoRoute(
          path: '/insights',
          builder: (context, state) => const InsightsPlaceholder(),
        ),
        GoRoute(
          path: '/coach',
          builder: (context, state) => const CoachPlaceholder(),
        ),
        GoRoute(
          path: '/reflections',
          builder: (context, state) => const ReflectionsPlaceholder(),
        ),
      ],
    ),
  ],
);

class ScaffoldWithDock extends StatelessWidget {
  final Widget child;
  const ScaffoldWithDock({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: FloatingDock(
        currentIndex: 0,
        items: const [
          DockItem(icon: Icons.query_stats, label: 'Insights'),
          DockItem(icon: Icons.smart_toy, label: 'Coach'),
          DockItem(icon: Icons.auto_stories, label: 'Reflections'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/insights');
            case 1:
              context.go('/coach');
            case 2:
              context.go('/reflections');
          }
        },
      ),
    );
  }
}
```

- [ ] **Step 5: Verify build**

```bash
flutter analyze
```

- [ ] **Step 6: Commit**

```bash
git add lib/core/widgets/ lib/navigation/
git commit -m "feat: add core widgets (GlassCard, AuraRing, FloatingDock)"
```

---

## Task 3: Insights Dashboard Screen

**Covers:** insights_dashboard

**Files:**
- Create: `lib/features/insights_dashboard/presentation/insights_dashboard_screen.dart`
- Create: `lib/features/insights_dashboard/presentation/widgets/discipline_score_aura.dart`
- Create: `lib/features/insights_dashboard/presentation/widgets/ai_insight_card.dart`
- Create: `lib/features/insights_dashboard/presentation/widgets/momentum_chart.dart`
- Create: `lib/features/insights_dashboard/presentation/widgets/weekly_audit_grid.dart`
- Create: `lib/features/insights_dashboard/data/mock_data.dart`
- Modify: `lib/navigation/app_router.dart`

- [ ] **Step 1: Create mock_data.dart**

```dart
class InsightsData {
  static const disciplineScore = 84;
  static const consistencyChange = '+12%';
  static const momentumChange = '+4.2 pts';
  static const weeklyConsistency = 92;
  static const identityLabel = 'High-Performer';
  static const aiInsight = 'Your focus is strongest before 11 AM. Leverage this window for Deep Work to accelerate your momentum for the identity \'Systems Architect\'.';
  
  static const focusTasks = [
    FocusTask(title: 'Design OS Pulse Dashboard', duration: '2 Hours', type: 'Deep Work'),
    FocusTask(title: 'Weekly Strategic Review', duration: '45 Mins', type: 'Reflection'),
  ];
  
  static const momentumData = [0.3, 0.45, 0.6, 0.85, 1.0];
  static const weeklyData = [true, true, true, false, true, true, false]; // true = active
}

class FocusTask {
  final String title;
  final String duration;
  final String type;

  const FocusTask({
    required this.title,
    required this.duration,
    required this.type,
  });
}
```

- [ ] **Step 2: Create discipline_score_aura.dart**

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/aura_ring.dart';

class DisciplineScoreAura extends StatelessWidget {
  final int score;
  final String changeText;

  const DisciplineScoreAura({
    super.key,
    required this.score,
    required this.changeText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuraRing(
          value: score / 100,
          size: 256,
          strokeWidth: 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score',
                style: AppTypography.displayLg.copyWith(
                  fontSize: 64,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                'DAILY SCORE',
                style: AppTypography.labelMono.copyWith(
                  color: AppColors.primary,
                  fontSize: 11,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Your consistency is ${changeText.replaceAll('%', '% ').replaceAll('+', '+ ')}higher than your 7-day average.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 3: Create ai_insight_card.dart**

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';

class AiInsightCard extends StatelessWidget {
  final String text;

  const AiInsightCard({super.key, required this.text});

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
          Text(
            'Optimize Deep Work',
            style: AppTypography.headlineLgMobile.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Create momentum_chart.dart**

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';

class MomentumChart extends StatelessWidget {
  final List<double> data;
  final String change;

  const MomentumChart({
    super.key,
    required this.data,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MOMENTUM',
                style: AppTypography.labelMono.copyWith(
                  fontSize: 10,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Icon(Icons.trending_up, color: AppColors.primary, size: 16),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 64,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((value) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2 + value * 0.8),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            change,
            style: AppTypography.bodyMd.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Create weekly_audit_grid.dart**

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';

class WeeklyAuditGrid extends StatelessWidget {
  final List<bool> activeDays;
  final int consistency;

  const WeeklyAuditGrid({
    super.key,
    required this.activeDays,
    required this.consistency,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'WEEKLY AUDIT',
                style: AppTypography.labelMono.copyWith(
                  fontSize: 10,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Icon(Icons.calendar_view_week, color: AppColors.tertiary, size: 16),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(7, (index) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 8,
                  decoration: BoxDecoration(
                    color: activeDays[index]
                        ? AppColors.tertiary
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            'CONSISTENCY',
            style: AppTypography.labelMono.copyWith(
              fontSize: 11,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Text(
            '$consistency%',
            style: AppTypography.bodyMd.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 6: Create insights_dashboard_screen.dart**

```dart
import 'package:flutter/material.dart';
import '../../../../core/constants/spacing.dart';
import '../data/mock_data.dart';
import 'widgets/discipline_score_aura.dart';
import 'widgets/ai_insight_card.dart';
import 'widgets/momentum_chart.dart';
import 'widgets/weekly_audit_grid.dart';

class InsightsDashboardScreen extends StatelessWidget {
  const InsightsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.marginMobile,
        vertical: Spacing.dockHeight + 40,
      ),
      child: Column(
        children: [
          DisciplineScoreAura(
            score: InsightsData.disciplineScore,
            changeText: InsightsData.consistencyChange,
          ),
          const SizedBox(height: 48),
          AiInsightCard(text: InsightsData.aiInsight),
          const SizedBox(height: 48),
          SizedBox(
            height: 160,
            child: Row(
              children: [
                Expanded(
                  child: MomentumChart(
                    data: InsightsData.momentumData,
                    change: InsightsData.momentumChange,
                  ),
                ),
                const SizedBox(width: Spacing.gutter),
                Expanded(
                  child: WeeklyAuditGrid(
                    activeDays: InsightsData.weeklyData,
                    consistency: InsightsData.weeklyConsistency,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 7: Update router and verify**

```bash
flutter analyze
```

- [ ] **Step 8: Commit**

```bash
git add lib/features/insights_dashboard/
git commit -m "feat: add Insights Dashboard screen with Aura Ring and AI insight"
```

---

## Task 4: Focus Session Screen

**Covers:** focus_session

**Files:**
- Create: `lib/features/focus_session/presentation/focus_session_screen.dart`
- Create: `lib/features/focus_session/presentation/widgets/timer_aura.dart`
- Create: `lib/features/focus_session/presentation/widgets/ambient_sound_selector.dart`
- Create: `lib/features/focus_session/presentation/widgets/daily_log_card.dart`
- Create: `lib/features/focus_session/data/mock_data.dart`

- [ ] **Step 1: Create focus_session_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import 'widgets/timer_aura.dart';
import 'widgets/ambient_sound_selector.dart';
import 'widgets/daily_log_card.dart';

class FocusSessionScreen extends StatelessWidget {
  const FocusSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(Spacing.marginMobile),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.timer, color: AppColors.primary, fill: 1),
                      const SizedBox(width: 8),
                      Text(
                        'Focus Session',
                        style: AppTypography.bodyLg.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.close, color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      'CURRENT PROTOCOL',
                      style: AppTypography.labelMono.copyWith(
                        color: AppColors.primary.withOpacity(0.6),
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Refining Neural Architecture',
                      style: AppTypography.headlineLgMobile.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const TimerAura(
                      minutesRemaining: 42,
                      secondsRemaining: 18,
                    ),
                    const SizedBox(height: 40),
                    // Controls
                    Row(
                      children: [
                        Expanded(
                          child: GlassCard(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.stop_circle, color: AppColors.recoveryRose),
                                const SizedBox(width: 8),
                                Text('Finish', style: AppTypography.bodyMd),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 30,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.pause,
                            color: AppColors.onPrimary,
                            size: 40,
                            fill: 1,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: GlassCard(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.refresh, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text('Reset', style: AppTypography.bodyMd),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // AI Focus Tip
                    GlassCard(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.auto_awesome, color: AppColors.auraViolet, fill: 1),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Coach Insight',
                                  style: AppTypography.bodyMd.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '"Your heart rate has stabilized. You are entering a state of flow. Let the physical world fade; the work is all that exists now."',
                                  style: AppTypography.bodyMd.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const AmbientSoundSelector(),
                    const SizedBox(height: 32),
                    const DailyLogCard(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Create timer_aura.dart**

```dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class TimerAura extends StatelessWidget {
  final int minutesRemaining;
  final int secondsRemaining;

  const TimerAura({
    super.key,
    required this.minutesRemaining,
    required this.secondsRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 288,
      height: 288,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow layer
          Container(
            width: 288,
            height: 288,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.1),
            ),
          ),
          // Ring
          CustomPaint(
            size: const Size(288, 288),
            painter: _TimerPainter(),
          ),
          // Time display
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${minutesRemaining.toString().padLeft(2, '0')}:${secondsRemaining.toString().padLeft(2, '0')}',
                style: AppTypography.displayLg.copyWith(
                  fontSize: 64,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'MINUTES REMAINING',
                style: AppTypography.labelMono.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;

    // Background ring
    final bgPaint = Paint()
      ..color = AppColors.outlineVariant.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress ring (75% for demo)
    final progressPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * 0.75;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```

- [ ] **Step 3: Create ambient_sound_selector.dart**

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';

class AmbientSoundSelector extends StatelessWidget {
  const AmbientSoundSelector({super.key});

  @override
  Widget build(BuildContext context) {
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
                color: AppColors.primary.withOpacity(0.4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _SoundChip(
                icon: Icons.waves,
                label: 'Ocean Deep',
                isActive: true,
              ),
              const SizedBox(width: 12),
              _SoundChip(
                icon: Icons.forest,
                label: 'Black Forest',
              ),
              const SizedBox(width: 12),
              _SoundChip(
                icon: Icons.grain,
                label: 'White Noise',
              ),
              const SizedBox(width: 12),
              _SoundChip(
                icon: Icons.thunderstorm,
                label: 'Midnight Storm',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SoundChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _SoundChip({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppTypography.bodyMd.copyWith(
              fontSize: 14,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Create daily_log_card.dart**

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';

class DailyLogCard extends StatelessWidget {
  const DailyLogCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily_Log.sys',
                style: AppTypography.labelMono.copyWith(
                  color: AppColors.onSurface,
                  letterSpacing: 0.1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.successEmerald.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'SYNCED',
                  style: AppTypography.labelMono.copyWith(
                    fontSize: 10,
                    color: AppColors.successEmererald,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _LogRow(label: 'SESSION_COUNT', value: '04'),
          _LogRow(label: 'ACCUMULATED_DEEP_WORK', value: '05h 12m'),
          _LogRow(label: 'COGNITIVE_LOAD_AVG', value: 'LOW', valueColor: AppColors.tertiary),
          const SizedBox(height: 16),
          Text(
            'RECENT_HIST:',
            style: AppTypography.labelMono.copyWith(
              fontSize: 11,
              color: AppColors.onSurfaceVariant.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 8),
          _LogEntry(time: '08:00 - 09:30', activity: 'ARCHITECTURE_DEV', intensity: 1.0),
          _LogEntry(time: '10:45 - 11:15', activity: 'INBOX_ZERO', intensity: 0.4),
        ],
      ),
    );
  }
}

class _LogRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _LogRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const Border(
        bottom: BorderSide(color: AppColors.outlineVariant, width: 0.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.labelMono.copyWith(
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: AppTypography.labelMono.copyWith(
              fontSize: 13,
              color: valueColor ?? AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LogEntry extends StatelessWidget {
  final String time;
  final String activity;
  final double intensity;

  const _LogEntry({
    required this.time,
    required this.activity,
    required this.intensity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(intensity),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$time | $activity',
            style: AppTypography.labelMono.copyWith(
              fontSize: 11,
              color: AppColors.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Verify and commit**

```bash
flutter analyze
git add lib/features/focus_session/
git commit -m "feat: add Focus Session screen with timer, sounds, and daily log"
```

---

## Task 5: AI Coach Screen

**Covers:** ai_coach

**Files:**
- Create: `lib/features/ai_coach/presentation/ai_coach_screen.dart`
- Create: `lib/features/ai_coach/presentation/widgets/pattern_discovery_card.dart`
- Create: `lib/features/ai_coach/presentation/widgets/micro_challenge_card.dart`
- Create: `lib/features/ai_coach/presentation/widgets/distraction_heatmap.dart`
- Create: `lib/features/ai_coach/presentation/widgets/consistency_flow_chart.dart`
- Create: `lib/features/ai_coach/data/mock_data.dart`

- [ ] **Step 1: Create ai_coach_screen.dart**

```dart
import 'package:flutter/material.dart';
import '../../../../core/constants/spacing.dart';
import 'widgets/pattern_discovery_card.dart';
import 'widgets/micro_challenge_card.dart';
import 'widgets/distraction_heatmap.dart';
import 'widgets/consistency_flow_chart.dart';

class AiCoachScreen extends StatelessWidget {
  const AiCoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.marginMobile,
        vertical: Spacing.dockHeight + 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good Evening, Alex.',
            style: AppTypography.headlineLgMobile.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your performance architecture is stabilizing. I\'ve noticed a recurring friction point in your afternoon cycles.',
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 48),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: const PatternDiscoveryCard(),
              ),
              const SizedBox(width: Spacing.gutter),
              Expanded(
                flex: 1,
                child: const MicroChallengeCard(),
              ),
            ],
          ),
          const SizedBox(height: 48),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: DistractionHeatmap()),
              const SizedBox(width: Spacing.gutter),
              Expanded(
                child: Column(
                  children: [
                    const _DailyPulseCard(),
                    const SizedBox(height: Spacing.gutter),
                    const ConsistencyFlowChart(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: _QuickAction(
                  icon: Icons.forum,
                  label: 'Ask AI Coach',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: Spacing.gutter),
              Expanded(
                child: _QuickAction(
                  icon: Icons.self_improvement,
                  label: 'Quick Reflection',
                  color: AppColors.auraViolet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DailyPulseCard extends StatelessWidget {
  const _DailyPulseCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_note, color: AppColors.auraViolet, size: 20),
              const SizedBox(width: 8),
              Text(
                'DAILY PULSE',
                style: AppTypography.labelMono.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '"A day of quiet persistence. The morning was clear, but the shadows of fatigue grew long by mid-afternoon. Still, the discipline held."',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurface,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppTypography.bodyMd.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Create pattern_discovery_card.dart, micro_challenge_card.dart, distraction_heatmap.dart, consistency_flow_chart.dart**

(Each follows the same GlassCard + theme token pattern as previous tasks)

- [ ] **Step 3: Verify and commit**

```bash
flutter analyze
git add lib/features/ai_coach/
git commit -m "feat: add AI Coach screen with pattern discovery and heatmap"
```

---

## Task 6-10: Remaining Screens

Follow the same pattern for:
- **Task 6:** Behavioral Analytics Center
- **Task 7:** Behavioral Archive Timeline
- **Task 8:** Daily Reflection Sanctuary
- **Task 9:** Profile & Identity Control
- **Task 10:** Ambient Shader Widget

Each task creates:
- Screen file with layout
- Widget files for major components
- Mock data file
- Router updates

---

## Task 11: Navigation Integration

**Covers:** Navigation

**Files:**
- Modify: `lib/navigation/app_router.dart`

- [ ] **Step 1: Update router with all screens**

```dart
// Update app_router.dart to include all 8 screens
// Main dock: Insights, Coach, Reflections
// Sub-screens accessible via routes
```

- [ ] **Step 2: Verify and commit**

```bash
flutter analyze
git add lib/navigation/
git commit -m "feat: integrate all screens with GoRouter navigation"
```

---

## Task 12: Final Verification

**Covers:** Quality assurance

- [ ] **Step 1: Run full analysis**

```bash
flutter analyze
```

- [ ] **Step 2: Build APK**

```bash
flutter build apk --release
```

- [ ] **Step 3: Update CHANGELOG.md**

```markdown
## [1.0.0] - 2026-07-03

### Added
- Insights Dashboard with Discipline Score Aura
- Focus Session with timer and ambient sounds
- AI Coach with pattern discovery
- Behavioral Analytics Center
- Behavioral Archive Timeline
- Daily Reflection Sanctuary
- Profile & Identity Control
- Ambient shader background
- Floating dock navigation
- Glass card components
- Complete design system
```

- [ ] **Step 4: Final commit**

```bash
git add .
git commit -m "feat: complete DisciplineOS v1.0.0 implementation"
```

---

## Summary

| Task | Screen | Complexity |
|------|--------|------------|
| 1 | Project Setup | Low |
| 2 | Core Widgets | Medium |
| 3 | Insights Dashboard | Medium |
| 4 | Focus Session | High |
| 5 | AI Coach | High |
| 6 | Behavioral Analytics | Medium |
| 7 | Behavioral Archive | Medium |
| 8 | Daily Reflection | Medium |
| 9 | Profile & Identity | Medium |
| 10 | Ambient Shader | Low |
| 11 | Navigation | Low |
| 12 | Final Verification | Low |

**Total estimated time:** 8-12 hours for a skilled Flutter developer
