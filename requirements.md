# Worksheet 6 — Requirements

Functional Requirements
-----------------------
1. Persist Cart
   - The app must save the current cart to a file named `cart.json` in the application's documents directory whenever the cart changes or user triggers save.
   - On startup or when the cart screen is opened, the app should load `cart.json` (if present) and restore the cart state.

2. Order ViewModel
   - Provide an `OrderViewModel` that exposes: `addToCart(Sandwich)`, `removeFromCart(itemId)`, `totalItems`, `totalPrice`, `saveCart()`, and `loadCart()`.
   - `OrderViewModel` should use an injectable `FileService` so tests can provide a `FakeFileService`.

3. Navigation & Screens
   - Provide a navigation drawer with links to `Order` (main), `Cart`, `Checkout`, `Profile`, and `About` screens.
   - `Cart` screen displays items, totals, and a `Checkout` button that opens the `Checkout` screen.
   - `Checkout` screen allows the user to submit the order and returns to `Order` screen with the cart cleared.

Non-Functional Requirements
---------------------------
- Tests must be deterministic: widget tests should not use actual file system IO. Use dependency injection to provide a fake file service during tests.
- The persistence format must be JSON and backward-compatible for simple Cart schema changes (use keys, not positional arrays).
- Code style should follow existing project conventions and pass `flutter analyze` with no errors (warnings/info permitted).

Acceptance Criteria
-------------------
- When items are added to cart, closing and reopening the app restores the same items and quantities.
- Widget tests that exercise cart load/save run on CI without relying on platform-specific storage.
- A reviewer can inspect `prompt.md` and `requirements.md` and clearly understand the feature and how it is validated.

Test Cases
----------
1. Manual: Add two items, restart app, verify two items present.
2. Unit: `Cart.toJson()` and `Cart.fromJson()` roundtrip test.
3. Widget: `CartScreen` with `FakeFileService` loads predetermined `cart.json` contents and displays totals.
4. End-to-end (manual): Add items, checkout, verify cart is cleared and persisted as empty.
