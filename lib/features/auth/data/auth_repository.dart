import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });
  Future<void> logout();
  Future<void> resetPassword({required String email});
  Future<UserModel> updateProfile({
    required String name,
    required String phone,
    String? avatarUrl,
  });
}
