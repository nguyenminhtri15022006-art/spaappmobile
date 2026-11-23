import 'dart:convert';
import 'auth_repository.dart';
import '../models/user_model.dart';

class _MockAccountRecord {
  final UserModel user;
  final String passwordHash;

  const _MockAccountRecord({
    required this.user,
    required this.passwordHash,
  });
}

class MockAuthRepository implements AuthRepository {
  UserModel? _currentUser;

  // Mô phỏng băm mật khẩu một chiều (không lưu plaintext password vào bộ nhớ lâu dài)
  static String _hashPassword(String email, String password) {
    final salt = 'spa_mock_salt_${email.trim().toLowerCase()}_';
    final bytes = utf8.encode('$salt$password');
    return base64.encode(bytes);
  }

  // Danh sách tài khoản đã đăng ký giả lập trong hệ thống
  static final Map<String, _MockAccountRecord> _initialAccounts = {
    'minhtri@gmail.com': _MockAccountRecord(
      user: const UserModel(
        id: 'user_demo_001',
        name: 'Nguyễn Minh Trí',
        email: 'minhtri@gmail.com',
        phone: '0901234567',
        avatarUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
      ),
      passwordHash: _hashPassword('minhtri@gmail.com', '123456'),
    ),
    'demo@spa.vn': _MockAccountRecord(
      user: const UserModel(
        id: 'user_demo_002',
        name: 'Khách hàng Demo',
        email: 'demo@spa.vn',
        phone: '0912345678',
        avatarUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
      ),
      passwordHash: _hashPassword('demo@spa.vn', '123456'),
    ),
  };

  final Map<String, _MockAccountRecord> _registeredAccounts = {};

  MockAuthRepository({bool startLoggedIn = false}) {
    _registeredAccounts.addAll(_initialAccounts);
    if (startLoggedIn) {
      _currentUser = _initialAccounts['minhtri@gmail.com']?.user;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 60));
    return _currentUser;
  }

  @override
  Future<UserModel> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 250));

    final cleanEmail = email.trim().toLowerCase();
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      throw Exception('Email không đúng định dạng');
    }
    if (password.length < 6) {
      throw Exception('Mật khẩu phải có ít nhất 6 ký tự');
    }

    final record = _registeredAccounts[cleanEmail];
    if (record == null) {
      throw Exception(
        'Tài khoản "$cleanEmail" chưa được đăng ký trong hệ thống Mock Demo. '
        'Vui lòng đăng ký tài khoản mới hoặc sử dụng tài khoản Demo: minhtri@gmail.com / 123456',
      );
    }

    final inputHash = _hashPassword(cleanEmail, password);
    if (record.passwordHash != inputHash) {
      throw Exception('Mật khẩu không chính xác. Vui lòng thử lại.');
    }

    _currentUser = record.user;
    return _currentUser!;
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final cleanEmail = email.trim().toLowerCase();
    final cleanName = name.trim();
    final cleanPhone = phone.trim();

    if (cleanName.isEmpty) {
      throw Exception('Họ và tên không được để trống');
    }
    if (!cleanEmail.contains('@')) {
      throw Exception('Email không hợp lệ');
    }
    if (cleanPhone.length < 9) {
      throw Exception('Số điện thoại không hợp lệ (tối thiểu 9 chữ số)');
    }
    if (password.length < 6) {
      throw Exception('Mật khẩu tối thiểu 6 ký tự');
    }

    if (_registeredAccounts.containsKey(cleanEmail)) {
      throw Exception('Email "$cleanEmail" đã được đăng ký trong hệ thống');
    }

    final newUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: cleanName,
      email: cleanEmail,
      phone: cleanPhone,
    );

    // Lưu mật khẩu dưới dạng băm một chiều
    _registeredAccounts[cleanEmail] = _MockAccountRecord(
      user: newUser,
      passwordHash: _hashPassword(cleanEmail, password),
    );

    _currentUser = newUser;
    return newUser;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _currentUser = null;
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final cleanEmail = email.trim().toLowerCase();
    if (!cleanEmail.contains('@') || !_registeredAccounts.containsKey(cleanEmail)) {
      throw Exception('Email "$cleanEmail" không tồn tại trong hệ thống');
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String name,
    required String phone,
    String? avatarUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (_currentUser == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    final cleanEmail = _currentUser!.email;
    final updated = _currentUser!.copyWith(
      name: name.trim(),
      phone: phone.trim(),
      avatarUrl: avatarUrl,
    );

    _currentUser = updated;
    final existing = _registeredAccounts[cleanEmail];
    if (existing != null) {
      _registeredAccounts[cleanEmail] = _MockAccountRecord(
        user: updated,
        passwordHash: existing.passwordHash,
      );
    }

    return updated;
  }
}
