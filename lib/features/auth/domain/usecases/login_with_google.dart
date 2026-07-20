import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/auth_repository.dart';

class LoginWithGoogleUseCase {
  final AuthRepository repository;

  LoginWithGoogleUseCase(this.repository);

  Future<User?> call() async {
    return await repository.loginWithGoogle();
  }
}
