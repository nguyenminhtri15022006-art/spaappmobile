import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spa_marketplace/core/router/app_router.dart';
import 'package:spa_marketplace/features/nearby/presentation/screens/nearby_screen.dart';
import 'package:spa_marketplace/features/booking/presentation/screens/my_bookings_screen.dart';
import 'package:spa_marketplace/features/chat/presentation/screens/ai_chat_screen.dart';
import 'package:spa_marketplace/features/auth/presentation/screens/profile_screen.dart';
import 'package:spa_marketplace/shared/widgets/main_scaffold_with_nav_bar.dart';

void main() {
  group('5-Tab Navigation Bar & Screens Widget Tests', () {
    testWidgets('Hiển thị đầy đủ 5 tab trên Bottom Navigation Bar theo đúng thứ tự', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: appRouter,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Kiểm tra sự xuất hiện của MainScaffoldWithNavBar
      expect(find.byType(MainScaffoldWithNavBar), findsOneWidget);

      // Kiểm tra đúng 5 tab trên thanh điều hướng Bottom Navigation Bar
      final bottomNav = find.byKey(const Key('main_bottom_nav_bar'));
      expect(find.descendant(of: bottomNav, matching: find.text('Trang chủ')), findsOneWidget);
      expect(find.descendant(of: bottomNav, matching: find.text('Gần đây')), findsOneWidget);
      expect(find.descendant(of: bottomNav, matching: find.text('Lịch hẹn')), findsOneWidget);
      expect(find.descendant(of: bottomNav, matching: find.text('AI tư vấn')), findsOneWidget);
      expect(find.descendant(of: bottomNav, matching: find.text('Cá nhân')), findsOneWidget);

      // Tab 1 mặc định được chọn và hiển thị Trang chủ
      expect(find.text('Spa Marketplace'), findsOneWidget);

      // Kiểm tra AppBar Trang chủ có icon chuông thông báo
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    });

    testWidgets('Chuyển sang Tab 2 (Gần đây) hiển thị màn hình NearbyScreen và bộ lọc bán kính', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: appRouter,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Nhấn vào Tab "Gần đây"
      await tester.tap(find.text('Gần đây'));
      await tester.pumpAndSettle();

      // Kiểm tra NearbyScreen xuất hiện
      expect(find.byType(NearbyScreen), findsOneWidget);
      expect(find.text('Spa gần bạn'), findsOneWidget);
      expect(find.text('Vị trí của bạn'), findsOneWidget);

      // Kiểm tra các chip bán kính
      expect(find.text('1 km'), findsOneWidget);
      expect(find.text('3 km'), findsOneWidget);
      expect(find.text('5 km'), findsOneWidget);
      expect(find.text('10 km'), findsOneWidget);
    });

    testWidgets('Chuyển sang Tab 3 (Lịch hẹn) hiển thị nút "+ Đặt lịch mới" và các nhóm Sắp tới/Lịch sử', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: appRouter,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Nhấn vào Tab "Lịch hẹn"
      await tester.tap(find.descendant(
        of: find.byKey(const Key('main_bottom_nav_bar')),
        matching: find.text('Lịch hẹn'),
      ));
      await tester.pumpAndSettle();

      // Kiểm tra MyBookingsScreen xuất hiện
      expect(find.byType(MyBookingsScreen), findsOneWidget);
      expect(find.text('Lịch hẹn của tôi'), findsOneWidget);

      // Nút "+ Đặt lịch mới"
      expect(find.text('Đặt lịch mới'), findsOneWidget);

      // Nhóm tab chính: Sắp tới & Lịch sử
      expect(find.text('Sắp tới'), findsOneWidget);
      expect(find.text('Lịch sử'), findsOneWidget);
    });

    testWidgets('Chuyển sang Tab 4 (AI tư vấn) hiển thị Trợ lý AI và gợi ý câu hỏi nhanh', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: appRouter,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Nhấn vào Tab "AI tư vấn"
      await tester.tap(find.text('AI tư vấn'));
      await tester.pumpAndSettle();

      // Kiểm tra AiChatScreen xuất hiện
      expect(find.byType(AiChatScreen), findsOneWidget);
      expect(find.text('Trợ lý AI Luxury Wellness'), findsOneWidget);
      expect(find.text('Đang trực tuyến • Sẵn sàng tư vấn'), findsOneWidget);

      // Kiểm tra gợi ý câu hỏi nhanh
      expect(find.text('Gợi ý gói gội đầu dưỡng sinh'), findsOneWidget);
      expect(find.text('Trị liệu đau vai gáy văn phòng'), findsOneWidget);
    });

    testWidgets('Chuyển sang Tab 5 (Cá nhân) KHÔNG chứa Thông báo và KHÔNG lặp lại Lịch hẹn', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: appRouter,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Nhấn vào Tab "Cá nhân"
      await tester.tap(find.text('Cá nhân'));
      await tester.pumpAndSettle();

      // Kiểm tra ProfileScreen hiển thị
      expect(find.byType(ProfileScreen), findsOneWidget);

      // KIỂM TRA ĐẶC BIỆT THEO YÊU CẦU:
      // Không được chứa 'Thông báo' trong Tab Cá nhân (chỉ có ở chuông AppBar Home)
      expect(find.widgetWithText(ListTile, 'Thông báo'), findsNothing);

      // Không được lặp lại 'Lịch hẹn của tôi' dạng ListTile trong Tab Cá nhân
      expect(find.widgetWithText(ListTile, 'Lịch hẹn của tôi'), findsNothing);
    });
  });
}
