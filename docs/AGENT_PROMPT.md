# Prompt for the Android Studio Agent

Paste everything inside the code block below into the agent.

```
You are helping me finish SaudaList, a grocery shopping list app.
Project path: /home/moetesum/AndroidStudioProjects/saudalist

READ FIRST (in this order), then inspect the code before changing anything:
docs/PRD.md, docs/TRD.md, docs/AppFlow.md, docs/Backend_Schema.md,
docs/UI_UX_Design_Brief.md, docs/Implementation_Plan.md, README.md.
Then read pubspec.yaml and everything under lib/ and test/.

PRODUCT
- Admin manages the catalog (categories, products, default units, images, users).
- A user only builds their own lists from the catalog (custom items allowed),
  then previews, prints, and shares them (PDF and plain text).
- Not an online grocery store. No payment, delivery, or prices in the MVP.

STACK (fixed, do not change)
- Flutter and Dart, Material 3 with the existing neumorphic theme, Provider for state.
- Supabase Free: PostgreSQL, Auth, RLS. SQL is in docs/Backend_Schema.md.
- Cloudinary Free for images (unsigned upload preset). Store the secure_url in image_path.
- pdf, printing, share_plus, image_picker, http, cached_network_image if needed.
- Everything must cost Rs 0.
- Do NOT add Firebase, Riverpod, go_router, Edge Functions, or any paid service.
  Keep the existing navigation (AppRoutes) unless there is a clear bug.

CURRENT STATE
- The UI screens exist but run on in-memory demo data inside lib/state/app_state.dart.
- Supabase.initialize is never called. The services (category, product, shopping_list)
  exist but the UI does not use them. Login is local with plain-text demo passwords.
- Signup currently makes anyone whose email contains "admin" an admin. Remove this.
- Services swallow errors with catch (_) { return []; }. Replace this with real errors.
- ProductService falls back to demo products on error. Remove that fallback.

HARD RULES
1. Inspect first. Never overwrite working code without understanding it.
   Do not change the Android applicationId or package name.
2. Work in the phases of docs/Implementation_Plan.md, one phase at a time.
   Before each phase, list the files you will create or change and wait for my approval.
3. Give complete working files for everything you change (no "..." placeholders).
4. Keep UI, services, models, and state separate. Widgets never run raw queries.
5. Secrets: only the Supabase URL and anon key, read with String.fromEnvironment
   (--dart-define), never committed. NEVER use or ask for a service_role key or the
   Cloudinary API secret. Never print or commit secrets. Add env files to .gitignore.
6. Admin rights come only from the user_roles table. There must be no client-side rule
   that grants admin. Every admin action must also be protected by database policies.
7. Errors are never silent. Services throw, AppState catches and exposes a readable
   message, and the UI shows it with a retry option. Network errors must not lose
   the user's input.
8. Units come from the fixed list: kg, g, litre, ml, pcs, dozen, packet, bottle, box,
   loaf, bunch, bag. Quantity must be greater than zero.
9. List items store product_name and unit snapshots. Deactivate instead of delete.
10. Do not use localStorage-like hacks or fake data as a permanent data source.
11. Run `dart format`, `flutter analyze`, and `flutter test` after each phase and fix
    problems before moving on. Do not claim a feature works until it has been run.
    If you cannot run something, say so and tell me exact steps to test it.
12. Do not build everything in one change. Keep changes small and reviewable.
13. Commit after each verified phase (suggest the commit message; I will run git).

START WITH PHASE 0 AND PHASE 1 ONLY
Phase 0: verify `flutter doctor`, `flutter devices`, git status, and that pubspec has no
flutter_riverpod or go_router. Check that android/app has a single MainActivity matching
the namespace. Tell me exactly what is missing and the commands to fix it. Propose the
.gitignore additions and the GitHub Actions keep-alive workflow from docs/TRD.md.

Phase 1 (after I confirm the SQL has been run in Supabase and I give you the run flags):
- main.dart: initialize Supabase before runApp using --dart-define values, then
  await AppState.bootstrap().
- Create lib/services/auth_service.dart (sign up with full_name metadata, sign in,
  sign out, reset password). Load role from user_roles and is_active from profiles.
- Remove demo users, plain-text passwords, loginAsAdminDemo, and the "admin in email"
  rule. Remove the password field from AppUser.
- Load categories and products from Supabase. Remove the hardcoded demo catalog.
- Update login, signup, and forgot-password screens to await the async calls, disable
  buttons while loading, and show errors.
- Show loading, empty, and error states on the catalog screens. Debounce search.
- Tell me how to verify on a device: sign up, sign in, restart the app, see the catalog,
  and confirm a normal account cannot see admin screens.

Then stop and report: what changed, what you verified, what you could not verify,
and the next phase proposal.

AFTER PHASE 1, in later phases (do not start them without my approval):
Phase 2 lists in Supabase, Phase 3 PDF and text sharing, Phase 4 admin screens with
Cloudinary uploads and user management through the admin_set_user_active and
admin_stats functions, Phase 5 security tests, Phase 6 tests and polish, Phase 7 APK.

DESIGN
Follow docs/UI_UX_Design_Brief.md: green primary #16A36A, dark text #1F2937, soft
neumorphic cards only (keep small controls high contrast), 48 dp touch targets,
loading, empty, and error states everywhere.

COMMUNICATION
Be concise. Show diffs or complete files. Ask me a short question only when a decision
is genuinely mine; otherwise propose a default and continue.
```

## How to use it

1. Copy the `docs/` folder and `README.md` into the project (`/home/moetesum/AndroidStudioProjects/saudalist`).
2. Run the SQL from `docs/Backend_Schema.md` in Supabase.
3. Paste the prompt into the agent. Give it the run flags only when it asks, and never paste the `service_role` key.
4. After each phase, test on a device before approving the next one.
