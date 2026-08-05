import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/features/auth/data/datasources.dart';
import 'package:nexlab_2026/features/auth/data/repositories.dart';
import 'package:nexlab_2026/features/booking/data/datasources.dart';
import 'package:nexlab_2026/features/booking/data/repositories.dart';
import 'package:nexlab_2026/features/health/data/datasources.dart';
import 'package:nexlab_2026/features/health/data/repositories.dart';
import 'package:nexlab_2026/core/network/api_client.dart';
import 'package:nexlab_2026/app.dart';

void main() {
  testWidgets('App starts up and shows login screen', (WidgetTester tester) async {
    final apiClient = ApiClient(baseUrl: 'http://localhost:8000/api');
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(apiClient),
      mockDataSource: AuthMockDataSourceImpl(),
      useRemote: false,
    );
    final bookingRepository = BookingRepositoryImpl(
      remoteDataSource: BookingRemoteDataSourceImpl(apiClient),
      mockDataSource: BookingMockDataSourceImpl(),
      useRemote: false,
    );
    final healthRepository = HealthRepositoryImpl(
      remoteDataSource: HealthRemoteDataSourceImpl(apiClient),
      mockDataSource: HealthMockDataSourceImpl(),
      useRemote: false,
    );

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(
          authRepository: authRepository,
          bookingRepository: bookingRepository,
          healthRepository: healthRepository,
        ),
        child: const MyApp(),
      ),
    );

    // Let the initial loading finish
    await tester.pumpAndSettle();

    // Verify login page elements exist
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}

