import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spa_marketplace/features/search/models/spa_search_filter.dart';
import 'package:spa_marketplace/features/search/models/spa_service_search_result.dart';
import 'package:spa_marketplace/features/search/presentation/screens/search_screen.dart';
import 'package:spa_marketplace/features/search/presentation/widgets/filter_chip_bar.dart';
import 'package:spa_marketplace/features/search/presentation/widgets/location_dropdown_selector.dart';
import 'package:spa_marketplace/features/search/presentation/widgets/location_quick_scroll_bar.dart';
import 'package:spa_marketplace/features/search/presentation/widgets/price_range_filter.dart';
import 'package:spa_marketplace/features/search/presentation/widgets/quick_filter_sheets.dart';
import 'package:spa_marketplace/features/search/presentation/widgets/search_bar_widget.dart';
import 'package:spa_marketplace/features/search/presentation/widgets/search_result_card.dart';
import 'package:spa_marketplace/shared/data/mock_administrative_repository.dart';
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

    testWidgets('SearchBarWidget hỗ trợ nhập tiếng Việt có dấu đầy đủ', (tester) async {
      final controller = TextEditingController(text: '');
      String lastChangedText = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              onChanged: (val) => lastChangedText = val,
              onSubmitted: (_) {},
              onClear: () {},
              onFilterTap: () {},
            ),
          ),
        ),
      );

      // Nhập chuỗi tiếng Việt có dấu
      await tester.enterText(find.byType(TextField), 'Gội đầu dưỡng sinh');
      expect(controller.text, equals('Gội đầu dưỡng sinh'));
      expect(lastChangedText, equals('Gội đầu dưỡng sinh'));
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
      await tester.pump(const Duration(milliseconds: 200));
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

    testWidgets('FilterChipBar kích hoạt đúng callback riêng biệt cho từng Quick Filter', (tester) async {
      tester.view.physicalSize = const Size(1600, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      bool catTapped = false;
      bool ratingTapped = false;
      bool sortTapped = false;
      bool locationTapped = false;
      bool priceTapped = false;
      bool allTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterChipBar(
              filter: const SpaSearchFilter(),
              adminRepo: MockAdministrativeRepository(),
              onOpenAllFilters: () => allTapped = true,
              onCategoryTap: () => catTapped = true,
              onRatingTap: () => ratingTapped = true,
              onSortTap: () => sortTapped = true,
              onLocationTap: () => locationTapped = true,
              onPriceTap: () => priceTapped = true,
            ),
          ),
        ),
      );

      // Nhấn chip Danh mục
      await tester.tap(find.text('Danh mục'));
      expect(catTapped, isTrue);

      // Nhấn chip Đánh giá
      await tester.tap(find.text('Đánh giá'));
      expect(ratingTapped, isTrue);

      // Nhấn chip Sắp xếp
      await tester.tap(find.text('Liên quan nhất'));
      expect(sortTapped, isTrue);

      // Nhấn chip Địa điểm
      await tester.tap(find.text('Địa điểm'));
      expect(locationTapped, isTrue);

      // Nhấn chip Khoảng giá
      await tester.tap(find.text('Khoảng giá'));
      expect(priceTapped, isTrue);

      // Nhấn Tất cả bộ lọc
      await tester.tap(find.text('Tất cả bộ lọc'));
      expect(allTapped, isTrue);
    });

    testWidgets('CategoryQuickFilterSheet hiển thị danh sách danh mục và áp dụng', (tester) async {
      String? appliedCat;
      bool resetCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryQuickFilterSheet(
              initialCategoryId: null,
              onApply: (catId) => appliedCat = catId,
              onReset: () => resetCalled = true,
            ),
          ),
        ),
      );

      expect(find.text('Danh mục dịch vụ'), findsOneWidget);
      expect(find.text('Gội đầu dưỡng sinh'), findsOneWidget);
      expect(find.text('Massage Body & Trị liệu'), findsOneWidget);

      // Chọn danh mục Gội đầu dưỡng sinh
      await tester.tap(find.text('Gội đầu dưỡng sinh'));
      await tester.pump();

      // Bấm nút Áp dụng danh mục
      await tester.tap(find.text('Áp dụng danh mục'));
      expect(appliedCat, equals('cat_goidau'));
      expect(resetCalled, isFalse);
    });

    testWidgets('RatingQuickFilterSheet hiển thị mức đánh giá và áp dụng', (tester) async {
      double? appliedRating;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RatingQuickFilterSheet(
              initialRating: null,
              onApply: (r) => appliedRating = r,
              onReset: () {},
            ),
          ),
        ),
      );

      expect(find.text('Đánh giá Spa'), findsOneWidget);
      expect(find.text('Từ 4★'), findsOneWidget);

      await tester.tap(find.text('Từ 4★'));
      await tester.pump();

      await tester.tap(find.text('Áp dụng mức đánh giá'));
      expect(appliedRating, equals(4.0));
    });

    testWidgets('SearchScreen KHÔNG hiển thị LocationQuickScrollBar', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Đảm bảo không còn LocationQuickScrollBar trên SearchScreen
      expect(find.byType(LocationQuickScrollBar), findsNothing);
      await tester.pump(const Duration(milliseconds: 300));
    });

    testWidgets('LocationDropdownSelector hiển thị 2 dropdown Tỉnh và Phường', (tester) async {
      String? changedProvince;
      String? changedWard;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationDropdownSelector(
              selectedProvinceCode: null,
              selectedWardCode: null,
              repository: MockAdministrativeRepository(),
              onProvinceChanged: (p) => changedProvince = p,
              onWardChanged: (w) => changedWard = w,
            ),
          ),
        ),
      );

      expect(find.text('Tỉnh / Thành phố'), findsOneWidget);
      expect(find.text('Phường / Xã / Đặc khu'), findsOneWidget);
      expect(find.text('Tất cả Tỉnh / Thành phố'), findsOneWidget);
      expect(find.text('Vui lòng chọn Tỉnh/Thành phố trước'), findsOneWidget);
      expect(changedProvince, isNull);
      expect(changedWard, isNull);
    });
  });
}
