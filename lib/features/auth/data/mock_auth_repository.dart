import 'auth_repository.dart';
import '../models/user_model.dart';

class MockAuthRepository implements AuthRepository {
  UserModel? _currentUser;

  // Demo user mặc định để tiện thử nghiệm
  static const UserModel _demoUser = UserModel(
    id: 'user_001',
    name: 'Nguyễn Minh Trí',
    email: 'minhtri@gmail.com',
    phone: '0901234567',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
  );

  MockAuthRepository({bool startLoggedIn = false}) {
    if (startLoggedIn) {
      _currentUser = _demoUser;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 80));
    return _currentUser;
  }

  @override
  Future<UserModel> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final cleanEmail = email.trim().toLowerCase();
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      throw Exception('Email không đúng định dạng');
    }
    if (password.length < 6) {
      throw Exception('Mật khẩu phải có ít nhất 6 ký tự');
    }

    // Đăng nhập demo thành công
    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: cleanEmail.startsWith('minhtri') ? 'Nguyễn Minh Trí' : cleanEmail.split('@').first,
      email: cleanEmail,
      phone: '0912345678',
    );
    return _currentUser!;
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    
    final cleanEmail = email.trim().toLowerCase();
    if (name.trim().isEmpty) {
      throw Exception('Họ và tên không được để trống');
    }
    if (!cleanEmail.contains('@')) {
      throw Exception('Email không hợp lệ');
    }
    if (phone.trim().length < 9) {
      throw Exception('Số điện thoại không hợp lệ');
    }
    if (password.length < 6) {
      throw Exception('Mật khẩu tối thiểu 6 ký tự');
    }

    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: cleanEmail,
      phone: phone.trim(),
    );
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 150));
    _currentUser = null;
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 250));
    if (!email.contains('@')) {
      throw Exception('Email không tồn tại trong hệ thống');
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String name,
    required String phone,
    String? avatarUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_currentUser == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }
    _currentUser = _currentUser!.copyWith(
      name: name.trim(),
      phone: phone.trim(),
      avatarUrl: avatarUrl,
    );
    return _currentUser!;
  }
}
