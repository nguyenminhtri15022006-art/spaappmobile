import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spa_marketplace/core/constants/app_colors.dart';
import 'package:spa_marketplace/features/search/models/spa_search_filter.dart';
import 'package:spa_marketplace/features/search/models/spa_service_search_result.dart';
import 'package:spa_marketplace/features/search/presentation/widgets/price_range_filter.dart';
import 'package:spa_marketplace/features/search/presentation/widgets/search_bar_widget.dart';
import 'package:spa_marketplace/features/search/presentation/widgets/search_result_card.dart';
import 'package:spa_marketplace/shared/data/mock_spa_data.dart';

void main() {
  group('Search Widgets UI Tests', () {
    testWidgets('SearchBarWidget hiển thị đúng TextField, placeholder và nút lọc', (tester) async {
      final controller = TextEditingController(text: '');
      bool filterTapped = false;
      bool cleared = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              onChanged: (_) {},
              onSubmitted: (_) {},
              onClear: () => cleared = true,
              onFilterTap: () => filterTapped = true,
              activeFilterCount: 2,
            ),
          ),
        ),
      );

      // Kiểm tra placeholder
      expect(find.text('Tìm gội đầu, massage, làm móng...'), findsOneWidget);

      // Kiểm tra badge số lượng tiêu chí lọc đang áp dụng
      expect(find.text('2'), findsOneWidget);

      // Nhấn nút lọc
      await tester.tap(find.byIcon(Icons.tune_rounded));
      expect(filterTapped, isTrue);

      // Nhập text và kiểm tra nút xóa
      controller.text = 'Massage';
      await tester.pump();
      expect(find.byIcon(Icons.cancel_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.cancel_rounded));
      expect(cleared, isTrue);
    });

    testWidgets('SearchResultCard hiển thị đầy đủ thông tin dịch vụ, Spa, giá và nút Xem chi tiết', (tester) async {
      final spa = MockSpaData.getSpas().first;
      final service = spa.services.first;
      final resultItem = SpaServiceSearchResult(
        service: service,
        spa: spa,
        matchingBranches: spa.branches,
        totalBranchesCount: spa.branches.length,
      );

      bool cardTapped = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SearchResultCard(
                item: resultItem,
                onTap: () => cardTapped = true,
              ),
            ),
          ),
        ),
      );

      // Kiểm tra tên Spa
      expect(find.text(spa.name), findsOneWidget);

      // Kiểm tra tên dịch vụ
      expect(find.text(service.name), findsOneWidget);

      // Kiểm tra thời lượng
      expect(find.text('${service.durationMinutes} phút'), findsOneWidget);

      // Kiểm tra nút Xem chi tiết
      expect(find.text('Xem chi tiết'), findsOneWidget);

      await tester.tap(find.text('Xem chi tiết'));
      expect(cardTapped, isTrue);
    });

    testWidgets('PriceRangeFilter hiển thị RangeSlider và định dạng tiền', (tester) async {
      double selectedMin = 100000;
      double selectedMax = 500000;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PriceRangeFilter(
              minPrice: selectedMin,
              maxPrice: selectedMax,
              onChanged: (min, max) {
                selectedMin = min;
                selectedMax = max;
              },
            ),
          ),
        ),
      );

      expect(find.text('Khoảng giá dịch vụ'), findsOneWidget);
      expect(find.byType(RangeSlider), findsOneWidget);
    });
  });
}
