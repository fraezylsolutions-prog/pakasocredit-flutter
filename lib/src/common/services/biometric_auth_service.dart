import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticateWithBiometrics() async {
    try {
      final canCheck = await auth.canCheckBiometrics;
      final isSupported = await auth.isDeviceSupported();
      final available = await auth.getAvailableBiometrics();

      if (!isSupported) {
        Fluttertoast.showToast(
          msg: "This device does not support biometrics.",
          backgroundColor: AppColors.error,
        );
        return false;
      }

      if (canCheck && available.isEmpty) {
        Fluttertoast.showToast(
          msg: "No biometric enrolled. Please set up fingerprint",
          backgroundColor: AppColors.error,
        );
        return false;
      }

      if (!canCheck) {
        Fluttertoast.showToast(
          msg: "Biometric features are currently unavailable.",
          backgroundColor: AppColors.error,
        );
        return false;
      }

      return await auth.authenticate(
        localizedReason: 'Authenticate to log in',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Biometric authentication failed.",
        backgroundColor: AppColors.error,
      );
      return false;
    }
  }

  Future<bool> isBiometricAvailable() async {
    try {
      final canCheckBiometrics = await auth.canCheckBiometrics;
      final availableBiometrics = await auth.getAvailableBiometrics();

      return canCheckBiometrics && availableBiometrics.isNotEmpty;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Unable to check biometric availability.",
        backgroundColor: AppColors.error,
      );
      return false;
    }
  }
}
