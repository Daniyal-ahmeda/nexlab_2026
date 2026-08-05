import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/api_client.dart';
import 'core/providers/app_state.dart';
import 'features/auth/data/datasources.dart';
import 'features/auth/data/repositories.dart';
import 'features/booking/data/datasources.dart';
import 'features/booking/data/repositories.dart';
import 'features/health/data/datasources.dart';
import 'features/health/data/repositories.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Clean Architecture Bootstrapping (Feature-First)
  final apiClient = ApiClient(baseUrl: 'http://localhost:8000/api');

  // Auth feature dependencies
  final authRemote = AuthRemoteDataSourceImpl(apiClient);
  final authMock = AuthMockDataSourceImpl();
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemote,
    mockDataSource: authMock,
    useRemote: false, // Set to true to connect to live Laravel API
  );

  // Booking feature dependencies
  final bookingRemote = BookingRemoteDataSourceImpl(apiClient);
  final bookingMock = BookingMockDataSourceImpl();
  final bookingRepository = BookingRepositoryImpl(
    remoteDataSource: bookingRemote,
    mockDataSource: bookingMock,
    useRemote: false,
  );

  // Health feature dependencies
  final healthRemote = HealthRemoteDataSourceImpl(apiClient);
  final healthMock = HealthMockDataSourceImpl();
  final healthRepository = HealthRepositoryImpl(
    remoteDataSource: healthRemote,
    mockDataSource: healthMock,
    useRemote: false,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(
        authRepository: authRepository,
        bookingRepository: bookingRepository,
        healthRepository: healthRepository,
      ),
      child: const MyApp(),
    ),
  );
}
