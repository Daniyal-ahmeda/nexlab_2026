import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/constants/api_constants.dart';
import 'core/network/api_client.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'core/notifications/notification_config.dart';
import 'core/providers/app_state.dart';
import 'features/auth/data/datasources.dart';
import 'features/auth/data/repositories.dart';
import 'features/booking/data/datasources.dart';
import 'features/booking/data/repositories.dart';
import 'features/health/data/datasources.dart';
import 'features/health/data/repositories.dart';
import 'app.dart';

/// Background message handler -- must be top-level (not inside a class)
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint('Firebase initialization warning: $e');
    }
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  await localNotifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(resultChannel);

  await localNotifications.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );

  final apiClient = ApiClient(baseUrl: ApiConstants.baseUrl);

  final authRemote = AuthRemoteDataSourceImpl(apiClient);
  final authMock = AuthMockDataSourceImpl();
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemote,
    mockDataSource: authMock,
    useRemote: true,
  );

  final bookingRemote = BookingRemoteDataSourceImpl(apiClient);
  final bookingMock = BookingMockDataSourceImpl();
  final bookingRepository = BookingRepositoryImpl(
    remoteDataSource: bookingRemote,
    mockDataSource: bookingMock,
    useRemote: true,
  );

  final healthRemote = HealthRemoteDataSourceImpl(apiClient);
  final healthMock = HealthMockDataSourceImpl();
  final healthRepository = HealthRepositoryImpl(
    remoteDataSource: healthRemote,
    mockDataSource: healthMock,
    useRemote: true,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(
        authRepository: authRepository,
        bookingRepository: bookingRepository,
        healthRepository: healthRepository,
        apiClient: apiClient,
      ),
      child: const MyApp(),
    ),
  );
}
