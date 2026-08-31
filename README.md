# 🧬 NexLab Diagnostic Portal (2026 Edition)

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Laravel](https://img.shields.io/badge/Laravel-11.x-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FCM-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/License-Proprietary-blue?style=for-the-badge)

**NexLab** is a next-generation healthcare and diagnostic laboratory booking portal tailored for modern clinical diagnostics and medical record management. Built with **Flutter 3** and powered by a robust **Laravel 11 REST API**, NexLab provides patients with seamless laboratory test scheduling, home sample collection, digital clinical reports, Libyan mobile payments, and push notifications.

---

## ✨ Key Features

- **🧪 Comprehensive Test Catalog & Dynamic Categories**:
  - Browse blood panels, pathology, hormone, and radiology tests.
  - Dynamically extracts and renders categories and test counters directly from the database.
  - Pull-to-refresh synchronization with live backend data.

- **🏥 Tripoli Accredited Partner Labs**:
  - Compare diagnostic laboratories by distance, customer rating, price, and turnaround time.
  - Choose between **Lab Visit** and **Home Sample Collection** (زيارة منزلية).

- **📊 Digital Clinical Reports & Parameter Breakdown**:
  - Real-time diagnostic findings with reference ranges, units, and status flags (`NORMAL`, `HIGH`, `LOW`).
  - Doctor notes, electronic signatures, and instant official PDF report viewer/sharing.

- **💳 Libyan Mobile Wallets & Payment Gateways**:
  - Integrated with Libyan payment networks: **Edfaaly (إدفع لي)**, **Mobi Cash (موبي كاش)**, **Sadad (سداد)**, **Tadawul / Sahel (تداول / سهل)**, **Moamalat (معاملات)**, **Tyssir (تيسير)**, and **Cash on Visit**.
  - Interactive SMS OTP authorization sheet for registering new payment cards/wallets.

- **🌐 Complete Bilingual Arabic (RTL) & English (LTR) Localization**:
  - Instant one-tap language switcher in the header and settings.
  - Native RTL layout mirroring and tailored Arabic medical typography.

- **🔔 Firebase Cloud Messaging & Notifications**:
  - Heads-up push notifications when diagnostic results are ready.
  - In-app notification center drawer on the home screen with direct "View Report" shortcuts.

- **👨‍👩‍👧‍👦 Family Health Profiles**:
  - Manage dependents and family members to book tests on their behalf.

- **🛡️ Race Condition & Concurrency Guards**:
  - Sequence-token protected data loading (`_fetchSequence`) preventing out-of-order stale network overwrites.
  - Re-entrant double-submit button locks on bookings and payments.

---

## 🏛️ Clean Architecture Structure

```
lib/
├── core/
│   ├── constants/          # Base URLs & API endpoints
│   ├── errors/             # Custom exceptions & failures
│   ├── l10n/               # Arabic & English localizations
│   ├── network/            # ApiClient with Bearer auth & mock database
│   ├── notifications/      # FCM & flutter_local_notifications config
│   ├── providers/          # AppState (Global ChangeNotifier & concurrency guards)
│   ├── routes/             # AppRouter & AuthWrapper
│   └── theme/              # Light & OLED Dark themes (Outfit + Inter)
├── features/
│   ├── auth/               # Login, Register, OTP & Profile
│   ├── booking/            # Tests catalog, Lab selection, Date/Time & Bookings
│   └── health/              # Test results, Family members, Payments & Settings
└── shared/
    └── widgets/            # NexLabLogo & ResponsiveDeviceFrame
```

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: `^3.22.0` or higher
- **Dart SDK**: `^3.4.0` or higher
- **PHP**: `^8.2` or `^8.3` / **Composer** (for Laravel Backend)
- **MySQL Database**

---

### 1. Start the Laravel Backend

```bash
cd c:\Users\Lenovo\Herd\nexlab-backend

# Install dependencies if needed
composer install

# Run database migrations & seeders
php artisan migrate --seed

# Start the API server on all network interfaces
php artisan serve --host=0.0.0.0 --port=8000
```

---

### 2. Configure Frontend Network IP

Open [`lib/core/constants/api_constants.dart`](file:///c:/Users/Lenovo/Desktop/nexlab_2026/lib/core/constants/api_constants.dart) and ensure the IP matches your development machine's local Wi-Fi IP address:

```dart
class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    }
    // Set to your computer's local Wi-Fi IPv4 address
    return 'http://192.168.0.101:8000/api';
  }
}
```

---

### 3. Run the Flutter App

```bash
# Get dependencies
flutter pub get

# Run on Android Physical Phone or Emulator
flutter run -d android

# Or run on Chrome Web
flutter run -d chrome

# Or run on Windows Desktop
flutter run -d windows
```

---

## 🔑 Test & Demo Credentials

| Role | Email | Password | OTP Code |
|---|---|---|---|
| **Patient Account** | `daah12909@gmail.com` | `password123` | `123456` |
| **New Registration** | Any valid email | Any $\ge$ 6 chars | `123456` |

---

## 📄 Documentation

For full architectural blueprints, entity models, and state workflows, refer to:
- 📖 [APP_SPECIFICATION.md](file:///c:/Users/Lenovo/Desktop/nexlab_2026/APP_SPECIFICATION.md)
