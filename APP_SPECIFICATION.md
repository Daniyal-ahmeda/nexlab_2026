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
- **State Management:** `Provider` (`AppState` ChangeNotifier)
- **Backend Service:** Laravel 11 REST API (Default port: `8000`) with local Mock fallback
- **Authentication:** Laravel Sanctum Token Auth + Phone SMS OTP / Fallback Verification
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
│   │   └── api_constants.dart              # Base URL resolution & API route strings
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
│   │   └── app_state.dart                  # Global ChangeNotifier managing state & business logic
│   ├── routes/
│   │   ├── app_router.dart                 # Route generator & AuthWrapper
│   │   └── app_routes.dart                 # Static route path constants
│   └── theme/
│       └── app_theme.dart                  # Light & OLED Dark themes, typography, gradients
├── features/
│   ├── auth/                               # Authentication feature
│   │   ├── data/                           # Datasources (Remote, Mock, Firebase) & repositories
│   │   ├── domain/                         # Entities (User) & UseCases (Login, Register, Logout)
│   │   └── presentation/pages/
│   │       ├── login/login_screen.dart     # Email/password login with language switch
│   │       ├── register/register_screen.dart # 7-field patient registration with OTP trigger
│   │       ├── otp/otp_screen.dart         # 6-digit PIN input with 60s timer & demo bypass (123456)
│   │       └── profile/profile_screen.dart # User profile, health metrics, activity & preferences
│   ├── booking/                            # Diagnostic tests & booking feature
│   │   ├── data/                           # TestModel, LabModel, BookingModel datasources & repos
│   │   ├── domain/                         # Entities (DiagnosticTest, LabOption, Booking) & UseCases
│   │   └── presentation/pages/
│   │       ├── main_navigation/            # 4-tab bottom navigation scaffold
│   │       ├── home/home_screen.dart       # Search, categories, popular tests & prescription upload
│   │       ├── test_details/               # Test description, turnaround, sample requirements
│   │       ├── select_lab/                 # Lab selection with distances, ratings & pricing
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
│           ├── settings/settings_screen.dart # Language picker (AR/EN), dark mode, notification switches
│           └── upload_prescription/        # Prescription image/camera upload simulation
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
- **Arabic Script:** Native Arabic fallback font (`Noto Naskh Arabic` / system Arabic) with RTL support.

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
  1. Top-right AppBar on `LoginScreen` & `RegisterScreen`.
  2. Header action on `ProfileScreen`.
  3. Interactive Language Bottom Sheet on `SettingsScreen`.

---

## 5. Global State Management (`AppState`)

`AppState` (`lib/core/providers/app_state.dart`) is a single `ChangeNotifier` providing state to all screens:

### Key State Fields
| Property | Type | Description |
|---|---|---|
| `currentUser` | `User?` | Active authenticated patient |
| `primaryUser` | `FamilyMember` | Default patient representation of the account owner |
| `allTests` | `List<DiagnosticTest>` | Available lab tests catalog |
| `allLabs` | `List<LabOption>` | Verified diagnostic centers |
| `bookings` | `List<Booking>` | User's active & past appointments |
| `results` | `List<TestResult>` | Diagnostic reports & laboratory findings |
| `familyMembers` | `List<FamilyMember>` | Dependents/family linked to patient |
| `paymentMethods` | `List<PaymentMethod>` | Saved Libyan gateways & cards |
| `favorites` | `List<DiagnosticTest>` | Saved bookmarked tests |
| `notifications` | `List<Map<String, String>>` | Push & in-app alerts list |
| `isDarkMode` | `bool` | Dark / Light theme toggle |
| `locale` | `Locale` | Active app language (`ar` / `en`) |
| `selectedTest`, `selectedLab`, `selectedDate`, `selectedTimeSlot`, `selectedPatient`, `isHomeCollection` | Multiple | Active diagnostic checkout workflow state |

---

## 6. Authentication & OTP Verification Logic

### 1. Login Flow (`/login`)
- Patient enters email + password.
- Calls `state.login(email, password)`.
- On success: stores JWT token in `ApiClient` and loads initial patient data.

### 2. Registration Flow (`/register`)
- Patient enters: Full Name, Email, Mobile Number (`091/092...`), Password, Age, Gender, Blood Type.
- Form auto-formats phone number to international format (`+218...`).
- When user taps **Verify Phone & Register**:
  - Web / Dev Mode: Immediately opens `OtpScreen`.
  - Native Android/iOS: Calls `FirebaseAuth.instance.verifyPhoneNumber`. If unavailable, gracefully falls back to `OtpScreen`.

### 3. Universal OTP Screen (`/otp`)
- **File:** `lib/features/auth/presentation/pages/otp/otp_screen.dart`
- **UI:** 6 separate PIN boxes with auto-advance and auto-submit.
- **Timer:** 60-second live countdown with Resend button.
- **Verification Logic:**
  1. Validates with Firebase Phone Auth if native verification session is active.
  2. Falls back to offline/demo validation code: **`123456`** (or `000000`).
- **Success Action:** Calls `onVerified(token)` which completes `state.register(...)` and redirects to the home screen.

---

## 7. Libyan Payment Gateways Architecture

### Supported Payment Gateways
1. **Edfaaly (إدفع لي):** Al-Madar Telecommunications network.
2. **Mobi Cash (موبي كاش):** Wahda Bank mobile payment service.
3. **Sadad (سداد):** Libyana Mobile Phone network.
4. **Tadawul / Sahel (تداول / سهل):** Local card processing & POS network.
5. **Moamalat (معاملات):** National Banking card switch.
6. **Tyssir (تيسير):** Jumhouria Bank mobile service.
7. **Cash on Visit (نقداً عند الزيارة):** Settle in cash at the lab or upon home sample collection.

### Payment Registration OTP Flow
- In `PaymentMethodsScreen`, tapping **Add New Libyan Payment Gateway** opens a bottom sheet.
- Entering account/mobile number and tapping **Verify via SMS & Add Method** routes through `OtpScreen` to authenticate the Libyan wallet/card before adding it to `state.paymentMethods`.

---

## 8. Diagnostic Booking & Checkout Workflow

```
HomeScreen (Select Test)
   └── TestDetailsScreen (Review requirements, fasting, sample type, price)
          └── SelectLabScreen (Choose accredited lab center in Tripoli)
                 └── SelectDateTimeScreen (Choose Date, Time Slot, Home Collection vs Lab Visit, Select Patient)
                        └── BookingConfirmationScreen (Review invoice breakdown, choose Libyan gateway, Confirm)
                               └── BookingsScreen (View live booking card with status badge & QR/NXL code)
```

- **Booking IDs:** Generated with format `NXL` + timestamp (e.g. `NXL8842091`).
- **Statuses:** `pending` (قيد الانتظار), `confirmed` (مؤكد), `completed` (مكتمل), `cancelled` (ملغي).

---

## 9. Medical Test Results & Diagnostic Reports

- **Results Screen:** Filter by status (`All`, `Completed`, `Pending`).
- **Result Details Screen:**
  - Overall status banner (`Normal`, `Needs Review`, `Critical`).
  - Diagnostic metric tiles with Value, Reference Range, Unit, and Flag (`NORMAL`, `HIGH`, `LOW`).
  - Doctor / Lab Director notes and electronic signature.
  - Action to share/download official PDF report.

---

## 10. API & Backend Contract (`ApiClient`)

- **Base URL Resolution (`ApiConstants`):**
  - Web: `http://localhost:8000/api`
  - Mobile Emulator: `http://10.0.2.2:8000/api`
  - Physical Device: `http://192.168.0.109:8000/api`

### Core Endpoints
| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/api/login` | Email/password login → returns user object & Bearer token |
| `POST` | `/api/register` | Register new patient profile |
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
