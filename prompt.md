# Worksheet 6 — Persistence & Navigation (Prompt)

Goal
----
Add lightweight persistence and simple navigation to the Sandwich Shop app so a user's cart survives app restarts, and the app provides pages for Cart, Checkout, Profile, and About accessible from a navigation drawer.

Context
-------
This repository already contains models for `Sandwich` and a `Cart`. Worksheet 6 extends the app by:
- introducing a `FileService` to save/load cart JSON to the app documents directory,
- adding an `OrderViewModel` that wraps cart operations and persistence,
- wiring views to use the view-model and to navigate between screens,
- adding `Cart`, `Checkout`, `Profile`, and `About` screens and a navigation drawer,
- ensuring deterministic widget tests by allowing injection of a test `FileService`.

Deliverables
------------
- `FileService` usage in code to persist `cart.json`.
- `OrderViewModel` that exposes add/save/load methods.
- UI screens: `Cart`, `Checkout`, `Profile`, `About`, and `AppDrawer` navigation.
- `prompt.md` and `requirements.md` (this file and the companion requirements file).
- Widget tests updated to use a `FakeFileService` for deterministic behavior.

How to validate manually
------------------------
1. Run the app and add items to the cart.
2. Close and restart the app; verify the cart contents persist.
3. Open the drawer and navigate to `Profile` and `About` pages.
4. Run `flutter test` and confirm tests pass (cart tests should inject a fake file service).

Notes for reviewers
------------------
- Files to review include `lib/services/file_service.dart`, `lib/view_models/order_view_model.dart`, and the new/updated `lib/views/*` screens.
- Tests are in `test/views/` and should not rely on platform file IO.
