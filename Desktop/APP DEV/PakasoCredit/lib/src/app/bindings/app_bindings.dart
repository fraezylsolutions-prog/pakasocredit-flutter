import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/register_fields_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/congrats/controller/congrats_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/finish_up_account/controller/finish_up_account_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/forgot_password/controller/forgot_password_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/forgot_password/controller/pin_code_verification_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/forgot_password/controller/reset_password_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/sign_in/controller/sign_in_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/sign_up/controller/sign_up_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/splash/controller/splash_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/two_fa/controller/two_fa_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:get/get.dart';

// Splash Binding
class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}

// Sign In Binding
class SignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
  }
}

// Navigation Binding
class NavigationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
  }
}

// Home Binding
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

// Forgot Password Binding
class ForgotPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
  }
}

// Sign Up Binding
class SignUpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(() => SignUpController());
  }
}

// Register Fields Binding
class RegisterFieldsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterFieldsController>(() => RegisterFieldsController());
  }
}

// Finish Up Account Binding
class FinishUpAccountBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinishUpAccountController>(() => FinishUpAccountController());
  }
}

// Congrats Binding
class CongratsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CongratsController>(() => CongratsController());
  }
}

// Two Fa Binding
class TwoFaBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TwoFaController>(() => TwoFaController());
  }
}

// Pin Code Verification Binding
class PinCodeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PinCodeVerificationController>(
      () => PinCodeVerificationController(),
    );
  }
}

// Reset Password Binding
class ResetPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController());
  }
}
