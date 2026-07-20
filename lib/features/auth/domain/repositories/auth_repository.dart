import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  /// Melakukan login menggunakan Google dan mendaftarkan session di Supabase
  Future<User?> loginWithGoogle();

  /// Melakukan logout dari Supabase dan menghapus token terkait jika diperlukan
  Future<void> logout();

  /// Mendapatkan data user yang aktif saat ini dari Supabase Auth
  User? getCurrentUser();
}
