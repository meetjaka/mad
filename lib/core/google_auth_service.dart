import 'package:google_sign_in/google_sign_in.dart';
import 'api_service.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
    // Force account selection every time to avoid cached issues
    forceCodeForRefreshToken: true,
  );

  /// Sign in with Google and authenticate with backend
  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return {'success': false, 'message': 'Sign in cancelled'};
      }

      // Get user information
      final String email = googleUser.email;
      final String displayName =
          googleUser.displayName ?? googleUser.email.split('@')[0];
      final String? photoUrl = googleUser.photoUrl;
      final String googleId = googleUser.id;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Get tokens
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      print('Google Sign-In Debug:');
      print('  Email: $email');
      print('  Display Name: $displayName');
      print('  Google ID: $googleId');
      print('  ID Token: ${idToken != null ? "Present" : "NULL"}');
      print('  Access Token: ${accessToken != null ? "Present" : "NULL"}');

      // Use access token if idToken is null (can happen on Android)
      final String authToken = idToken ?? accessToken ?? '';

      if (email.isEmpty || authToken.isEmpty) {
        await _googleSignIn.signOut(); // Clean up
        return {
          'success': false,
          'message': 'Failed to get user information. Please try again.'
        };
      }

      // Send to backend for verification and user creation/login
      final result = await ApiService.googleSignIn(
        email: email,
        name: displayName,
        googleId: googleId,
        idToken: authToken,
        photoUrl: photoUrl,
      );

      return result;
    } catch (error) {
      print('Google Sign-In error: $error');
      await _googleSignIn.signOut(); // Clean up on error
      return {
        'success': false,
        'message': 'Google Sign-In failed: ${error.toString()}'
      };
    }
  }

  /// Sign out from Google
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await ApiService.logout();
    } catch (error) {
      print('Google Sign-Out error: $error');
    }
  }

  /// Check if user is currently signed in with Google
  static Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  /// Get current Google user
  static GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  /// Silent sign in (try to sign in without user interaction)
  static Future<GoogleSignInAccount?> signInSilently() async {
    try {
      return await _googleSignIn.signInSilently();
    } catch (error) {
      print('Silent sign-in error: $error');
      return null;
    }
  }
}
