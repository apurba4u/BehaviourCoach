import 'dart:ui';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

/// DisciplineOS Floating Dock Component
/// Bottom navigation bar with glassmorphism effect
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
    final tokens = DisciplineTokens.of(context);

    return Center(
      child: Container(
        height: tokens.dockHeight,
        margin: EdgeInsets.symmetric(horizontal: tokens.marginMobile),
        decoration: BoxDecoration(
          color: AppColors.glassSurface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(tokens.borderRadiusFull),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(tokens.borderRadiusFull),
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
                    padding: EdgeInsets.symmetric(
                      horizontal: tokens.gutter,
                      vertical: tokens.spacingUnit,
                    ),
                    decoration: isActive
                        ? BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(tokens.borderRadiusFull),
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
                        SizedBox(height: tokens.spacingUnit * 0.5),
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
