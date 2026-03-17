import 'package:marketplace_supabase/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Sign up with email and password
  Future<AuthResponse> signUp(String email, String password) async {
    return await supabase.auth.signUp(email: email, password: password);
  }

  // Sign in with email and password
  Future<AuthResponse> signIn(String email, String password) async {
    return await supabase.auth.signInWithPassword(email: email, password: password);
  }

  // Sign out
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // get user info
  User? getUser() {
    return supabase.auth.currentUser;
  }
}
