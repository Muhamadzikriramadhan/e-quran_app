import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();

  String? _lastToken;

  /// Inisialisasi Firebase Messaging
  Future<void> initNotification() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // 1. Minta izin notifikasi (penting untuk iOS dan Android 13+)
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('NotificationService: User granted permission: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // 2. Dapatkan token aktif saat inisialisasi
        _lastToken = await messaging.getToken();
        debugPrint('NotificationService: FCM Token: $_lastToken');

        // Jika user sudah login di Supabase, simpan tokennya
        final currentUser = Supabase.instance.client.auth.currentUser;
        if (currentUser != null && _lastToken != null) {
          await SupabaseService.instance.saveFcmToken(
            userId: currentUser.id,
            token: _lastToken!,
          );
        }

        // 3. Listen untuk event pembaruan token (token refresh)
        messaging.onTokenRefresh.listen((newToken) async {
          debugPrint('NotificationService: FCM Token Refreshed: $newToken');
          _lastToken = newToken;
          
          final user = Supabase.instance.client.auth.currentUser;
          if (user != null) {
            await SupabaseService.instance.saveFcmToken(
              userId: user.id,
              token: newToken,
            );
          }
        });

        // 4. Setup message handlers (foreground & background)
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          debugPrint('NotificationService: Received foreground message: ${message.notification?.title}');
        });

        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          debugPrint('NotificationService: Notification clicked and opened app: ${message.data}');
        });
      }
    } catch (e) {
      debugPrint('NotificationService Error: Gagal menginisialisasi FCM: $e');
    }
  }

  /// Dapatkan token terakhir yang tersimpan secara lokal di service
  String? get token => _lastToken;
}
