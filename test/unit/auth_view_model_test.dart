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

    test('Đăng nhập thành công với tài khoản Demo có sẵn', () async {
      final success = await viewModel.login(
        email: 'minhtri@gmail.com',
        password: '123456',
      );

      expect(success, isTrue);
      expect(viewModel.state.isAuthenticated, isTrue);
      expect(viewModel.state.user?.email, equals('minhtri@gmail.com'));
      expect(viewModel.state.status, equals(AuthStatus.authenticated));
    });

    test('Đăng nhập thất bại khi tài khoản chưa được đăng ký trong hệ thống Mock', () async {
      final success = await viewModel.login(
        email: 'unregistered_person@gmail.com',
        password: '123456',
      );

      expect(success, isFalse);
      expect(viewModel.state.isAuthenticated, isFalse);
      expect(viewModel.state.status, equals(AuthStatus.error));
      expect(viewModel.state.errorMessage, contains('chưa được đăng ký'));
    });

    test('Đăng nhập thất bại khi sai mật khẩu của tài khoản Demo', () async {
      final success = await viewModel.login(
        email: 'minhtri@gmail.com',
        password: 'wrong_password_999',
      );

      expect(success, isFalse);
      expect(viewModel.state.isAuthenticated, isFalse);
      expect(viewModel.state.status, equals(AuthStatus.error));
      expect(viewModel.state.errorMessage, contains('Mật khẩu không chính xác'));
    });

    test('Đăng nhập thất bại khi email không đúng định dạng', () async {
      final success = await viewModel.login(
        email: 'invalid_email_format',
        password: '123456',
      );

      expect(success, isFalse);
      expect(viewModel.state.isAuthenticated, isFalse);
      expect(viewModel.state.status, equals(AuthStatus.error));
      expect(viewModel.state.errorMessage, isNotNull);
    });

    test('Đăng ký tài khoản mới thành công và cho phép đăng nhập lại', () async {
      // 1. Đăng ký tài khoản mới
      final regSuccess = await viewModel.register(
        name: 'Trần Thị Mai',
        email: 'thimai@gmail.com',
        phone: '0987654321',
        password: 'mypassword123',
      );

      expect(regSuccess, isTrue);
      expect(viewModel.state.isAuthenticated, isTrue);
      expect(viewModel.state.user?.name, equals('Trần Thị Mai'));

      // 2. Đăng xuất
      await viewModel.logout();
      expect(viewModel.state.isAuthenticated, isFalse);

      // 3. Đăng nhập lại với thông tin vừa đăng ký
      final loginSuccess = await viewModel.login(
        email: 'thimai@gmail.com',
        password: 'mypassword123',
      );
      expect(loginSuccess, isTrue);
      expect(viewModel.state.isAuthenticated, isTrue);
      expect(viewModel.state.user?.email, equals('thimai@gmail.com'));
    });

    test('Đăng ký thất bại khi trùng email đã tồn tại', () async {
      final success = await viewModel.register(
        name: 'Trùng Email',
        email: 'minhtri@gmail.com', // Email demo đã tồn tại
        phone: '0988776655',
        password: '123456',
      );

      expect(success, isFalse);
      expect(viewModel.state.errorMessage, contains('đã được đăng ký'));
    });

    test('Đăng ký thất bại khi để trống họ tên', () async {
      final success = await viewModel.register(
        name: '',
        email: 'newuser@gmail.com',
        phone: '0987654321',
        password: '123456',
      );

      expect(success, isFalse);
      expect(viewModel.state.errorMessage, contains('Họ và tên'));
    });

    test('Đăng xuất xóa sạch thông tin người dùng', () async {
      await viewModel.login(email: 'minhtri@gmail.com', password: '123456');
      expect(viewModel.state.isAuthenticated, isTrue);

      await viewModel.logout();
      expect(viewModel.state.isAuthenticated, isFalse);
      expect(viewModel.state.user, isNull);
    });

    test('Cập nhật hồ sơ cá nhân thành công', () async {
      await viewModel.login(email: 'minhtri@gmail.com', password: '123456');
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
