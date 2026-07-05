import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:discipline_os/core/theme/app_colors.dart';
import 'package:discipline_os/core/theme/app_typography.dart';
import 'package:discipline_os/core/theme/theme_extensions.dart';
import 'package:discipline_os/features/ai_coach/presentation/providers/ai_coach_provider.dart';
import 'package:discipline_os/features/ai_coach/presentation/widgets/pattern_discovery_card.dart';
import 'package:discipline_os/features/ai_coach/presentation/widgets/micro_challenge_card.dart';
import 'package:discipline_os/features/ai_coach/presentation/widgets/distraction_heatmap.dart';
import 'package:discipline_os/features/ai_coach/presentation/widgets/daily_pulse_card.dart';
import 'package:discipline_os/features/ai_coach/presentation/widgets/consistency_flow_chart.dart';
import 'package:discipline_os/features/ai_coach/presentation/widgets/quick_action_button.dart';
import 'package:discipline_os/features/auth/presentation/providers/auth_provider.dart';

class AiCoachScreen extends ConsumerStatefulWidget {
  const AiCoachScreen({super.key});

  @override
  ConsumerState<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends ConsumerState<AiCoachScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initConversation();
    });
  }

  void _initConversation() {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId != null &&
        ref.read(aiCoachNotifierProvider).conversation == null) {
      ref.read(aiCoachNotifierProvider.notifier).startNewConversation(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = DisciplineTokens.of(context);
    final coachState = ref.watch(aiCoachNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: SafeArea(
        child: coachState.state == AiCoachState.loading
            ? const Center(child: CircularProgressIndicator())
            : coachState.state == AiCoachState.error
                ? _buildErrorState(coachState.error ?? 'Failed to load AI coach')
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopBar(tokens),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: tokens.marginMobile),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 32),
                              _buildHeaderSection(coachState),
                              const SizedBox(height: 48),
                              _buildPatternAndChallengeRow(tokens, coachState),
                              const SizedBox(height: 48),
                              _buildAnalyticsRow(tokens),
                              const SizedBox(height: 32),
                              _buildQuickActions(),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildTopBar(DisciplineTokens tokens) {
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
                    color: AppColors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/avatar.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceContainer,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'DisciplineOS',
                style: AppTypography.headlineLgMobile.copyWith(
                  color: AppColors.onSurface,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(AiCoachDataState coachState) {
    final lastMessage = coachState.conversation?.lastMessage;
    final greeting = _getTimeGreeting();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, Alex.',
          style: AppTypography.headlineLgMobile.copyWith(
            color: AppColors.onSurface,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          lastMessage?.content ??
              "Your performance architecture is stabilizing. I'm analyzing your behavioral patterns to generate personalized insights.",
          style: AppTypography.bodyLg.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildPatternAndChallengeRow(
      DisciplineTokens tokens, AiCoachDataState coachState) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: PatternDiscoveryCard(
                  title: 'The Afternoon Resistance',
                  description:
                      "I've observed a 42% drop in cognitive focus between 2:30 PM and 4:00 PM. This correlates strongly with your high-glucose lunch selections yesterday and today. Your sleep latency also increases on these days, suggesting a metabolic rebound effect that disrupts your deep work architecture.",
                  tags: const [
                    PatternTag(
                      icon: Icons.restaurant,
                      color: AppColors.primary,
                      label: 'Sugar Intake High',
                    ),
                    PatternTag(
                      icon: Icons.bedtime,
                      color: AppColors.recoveryRose,
                      label: 'Sleep Quality: -14%',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 4,
                child: MicroChallengeCard(
                  title: 'Analog Initiation',
                  description:
                      'Start tomorrow with 15 minutes of offline reading. No screens until 8:15 AM.',
                  onCommit: () {},
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            PatternDiscoveryCard(
              title: 'The Afternoon Resistance',
              description:
                  "I've observed a 42% drop in cognitive focus between 2:30 PM and 4:00 PM. This correlates strongly with your high-glucose lunch selections yesterday and today. Your sleep latency also increases on these days, suggesting a metabolic rebound effect that disrupts your deep work architecture.",
              tags: const [
                PatternTag(
                  icon: Icons.restaurant,
                  color: AppColors.primary,
                  label: 'Sugar Intake High',
                ),
                PatternTag(
                  icon: Icons.bedtime,
                  color: AppColors.recoveryRose,
                  label: 'Sleep Quality: -14%',
                ),
              ],
            ),
            const SizedBox(height: 24),
            MicroChallengeCard(
              title: 'Analog Initiation',
              description:
                  'Start tomorrow with 15 minutes of offline reading. No screens until 8:15 AM.',
              onCommit: () {},
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnalyticsRow(DisciplineTokens tokens) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                child: DistractionHeatmap(
                  data: [
                    [0.1, 0.2, 0.4, 0.1, 0.6, 0.8, 0.2],
                    [0.05, 0.1, 0.3, 0.9, 0.2, 0.1, 0.05],
                    [0.1, 0.1, 0.4, 0.1, 0.1, 0.1, 0.1],
                    [0.2, 0.05, 0.1, 0.2, 0.1, 0.05, 0.1],
                  ],
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: DailyPulseCard(
                  quote:
                      'A day of quiet persistence. The morning was clear, but the shadows of fatigue grew long by mid-afternoon. Still, the discipline held.',
                  flowLevel: 3,
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: ConsistencyFlowChart(
                  values: [0.4, 0.6, 0.5, 0.8, 0.95, 0.65, 1.0],
                ),
              ),
            ],
          );
        }

        return Column(
          children: const [
            DistractionHeatmap(
              data: [
                [0.1, 0.2, 0.4, 0.1, 0.6, 0.8, 0.2],
                [0.05, 0.1, 0.3, 0.9, 0.2, 0.1, 0.05],
                [0.1, 0.1, 0.4, 0.1, 0.1, 0.1, 0.1],
                [0.2, 0.05, 0.1, 0.2, 0.1, 0.05, 0.1],
              ],
            ),
            SizedBox(height: 24),
            DailyPulseCard(
              quote:
                  'A day of quiet persistence. The morning was clear, but the shadows of fatigue grew long by mid-afternoon. Still, the discipline held.',
              flowLevel: 3,
            ),
            SizedBox(height: 24),
            ConsistencyFlowChart(
              values: [0.4, 0.6, 0.5, 0.8, 0.95, 0.65, 1.0],
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Row(
          children: [
            QuickActionButton(
              icon: Icons.forum,
              label: 'Ask AI Coach',
              color: AppColors.primary,
              onPressed: _showChatSheet,
            ),
            const SizedBox(width: 16),
            QuickActionButton(
              icon: Icons.self_improvement,
              label: 'Quick Reflection',
              color: AppColors.auraViolet,
              onPressed: _showQuickReflectionSheet,
            ),
          ],
        ),
      ),
    );
  }

  void _showChatSheet() {
    final coachState = ref.read(aiCoachNotifierProvider);
    final messages = coachState.conversation?.messages ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ChatSheet(
        messages: messages,
        onSend: (content) {
          final userId = ref.read(currentUserProvider).value?.id;
          if (userId != null) {
            ref.read(aiCoachNotifierProvider.notifier).sendUserMessage(
                  content: content,
                  userId: userId,
                );
          }
        },
      ),
    );
  }

  void _showQuickReflectionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _QuickReflectionSheet(
        onSubmit: (content) {
          final userId = ref.read(currentUserProvider).value?.id;
          if (userId != null) {
            ref.read(aiCoachNotifierProvider.notifier).sendUserMessage(
                  content: 'Quick reflection: $content',
                  userId: userId,
                );
          }
        },
      ),
    );
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
              'AI Coach Error',
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
              onPressed: _initConversation,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatSheet extends StatefulWidget {
  final List messages;
  final Function(String) onSend;

  const _ChatSheet({required this.messages, required this.onSend});

  @override
  State<_ChatSheet> createState() => _ChatSheetState();
}

class _ChatSheetState extends State<_ChatSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'AI Coach',
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.messages.length,
              itemBuilder: (context, index) {
                final msg = widget.messages[index];
                final isUser = msg.role.name == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : AppColors.glassSurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.content,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Ask your coach...',
                      hintStyle: AppTypography.bodyMd
                          .copyWith(color: AppColors.onSurfaceVariant),
                      filled: true,
                      fillColor:
                          AppColors.glassSurface.withValues(alpha: 0.4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      widget.onSend(_controller.text.trim());
                      _controller.clear();
                    }
                  },
                  icon: const Icon(Icons.send, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickReflectionSheet extends StatefulWidget {
  final Function(String) onSubmit;

  const _QuickReflectionSheet({required this.onSubmit});

  @override
  State<_QuickReflectionSheet> createState() => _QuickReflectionSheetState();
}

class _QuickReflectionSheetState extends State<_QuickReflectionSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
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
            'Quick Reflection',
            style: AppTypography.headlineLgMobile.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 4,
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
            decoration: InputDecoration(
              hintText: 'How are you feeling right now?',
              hintStyle: AppTypography.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant),
              filled: true,
              fillColor: AppColors.glassSurface.withValues(alpha: 0.4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  widget.onSubmit(_controller.text.trim());
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
