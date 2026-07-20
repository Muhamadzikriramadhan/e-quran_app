import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService instance = SupabaseService._internal();
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  /// Simpan atau update FCM Token untuk user yang aktif
  Future<void> saveFcmToken({
    required String userId,
    required String token,
  }) async {
    try {
      debugPrint('SupabaseService: Saving FCM token for user $userId...');
      
      // Mengirim request upsert ke tabel user_tokens
      await client.from('user_tokens').upsert(
        {
          'user_id': userId,
          'fcm_token': token,
          'device_type': Platform.isAndroid ? 'android' : Platform.isIOS ? 'ios' : 'unknown',
          'updated_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'user_id, fcm_token',
      );
      
      debugPrint('SupabaseService: FCM Token saved successfully.');
    } catch (e) {
      debugPrint('SupabaseService Error: Gagal menyimpan FCM Token ke Supabase: $e');
    }
  }

  /// Hapus FCM Token (digunakan saat logout)
  Future<void> removeFcmToken({
    required String userId,
    required String token,
  }) async {
    try {
      debugPrint('SupabaseService: Removing FCM token for user $userId...');
      
      await client
          .from('user_tokens')
          .delete()
          .match({'user_id': userId, 'fcm_token': token});
          
      debugPrint('SupabaseService: FCM Token removed successfully.');
    } catch (e) {
      debugPrint('SupabaseService Error: Gagal menghapus FCM Token dari Supabase: $e');
    }
  }

  /// Simpan atau update profil user dari metadata Google/Auth ke tabel profiles
  Future<void> saveUserProfile({required User user}) async {
    try {
      debugPrint('SupabaseService: Saving user profile for ${user.id}...');

      final name = user.userMetadata?['full_name'] ??
          user.userMetadata?['name'] ??
          'Pengguna E-Quran';
      final avatarUrl = user.userMetadata?['avatar_url'] ??
          user.userMetadata?['picture'] ??
          '';
      final email = user.email ?? '';

      await client.from('profiles').upsert({
        'id': user.id,
        'email': email,
        'full_name': name,
        'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      });

      debugPrint('SupabaseService: User profile saved successfully.');
    } catch (e) {
      debugPrint('SupabaseService Error: Gagal menyimpan data profil ke Supabase: $e');
    }
  }

  /// Ambil data profil pengguna dari tabel profiles (dengan pencadangan metadata)
  Future<Map<String, dynamic>?> getUserProfile(User? user) async {
    if (user == null) return null;
    try {
      // Auto-sync profil ke database jika belum ada
      await saveUserProfile(user: user);

      final response = await client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        return response;
      }
    } catch (e) {
      debugPrint('SupabaseService Error: Gagal mengambil data profil dari Supabase: $e');
    }

    final name = user.userMetadata?['full_name'] ??
        user.userMetadata?['name'] ??
        'Pengguna E-Quran';
    final avatarUrl = user.userMetadata?['avatar_url'] ??
        user.userMetadata?['picture'] ??
        '';

    return {
      'id': user.id,
      'email': user.email ?? '',
      'full_name': name,
      'avatar_url': avatarUrl,
    };
  }
}
