# DisciplineOS Production-Grade Implementation Roadmap

> **Principal Flutter Architecture Review**
> Reviewed: 2026-07-03

---

## Part 1: Architectural Weakness Analysis

### Critical Issues Found

| # | Issue | Severity | Impact |
|---|-------|----------|--------|
| 1 | **No Clean Architecture layers** — Flat feature folders without data/domain/presentation separation | Critical | Untestable, unscalable |
| 2 | **No state management strategy** — Riverpod mentioned but no providers defined | Critical | State chaos, rebuilds |
| 3 | **No backend integration** — Supabase not in architecture | Critical | No persistence, no auth |
| 4 | **No AI architecture** — Gemini API not planned | Critical | Core feature missing |
| 5 | **No offline-first strategy** — No local storage | High | Poor UX on slow networks |
| 6 | **No repository pattern** — Data access coupled to UI | High | Untestable data layer |
| 7 | **No dependency injection** — Tight coupling | High | Hard to test, swap impls |
| 8 | **No error handling strategy** — No error boundaries | High | App crashes |
| 9 | **No logging/observability** — No debugging tools | Medium | Hard to debug |
| 10 | **No security layer** — No encryption, biometrics | Medium | Data vulnerability |

### Scalability Concerns

- **Screen widgets are monolithic** — 300+ line widgets that mix layout with business logic
- **No lazy loading** — All screens load full content
- **No pagination** — Timeline and archive screens will choke on large datasets
- **No asset management** — Fonts, icons, sounds loaded ad-hoc

### Maintainability Risks

- **Hardcoded colors in widget code** — Should use theme extensions
- **No naming conventions documented** — File/class naming inconsistent
- **No code generation** — Freezed/JsonSerializable not planned for models
- **No feature flags** — Cannot safely roll out features

---

## Part 2: Improved Architecture

### Folder Structure (Feature-First + Clean Architecture)

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── asset_paths.dart
│   ├── errors/
│   │   ├── app_exception.dart
│   │   └── exception_handler.dart
│   ├── extensions/
│   │   ├── context_extensions.dart
│   │   ├── date_extensions.dart
│   │   └── string_extensions.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   └── interceptors/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_theme.dart
│   │   └── theme_extensions.dart
│   ├── utils/
│   │   ├── logger.dart
│   │   └── validators.dart
│   └── widgets/
│       ├── glass_card.dart
│       ├── aura_ring.dart
│       ├── floating_dock.dart
│       ├── ambient_blob.dart
│       ├── error_boundary.dart
│       └── loading_skeleton.dart
│
├── features/
│   └── [feature_name]/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── [feature]_remote_datasource.dart
│       │   │   └── [feature]_local_datasource.dart
│       │   ├── models/
│       │   │   └── [feature]_model.dart  # Freezed
│       │   └── repositories/
│       │       └── [feature]_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── [feature]_entity.dart
│       │   ├── repositories/
│       │   │   └── [feature]_repository.dart  # Abstract
│       │   └── usecases/
│       │       └── [feature]_usecase.dart
│       ├── presentation/
│       │   ├── providers/
│       │   │   └── [feature]_provider.dart  # Riverpod
│       │   ├── screens/
│       │   │   └── [feature]_screen.dart
│       │   └── widgets/
│       │       └── [widget_name].dart
│       └── [feature]_module.dart  # DI registration
│
├── config/
│   ├── env_config.dart
│   └── route_config.dart
│
└── injection.dart  # GetIt/Riverpod setup
```

### Dependency Graph

```
presentation → domain → data
     ↓            ↓        ↓
  providers    usecases  datasources
     ↓            ↓        ↓
  Riverpod    Repository  Supabase/Hive
```

---

## Part 3: Technology Stack (Production-Grade)

### Core Dependencies

```yaml
dependencies:
  # State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  
  # Navigation
  go_router: ^14.2.0
  
  # Backend
  supabase_flutter: ^2.3.0
  
  # Local Storage
  hive_flutter: ^1.1.0
  hive: ^2.2.3
  
  # AI Integration
  google_generative_ai: ^0.4.0
  
  # Environment
  flutter_dotenv: ^5.1.0
  
  # Charts
  fl_chart: ^0.68.0
  
  # Code Generation
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  riverpod_generator: ^2.3.9
  
  # Animations
  lottie: ^3.0.0
  
  # Security
  flutter_secure_storage: ^9.0.0
  local_auth: ^2.1.8
  
  # Logging
  logger: ^2.0.2+1
  
  # UI
  google_fonts: ^6.1.0
  shimmer: ^3.0.0
  
dev_dependencies:
  # Code Generation
  build_runner: ^2.4.7
  freezed: ^2.4.7
  json_serializable: ^6.7.1
  riverpod_generator: ^2.3.9
  
  # Testing
  mockito: ^5.4.4
  build_verify: ^3.1.0
  riverpod_lint: ^2.3.10
  
  # Linting
  flutter_lints: ^3.0.1
  very_good_analysis: ^5.1.0
```

---

## Part 4: Implementation Roadmap

### Phase 1: Foundation (Days 1-2)

#### Task 1.1: Project Initialization
**Files:**
- `pubspec.yaml`
- `.env.development`
- `.env.production`
- `analysis_options.yaml`

**Steps:**
1. Create Flutter project
2. Configure `flutter_dotenv` with `.env` files
3. Set up `analysis_options.yaml` with `very_good_analysis`
4. Configure build.yaml for code generation

#### Task 1.2: Theme System
**Files:**
- `lib/core/theme/app_colors.dart`
- `lib/core/theme/app_typography.dart`
- `lib/core/theme/app_theme.dart`
- `lib/core/theme/theme_extensions.dart`

**Requirements:**
- All colors as ThemeExtension for proper Material 3
- Typography scale with context-dependent sizes
- Theme data that works with Riverpod

#### Task 1.3: Core Widgets
**Files:**
- `lib/core/widgets/glass_card.dart`
- `lib/core/widgets/aura_ring.dart`
- `lib/core/widgets/floating_dock.dart`
- `lib/core/widgets/ambient_blob.dart`
- `lib/core/widgets/error_boundary.dart`
- `lib/core/widgets/loading_skeleton.dart`

**Requirements:**
- All widgets accept theme from context
- Animation controllers properly disposed
- Custom painters with RepaintBoundary

---

### Phase 2: Data Layer (Days 3-4)

#### Task 2.1: Supabase Setup
**Files:**
- `lib/core/network/api_client.dart`
- `lib/config/supabase_config.dart`
- `supabase/migrations/`

**Database Schema:**
```sql
-- Users
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  identity_level TEXT DEFAULT 'novice',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Behavioral Logs
CREATE TABLE behavioral_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  log_type TEXT NOT NULL, -- 'focus', 'reflection', 'distraction'
  score INT,
  duration_minutes INT,
  metadata JSONB,
  recorded_at TIMESTAMPTZ DEFAULT NOW()
);

-- Habits
CREATE TABLE habits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  name TEXT NOT NULL,
  frequency TEXT, -- 'daily', 'weekly'
  target_count INT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- AI Insights
CREATE TABLE ai_insights (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  insight_type TEXT NOT NULL,
  content TEXT NOT NULL,
  confidence_score FLOAT,
  generated_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### Task 2.2: Repository Pattern
**Files:**
- `lib/features/[feature]/domain/repositories/[feature]_repository.dart`
- `lib/features/[feature]/data/repositories/[feature]_repository_impl.dart`

**Pattern:**
```dart
abstract class FocusSessionRepository {
  Future<Either<Failure, FocusSession>> startSession(FocusSessionParams params);
  Future<Either<Failure, FocusSession>> endSession(String sessionId);
  Future<Either<Failure, List<FocusSession>>> getSessions({int limit, int offset});
}

class FocusSessionRepositoryImpl implements FocusSessionRepository {
  final FocusSessionRemoteDataSource remote;
  final FocusSessionLocalDataSource local;
  
  @override
  Future<Either<Failure, FocusSession>> startSession(FocusSessionParams params) async {
    try {
      final session = await remote.startSession(params);
      await local.cacheSession(session);
      return Right(session);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

#### Task 2.3: Hive Local Cache
**Files:**
- `lib/core/local/hive_service.dart`
- `lib/features/[feature]/data/datasources/[feature]_local_datasource.dart`

**Requirements:**
- Cache-first strategy with TTL
- Sync queue for offline mutations
- Encryption for sensitive data

#### Task 2.4: Freezed Models
**Files:**
- `lib/features/[feature]/data/models/[feature]_model.dart`

**Pattern:**
```dart
@freezed
class FocusSession with _$FocusSession {
  const factory FocusSession({
    required String id,
    required String userId,
    required DateTime startedAt,
    DateTime? endedAt,
    required int durationMinutes,
    @Default(0) int score,
    FocusSessionStatus status = FocusSessionStatus.active,
  }) = _FocusSession;

  factory FocusSession.fromJson(Map<String, dynamic> json) =>
      _$FocusSessionFromJson(json);
}
```

---

### Phase 3: AI Integration (Days 5-6)

#### Task 3.1: Gemini Service
**Files:**
- `lib/core/ai/gemini_service.dart`
- `lib/core/ai/prompts/`

**Architecture:**
```dart
class GeminiService {
  final GenerativeModel _model;
  
  Future<AIInsight> generateInsight(BehavioralData data) async {
    final prompt = _buildInsightPrompt(data);
    final response = await _model.generateContent(prompt);
    return AIInsight.fromResponse(response);
  }
  
  Future<List<Pattern>> detectPatterns(List<BehavioralLog> logs) async {
    final prompt = _buildPatternPrompt(logs);
    final response = await _model.generateContent(prompt);
    return PatternList.fromResponse(response);
  }
}
```

#### Task 3.2: Prompt Engineering
**Files:**
- `lib/core/ai/prompts/insight_prompt.dart`
- `lib/core/ai/prompts/pattern_prompt.dart`
- `lib/core/ai/prompts/coach_prompt.dart`

**Persona:**
```
You are DisciplineOS, an AI-powered behavioral operating system.
Your role: Understand human behavior before trying to improve it.

Tone: Stoic, empathetic, analytical
Avoid: Generic productivity advice, toxic positivity

When analyzing:
1. Look for behavioral patterns (time-based, emotion-based)
2. Identify triggers and correlations
3. Provide specific, actionable insights
4. Never assume — base insights on data
```

#### Task 3.3: AI Provider (Riverpod)
**Files:**
- `lib/core/ai/providers/ai_provider.dart`

```dart
@riverpod
GeminiService geminiService(GeminiServiceRef ref) {
  final apiKey = ref.watch(envProvider).geminiApiKey;
  return GeminiService(apiKey: apiKey);
}

@riverpod
Stream<AIInsight> dailyInsight(DailyInsightRef ref) {
  final aiService = ref.watch(geminiServiceProvider);
  final userData = ref.watch(userDataProvider);
  return aiService.streamDailyInsight(userData);
}
```

---

### Phase 4: Feature Implementation (Days 7-14)

Each feature follows:

```
1. Define entities (domain)
2. Create repository interface (domain)
3. Implement data sources (data)
4. Implement repository (data)
5. Create use cases (domain)
6. Set up providers (presentation)
7. Build UI (presentation)
8. Write tests
```

#### Feature Priority Order

| Priority | Feature | Est. Days | Dependencies |
|----------|---------|-----------|--------------|
| P0 | Insights Dashboard | 2 | Theme, Supabase |
| P1 | Focus Session | 2 | Hive, Timer |
| P1 | AI Coach | 2 | Gemini, Supabase |
| P2 | Behavioral Analytics | 1.5 | fl_chart |
| P2 | Daily Reflection | 1.5 | Hive |
| P2 | Behavioral Archive | 1 | Supabase |
| P3 | Profile & Identity | 1 | Supabase, Auth |
| P3 | Ambient Shader | 0.5 | CustomPainter |

---

### Phase 5: Testing (Days 15-16)

#### Unit Tests
```dart
// test/features/focus_session/domain/usecases/start_session_test.dart
void main() {
  late StartSessionUseCase useCase;
  late MockFocusSessionRepository mockRepo;

  setUp(() {
    mockRepo = MockFocusSessionRepository();
    useCase = StartSessionUseCase(mockRepo);
  });

  test('should return FocusSession on success', () async {
    // Arrange
    when(mockRepo.startSession(any))
        .thenAnswer((_) async => Right(testSession));

    // Act
    final result = await useCase(params);

    // Assert
    expect(result, Right(testSession));
    verify(mockRepo.startSession(params)).called(1);
  });
}
```

#### Widget Tests
```dart
// test/features/insights_dashboard/presentation/widgets/aura_ring_test.dart
void main() {
  testWidgets('renders score correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AuraRing(value: 0.84),
      ),
    );

    expect(find.text('84'), findsOneWidget);
  });
}
```

#### Golden Tests
```dart
// test/goldens/glass_card_golden.dart
void main() {
  testWidgets('glass card renders correctly', (tester) async {
    await tester.pumpWidget(
      TestApp(
        child: GlassCard(
          child: Text('Test'),
        ),
      ),
    );

    await expectLater(
      find.byType(GlassCard),
      matchesGoldenFile('goldens/glass_card.png'),
    );
  });
}
```

---

### Phase 6: Security & Production (Days 17-18)

#### Security Measures
```dart
// lib/core/security/encryption_service.dart
class EncryptionService {
  final FlutterSecureStorage _storage;
  
  Future<void> storeSensitive(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
  
  Future<String?> readSensitive(String key) async {
    return await _storage.read(key: key);
  }
}
```

#### Biometric Auth
```dart
// lib/core/security/biometric_service.dart
class BiometricService {
  final LocalAuthentication _auth;
  
  Future<bool> authenticate() async {
    return await _auth.authenticate(
      localizedReason: 'Authenticate to access DisciplineOS',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );
  }
}
```

---

### Phase 7: CI/CD & Polish (Days 19-20)

#### GitHub Actions
```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk --release
```

#### Code Generation
```bash
# Generate all code
dart run build_runner build --delete-conflicting-outputs

# Watch mode during development
dart run build_runner watch
```

---

## Part 5: Revised Task Structure

### Task 1: Project Foundation
**Deliverables:**
- [ ] Flutter project with all dependencies
- [ ] `.env` files configured
- [ ] `analysis_options.yaml` with strict rules
- [ ] Theme system (colors, typography, extensions)
- [ ] Core widgets (glass card, aura ring, dock, error boundary)
- [ ] Logger configured
- [ ] Git initialized with conventional commits

**Tests:** None (scaffolding)

---

### Task 2: Data Layer
**Deliverables:**
- [ ] Supabase client configured
- [ ] Database migrations created
- [ ] Freezed models generated
- [ ] Repository interfaces defined
- [ ] Remote data sources implemented
- [ ] Local data sources with Hive
- [ ] Sync queue for offline

**Tests:** Unit tests for repositories, data sources

---

### Task 3: AI Integration
**Deliverables:**
- [ ] Gemini service configured
- [ ] Prompt templates created
- [ ] AI providers set up
- [ ] Insight generation working
- [ ] Pattern detection working

**Tests:** Unit tests for AI service

---

### Task 4-N: Feature Screens
**Each feature deliverables:**
- [ ] Domain entities
- [ ] Use cases
- [ ] Riverpod providers
- [ ] Screen widgets
- [ ] Sub-widgets
- [ ] Unit tests
- [ ] Widget tests
- [ ] Golden tests (optional)

---

## Part 6: Environment Configuration

```env
# .env.development
SUPABASE_URL=https://xyz.supabase.co
SUPABASE_ANON_KEY=eyJxxx...
GEMINI_API_KEY=AIza...
APP_ENV=development

# .env.production
SUPABASE_URL=https://xyz.supabase.co
SUPABASE_ANON_KEY=eyJxxx...
GEMINI_API_KEY=AIza...
APP_ENV=production
```

---

## Part 7: Git Workflow

```bash
# Branch strategy
main          # Production
├── develop   # Integration
│   ├── feature/insights-dashboard
│   ├── feature/focus-session
│   └── feature/ai-coach
├── bugfix/*
└── hotfix/*

# Commit convention
feat: add focus session timer
fix: resolve aura ring animation glitch
refactor: extract glass card component
test: add unit tests for repository
docs: update README with setup guide
chore: update dependencies
```

---

## Part 8: Code Quality Gates

```yaml
# analysis_options.yaml
include: package:very_good_analysis/analysis_options.yaml

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_declarations: true
    avoid_print: true
    require_trailing_commas: true
    prefer_single_quotes: true
```

**CI Gates:**
- `flutter analyze` — 0 issues
- `flutter test` — 100% pass
- `dart run build_runner build` — no conflicts
- `flutter build apk` — successful

---

## Summary

| Phase | Duration | Focus |
|-------|----------|-------|
| 1 | Days 1-2 | Foundation, Theme, Core Widgets |
| 2 | Days 3-4 | Supabase, Hive, Repositories, Models |
| 3 | Days 5-6 | Gemini AI Integration |
| 4 | Days 7-14 | Feature Implementation |
| 5 | Days 15-16 | Testing |
| 6 | Days 17-18 | Security, Production |
| 7 | Days 19-20 | CI/CD, Polish |

**Total:** 20 days for production-grade implementation

**Key Improvements:**
1. ✅ Clean Architecture with domain/data/presentation
2. ✅ Repository Pattern with abstract interfaces
3. ✅ Riverpod with code generation
4. ✅ Supabase backend with proper schema
5. ✅ Gemini AI integration
6. ✅ Hive offline-first with sync
7. ✅ Freezed models for immutability
8. ✅ Proper error handling with Either
9. ✅ Security layer with encryption
10. ✅ CI/CD pipeline
