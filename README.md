# Madini Mobile

Madini Mobile is a Flutter client that mirrors the NGMRIS portal modules for mobile devices.

The current implementation focuses on:

- **Secure Authentication** – Integration with Keycloak using JWT decoding and secure token storage.
- **Role-Based Access Control (RBAC)** – Permission guards that restrict dashboard access based on user roles (Admin, Miner, Officer, etc.).
- **Module Switchboard** – Dashboard-style navigation for Dashboard, Data Shop, Geoscientific Survey, and Laboratory.
- **Data Shop** – Interactive dashboard cards and tables for sales and inventory.
- **Geoscientific Survey** – Mapping activity listing and structured create-activity flow.
- **Design Consistency** – Reuses design tokens (colors/typography) from the NGMRIS web portal for a unified experience.

---

## Application structure

The main package entry points are:

- `lib/main.dart` – boots the Flutter app.
- `lib/providers.dart` – centralized dependency injection and provider setup.

### High-level structure under `lib/`

#### `core/`

- `app.dart` – root widget that manages global state (Theme, Routing) and exposes `MaterialApp.router`.
- `config/`
  - `app_config.dart` – environment configurations and API base URLs.
  - `router_config.dart` – stable `GoRouter` configuration with unified navigation and splash handling.
- `network/`
  - `api_client.dart` – `Dio` HTTP client with automated token attachment via `ApiInterceptor`.
- `theme/`
  - `app_theme.dart` – coordinated Light and Dark themes matching the NGMRIS web palette.

---

#### `features/`

- `auth/` – Authentication sub-system following Clean Architecture:
  - `data/` – Remote data sources and repository implementations for Keycloak.
  - `domain/` – Core `User` entity and repository interfaces.
  - `presentation/` – `AuthProvider` for login/logout state management and authentication UI pages.
- `home/presentation/` – landing dashboard (Switchboard) for module navigation.
- `datashop/presentation/` – Data Shop metrics and inventory tables.
- `geoscientific_survey/presentation/` – Listing and creation flows for mapping activities.

---

#### `shared/widgets/`

- `permission_guard.dart` – Security widget for restricting UI access based on user roles.
- `app_scaffold.dart` – Standard layout with portal header, theme toggle, and user avatar.
- `app_button.dart`, `app_card.dart`, `app_input.dart` – Reusable design system components.

---

#### `services/`

- `storage_service.dart` – Secure persistence for JWT tokens using `FlutterSecureStorage`.

---

#### `state/`

- `theme_provider.dart` – Runtime theme mode management (Light/Dark).

---

## Architecture overview

- **Clean Architecture Principles** – Features (such as authentication) are decoupled into Data, Domain, and Presentation layers to ensure separation of concerns and testability.
- **State Management** – Uses the `provider` package for reactive UI updates and dependency injection.
- **Stabilized Navigation** – `GoRouter` is configured as a persistent provider to prevent splash-screen hangs and navigation resets during app rebuilds.
- **JWT & Role Management** – The app decodes JWT claims locally from Keycloak tokens to determine user identity and permissions without redundant API calls.
- **Functional Error Handling** – Uses the `dartz` package (`Either`) to handle successes and failures explicitly in the repository layer.
- **Storage Security** – Sensitive tokens are stored in the device's secure enclave via `FlutterSecureStorage`.

---

## Technologies used

- **Flutter** – UI framework.

### Dart packages

- `provider` – state management and dependency injection.
- `go_router` – declarative routing and deep linking.
- `dio` – networking with interceptors for authentication.
- `dartz` – functional programming types (`Either`) for clean error handling.
- `flutter_secure_storage` – encrypted local storage.
- `google_fonts` – Plus Jakarta Sans integration.
- `cupertino_icons` – UI iconography.

---

## Running the app

Ensure you have an emulator or physical device connected:

```bash
flutter pub get
flutter run
