
import 'package:local_auth/local_auth.dart';

class BiometricHelper {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> hasEnrolledBiometrics() async {
    final List<BiometricType> availablemetric = await _auth.getAvailableBiometrics();

    if (availablemetric.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> authenticate() async {
    final bool didAuthenticate = await _auth.authenticate(
      localizedReason: "Please authenticated to Proceed",
      options: const AuthenticationOptions(
        biometricOnly: true
      )
    );

    return didAuthenticate;
  }
}