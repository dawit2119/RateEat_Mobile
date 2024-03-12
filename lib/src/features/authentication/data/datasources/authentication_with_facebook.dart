import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../../../user_profile/data/data.dart';

class AuthenticationWithFacebook {
  static Future<UserModel> signInWithFacebook() async {
    // dpLocator.<AuthenticationBloc>().add(SignOutWithFacebookEvent());
    late UserModel user;
    try {
      final facebookSignInAccount = await FacebookAuth.instance
          .login(loginBehavior: LoginBehavior.dialogOnly);
      if (facebookSignInAccount.status == LoginStatus.success) {
        final account = await FacebookAuth.instance.getUserData();
        final displayName = account['name'].split(" ");
        user = UserModel(
          id: account['id'],
          firstName: displayName[0],
          lastName: displayName.length > 1 ? displayName[1] : "",
          email: account['email'],
          image: account['picture']['data']['url'],
          token: facebookSignInAccount.accessToken!.token,
        );
      } else {
        throw SignInWithFacebookException(errorMessage: "Check Your Internet");
      }
    } catch (e) {
      throw SignInWithGoogleException(errorMessage: e.toString());
    }
    return user;
  }

  static Future<void> signOut() async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      throw SignOutWithFacebookException(errorMessage: e.toString());
    }
  }

  static getCurrentUser() async {}
}
