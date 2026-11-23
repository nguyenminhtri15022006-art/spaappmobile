import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spa_marketplace/shared/widgets/not_found_view.dart';

void main() {
  group('NotFoundView Widget Tests', () {
    testWidgets('Hiển thị tiêu đề và thông báo khi không tìm thấy dữ liệu', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NotFoundView(
              title: 'Không tìm thấy Spa',
              message: 'Mã Spa không tồn tại trong hệ thống.',
            ),
          ),
        ),
      );

      expect(find.text('Không tìm thấy Spa'), findsOneWidget);
      expect(find.text('Mã Spa không tồn tại trong hệ thống.'), findsOneWidget);
      expect(find.text('Về trang chủ'), findsOneWidget);
      expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
    });
  });
}
