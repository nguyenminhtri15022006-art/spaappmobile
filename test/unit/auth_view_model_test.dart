import 'package:flutter_test/flutter_test.dart';
import 'package:spa_marketplace/features/auth/data/mock_auth_repository.dart';
import 'package:spa_marketplace/features/auth/presentation/view_models/auth_state.dart';
import 'package:spa_marketplace/features/auth/presentation/view_models/auth_view_model.dart';

void main() {
  late MockAuthRepository repo;
  late AuthViewModel viewModel;

  setUp(() {
    repo = MockAuthRepository();
    viewModel = AuthViewModel(repo);
  });

  group('AuthViewModel & MockAuthRepository Tests', () {
    test('Khởi tạo ban đầu trạng thái là unauthenticated', () {
      expect(viewModel.state.isAuthenticated, isFalse);
      expect(viewModel.state.user, isNull);
    });

    test('Đăng nhập thành công với thông tin hợp lệ', () async {
      final success = await viewModel.login(
        email: 'minhtri@gmail.com',
        password: 'password123',
      );

      expect(success, isTrue);
      expect(viewModel.state.isAuthenticated, isTrue);
      expect(viewModel.state.user?.email, equals('minhtri@gmail.com'));
      expect(viewModel.state.status, equals(AuthStatus.authenticated));
    });

    test('Đăng nhập thất bại khi email không đúng định dạng', () async {
      final success = await viewModel.login(
        email: 'invalid_email_format',
        password: 'password123',
      );

      expect(success, isFalse);
      expect(viewModel.state.isAuthenticated, isFalse);
      expect(viewModel.state.status, equals(AuthStatus.error));
      expect(viewModel.state.errorMessage, isNotNull);
    });

    test('Đăng nhập thất bại khi mật khẩu dưới 6 ký tự', () async {
      final success = await viewModel.login(
        email: 'user@gmail.com',
        password: '123',
      );

      expect(success, isFalse);
      expect(viewModel.state.errorMessage, contains('6 ký tự'));
    });

    test('Đăng ký tài khoản thành công', () async {
      final success = await viewModel.register(
        name: 'Trần Thị Mai',
        email: 'thimai@gmail.com',
        phone: '0987654321',
        password: 'password123',
      );

      expect(success, isTrue);
      expect(viewModel.state.isAuthenticated, isTrue);
      expect(viewModel.state.user?.name, equals('Trần Thị Mai'));
    });

    test('Đăng ký thất bại khi để trống họ tên', () async {
      final success = await viewModel.register(
        name: '',
        email: 'thimai@gmail.com',
        phone: '0987654321',
        password: 'password123',
      );

      expect(success, isFalse);
      expect(viewModel.state.errorMessage, contains('Họ và tên'));
    });

    test('Đăng xuất xóa sạch thông tin người dùng', () async {
      await viewModel.login(email: 'minhtri@gmail.com', password: 'password123');
      expect(viewModel.state.isAuthenticated, isTrue);

      await viewModel.logout();
      expect(viewModel.state.isAuthenticated, isFalse);
      expect(viewModel.state.user, isNull);
    });

    test('Cập nhật hồ sơ cá nhân thành công', () async {
      await viewModel.login(email: 'minhtri@gmail.com', password: 'password123');
      final updated = await viewModel.updateProfile(
        name: 'Minh Trí Cập Nhật',
        phone: '0999888777',
      );

      expect(updated, isTrue);
      expect(viewModel.state.user?.name, equals('Minh Trí Cập Nhật'));
      expect(viewModel.state.user?.phone, equals('0999888777'));
    });
  });
}
