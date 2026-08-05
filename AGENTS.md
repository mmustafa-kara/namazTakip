# AGENTS.md

## Must-follow constraints
- **UI Design (CRITICAL):** DO NOT use default Material Design components with elevation/shadows (e.g., standard `Card`, `ElevatedButton`). You MUST implement "Flat Premium" UI styles (1px subtle borders, high border-radius 20-24, solid surface colors). DO NOT use Glassmorphism (BackdropFilter) for performance reasons.
- **Color Palette:** Hardcode NO colors in views. ONLY use defined constants:
  - Dark Mode: Matte Black/Anthracite background, Emerald/Mint Green accents.
  - Light Mode: Off-white background, Sage/Forest Green accents.
- **Typography:** DO NOT use system default fonts. ALL text must use the custom font definitions in `lib/core/typography.dart`.
- **API Strategy:** DO NOT fetch prayer times daily. You MUST fetch the entire month's data via Aladhan API once and cache it in the local database (Hive/Isar).
- **Language:** Codebase (variables, classes, filenames) MUST be 100% English. User-facing UI strings MUST be 100% Turkish.

## Repo-specific conventions
- **State Management:** DO NOT use `setState` for business logic, timers, or API states. Business logic MUST reside in ViewModels using the project's designated state manager.
- **File Size Limits:** View files (`lib/views/*`) MUST NOT exceed 200 lines. Extract UI fragments into `lib/widgets/*`.
- **Timers:** The prayer countdown timer MUST run efficiently without rebuilding the entire screen every second. Scope the rebuild only to the timer text widget.

## Important locations
- `lib/core/` - Single source of truth for styles, theme constants, and configuration.
- `lib/services/` - All hardware/external interactions MUST be abstracted here (Geolocator, Compass, Hive, Local Notifications).
- `lib/widgets/` - Home for reusable, custom-styled (Flat Premium) components.

## Change safety rules
- **Offline-First:** All UI components relying on prayer times or zikir/kaza counts MUST gracefully read from the local cache if the API call fails or there is no network. 
- **Notification Permissions:** Any feature using `flutter_local_notifications` MUST explicitly check and request OS-level permissions before scheduling.