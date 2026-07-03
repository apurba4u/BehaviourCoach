# DisciplineOS

**AI-Powered Behavioral Operating System**

> Understand human behavior before trying to improve it.

## Overview

DisciplineOS is not a habit tracker, todo app, or productivity app. It is an AI-powered behavioral intelligence platform that combines behavioral analytics, personalized coaching, habit tracking, focus sessions, goal management, and reflective journaling to help users understand their behavior, build discipline, reduce distractions, and achieve long-term goals.

## Tech Stack

- **Framework:** Flutter (latest stable)
- **State Management:** Riverpod
- **Navigation:** GoRouter
- **Backend:** Supabase
- **AI:** Gemini API
- **Local Storage:** Hive
- **Charts:** fl_chart
- **Code Generation:** Freezed

## Architecture

```
lib/
├── core/           # Shared utilities, theme, widgets
├── features/       # Feature-first modules
│   └── [feature]/
│       ├── data/       # Datasources, models, repositories
│       ├── domain/     # Entities, repositories, usecases
│       └── presentation/ # Providers, screens, widgets
├── config/         # Environment, routes
└── injection.dart  # Dependency injection
```

## Getting Started

### Prerequisites

- Flutter SDK 3.x
- Dart SDK 3.x
- Supabase account
- Google AI Studio account (for Gemini)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-repo/discipline-os.git
cd discipline-os
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure environment:
```bash
cp .env.example .env
# Edit .env with your API keys
```

4. Run the app:
```bash
flutter run
```

## Design System

The UI follows the "Silent Intelligence" design philosophy:

- **Dark Mode First:** Obsidian backgrounds (#09090B)
- **Glassmorphism:** Frosted glass cards with backdrop blur
- **Aura Rings:** Circular progress with glow effects
- **Typography:** Hanken Grotesk (headlines), Inter (body), JetBrains Mono (data)

## Features

- **Insights Dashboard:** Discipline score, AI insights, momentum tracking
- **Focus Sessions:** Timer with ambient sounds, AI coaching tips
- **AI Coach:** Pattern detection, behavioral insights, micro-challenges
- **Behavioral Analytics:** Charts, heatmaps, consistency tracking
- **Daily Reflection:** Mood tracking, journaling, AI synthesis
- **Profile & Identity:** Achievements, settings, guardrails

## Testing

```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget/

# Golden tests
flutter test test/goldens/
```

## Code Generation

```bash
# Run build_runner
dart run build_runner build --delete-conflicting-outputs

# Watch mode
dart run build_runner watch
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Run tests and analyze
4. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) for details.
