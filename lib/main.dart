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
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (reads google-services.json on Android)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization warning: $e');
  }

  // Clean Architecture Bootstrapping (Feature-First)
  final apiClient = ApiClient(baseUrl: 'http://localhost:8000/api');

  // Auth feature dependencies (Powered by Firebase Auth)
  final authFirebase = AuthFirebaseDataSourceImpl();
  final authMock = AuthMockDataSourceImpl();
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authFirebase,
    mockDataSource: authMock,
    useRemote: true, // Uses Firebase Auth for login & register
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
