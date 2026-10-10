import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_client.dart';

class AuthService {
  static final SupabaseClient _client = SupabaseService.client;

  // تسجيل حساب جديد
  static Future<String?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      final user = response.user;
      if (user == null) {
        return 'Sign up failed';
      }

      // الخطوة الجديدة: ننشئ صف بجدول profiles بنفس الـ id
      await _client.from('profiles').insert({'id': user.id});

      return null; // نجح، ما فيه خطأ
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Something went wrong: $e';
    }
  }

  // تسجيل دخول
  static Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return null;
      }
      return 'Sign in failed';
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Something went wrong';
    }
  }

  // تسجيل خروج
  static Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
