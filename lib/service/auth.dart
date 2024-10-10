import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:full_flutter_firebase_auth/home.dart';
import 'package:full_flutter_firebase_auth/service/database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        // Handle case where user cancels Google Sign-In
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final UserCredential result = await auth.signInWithCredential(credential);
      final User? userDetails = result.user;

      if (userDetails != null) {
        Map<String, dynamic> userInfoMap = {
          "email": userDetails.email,
          "name": userDetails.displayName,
          "imgUrl": userDetails.photoURL,
          "id": userDetails.uid,
        };

        await DatabaseMethods().addUser(userDetails.uid, userInfoMap);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    } catch (e) {
      print("Google sign-in error: $e");
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: $e')),
      );
    }
  }

  Future<User?> signInWithApple({List<Scope> scopes = const []}) async {
    try {
      final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)],
      );

      switch (result.status) {
        case AuthorizationStatus.authorized:
          final AppleIdCredential = result.credential!;
          final oAuthCredential = OAuthProvider('apple.com');
          final credential = oAuthCredential.credential(
            idToken: String.fromCharCodes(AppleIdCredential.identityToken!),
          );

          final UserCredential authResult = await auth.signInWithCredential(credential);
          final User? firebaseUser = authResult.user;

          if (firebaseUser != null && scopes.contains(Scope.fullName)) {
            final fullName = AppleIdCredential.fullName;
            if (fullName?.givenName != null && fullName?.familyName != null) {
              final displayName = '${fullName!.givenName!} ${fullName.familyName!}';
              await firebaseUser.updateDisplayName(displayName);
            }
          }

          return firebaseUser;

        case AuthorizationStatus.error:
          throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString(),
          );

        case AuthorizationStatus.cancelled:
          throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER',
            message: 'Sign in aborted by user',
          );

        default:
          throw UnimplementedError('Unknown Apple Sign-In status');
      }
    } catch (e) {
      print("Apple sign-in error: $e");
      // Handle Apple sign-in errors here if needed
      rethrow;
    }
  }
}
