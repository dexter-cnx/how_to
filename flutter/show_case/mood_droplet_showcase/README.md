# Mood Droplet Showcase

Production-ready Flutter showcase for a procedural **rain-on-glass** experience.

## What is included

- Reusable rain engine with presets
- Layered droplet painter
- Showcase screen with interaction
- Live control panel for tuning atmosphere
- Clean folder structure for pushing to a repo

## Demo features

- Tap or drag anywhere to spawn a splash cluster
- Switch between presets: Calm, Storm, Night, Frost
- Tune intensity, blur, glow, and message live
- Freeze or resume motion
- Reset scene instantly

## Structure

```text
lib/
  main.dart
  src/
    app/
    engine/
    models/
    painters/
    presentation/
    theme/
```

## Run

```bash
flutter pub get
flutter run
```

## Suggested next steps

1. Add platform-specific packaging for iOS, Android, macOS, and Web.
2. Extract `RainGlassScene` into a separate package if you want reuse across apps.
3. Add golden tests for painter output and performance benchmarks for target devices.
