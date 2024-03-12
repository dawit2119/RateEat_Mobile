import 'package:sign_in_with_apple/sign_in_with_apple.dart'
    hide SignInWithAppleException;
import 'package:rateeat_mobile/src/core/core.dart';
import '../../../user_profile/data/data.dart';

class AuthenticationWithApple {
  static Future<UserModel> signInWithApple() async {
    late UserModel user;
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final displayName = [
        credential.givenName ?? '',
        credential.familyName ?? ''
      ];

      user = UserModel(
        firstName: displayName[0],
        lastName: displayName[1],
        email: credential.email ?? '',
        image: null, // Apple doesn't provide profile image
        token: credential.identityToken,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      throw SignInWithAppleException(errorMessage: e.message);
    } catch (e) {
      throw SignInWithAppleException(errorMessage: e.toString());
    }
    return user;
  }

  static Future<void> signOut() async {
    // Apple doesn't provide a sign out method
    // The app should handle this locally
  }
}
