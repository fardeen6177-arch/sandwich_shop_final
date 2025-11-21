
# Sandwich Shop (sandwich_shop_final)

Simple Flutter app demonstrating a sandwich-ordering UI (Mr Tree Sandwiches).

This repository contains a small Flutter application used for learning and
testing Flutter widgets, state management and basic repository separation.

**Quick start**

- Ensure Flutter is installed: https://docs.flutter.dev/get-started/install
- From the project root, get packages:

```bash
flutter pub get
```

- Run the app on a device or emulator:

```bash
flutter run
```

**Run tests**

```bash
flutter test
```

**What’s inside**

- `lib/` — application source
	- `main.dart` — app entry and UI
	- `repositories/` — `OrderRepository`, `PricingRepository`
- `test/` — widget and unit tests

**Notes**

- Tests currently exercise switches and basic UI interactions. Keys were
	added to a couple of widgets to make them testable (`size_switch`,
	`toasted_switch`, `notes_textfield`).
- Repositories were moved to `lib/repositories` for better separation.

If you want, I can push these changes to the remote branch or open a PR.

---

Maintainer: Fardeen
