import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spa_marketplace/shared/widgets/app_drawer.dart';

void main() {
  group('AppDrawer Widget Tests', () {
    testWidgets('Hiển thị đầy đủ các mục menu điều hướng trong Hamburger Menu', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              drawer: AppDrawer(),
              body: Center(child: Text('Main Screen')),
            ),
          ),
        ),
      );

      // Mở Drawer
      final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      // Kiểm tra các mục menu theo đúng yêu cầu nghiệp vụ
      expect(find.text('Trang chủ'), findsOneWidget);
      expect(find.text('Tìm kiếm dịch vụ'), findsOneWidget);
      expect(find.text('Spa yêu thích'), findsOneWidget);
      expect(find.text('Lịch hẹn của tôi'), findsOneWidget);
      expect(find.text('Bản đồ chi nhánh'), findsOneWidget);
      expect(find.text('Thông báo'), findsOneWidget);
      expect(find.text('Đăng nhập / Đăng ký'), findsOneWidget);
    });
  });
}
