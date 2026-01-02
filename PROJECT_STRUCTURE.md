# Grow-First-Mobile-App — Project Structure (shareable)

Root: `grow_first/`

- `analysis_options.yaml`
- `grow_first.iml`
- `pubspec.yaml`
- `README.md`
- `android/`
  - `build.gradle.kts`
  - `gradle.properties`
  - `gradlew`
  - `gradlew.bat`
  - `local.properties`
  - `settings.gradle.kts`
  - `app/`
    - `build.gradle.kts`
    - `src/`
- `assets/`
  - `animations/`
  - `configs/`
  - `fonts/`
    - `inter/`
    - `montserrat/`
    - `poppins/`
  - `icons/`
  - `images/`
- `build/` (build outputs and intermediates)
  - `<platform-specific and plugin generated folders>`
- `ios/`
  - `Podfile`
  - `Flutter/`
  - `Runner/`
  - `Runner.xcodeproj/`
  - `Runner.xcworkspace/`
  - `RunnerTests/`
- `lib/`
  - `main.dart`  <-- current open file
  - `app/`
    - `di/`
      - `app_injections.dart`  <-- existing DI setup using `get_it`
    - `bloc/`  <-- application BLoC files
    - `router/`
      - `app_router.dart`
    - `...` (feature folders)
  - `core/`
    - `config/`
      - `app_config.dart`  <-- config loader and `AppConfig`
    - `network/`
      - `dio_client.dart`
    - `sessions/`
      - `session_manager.dart`
    - `storage/`
      - `secure_storage.dart`
  - `features/` (feature modules)
- `linux/`
- `macos/`
- `test/`
  - `widget_test.dart`
- `web/`
  - `index.html`
  - `manifest.json`
  - `icons/`
- `windows/`

Notes:
- The DI is implemented with `get_it` in `lib/app/di/app_injections.dart` and exposes `sl = GetIt.instance`.
- `lib/core/config/app_config.dart` reads `assets/configs/config.json` with environment keys.
- `lib/main.dart` is currently a default Flutter app scaffold — it should be updated to load `AppConfig` and call `configureDependencies(config)` before `runApp()`.

How to share with ChatGPT:
- Copy the contents of this file and paste into the chat for context.
- Or attach the file as a snippet if your chat interface supports file uploads.

Suggested next steps (I can do these):
- Update `lib/main.dart` to load `AppConfig` and call `configureDependencies()` (I can implement this).
- Optionally create a small `App` widget and wire `AppBloc` / `GoRouter` integration.

Generated on 22 Nov 2025
