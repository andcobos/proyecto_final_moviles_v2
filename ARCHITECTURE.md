# Clean Architecture Documentation

## Project Structure

This Flutter application follows Clean Architecture principles, organizing code into distinct layers with clear separation of concerns.

```
lib/
├── core/                    # Core utilities and configuration
│   ├── constants.dart       # API and app-wide constants
│   ├── router/              # Navigation configuration
│   │   └── app_router.dart  # GoRouter setup
│   └── theme/               # App theming
│       ├── app_theme.dart
│       └── theme_changer.dart
│
├── data/                    # Data layer
│   ├── models/              # Data models with JSON serialization
│   │   ├── contractor.dart
│   │   ├── job.dart
│   │   ├── review.dart
│   │   ├── service.dart
│   │   └── user.dart
│   ├── repositories/        # Repository implementations (future)
│   └── services/            # API and data services
│       ├── api_service.dart
│       ├── auth_service.dart
│       ├── contractor_service.dart
│       ├── job_service.dart
│       ├── review_service.dart
│       ├── service_services.dart
│       └── storage_service.dart
│
├── domain/                  # Business logic layer (future use)
│   ├── entities/            # Business entities
│   ├── repositories/        # Repository interfaces
│   └── usecases/            # Business use cases
│
└── presentation/            # Presentation layer
    ├── providers/           # State management (Riverpod)
    │   ├── auth_provider.dart
    │   └── theme_provider.dart
    └── screens/             # UI screens
        ├── client/          # Client-side screens
        ├── provider/        # Service provider screens
        └── landing_login/   # Authentication screens
```

## Layer Responsibilities

### Core Layer
- **Purpose**: Shared utilities, constants, and configuration
- **Contains**: App constants, routing, theming
- **Dependencies**: None (independent layer)

### Data Layer
- **Purpose**: Data handling and external communication
- **Contains**:
  - Models with JSON serialization
  - API service implementations
  - Local storage services
- **Dependencies**: Core layer only

### Domain Layer
- **Purpose**: Business logic and rules (currently minimal)
- **Contains**:
  - Business entities
  - Repository contracts
  - Use cases
- **Dependencies**: None (will be implemented as needed)

### Presentation Layer
- **Purpose**: UI and user interaction
- **Contains**:
  - Screens and widgets
  - State management providers
  - UI-specific logic
- **Dependencies**: Core, Data, and Domain layers

## Key Features

### Authentication Flow
- JWT-based authentication
- Token storage using SharedPreferences
- AuthProvider manages authentication state globally

### API Integration
- Base API service with interceptor-like functionality
- Automatic token injection for authenticated requests
- Centralized error handling

### State Management
- Riverpod for dependency injection and state management
- Providers for authentication, theme, and data fetching

### Navigation
- GoRouter for declarative routing
- Separate routes for client and provider flows

## Design Patterns

1. **Repository Pattern**: Services abstract data source details
2. **Provider Pattern**: Riverpod providers for state management
3. **Singleton Pattern**: Services instantiated once
4. **Factory Pattern**: Model fromJson/toJson methods

## API Endpoints

Configured in `lib/core/constants.dart`:

- **Auth**: `/auth/login`, `/auth/register`
- **Users**: `/users/me`
- **Contractors**: `/workers`, `/workers/:id`
- **Jobs**: `/jobs`, `/jobs/:id/accept`, `/jobs/:id/complete`, `/jobs/:id/cancel`
- **Reviews**: `/reviews`

## Development Guidelines

### Adding a New Feature

1. **Create models** in `data/models/` with JSON serialization
2. **Create service** in `data/services/` for API calls
3. **Create provider** in `presentation/providers/` for state management
4. **Create screens** in appropriate `presentation/screens/` subfolder
5. **Add routes** in `core/router/app_router.dart`

### Import Conventions

- Use relative imports within the same layer
- Use absolute imports from `lib/` for cross-layer dependencies
- Example from presentation layer:
  ```dart
  import '../../../data/models/job.dart';
  import '../../providers/auth_provider.dart';
  import '../../../data/services/job_service.dart';
  ```

### Null Safety

All models implement null-safe JSON parsing:
```dart
factory Model.fromJson(Map<String, dynamic> json) {
  return Model(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
  );
}
```

## Technology Stack

- **Flutter**: UI framework
- **Riverpod**: State management
- **GoRouter**: Navigation
- **http**: API communication
- **SharedPreferences**: Local storage

## Future Improvements

1. Implement Repository pattern in domain layer
2. Add use cases for complex business logic
3. Implement comprehensive error handling
4. Add unit and integration tests
5. Implement offline-first architecture with local database
