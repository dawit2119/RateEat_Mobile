import 'package:google_sign_in/google_sign_in.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import '../../../user_profile/data/data.dart';

class AuthenticationWithGoogle {
  static Future<UserModel> signInWithGoogle() async {
    late UserModel user;
    try {
      await signOut();

      // Use GoogleSignIn.instance instead of GoogleSignIn()
      final googleSignInAccount = await GoogleSignIn.instance.authenticate();

      if (googleSignInAccount != null) {
        final displayName = googleSignInAccount.displayName?.split(' ') ?? [];

        // Use authorizationClient to get tokens
        const List<String> scopes = ['email', 'profile'];
        final authorization = await googleSignInAccount.authorizationClient
            .authorizationForScopes(scopes);

        if (authorization == null) {
          throw SignInWithGoogleException(
              errorMessage: 'Failed to obtain authorization');
        }

        //final idToken = authorization.idToken;
        final accessToken = authorization.accessToken;

        // if (idToken == null) {
        //   throw SignInWithGoogleException(
        //       errorMessage: 'Failed to obtain ID token');
        // }

        user = UserModel(
          firstName: displayName.isNotEmpty ? displayName[0] : '',
          lastName: displayName.length > 1 ? displayName[1] : '',
          email: googleSignInAccount.email,
          image: googleSignInAccount.photoUrl,
          token: accessToken,
        );
      } else {
        throw DefaultException();
      }
    } on DefaultException {
      rethrow;
    } catch (e) {
      throw SignInWithGoogleException(errorMessage: e.toString());
    }
    return user;
  }

  static Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (e) {
      throw SignOutWithGoogleException(errorMessage: e.toString());
    }
  }

  static getCurrentUser() async {}
}
