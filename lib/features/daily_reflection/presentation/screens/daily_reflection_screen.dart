import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:discipline_os/core/theme/theme_extensions.dart';
import 'package:discipline_os/core/widgets/glass_card.dart';
import 'package:discipline_os/features/auth/presentation/providers/auth_provider.dart';
import 'package:discipline_os/features/daily_reflection/domain/entities/daily_reflection_entity.dart';
import 'package:discipline_os/features/daily_reflection/presentation/providers/daily_reflection_provider.dart';
import 'package:discipline_os/features/daily_reflection/presentation/widgets/mood_selector.dart';
import 'package:discipline_os/features/daily_reflection/presentation/widgets/energy_slider.dart';
import 'package:discipline_os/features/daily_reflection/presentation/widgets/reflection_text_area.dart';
import 'package:discipline_os/features/daily_reflection/presentation/widgets/ai_synthesis_card.dart';
import 'package:discipline_os/features/daily_reflection/presentation/widgets/reflection_history_card.dart';

/// Daily Reflection Screen
/// Sanctuary for morning and evening reflections
class DailyReflectionScreen extends ConsumerStatefulWidget {
  const DailyReflectionScreen({super.key});

  @override
  ConsumerState<DailyReflectionScreen> createState() =>
      _DailyReflectionScreenState();
}

class _DailyReflectionScreenState extends ConsumerState<DailyReflectionScreen> {
  MoodType? _selectedMood;
  double _energyLevel = 0.65;
  final _reflectionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReflections();
    });
  }

  void _loadReflections() {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId != null) {
      ref
          .read(dailyReflectionListProvider.notifier)
          .loadReflections(userId);
    }
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = DisciplineTokens.of(context);
    final reflectionState = ref.watch(dailyReflectionListProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, tokens),
            Expanded(
              child: reflectionState.state == DailyReflectionListState.loading
                  ? const Center(child: CircularProgressIndicator())
                  : reflectionState.state == DailyReflectionListState.error
                      ? _buildErrorState(reflectionState.error ?? 'Failed to load reflections')
                      : SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                              horizontal: tokens.marginMobile),
                          child: Column(
                            children: [
                              const SizedBox(height: 32),
                              _buildPhaseHeader(),
                              const SizedBox(height: 40),
                              _buildReflectionCard(),
                              const SizedBox(height: 24),
                              _buildMorningIntentionCard(),
                              const SizedBox(height: 24),
                              const AiSynthesisCard(),
                              const SizedBox(height: 32),
                              _buildHistorySection(reflectionState.reflections),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Text(
            'Reflections',
            style: AppTypography.headlineLgMobile.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseHeader() {
    return Column(
      children: [
        Text(
          'EVENING CYCLE',
          style: AppTypography.labelMono.copyWith(
            color: AppColors.auraViolet,
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Good Evening, Alex.',
          style: AppTypography.headlineLg.copyWith(
            color: AppColors.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'How was your inner rhythm today?',
          style: AppTypography.headlineLg.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildReflectionCard() {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      showGlow: true,
      glowColor: AppColors.auraViolet,
      borderRadius: 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evening Reflection',
                    style: AppTypography.headlineLgMobile.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '20:45 PM  •  Session Active',
                    style: AppTypography.labelMono.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.auraViolet.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.nightlight,
                  color: AppColors.auraViolet,
                  fill: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          MoodSelector(
            selectedMood: _selectedMood,
            onMoodChanged: (mood) => setState(() => _selectedMood = mood),
          ),
          const SizedBox(height: 32),
          EnergySlider(
            value: _energyLevel,
            onChanged: (value) => setState(() => _energyLevel = value),
          ),
          const SizedBox(height: 32),
          ReflectionTextArea(controller: _reflectionController),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.only(top: 24),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.outline,
                  width: 0.15,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mic,
                          color: AppColors.auraViolet,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Voice Reflection',
                        style: AppTypography.labelMono.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final userId =
                        ref.read(currentUserProvider).value?.id;
                    if (userId == null) return;
                    final content = _reflectionController.text.trim();
                    if (content.isEmpty && _selectedMood == null) return;

                    final now = DateTime.now();
                    final isMorning = now.hour < 12;
                    final reflectionType = isMorning
                        ? ReflectionType.morning
                        : ReflectionType.evening;

                    ref
                        .read(dailyReflectionListProvider.notifier)
                        .saveReflection(
                          userId: userId,
                          reflectionType: reflectionType,
                          mood: _selectedMood?.name,
                          energyLevel: (_energyLevel * 100).round(),
                          content: content,
                        )
                        .then((_) {
                      _reflectionController.clear();
                      setState(() {
                        _selectedMood = null;
                        _energyLevel = 0.65;
                      });
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.onSurface,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      'SAVE',
                      style: AppTypography.labelMono.copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMorningIntentionCard() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      opacity: 0.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.warningAmber.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.light_mode,
                  color: AppColors.warningAmber,
                  fill: 1,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Morning Intention',
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '07:15 AM  •  Completed',
                    style: AppTypography.labelMono.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(
            Icons.check_circle,
            color: AppColors.successEmerald,
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(List<DailyReflectionEntity> reflections) {
    if (reflections.isEmpty) {
      return Column(
        children: [
          Text(
            'PAST SHADOWS',
            style: AppTypography.labelMono.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.15,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No reflections yet. Your history will appear here.',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    final recentReflections = reflections.take(5).toList();

    return Column(
      children: [
        Text(
          'PAST SHADOWS',
          style: AppTypography.labelMono.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 24),
        Stack(
          children: [
            Positioned(
              left: 23,
              top: 0,
              bottom: 0,
              child: Container(
                width: 1,
                color: AppColors.white.withValues(alpha: 0.1),
              ),
            ),
            Column(
              children: recentReflections.map((r) {
                final isEvening = r.reflectionType == ReflectionType.evening;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ReflectionHistoryCard(
                    dateLabel: _formatMonthDay(r.recordedAt),
                    content: r.content ?? 'No content',
                    moodIcon: isEvening
                        ? Icons.bedtime
                        : Icons.light_mode,
                    moodColor: isEvening
                        ? AppColors.warningAmber
                        : AppColors.auraViolet,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  String _formatMonthDay(DateTime date) {
    final months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load reflections',
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadReflections,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
