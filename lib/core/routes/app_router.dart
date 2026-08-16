import 'package:flutter/material.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/booking_confirmation/booking_confirmation_screen.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/select_date_time/select_date_time_screen.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/select_lab/select_lab_screen.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/test_details/test_details_screen.dart';
import 'package:nexlab_2026/features/health/presentation/pages/result_details/result_details_screen.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/main_navigation/main_navigation_screen.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/features/auth/presentation/pages/login/login_screen.dart';
import 'package:nexlab_2026/features/auth/presentation/pages/register/register_screen.dart';
import 'package:nexlab_2026/shared/widgets/nexlab_logo.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.initial:
        return MaterialPageRoute(builder: (_) => const AuthWrapper());
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
    
    if (state.isLoading) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: AppTheme.blueGradient,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const NexLabLogo(
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    fontFamily: 'Outfit',
                  ),
                  children: [
                    TextSpan(
                      text: 'nex',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    TextSpan(
                      text: 'Lab',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Next-Gen Diagnostic Portal',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.currentUser == null) {
      return const LoginScreen();
    }

    return const MainNavigationScreen();
  }
}

