# Changelog

All notable changes to DisciplineOS will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-07-03

### Code Quality

- Resolved all analyzer issues (0 errors, 0 warnings, 0 infos)
- Updated Supabase SDK to use `publishableKey` instead of deprecated `anonKey`
- Removed redundant default values
- Added missing trailing commas
- Added curly braces to control flow statements
- Applied dart format to all files
- Updated analysis_options.yaml with clean lint rules

### Added

- Flutter project initialization with Clean Architecture
- Theme system with Silent Intelligence design tokens
- Color palette (Discipline Blue, Aura Violet, Recovery Rose, Success Emerald)
- Typography system (Hanken Grotesk, Inter, JetBrains Mono)
- Glass Card component with backdrop blur
- Aura Ring circular progress indicator
- Floating Dock bottom navigation
- Loading Skeleton component
- Error Boundary component
- Logger utility
- Custom exceptions and failure types
- Environment configuration with flutter_dotenv
- GoRouter navigation setup
- Riverpod state management setup
- Feature-first folder structure

### Authentication

- Supabase initialization and configuration
- Email/Password authentication
- Google OAuth authentication
- Sign In screen with form validation
- Sign Up screen with form validation
- Auth repository with abstract interface
- Auth use cases (SignIn, SignUp, SignOut, GetCurrentUser, ResetPassword)
- Auth providers with Riverpod
- Route guards for protected routes
- Auth state management

### Database Layer

- Complete Supabase database schema (10 tables)
- User profiles with identity levels
- Behavioral logs with metadata support
- Daily reflections with mood tracking
- AI insights with confidence scores
- Goals with progress tracking
- Focus sessions with ambient sounds
- Behavior timeline with event types
- Notifications with scheduling
- App settings with JSON values
- User achievements with unlock dates

### Security

- Row Level Security (RLS) on all tables
- User isolation policies
- Storage buckets (avatars, voice recordings, exports)
- Foreign key relationships
- Database indexes for performance
- UpdatedAt triggers
- User profile auto-creation trigger

### Data Layer

- Entities for all database tables
- Repository interfaces (abstract)
- Remote data sources for all tables
- Supabase query builders

### AI Infrastructure

- Gemini AI Service with retry logic
- AI Orchestrator for prompt management
- Prompt Manager with template loading
- Response Parser for JSON extraction
- AI Repository with full implementation
- AI Use Cases (Daily Insight, Weekly Summary, Behavior Analysis, Reflection Analysis, Goal Analysis, Focus Analysis, Recommendations)
- Riverpod Providers for AI services
- Prompt templates in markdown format (7 templates)
- Error handling with retry strategy
- Timeout handling
- Rate limit handling
- API key validation

### Offline Infrastructure

- Hive initialization with all adapters
- Local cache layer for all entities
- Cache Manager with typed access
- Sync Manager for offline-to-online sync
- Pending operation queue with retry mechanism
- Connectivity monitoring with auto-sync
- Conflict resolution strategy

### Dashboard Feature

- Dashboard screen with real data from Supabase
- Discipline Score Aura visualization
- AI Daily Insight card
- Momentum tracking
- Weekly consistency audit
- Today's goals section
- Active focus session display
- Recent reflection summary
- Empty states for missing data
- Pull-to-refresh functionality
- Dashboard repository with local cache fallback
- Dashboard use cases (Get, Refresh)
- Dashboard Riverpod providers

### Focus Session Feature

- Focus Session screen with timer visualization
- Start, Pause, Resume, End session controls
- Session Timer with countdown
- Ambient Sound Selection UI
- Session completion with score calculation
- Auto-save to Supabase
- Offline support with Hive cache
- Sync to Supabase when online
- Live session state management
- Behavioral log creation on session end
- Dashboard integration for active sessions
- Focus Session repository with local/remote data sources
- Focus Session use cases (Start, Pause, Resume, End, GetActive)
- Focus Session Riverpod providers

### Architecture

- Clean Architecture (domain/data/presentation)
- Repository Pattern with abstract interfaces
- Riverpod for dependency injection
- GoRouter for navigation
- Freezed for immutable models (configured)
- Hive for local storage
- Supabase for backend
- Gemini API for AI
