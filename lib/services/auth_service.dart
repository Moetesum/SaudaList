import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_user.dart';
import 'supabase_service.dart';

class AuthFailure implements Exception {
  final String message;
  const AuthFailure(this.message);

  @override
  String toString() => message;
}

abstract class AuthService {
  Future<AppUser?> getCurrentUser();
  Future<AppUser?> signIn({required String email, required String password});
  Future<AppUser?> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<void> resetPassword({required String email});
}

class SupabaseAuthService implements AuthService {
  SupabaseClient get _client => SupabaseService().client;

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on AuthFailure {
      rethrow;
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } on PostgrestException catch (e, st) {
      debugPrint('PostgrestException: $e\n$st');
      throw const AuthFailure(
        'Could not load your account data. Try again or contact the admin.',
      );
    } on SocketException catch (e, st) {
      debugPrint('SocketException: $e\n$st');
      throw const AuthFailure(
        'Could not reach the server. Check your internet and try again.',
      );
    } on TimeoutException catch (e, st) {
      debugPrint('TimeoutException: $e\n$st');
      throw const AuthFailure(
        'Could not reach the server. Check your internet and try again.',
      );
    } catch (e, st) {
      debugPrint('Unexpected auth error: $e\n$st');
      throw const AuthFailure('Something went wrong. Please try again.');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    return _guard(() async {
      final sessionUser = _client.auth.currentUser;
      if (sessionUser == null) return null;
      return _fetchUserData(sessionUser.id, sessionUser.email);
    });
  }

  Future<AppUser?> _fetchUserData(String userId, String? sessionEmail) async {
    final profileRes = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (profileRes == null) {
      await _client.auth.signOut();
      throw const AuthFailure('User profile record missing. Contact support.');
    }

    final isActive = profileRes['is_active'] as bool? ?? true;
    if (!isActive) {
      await _client.auth.signOut();
      throw const AuthFailure('Your account is disabled. Contact the admin.');
    }

    final roleRes = await _client
        .from('user_roles')
        .select('role')
        .eq('user_id', userId)
        .maybeSingle();

    if (roleRes == null) {
      await _client.auth.signOut();
      throw const AuthFailure('User role record missing. Contact the admin.');
    }

    final role = roleRes['role'] as String? ?? 'customer';

    return AppUser.fromJson(profileRes, role: role, isActive: isActive);
  }

  @override
  Future<AppUser?> signIn({
    required String email,
    required String password,
  }) async {
    return _guard(() async {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      final sessionUser = response.user;
      if (sessionUser == null) {
        throw const AuthFailure(
          'Sign in failed. Please check your credentials.',
        );
      }

      return _fetchUserData(sessionUser.id, sessionUser.email);
    });
  }

  @override
  Future<AppUser?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return _guard(() async {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'full_name': name.trim()},
      );

      final sessionUser = response.user;
      if (sessionUser == null) return null;
      if (response.session == null) return null; // Email confirmation ON

      return _fetchUserData(sessionUser.id, sessionUser.email);
    });
  }

  @override
  Future<void> signOut() async {
    return _guard(() async {
      await _client.auth.signOut();
    });
  }

  @override
  Future<void> resetPassword({required String email}) async {
    return _guard(() async {
      await _client.auth.resetPasswordForEmail(email.trim());
    });
  }
}
