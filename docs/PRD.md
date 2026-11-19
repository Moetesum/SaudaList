# Product Requirements Document (PRD): SaudaList

Version 2.0 | Status: MVP in progress (UI built on demo data, backend integration pending)

## 1. Summary

**SaudaList** is a grocery shopping list app for Android (iOS later). An **administrator** manages a shared catalog of categories and products. A **user** signs in, picks products from that catalog (or adds a custom item), sets quantities and units, saves multiple lists, previews a clean printable document, and then **prints or shares it** with anyone.

SaudaList is a list-management app. It is **not** an online grocery store: there is no payment, delivery, or checkout.

The whole stack must cost **Rs 0**: Flutter, Supabase Free (PostgreSQL), Cloudinary Free (images), GitHub Free.

## 2. Goals and non-goals

### Goals
- Admin-controlled catalog that users cannot change.
- Fast list building from the catalog with quantities and units.
- Multiple personal lists per user, stored in the cloud.
- Print and share: PDF and plain text.
- Strict data isolation: a user can only see their own lists. Enforced in the database, not only in the UI.
- Simple, readable, responsive interface.

### Non-goals for the MVP
Online payment, delivery or order tracking, live inventory, prices and totals (Phase 2), barcode scanning, voice input, family or shared lists, recurring reminders, offline sync, iOS release, advanced analytics.

## 3. Roles and permissions

| Capability | Admin | User |
|---|---|---|
| Sign in and sign out | Yes | Yes |
| Browse and search active catalog | Yes | Yes |
| Create, edit, reorder, deactivate categories | Yes | No |
| Create, edit, deactivate products (name, category, default unit, image) | Yes | No |
| Upload product and category images | Yes | No |
| See user list, activate or deactivate a user | Yes | No |
| See app statistics (counts) | Yes | No |
| Create, rename, duplicate, delete **own** lists | Yes | Yes |
| Add, edit, remove, check off items in own lists | Yes | Yes |
| Add a custom item that is not in the catalog | Yes | Yes |
| Read another user's lists | **No** | **No** |
| Print and share own lists | Yes | Yes |

Normal registration never creates an admin. The first admin is assigned manually in the Supabase SQL Editor.

## 4. Functional requirements

### 4.1 Authentication (FR-A)
- FR-A1: Sign up with full name, email, password (minimum 6 characters).
- FR-A2: Sign in with email and password. Show clear errors (wrong password, no account, no network).
- FR-A3: Forgot password using Supabase's reset email flow (email sent; in-app new-password screen pending (step 1a-2)).
- FR-A4: Session persists across app restarts. Sign out is available in Profile.
- FR-A5: A deactivated user is signed out and cannot read or write data.

### 4.2 Catalog browsing (FR-C)
- FR-C1: Categories and products load from Supabase. Nothing is hardcoded in the UI.
- FR-C2: Only active categories and products are shown to users.
- FR-C3: Search products by name and filter by category.
- FR-C4: Each product shows name, default unit, and an image if available (placeholder otherwise).
- FR-C5: Loading, empty, and error states on every catalog screen.

### 4.3 Shopping lists (FR-L)
- FR-L1: Create, rename, duplicate, delete lists (with confirmation for destructive actions).
- FR-L2: Add a catalog product with quantity and unit. Decimal quantities are allowed (for example 0.5 kg).
- FR-L3: If the product is already in the list, offer to increase the quantity instead of creating a duplicate row.
- FR-L4: Edit quantity or unit, remove an item (with undo or confirmation), mark an item purchased.
- FR-L5: Add a custom item by typing a name, quantity, and unit.
- FR-L6: Each saved item keeps a snapshot of product name and unit, so old lists stay readable after the admin changes the catalog.
- FR-L7: Show item count and pending versus purchased status for each list.
- FR-L8: Network errors never silently lose a change. The user sees a message and can retry.

### 4.4 Print and share (FR-P)
- FR-P1: Preview the PDF before exporting. The user can go back and edit.
- FR-P2: PDF is A4, readable, supports long lists with automatic page breaks and page numbers, and long product names wrap.
- FR-P3: Save or share the PDF through the system share sheet, and print on supported devices.
- FR-P4: Share the list as plain text (works well in WhatsApp).
- FR-P5: The export always uses the latest saved list data.

### 4.5 Administration (FR-D)
- FR-D1: Admin screens are reachable only for admin users. Every admin operation is also enforced by database policies.
- FR-D2: Add, edit, deactivate products; choose category and default unit; upload an optional image to Cloudinary.
- FR-D3: Add, edit, reorder, activate or deactivate categories. A category with products cannot be deleted.
- FR-D4: Prefer deactivation over deletion.
- FR-D5: User management: list users, show role and status, activate or deactivate a user. Permanent deletion is done in the Supabase Dashboard.
- FR-D6: Dashboard shows counts: users, lists, active products, active categories.

## 5. Business rules

1. Only the admin changes the global catalog.
2. A user sees only their own lists, even if they call the API directly.
3. Catalog changes appear for users automatically, because they read the same tables.
4. Deactivated products are hidden from the catalog but remain visible by name in existing lists.
5. Units come from a fixed list: kg, g, litre, ml, pcs, dozen, packet, bottle, box, loaf, bunch, bag.
6. Quantity must be greater than zero.

## 6. Non-functional requirements

| Area | Requirement |
|---|---|
| Cost | Rs 0. No paid plan, no card, no paid add-on |
| Security | RLS on every table, no service-role key in any client, anon key only, secrets outside Git |
| Privacy | Store only name, email, and lists. Provide a short privacy note before release |
| Performance | Catalog and lists load in under 2 seconds on a normal mobile connection. Images served resized through Cloudinary |
| Reliability | Clear error messages and retry. Supabase free project kept awake by a scheduled ping |
| Usability | Touch targets at least 48 dp, readable contrast in bright light, works on small and large phones |
| Compatibility | Android 5.0 (API 21) and newer. iOS later |
| Language | English UI. Urdu product names are supported in the app. Urdu in PDF needs an embedded font (optional) |

## 7. Free-tier constraints

- Supabase Free: about 500 MB database, 1 GB file storage, free projects can pause after a period of inactivity (mitigated by keep-alive).
- Cloudinary Free: monthly credit pool shared by storage, transformations, and bandwidth. Over-limit usage can block uploads or delivery instead of billing.
- Keep product images small (WebP or JPEG, about 100 KB).
- Verify current limits on each provider's pricing page before launch, because free plans change.

## 8. Roadmap

| Phase | Scope |
|---|---|
| MVP | Auth, catalog, lists, PDF and text sharing, admin catalog and users, RLS, Cloudinary images, APK release |
| Phase 2 | Optional prices and estimated total, admin starter lists (Monthly, Weekly, Party), frequently used items, notes per item |
| Phase 3 | Public share link, offline cache, reminders, iOS release |

## 9. MVP is complete when

- A user can register, sign in, and stay signed in.
- Categories and products load from Supabase.
- A user can save multiple lists with correct quantities and units, edit, remove, and mark items purchased.
- The PDF preview, save, share, print, and text share work on a real Android phone.
- An admin can manage products, categories, and images from the app, and users see the changes.
- Tests with two customer accounts and one admin account prove that RLS blocks unauthorized access.
- Setup and release steps are documented.

## 10. Decisions and assumptions

| Decision | Choice | Note |
|---|---|---|
| Backend | Supabase Free | Real SQL, Auth, and RLS, with an official Flutter SDK |
| Images | Cloudinary Free, unsigned upload preset | URL stored in `image_path` |
| Admin UI | Inside the Flutter app (existing admin screens) | A separate web panel is optional later |
| Custom items | Allowed | Hide the button if a strict catalog-only app is wanted |
| Prices | Phase 2 | Columns are nullable, so adding them later is safe |
| State management | Provider (already in the code) | Do not add Riverpod |
| User deactivation | `is_active` flag enforced by RLS | Hard delete is a Dashboard task |
