import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/features/auth/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:nexlab_2026/features/auth/presentation/pages/login/login_screen.dart';
import 'package:nexlab_2026/features/auth/presentation/pages/register/register_screen.dart';
import 'package:nexlab_2026/features/auth/presentation/pages/splash/splash_screen.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/main_navigation/main_navigation_screen.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/test_details/test_details_screen.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/select_lab/select_lab_screen.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/select_date_time/select_date_time_screen.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/booking_confirmation/booking_confirmation_screen.dart';
import 'package:nexlab_2026/features/health/presentation/pages/result_details/result_details_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.initial:
        return MaterialPageRoute(builder: (_) => const AuthWrapper());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.testDetails:
        final test = settings.arguments as DiagnosticTest;
        return MaterialPageRoute(builder: (_) => TestDetailsScreen(test: test));
      case AppRoutes.selectLab:
        return MaterialPageRoute(builder: (_) => const SelectLabScreen());
      case AppRoutes.selectDateTime:
        return MaterialPageRoute(builder: (_) => const SelectDateTimeScreen());
      case AppRoutes.bookingConfirmation:
        final booking = settings.arguments as Booking;
        return MaterialPageRoute(builder: (_) => BookingConfirmationScreen(booking: booking));
      case AppRoutes.resultDetails:
        final result = settings.arguments as TestResult;
        return MaterialPageRoute(builder: (_) => ResultDetailsScreen(result: result));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    
    if (state.isLoading && state.currentUser == null && !state.hasSeenOnboarding) {
      return const NexLabSplashScreen();
    }

    if (state.currentUser != null) {
      return const MainNavigationScreen();
    }

    if (!state.hasSeenOnboarding) {
      return const OnboardingScreen();
    }

    return const LoginScreen();
  }
}
