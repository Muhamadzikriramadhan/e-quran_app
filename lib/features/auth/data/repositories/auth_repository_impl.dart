import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User?> loginWithGoogle() async {
    final user = await remoteDataSource.loginWithGoogle();
    if (user != null) {
      // 1. Simpan data profil pengguna ke Supabase
      try {
        await SupabaseService.instance.saveUserProfile(user: user);
      } catch (e) {
        debugPrint('AuthRepositoryImpl Warning: Gagal menyinkronkan profil user: $e');
      }

      // 2. Dapatkan token FCM aktif dan simpan ke Supabase
      try {
        final fcmToken = NotificationService.instance.token ?? 
            await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await SupabaseService.instance.saveFcmToken(
            userId: user.id,
            token: fcmToken,
          );
        }
      } catch (e) {
        // Jangan block proses login jika sinkronisasi token FCM gagal
        debugPrint('AuthRepositoryImpl Warning: Gagal mensinkronisasikan token FCM saat login: $e');
      }
    }
    return user;
  }

  @override
  Future<void> logout() async {
    final user = remoteDataSource.getCurrentUser();
    if (user != null) {
      // Hapus token FCM aktif dari database agar perangkat ini tidak menerima push notif user ini lagi
      try {
        final fcmToken = NotificationService.instance.token ?? 
            await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await SupabaseService.instance.removeFcmToken(
            userId: user.id,
            token: fcmToken,
          );
        }
      } catch (e) {
        debugPrint('AuthRepositoryImpl Warning: Gagal menghapus token FCM dari database saat logout: $e');
      }
    }
    await remoteDataSource.logout();
  }

  @override
  User? getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }
}
