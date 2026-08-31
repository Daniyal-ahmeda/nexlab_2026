# NexLab 2026 — Complete Frontend Architecture & Logic Specification

> **Notice for Future AI Agents & Developers:**  
> This file contains the complete architectural, logical, design, and API specification of the **NexLab Flutter Diagnostic Portal**. Read this document to understand the codebase structure, state management, routes, workflows, and styling rules without having to scan individual files.

---

## 1. Project Overview & Technology Stack

- **Project Name:** NexLab Diagnostic Portal (`nexlab_2026`)
- **Domain:** Diagnostic Laboratory Booking & Medical Health Records Portal
- **Target Market:** Libya (Tripoli & major cities, LYD currency, local Libyan payment networks)
- **Framework:** Flutter 3.x / Dart 3
- **Design Pattern:** Clean Architecture with Feature-First Modular Structure
- **State Management:** `Provider` (`AppState` ChangeNotifier) with Race Condition Guards
- **Backend Service:** Laravel 11 REST API (Default port: `8000`) with local Mock fallback
- **Authentication:** Laravel Sanctum Token Auth + Phone SMS OTP / Local Dev Bypass
- **Push Notifications:** Firebase Cloud Messaging (`firebase_messaging`) + `flutter_local_notifications`
- **Localization:** Bilingual English (`en` - LTR) and Arabic (`ar` - RTL) via `AppLocalizations`

---

## 2. Directory & File Organization

```
lib/
├── app.dart                                # MaterialApp entry point (theme, routes, localizations)
├── main.dart                               # Application bootstrap, Firebase & local notifications init
├── core/
│   ├── constants/
│   │   └── api_constants.dart              # Base URL resolution (Web/Device) & API route strings
│   ├── errors/
│   │   ├── exceptions.dart                 # AppException, ServerException, AuthException, etc.
│   │   └── failures.dart                   # Failure models mapped to UI error messages
│   ├── l10n/
│   │   └── app_localizations.dart          # English & Arabic dictionary, helper getters & delegate
│   ├── network/
│   │   ├── api_client.dart                 # HTTP client wrapper with JWT bearer token interceptor
│   │   └── mock_database.dart              # In-memory mock database for offline fallback
│   ├── notifications/
│   │   └── notification_config.dart        # Local notification channel & notification definitions
│   ├── providers/
│   │   └── app_state.dart                  # Global ChangeNotifier managing state, concurrency & logic
│   ├── routes/
│   │   ├── app_router.dart                 # Route generator & reactive AuthWrapper
│   │   └── app_routes.dart                 # Static route path constants
│   └── theme/
│       └── app_theme.dart                  # Light & OLED Dark themes, typography, gradients
├── features/
│   ├── auth/                               # Authentication feature
│   │   ├── data/                           # Safe UserModel, Datasources & Repositories
│   │   ├── domain/                         # Entities (User) & UseCases (Login, Register, Logout)
│   │   └── presentation/pages/
│   │       ├── onboarding/onboarding_screen.dart # Interactive 3-slide value intro with transparent logo
│   │       ├── login/login_screen.dart     # Email/password login with brand header & language switch
│   │       ├── register/register_screen.dart # Patient registration with OTP trigger
│   │       ├── otp/otp_screen.dart         # 6-digit PIN input with 60s timer & demo bypass (123456)
│   │       └── profile/profile_screen.dart # User profile, health metrics, activity & preferences
│   ├── booking/                            # Diagnostic tests & booking feature
│   │   ├── data/                           # DiagnosticTestModel, LabOptionModel, BookingModel
│   │   ├── domain/                         # Entities (DiagnosticTest, LabOption, Booking) & UseCases
│   │   └── presentation/pages/
│   │       ├── main_navigation/            # 4-tab bottom navigation scaffold
│   │       ├── home/home_screen.dart       # Search, dynamic categories, pull-to-refresh, test catalog
│   │       │   └── widgets/
│   │       │       ├── home_header.dart    # Avatar, Tripoli badge, language toggle & notifications sheet
│   │       │       └── health_category_chips.dart # Dynamic category chips derived from DB tests
│   │       ├── test_details/               # Test description, turnaround, sample requirements
│   │       ├── select_lab/                 # Lab selection with distances, ratings, pricing & refresh
│   │       ├── select_date_time/           # Date picker, morning/evening slots, home visit toggle
│   │       ├── booking_confirmation/       # Order summary, invoice breakdown, payment gateway picker
│   │       ├── bookings/bookings_screen.dart # Tabbed bookings list (Pending, Confirmed, Completed, Cancelled)
│   │       └── favorites/favorites_screen.dart # Bookmarked tests
│   └── health/                             # Medical reports & patient health feature
│       ├── data/                           # TestResultModel, FamilyMemberModel, PaymentMethodModel
│       ├── domain/                         # Entities (TestResult, FamilyMember, PaymentMethod) & UseCases
│       └── presentation/pages/
│           ├── results/results_screen.dart # Test results list with status filters
│           ├── result_details/             # Parameter breakdown (Hemoglobin, WBC, etc.), doctor notes
│           ├── family_members/             # Add, view & remove linked family member profiles
│           ├── payment_methods/            # Libyan gateways, saved cards, OTP authorization modal
│           └── settings/settings_screen.dart # Language picker (AR/EN), dark mode, notification switches
└── shared/
    └── widgets/
        ├── nexlab_logo.dart                # Brand vector logo with typography
        └── responsive_device_frame.dart    # Mobile device frame wrapper for Web/Desktop views
```

---

## 3. Design System & Theming

### Brand Color Tokens (`AppTheme`)
- **Primary Brand Blue:** `#1E6DFB` (Hover/Dark Accent: `#0F56D3`)
- **Emerald Green (Normal/Success):** `#10B981`
- **Coral Red (Critical/Error):** `#EF4444`
- **Amethyst Purple (Specialist/Radiology):** `#8B5CF6`
- **Sunset Orange (Pathology/Urgent):** `#F97316`
- **Amber Gold (Pending):** `#F59E0B`
- **Scaffold Background (Light):** `#F8FAFC`
- **Scaffold Background (Dark):** `#0F172A` (Deep Slate / OLED)
- **Card Background (Light):** `#FFFFFF` with `1px` border `#E2E8F0`
- **Card Background (Dark):** `#1E293B` with `1px` border `#334155`

### Typography Hierarchy
- **Brand / Headings / Numerical Scores:** `'Outfit'`, `FontWeight.w700` / `FontWeight.w800`
- **Body & Clinical Descriptions:** `'Inter'`, `FontWeight.w400` / `FontWeight.w500`
- **Arabic Script:** Native Arabic fallback font (`Noto Naskh Arabic` / system Arabic) with full RTL support.

---

## 4. Localization (Arabic RTL & English LTR)

- **Class:** `AppLocalizations` (`lib/core/l10n/app_localizations.dart`)
- **State Properties:**
  - `state.locale` (`Locale('ar')` or `Locale('en')`)
  - `state.isArabic` (boolean)
  - `state.setLocale(Locale newLocale)`
  - `state.toggleLocale()`
- **Supported Locales:** `['ar', 'en']` (Default: `ar` Arabic).
- **Directionality:** Automatically switches between Left-to-Right (`ltr`) and Right-to-Left (`rtl`).
- **Language Switch Points:**
  1. Header on `HomeScreen` (Quick toggle `EN` / `عربي`).
  2. Top-right AppBar on `LoginScreen` & `RegisterScreen`.
  3. Action on `ProfileScreen`.
  4. Interactive Language Bottom Sheet on `SettingsScreen`.

---

## 5. Global State Management & Concurrency Guards (`AppState`)

`AppState` (`lib/core/providers/app_state.dart`) is a single `ChangeNotifier` providing reactive state and resilient network synchronization:

### Concurrency & Race Condition Protections
1. **Monotonic Sequence Fetch Token (`_fetchSequence`)**:
   - Every invocation of `loadInitialData()` increments an internal sequence integer (`++_fetchSequence`).
   - When an asynchronous network request finishes, it checks `if (currentSeq != _fetchSequence) return;`. Stale responses from out-of-order network latency are automatically discarded.
2. **Re-Entrant Double-Submit Guards**:
   - `confirmBooking()`, `login()`, `register()`, `addPaymentMethod()`, and `addFamilyMember()` have dedicated lock flags (`_isSubmittingBooking`, `_isSubmittingAuth`, etc.) preventing double-taps from generating duplicate server records.
3. **Reactive `AuthWrapper` Navigation**:
   - `AuthWrapper` reactively switches between `LoginScreen` and `MainNavigationScreen` based on `state.currentUser`. Successful login and registration use `Navigator.of(context).popUntil((r) => r.isFirst)` to cleanly reveal `MainNavigationScreen` without router loops.

---

## 6. Dynamic Dashboard Data & Resilient Parsing

### MySQL / Laravel Multi-Type Safe Parsing
To eliminate Dart `TypeError` crashes from MySQL driver types, all models utilize defensive parsing helpers:
- `_parseBool(val)`: Handles `true`, `false`, `1`, `0`, `"1"`, `"0"`, `"true"`, `"yes"`.
- `_parseDouble(val)`: Handles `int`, `double`, and numeric strings (e.g. `"150.00"`).
- `_parseInt(val)`: Handles `int`, `double`, and numeric strings.
- `_parseString(val)`: Coalesces multiple key variations (e.g. `title` vs `name`, `details` vs `description`, `turnaround_time` vs `reports_in_hours`).

### Dynamic Category Engine
- `HomeScreen` dynamically extracts all unique categories from `state.allTests`.
- Adding a test with a new category from the Laravel dashboard automatically creates a dedicated filter chip with matching icon and active counter.
- **Pull-to-Refresh**: Pulling down on `HomeScreen` or `SelectLabScreen` triggers `state.refreshAll()`.

---

## 7. Authentication & OTP Verification Logic

### 1. Login Flow (`/login`)
- Patient enters email + password.
- Calls `state.login(email, password)`.
- Stores Sanctum token in `ApiClient` and loads initial patient data.

### 2. Registration Flow (`/register`)
- Patient enters: Full Name, Email, Mobile Number (`091/092...`), Password, Age, Gender, Blood Type.
- Form auto-formats phone number to Libyan international format (`+218...`).
- Routes through `OtpScreen`.

### 3. Universal OTP Screen (`/otp`)
- **File:** `lib/features/auth/presentation/pages/otp/otp_screen.dart`
- **UI:** 6 separate PIN boxes with auto-advance and 60-second live countdown.
- **Verification Logic:**
  1. Validates with Firebase Phone Auth if native verification session is active.
  2. Local Dev Bypass Code: **`123456`** (or `000000`).
  3. Laravel backend (`FirebaseOtpService.php`) natively accepts dev mock tokens in local development.

---

## 8. Libyan Payment Gateways Architecture

### Supported Gateways
1. **Edfaaly (إدفع لي):** Al-Madar Telecommunications network.
2. **Mobi Cash (موبي كاش):** Wahda Bank mobile payment service.
3. **Sadad (سداد):** Libyana Mobile Phone network.
4. **Tadawul / Sahel (تداول / سهل):** Local card processing & POS network.
5. **Moamalat (معاملات):** National Banking card switch.
6. **Tyssir (تيسير):** Jumhouria Bank mobile service.
7. **Cash on Visit (نقداً عند الزيارة):** Settle in cash at the lab or upon home sample collection.

---

## 9. Push Notifications & In-App Medical Alerts

- **FCM Device Registration:** Registered via `POST /api/device-token`.
- **Foreground Alerts:** Displays heads-up banner via `flutter_local_notifications` (`nexlab_results` high-priority channel) and automatically triggers background data refresh (`state.refreshResults()`).
- **Background & Terminated State:** Top-level `_firebaseBackgroundHandler` catches notifications and routes tapping to the test result.
- **In-App Notification Center:** Tapping the bell icon on `HomeScreen` opens the Medical Notifications Sheet with unread badge indicators and direct "View Report" navigation.

---

## 10. API & Backend Contract (`ApiClient`)

- **Base URL Resolution (`ApiConstants`):**
  - Web: `http://localhost:8000/api`
  - Mobile Device / Emulator: `http://192.168.0.101:8000/api`

### Core Endpoints
| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/api/login` | Email/password login → returns user object & Bearer token |
| `POST` | `/api/register` | Register new patient profile with phone & verification token |
| `POST` | `/api/logout` | Revokes current API session token |
| `GET` | `/api/me` | Fetch currently authenticated user session |
| `GET` | `/api/tests` | List all available diagnostic tests |
| `GET` | `/api/labs` | List all verified lab branches & diagnostic centers |
| `GET` | `/api/bookings` | Fetch patient's booking history |
| `POST` | `/api/bookings` | Create new diagnostic appointment |
| `PUT` | `/api/bookings/{id}/cancel` | Cancel existing booking |
| `GET` | `/api/results` | List diagnostic reports & blood panels |
| `GET` | `/api/family-members` | Fetch linked family member profiles |
| `POST` | `/api/family-members` | Add new family member |
| `DELETE` | `/api/family-members/{id}`| Remove family member |
| `GET` | `/api/payment-methods` | List saved payment methods |
| `POST` | `/api/payment-methods` | Add verified Libyan payment method |
| `POST` | `/api/device-token` | Register FCM push notification token |

---

## 11. Quick Testing & Development Guide

1. **Start Backend:**
   ```bash
   cd c:\Users\Lenovo\Herd\nexlab-backend
   php artisan serve --host=0.0.0.0 --port=8000
   ```
2. **Start Flutter App:**
   ```bash
   flutter run -d chrome
   # or
   flutter run -d windows
   # or
   flutter run -d android
   ```
3. **Demo Bypass Credentials:**
   - **Login Email:** `daah12909@gmail.com` / `patient@nexlab.ly`
   - **Login Password:** Any string $\ge$ 6 chars (e.g. `password123`)
   - **OTP Verification Code:** **`123456`** (or `000000`)
