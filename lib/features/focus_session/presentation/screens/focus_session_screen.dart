import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:discipline_os/core/theme/theme_extensions.dart';
import 'package:discipline_os/core/widgets/glass_card.dart';
import 'package:discipline_os/features/auth/presentation/providers/auth_provider.dart';
import 'package:discipline_os/features/focus_session/domain/entities/focus_session_entity.dart'
    as domain;
import 'package:discipline_os/features/focus_session/presentation/providers/focus_session_provider.dart';
import 'package:discipline_os/features/focus_session/presentation/widgets/ambient_sound_selector.dart';
import 'package:discipline_os/features/focus_session/presentation/widgets/timer_aura.dart';
import 'package:go_router/go_router.dart';

/// Focus Session Screen
class FocusSessionScreen extends ConsumerStatefulWidget {
  const FocusSessionScreen({super.key});

  @override
  ConsumerState<FocusSessionScreen> createState() => _FocusSessionScreenState();
}

class _FocusSessionScreenState extends ConsumerState<FocusSessionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadActiveSession();
    });
  }

  void _loadActiveSession() {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId != null) {
      ref.read(focusSessionNotifierProvider.notifier).loadActiveSession(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(focusSessionNotifierProvider);
    final tokens = DisciplineTokens.of(context);
    final isActive = sessionState.state == FocusSessionState.active;
    final isPaused = sessionState.state == FocusSessionState.paused;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, tokens),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Protocol Title
                    _buildProtocolTitle(sessionState),

                    const SizedBox(height: 40),

                    // Timer Aura
                    TimerAura(
                      remainingSeconds: sessionState.remainingSeconds,
                      progress: sessionState.session?.progress ?? 0.0,
                      isActive: isActive,
                    ),

                    const SizedBox(height: 40),

                    // Controls
                    _buildControls(sessionState, isActive, isPaused),

                    const SizedBox(height: 32),

                    // AI Focus Tip
                    _buildAiFocusTip(),

                    const SizedBox(height: 32),

                    // Ambient Sound Selector
                    const AmbientSoundSelector(),

                    const SizedBox(height: 32),

                    // Session Stats
                    _buildSessionStats(sessionState),

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

  Widget _buildHeader(BuildContext context, DisciplineTokens tokens) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.marginMobile,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.glassSurface.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.timer,
                color: AppColors.primary,
                fill: 1,
              ),
              const SizedBox(width: 12),
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
            icon: Icon(
              Icons.close,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolTitle(FocusSessionDataState state) {
    final title = state.session?.title ?? 'Focus Session';
    return Column(
      children: [
        Text(
          'CURRENT PROTOCOL',
          style: AppTypography.labelMono.copyWith(
            color: AppColors.primary.withValues(alpha: 0.6),
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: AppTypography.headlineLgMobile.copyWith(
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildControls(
    FocusSessionDataState state,
    bool isActive,
    bool isPaused,
  ) {
    return Row(
      children: [
        // Finish button
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: GestureDetector(
              onTap: _showEndSessionDialog,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.stop_circle,
                    color: AppColors.recoveryRose,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Finish',
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 24),

        // Play/Pause button
        GestureDetector(
          onTap: () {
            if (isActive) {
              ref.read(focusSessionNotifierProvider.notifier).pauseSession();
            } else if (isPaused) {
              ref.read(focusSessionNotifierProvider.notifier).resumeSession();
            } else {
              _showStartSessionDialog();
            }
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 30,
                ),
              ],
            ),
            child: Icon(
              isActive ? Icons.pause : Icons.play_arrow,
              color: AppColors.onPrimary,
              size: 40,
              fill: 1,
            ),
          ),
        ),

        const SizedBox(width: 24),

        // Reset button
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: GestureDetector(
              onTap: () {
                ref.read(focusSessionNotifierProvider.notifier).reset();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.refresh,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Reset',
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAiFocusTip() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.auto_awesome,
            color: AppColors.auraViolet,
            fill: 1,
          ),
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
    );
  }

  Widget _buildSessionStats(FocusSessionDataState state) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      border: Border.all(
        color: AppColors.outlineVariant.withValues(alpha: 0.5),
        style: BorderStyle.solid,
      ),
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
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'SYNCED',
                  style: AppTypography.labelMono.copyWith(
                    fontSize: 10,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _StatRow(
            label: 'SESSION_STATUS',
            value: state.session?.status.name.toUpperCase() ?? 'IDLE',
          ),
          _StatRow(
            label: 'DURATION',
            value: '${state.session?.durationMinutes ?? 0} MIN',
          ),
          _StatRow(
            label: 'ELAPSED',
            value: '${state.session?.actualMinutes ?? 0} MIN',
          ),
        ],
      ),
    );
  }

  void _showStartSessionDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _StartSessionSheet(
        onStart: (title, duration) {
          final userId = ref.read(currentUserProvider).value?.id;
          if (userId != null) {
            ref.read(focusSessionNotifierProvider.notifier).startSession(
                  userId: userId,
                  params: domain.FocusSessionParams(
                    title: title,
                    durationMinutes: duration,
                    ambientSound: ref.read(selectedAmbientSoundProvider)?.name,
                  ),
                );
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showEndSessionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        title: Text(
          'End Session',
          style: AppTypography.headlineLgMobile.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        content: Text(
          'Are you sure you want to end this focus session?',
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(focusSessionNotifierProvider.notifier).endSession();
              Navigator.pop(context);
            },
            child: Text(
              'End Session',
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.recoveryRose,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant,
            width: 0.1,
          ),
        ),
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
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Start Session Bottom Sheet
class _StartSessionSheet extends StatefulWidget {
  final Function(String title, int duration) onStart;

  const _StartSessionSheet({required this.onStart});

  @override
  State<_StartSessionSheet> createState() => _StartSessionSheetState();
}

class _StartSessionSheetState extends State<_StartSessionSheet> {
  final _titleController = TextEditingController(text: 'Focus Session');
  int _selectedDuration = 25;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Start Focus Session',
            style: AppTypography.headlineLgMobile.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'SESSION TITLE',
            style: AppTypography.labelMono.copyWith(
              fontSize: 11,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.glassSurface.withValues(alpha: 0.4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.outline.withValues(alpha: 0.15),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.outline.withValues(alpha: 0.15),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'DURATION (MINUTES)',
            style: AppTypography.labelMono.copyWith(
              fontSize: 11,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [15, 25, 30, 45, 60].map((duration) {
              final isSelected = _selectedDuration == duration;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDuration = duration),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : AppColors.glassSurface.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.outline.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$duration',
                        style: AppTypography.bodyMd.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onStart(_titleController.text, _selectedDuration);
              },
              child: const Text('Start Session'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
