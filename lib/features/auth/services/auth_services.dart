import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:social_media_app/core/utils/app_tables.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServices {
  final supabase = Supabase.instance.client;
  final supabaseDatabaseServices = SupabaseDatabaseServices.instance;

  Future<void> signInWithEmail(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw Exception('Failed to sign in');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      if (response.user == null) {
        throw Exception('Failed to sign up');
      }
      await _setUserData(name, email, response.user!.id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  User? fetchRawUser() {
    final user = supabase.auth.currentUser;
    if (user == null) return null;
    return user;
  }

  Future<void> _setUserData(String name, String email, String userId) async {
    try {
      final userData = UserData(name: name, email: email, id: userId);
      await supabaseDatabaseServices.insertRow(
        table: AppTables.users,
        values: userData.toMap(),
      );
    } catch (e) {
      rethrow;
    }
  }
 GoogleSignInAccount? googleUser;

  Future<AuthResponse> googleSignIn() async {
    const androidClientId  =
        '703226173077-5238j18jc9s2r54bqgregvplj956nu1p.apps.googleusercontent.com';

     
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: androidClientId
    );
      googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }
  // Future<void> signInWithGoogle() async {
  //   try {
  //     await supabase.auth.signInWithOAuth(
  //       OAuthProvider.google,
  //       redirectTo: 'com.socialmedia.app://login-callback',
  //     );
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
//  GoogleSignInAccount? googleUser;
//   Future<AuthResponse> googleSignIn() async {
//     const androidClientId =
//         '761361954261-27q368se1rvdclkhkh2merm84hdkb3nq.apps.googleusercontent.com';

//     final GoogleSignIn googleSignIn = GoogleSignIn(clientId: androidClientId);
//     log('======================================');
//     print(await GoogleSignIn().currentUser);

//     // Open Google Sign-In
//     googleUser = await googleSignIn.signIn();

//     if (googleUser == null) {
//       throw Exception('Google Sign-In was canceled by user');
//     }

//     final googleAuth = await googleUser!.authentication;
//     final accessToken = googleAuth.accessToken;
//     final idToken = googleAuth.idToken;

//     if (accessToken == null || idToken == null) {
//       throw Exception('Missing Google Auth tokens');
//     }

//     return supabase.auth.signInWithIdToken(
//       provider: OAuthProvider.google,
//       idToken: idToken,
//       accessToken: accessToken,
//     );
  // }