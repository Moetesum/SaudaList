# UI/UX Design Brief: SaudaList

Version 2.0

## 1. Design direction

A **soft, friendly Material 3 interface with light neumorphic touches**. The goal is fast list building in a shop, so readability comes before decoration.

- Two experiences, one brand: the **user app** is simple, friendly, and shopping-focused. The **admin screens** are denser and data-focused.
- Product images are optional. Text-only products must look complete.
- No heavy animation or complex custom graphics in the MVP.

## 2. Color system

| Role | Color | Use |
|---|---|---|
| Primary | Emerald `#16A36A` | Main buttons, selected states, brand |
| Primary dark | `#0E7A50` | Text or icons on light backgrounds, pressed states |
| Secondary | Warm orange `#F59E0B` | Badges, highlights, pending status |
| Background | `#F0F3F8` | App background |
| Surface | `#F8FAFC` | Cards and sheets |
| Text | `#1F2937` | Body and headings |
| Muted text | `#6B7280` | Captions, hints |
| Success | `#16A36A` | Purchased items |
| Error | `#DC2626` | Errors and destructive actions |

**Decision note:** an earlier brief used indigo and navy. The green palette is chosen for a grocery context. If `neumorphic_theme.dart` still uses indigo, update the theme to this palette (seed color `#16A36A`) so the app and this document match.

Contrast rules:
- White text on `#16A36A` is only about 3:1, which is weak for small text. For buttons with white labels use `#0E7A50` or make the label large and bold. Use dark text `#1F2937` on light surfaces.
- Orange is an accent, never the color of body text.
- Never convey state by color alone: pair color with an icon or label (for example a check icon for purchased).

## 3. Typography

- Font: Inter or Roboto (system fallback is fine).
- Screen title 22 to 24 sp bold, section title 18 sp semi-bold, body 14 to 16 sp regular, caption and badge 12 sp medium.
- Product names may wrap to two lines. Never truncate a quantity or unit.
- Urdu text needs a font with Urdu glyphs, for example Noto Naskh Arabic. Support right-to-left text in product names even if the UI is English.

## 4. Neumorphism, used carefully

Soft same-color shadows look pleasant but reduce contrast and make controls hard to identify.

- Use soft raised shadows on **cards and large containers** only.
- Text fields, small buttons, and checkboxes keep a clear border or fill so they stay visible.
- Body text is always dark on a light surface.
- Test the app outdoors-bright and at low brightness. If something is hard to see, increase contrast.

## 5. Components

| Component | Specification |
|---|---|
| Primary button | Filled green, 48 dp high minimum, rounded 14 to 16 dp, loading state disables the button |
| Secondary button | Outlined or soft surface |
| Product card | Image (or placeholder icon), name, default unit, Add button |
| Quantity sheet | Bottom sheet: product name, quantity field (decimals allowed), unit selector chips, Add or Update, Cancel |
| List item row | Checkbox, product name, quantity and unit visible, edit and remove actions |
| List card | Title, item count, pending or done badge, updated date, overflow menu (rename, duplicate, delete) |
| Empty state | Icon, one sentence, one action button |
| Error state | Plain message, Retry button |
| Loading | Skeleton or spinner, never a blank screen |
| Confirm dialog | For delete list and remove item. Offer undo for item removal |

Units are chosen from chips or a dropdown: kg, g, litre, ml, pcs, dozen, packet, bottle, box, loaf, bunch, bag.

## 6. Screens

**User app**
1. Splash and session check (no long delay).
2. Login, Sign up, Forgot password.
3. Home: welcome, search bar, category grid, current-list shortcut, Create New List.
4. Categories and Products: search field, category filter, product cards, loading, empty, error states.
5. My Lists: list cards, create button, empty state.
6. List Details: editable title, items with quantity and unit, purchased checkbox, progress ("3 of 10 purchased"), Add products, Preview.
7. PDF Preview: rendered document, back to edit, share, print, share as text.
8. Profile: name, email, sign out, app info.

Bottom navigation: **Home, My Lists, Profile**. Products and Categories open from Home.

**Admin screens**
1. Dashboard: counts (users, lists, products, categories), quick links.
2. Manage Catalog: searchable product table or list with image, name, category, unit, active switch, edit. Add or edit form with image upload. Category list with ordering and active switch.
3. User Management: name, email, role, active switch.
4. Statistics and recent activity.

Admin screens use a compact layout with more information per screen. Show the Admin entry only for admin users.

## 7. PDF layout (A4)

- Header: app name or logo, list title, date.
- Table columns: number, product, quantity, unit, purchased mark.
- Wrapped product names, repeated header row on each page, page number in the footer ("Page 1 of 3").
- Black text on white, no heavy backgrounds, so it prints well and saves ink.
- Optional footer line "Made with SaudaList".

## 8. Accessibility and responsiveness

- Minimum touch target 48 x 48 dp.
- Text scales with the system font size without breaking layouts.
- Support small phones, large phones, and landscape. Use flexible layouts and avoid fixed sizes.
- Provide semantic labels for icon buttons.
- Use clear error text, not only red borders.

## 9. Content rules

- Short, plain English. Error messages say what happened and what to do.
- Destructive actions use a verb ("Delete list"), not "OK".
- Currency is not shown in the MVP because prices are Phase 2.
