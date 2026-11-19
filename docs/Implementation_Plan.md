# Implementation Plan: SaudaList

Version 2.0 | Honest status. A box is checked only when the feature has been built **and verified on a device against real Supabase data**.

## 1. Current status

| Area | Status |
|---|---|
| Flutter project, Android toolchain, Provider, `supabase_flutter`, `pdf`, `printing` | Done |
| UI screens (auth, home, categories, products, lists, list details, PDF preview, profile, admin dashboard, user management, analytics) | Built, **running on in-memory demo data** |
| Neumorphic theme, logo, catalog look | Built |
| `PdfService` and PDF preview screen | Built, needs verification with real list data |
| Services (`category`, `product`, `shopping_list`) | Partly written, **not used by the UI** |
| Supabase initialization and real login | **Not done** |
| Database SQL and RLS | **Not run yet** |
| Cloudinary image upload | **Not done** |
| Tests | Only the default widget test |

## 2. Roadmap

### Phase 0: Environment and backend setup
- [x] Flutter, Dart, Android SDK, and licenses working (`flutter doctor`)
- [ ] Android emulator or physical phone shows in `flutter devices`
- [ ] Commit the current work to Git (check for secrets first)
- [ ] Remove accidental dependencies if present (`flutter_riverpod`, `go_router`)
- [ ] Create the Supabase project (Free plan)
- [ ] Run `supabase/migrations/001_schema.sql` from `Backend_Schema.md`
- [ ] Create the Cloudinary account and an unsigned upload preset
- [ ] Add `.gitignore` entries for env files and signing keys
- [ ] Add the GitHub Actions keep-alive workflow and its two repository secrets

### Phase 1: Authentication and catalog
- [ ] `main.dart`: initialize Supabase (via `--dart-define`) before `runApp`, then `await AppState.bootstrap()`
- [ ] Create `auth_service.dart`: sign up (with `full_name`), sign in, sign out, reset password (email sent; in-app new-password screen pending (step 1a-2))
- [ ] Load the user's role from `user_roles` and `is_active` from `profiles`. Remove the demo users, plain-text passwords, `loginAsAdminDemo`, and the "email contains admin" rule
- [ ] Update login, signup, and forgot-password screens to await results and show errors
- [ ] Load categories and products from Supabase. Remove hardcoded demo catalog and the silent demo fallback in `ProductService`
- [ ] Session persists across restarts. Inactive user is signed out
- [ ] Loading, empty, and error states on catalog screens, search with debounce
- [ ] Verify: sign up, sign in, restart, catalog appears

### Phase 2: Shopping lists
- [ ] Complete `ShoppingListService`: create, rename, delete, duplicate, add item (increase quantity if the product exists), update item (quantity, unit, checked), remove item
- [ ] Remove `catch (_) { return []; }` patterns. Services throw, `AppState` shows messages
- [ ] Add `unit` to `ShoppingListItem.copyWith`
- [ ] Custom item (no product id)
- [ ] My Lists and List Details read and write Supabase, with Retry on failure
- [ ] Verify: lists survive app restart and sign out and sign in

### Phase 3: Print and share
- [ ] PDF built from the latest saved list: title, date, numbered table, quantity, unit, purchased mark, page numbers, wrapped long names
- [ ] Preview, back to edit, share PDF, print
- [ ] Share as plain text (`share_plus`)
- [ ] Empty-list message
- [ ] Optional: embedded font for Urdu names
- [ ] Verify on a physical Android phone: empty list, one item, 100+ items, long names

### Phase 4: Admin
- [ ] Admin screens read real data. Guard routes and also rely on RLS
- [ ] Manage categories: add, edit, order, activate or deactivate
- [ ] Manage products: add, edit, deactivate, default unit
- [ ] Cloudinary upload in the product form, URL saved in `image_path`, failure handled
- [ ] User management from `profiles` (name, email, role, status), activate or deactivate through `admin_set_user_active`
- [ ] Dashboard counts through `admin_stats`
- [ ] Persist the activity log in `activity_log` (or remove that section)
- [ ] Remove demo admin data
- [ ] Verify: admin adds a product with an image and a customer sees it

### Phase 5: Security tests
- [ ] Run the checks in `Backend_Schema.md` section 7 with two customers and one admin
- [ ] Confirm no `service_role` key or Cloudinary API secret anywhere (`grep -rn service_role lib/`)
- [ ] Confirm secrets are not in Git history

### Phase 6: Quality and polish
- [ ] `flutter analyze` and `dart format` clean
- [ ] Unit tests (models, validators, text-share formatter) and widget tests (login, product states, list details)
- [ ] Contrast check of the neumorphic theme (see UI brief)
- [ ] Reusable widgets in `shared/widgets` (loading, empty, error, buttons)
- [ ] Split `AppState` into auth, catalog, and lists notifiers if it has become too large
- [ ] Update the README and docs to match the final behavior

### Phase 7: Release (Rs 0)
- [ ] Add the `INTERNET` permission to the release manifest
- [ ] Create a signing key and keep it outside Git
- [ ] `flutter build apk --release`
- [ ] Test the release APK on a physical phone from a fresh install
- [ ] Upload the APK to GitHub Releases
- [ ] Add a short privacy note
- [ ] Enable "Confirm email" in Supabase Auth if wanted for production

### Phase 8 (later, optional)
- Prices and estimated total, starter lists by admin, frequently used items, notes per item, public share link, offline cache, iOS build (needs a Mac).

## 3. Definition of done for a phase

1. The code compiles and `flutter analyze` is clean.
2. The feature works on a physical Android device or emulator with real Supabase data.
3. Error and empty states were tested (turn off the network and try).
4. The change is committed with a clear message.
5. The checkbox above is updated.

## 4. Working rules

- One phase at a time. Do not build everything in one change.
- Inspect existing code before changing it. Do not overwrite working screens without understanding them.
- Never commit secrets. Never add a service-role key to the app.
- Do not claim a feature works until it was run.
- Keep the stack: Flutter, Provider, Supabase, Cloudinary. No Firebase, Riverpod, or paid services.
