# Changelog

All notable changes to DisciplineOS will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-07-03

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

### Architecture

- Clean Architecture (domain/data/presentation)
- Repository Pattern with abstract interfaces
- Riverpod for dependency injection
- GoRouter for navigation
- Freezed for immutable models (configured)
- Hive for local storage (configured)
- Supabase for backend
- Gemini API for AI (configured)
