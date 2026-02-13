# Madini Mobile

Madini Mobile is a Flutter client that mirrors the NGMRIS portal modules for mobile devices. The current implementation focuses on:

- Dashboard-style module switchboard (Dashboard, Data Shop, Geoscientific Survey, Laboratory)
- Data Shop dashboard cards and tables
- Geoscientific Survey mapping activity listing and create‑activity flow

All UI is built directly in Flutter and reuses design tokens from the web portal
(theme colors and typography).

## Application structure

The main package entry point is:

- `lib/main.dart` – boots the Flutter app and runs `MadiniApp`.

High‑level structure under `lib/`:

- `core/`
  - `app.dart` – wraps the app with `ThemeProvider` and exposes `MaterialApp.router`.
  - `config/`
    - `app_config.dart` – immutable `AppConfig` with environment (`dev`, `staging`, `prod`), API base URL and auth base URL. The default config (`kDefaultAppConfig`) is set to a development environment.
    - `module_config.dart` – static list of module definitions (id, title, description, route, icon) used by the home switchboard.
    - `router_config.dart` – central `GoRouter` configuration (splash screen, home switchboard, dashboard, data shop, geoscientific survey listing, and create‑mapping routes).
  - `network/`
    - `api_client.dart` – centralized `Dio` HTTP client configured with `AppConfig` (`apiBaseUrl`, timeouts, JSON headers) and an `ApiInterceptor`.
    - `api_interceptor.dart` – interceptor that attaches a bearer token from `StorageService` to outgoing requests and provides hooks for global response/error handling.
  - `theme/`
    - `app_theme.dart` – light and dark `ThemeData` definitions, using Plus Jakarta Sans via `google_fonts` and a color scheme that matches the NGMRIS web palette.

- `features/`
  - `home/presentation/`
    - `pages/switchboard_page.dart` – landing dashboard showing one large card per module (Dashboard, Data Shop, Geoscientific Survey, Laboratory).
    - `widgets/module_card.dart` – reusable card widget with centered icon, title, and description, wired to navigate via `go_router`.
  - `dashboard/presentation/`
    - `pages/dashboard_page.dart` – example analytics dashboard using tabs and statistic cards.
    - `widgets/stat_card.dart` – small metric card component used by the dashboard.
  - `datashop/presentation/`
    - `pages/datashop_page.dart` – implements the Data Shop dashboard: metric cards (Total Sales, Active Materials, Total Orders, New Customers) plus “Recent Orders” and “Popular Materials” tables.
  - `geoscientific_survey/presentation/`
    - `pages/geoscientific_mapping_list_page.dart` – “Mapping Activity” listing: breadcrumb, heading + description, search field, mapping table (Activity Name, Type, Survey Type, Location) with chips for “Internal”/“Consultancy”, and a footer with paging controls.
    - `pages/geoscientific_mapping_create_page.dart` – modal‑style “Create New Mapping Activity” form with fields for activity name, type, survey type, location, lead scientist, and created date, plus Create/Cancel actions.

- `shared/widgets/`
  - `app_scaffold.dart` – common scaffold with an NGMRIS‑style portal header (title, theme toggle, avatar) and optional plain header mode.
  - `app_card.dart` – base card component (rounded corners and subtle border) used for metric cards, tables, and search fields.
  - `app_button.dart` – button wrapper with variants (primary, secondary, outline, destructive, ghost, link) and optional full‑width behavior.
  - `app_input.dart` – text form field wrapper with label, hint, prefix/suffix icons, and basic validation hooks.

- `services/`
  - `storage_service.dart` – singleton wrapper around `FlutterSecureStorage` for persisting access and refresh tokens (read, write, clear).

- `state/`
  - `theme_provider.dart` – `ChangeNotifier` that manages the current `ThemeMode` and exposes helpers for accessing the light/dark themes.

## Architecture overview

- **Feature‑first layout** – Screens and widgets are grouped by feature
  (`home`, `dashboard`, `datashop`, `geoscientific_survey`) under
  `features/<feature>/presentation/`.
- **Core shared modules** – Cross‑cutting concerns (routing, theme, network
  client, global configuration) live under `core/`.
- **Shared UI components** – Reusable visual primitives (`AppScaffold`,
  `AppCard`, `AppButton`, `AppInput`) live under `shared/widgets/` and are
  used across features to keep the look‑and‑feel consistent.
- **Networking & storage** – All HTTP traffic goes through `ApiClient`
  (`Dio`) with `ApiInterceptor` attaching bearer tokens fetched from
  `StorageService` (`FlutterSecureStorage`).
- **Navigation** – `GoRouter` is the single source of truth for routes. The
  route names and paths mirror the modules defined in `module_config.dart`.
- **Theming** – `MadiniApp` wraps the router with a `ThemeProvider`. The
  `AppScaffold` header exposes a theme toggle that flips between light and
  dark themes at runtime.

## Technologies used

- **Flutter** – UI framework for building the mobile app.
- **Dart packages**
  - `provider` – used for app‑wide theme state in `ThemeProvider`.
  - `go_router` – declarative routing (`appRouter` in `core/config/router_config.dart`).
  - `dio` – HTTP client used in `ApiClient` with `ApiInterceptor`.
  - `flutter_secure_storage` – secure token storage used by `StorageService`.
  - `google_fonts` – Plus Jakarta Sans text theme in `AppTheme`.
  - `cupertino_icons` – standard iOS icon set (available for use in UI).
  - `shared_preferences` – declared as a dependency and available for simple key‑value storage if needed.

## Running the app

This is a standard Flutter project. To run it:

```bash
flutter pub get
flutter run
```