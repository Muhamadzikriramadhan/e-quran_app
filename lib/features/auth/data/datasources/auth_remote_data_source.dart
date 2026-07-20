import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/constants.dart';

abstract class AuthRemoteDataSource {
  Future<User?> loginWithGoogle();
  Future<void> logout();
  User? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.supabaseClient,
    GoogleSignIn? googleSignIn,
  }) : googleSignIn = googleSignIn ??
            GoogleSignIn(
              serverClientId: googleWebClientId,
              clientId: googleIosClientId,
            );

  @override
  Future<User?> loginWithGoogle() async {
    try {
      // 1. Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User cancel sign-in
        debugPrint('AuthRemoteDataSource: Google Sign-in dibatalkan oleh user.');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Tidak menemukan ID Token dari Google.');
      }

      // 2. Sign-In ke Supabase menggunakan idToken
      final AuthResponse response = await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return response.user;
    } catch (e) {
      debugPrint('AuthRemoteDataSource Error: Gagal login dengan Google: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut(scope: SignOutScope.local);
    } catch (e) {
      debugPrint('AuthRemoteDataSource: Supabase signOut warning: $e');
    }
    try {
      await googleSignIn.signOut();
    } catch (e) {
      debugPrint('AuthRemoteDataSource: GoogleSignIn signOut warning: $e');
    }
  }

  @override
  User? getCurrentUser() {
    return supabaseClient.auth.currentUser;
  }
}
