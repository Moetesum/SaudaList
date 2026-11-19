# SaudaList

SaudaList is a grocery shopping list app for Android built with **Flutter**. An administrator manages a shared catalog of categories and products. Users build their own shopping lists from that catalog, then **print or share** them as a PDF or as text.

It is a list-management app, not an online grocery store: there is no payment or delivery.

The whole stack is **free**: Flutter, Supabase Free (PostgreSQL), Cloudinary Free (images), GitHub.

## Status

The UI screens are built. The app is being connected to the real backend (Supabase). See [`docs/Implementation_Plan.md`](docs/Implementation_Plan.md) for the exact, up-to-date checklist.

## Features

**Users**
- Sign up, sign in, reset password
- Browse and search the admin's catalog, filter by category
- Create multiple lists, add products with quantity and unit, add custom items
- Mark items purchased, edit or remove items, rename, duplicate, delete lists
- Preview a PDF, then save, share, or print it. Share as plain text

**Admin**
- Manage categories and products (including images), prefer deactivation over deletion
- View users and activate or deactivate accounts
- See simple statistics

Users cannot change the catalog or see other users' lists. This is enforced by database Row Level Security.

## Tech stack

| Layer | Choice |
|---|---|
| App | Flutter, Dart, Material 3 with a neumorphic theme |
| State | Provider |
| Backend | Supabase (PostgreSQL, Auth, Row Level Security) |
| Images | Cloudinary (unsigned upload preset) |
| PDF and print | `pdf`, `printing` |
| CI | GitHub Actions (keep-alive ping) |

## Documentation

| Document | Purpose |
|---|---|
| [PRD](docs/PRD.md) | What we build and for whom |
| [TRD](docs/TRD.md) | Architecture, security, configuration |
| [AppFlow](docs/AppFlow.md) | Screens, routes, flows, state machines |
| [UI/UX Design Brief](docs/UI_UX_Design_Brief.md) | Colors, components, screens, accessibility |
| [Backend Schema](docs/Backend_Schema.md) | Full SQL, RLS policies, tests |
| [Implementation Plan](docs/Implementation_Plan.md) | Phased checklist with honest status |

## Getting started

### 1. Prerequisites
- Flutter SDK and Android Studio with the Flutter and Dart plugins
- An Android emulator or a phone with USB debugging
- Free accounts: GitHub, Supabase, Cloudinary

Check your setup with `flutter doctor`. Linux desktop and Chrome are not required.

### 2. Clone and install

```bash
git clone https://github.com/<your-username>/saudalist.git
cd saudalist
flutter pub get
```

### 3. Create the Supabase project
1. Sign in at supabase.com and create a project on the **Free** plan.
2. Open **SQL Editor**, paste the SQL from [`docs/Backend_Schema.md`](docs/Backend_Schema.md), and run it. Save it also as `supabase/migrations/001_schema.sql`.
3. In **Project Settings, API**, copy the **Project URL** and the **anon (publishable) key**. Do not use or copy the `service_role` key.
4. During development you may turn off "Confirm email" under Authentication, Providers, Email.

### 4. Create the Cloudinary preset
1. Note your **Cloud name** on the Cloudinary dashboard.
2. Create an **unsigned upload preset** (folder `saudalist`, allowed formats jpg, png, webp, with a size limit). Note the preset name.
3. Do not put the API secret in the app.

### 5. Run the app

```bash
flutter devices
flutter run -d <device_id> \
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_anon_key \
  --dart-define=CLOUDINARY_CLOUD=your_cloud_name \
  --dart-define=CLOUDINARY_PRESET=your_unsigned_preset
```

In Android Studio you can put the same flags in Run, Edit Configurations, Additional run args.

### 6. Make yourself the admin

Sign up in the app first, then run this in the Supabase SQL Editor:

```sql
update public.user_roles
   set role = 'admin'
 where user_id = (select id from auth.users where email = 'YOUR_EMAIL_HERE');
```

### 7. Keep the free Supabase project awake
Add the workflow from [`docs/TRD.md`](docs/TRD.md) section 10 as `.github/workflows/keepalive.yml`, and set the repository secrets `SUPABASE_URL` and `SUPABASE_ANON_KEY`.

## Project structure

```
lib/
  core/        config, routing, theme, utils
  models/      Category, Product, ShoppingListModel, ShoppingListItem, AppUser
  services/    supabase, auth, category, product, shopping list, cloudinary, pdf, share, admin
  state/       AppState (Provider)
  features/    auth, home, categories, products, saved_lists, pdf_preview, settings, admin
  shared/      reusable widgets
supabase/migrations/   SQL
docs/                  project documents
```

## Testing

```bash
flutter analyze
flutter test
```

Security tests (two customer accounts and one admin) are listed in [`docs/Backend_Schema.md`](docs/Backend_Schema.md) section 7. Run them before sharing the app.

## Build a release APK

```bash
flutter build apk --release --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=... \
  --dart-define=CLOUDINARY_CLOUD=... --dart-define=CLOUDINARY_PRESET=...
```

Publish the APK on GitHub Releases. Keep the signing key and all keys out of Git.

## Security notes

- Only the anon key is used in the app. The `service_role` key and the Cloudinary API secret are never in the app or in Git.
- Admin rights come only from the `user_roles` table, set in the SQL Editor.
- Row Level Security is enabled on every table. Hiding a button is never treated as security.

## Free-tier notes

- Supabase and Cloudinary free plans have limits and can change. Check their pricing pages.
- Keep product images small (about 100 KB).
- Export your data to CSV now and then.

## License

Choose a license before making the repository public (for example MIT) and add a `LICENSE` file.
