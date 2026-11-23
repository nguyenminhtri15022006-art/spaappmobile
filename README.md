# Spa Marketplace Mobile (Frontend)

Ứng dụng di động tìm kiếm và đặt lịch dịch vụ spa, massage, gội đầu dưỡng sinh. Dự án hiện tại phụ trách phần **Frontend (Flutter)**, giao diện theo phong cách Luxury Wellness và đang kết nối qua **Mock Data** độc lập trước khi tích hợp API từ Backend.

---

## 1. Công nghệ sử dụng

- **Framework:** Flutter (Dart SDK >= 3.0.0)
- **Quản lý State:** `flutter_riverpod` (StateNotifierProvider)
- **Điều hướng (Routing):** `go_router`
- **Định dạng tiền tệ / ngày tháng:** `intl`

---

## 2. Quy tắc nghiệp vụ cần lưu ý khi phát triển tiếp

Anh em làm cùng dự án (đặc biệt khi ghép nối với Backend/Database) lưu ý các quan hệ dữ liệu sau:

1. **Quan hệ Spa - Chi nhánh - Dịch vụ:**
   - 1 Spa có nhiều chi nhánh (`SpaBranch`).
   - 1 Spa có nhiều dịch vụ (`SpaService`).
   - Các chi nhánh trong cùng 1 Spa dùng chung danh mục dịch vụ và bảng giá.
   - Mỗi chi nhánh có địa chỉ, toạ độ GPS riêng.
2. **Bộ lọc địa điểm:**
   - Lọc địa điểm áp dụng theo từng chi nhánh, không áp dụng cho địa chỉ chung của Spa.
   - Đơn vị hành chính theo mô hình 2 cấp: **Tỉnh/Thành phố → Xã/Phường/Thị trấn**.
   - Khi đổi Tỉnh/Thành phố, Xã/Phường đã chọn phải tự động reset về rỗng để tránh sai lệch mã địa bàn.
3. **Tìm kiếm & Hiển thị kết quả:**
   - Hỗ trợ gõ tiếng Việt có dấu lẫn không dấu (ví dụ: gõ `goi dau` vẫn tìm được `Gội đầu dưỡng sinh`).
   - Không phân biệt chữ hoa/thường.
   - Nếu 1 Spa có nhiều chi nhánh cùng khớp với bộ lọc, **chỉ hiển thị 1 thẻ kết quả duy nhất** cho dịch vụ đó của Spa kèm số lượng chi nhánh phù hợp (ví dụ: `Lotus Bến Nghé (+2 chi nhánh)`), không nhân bản thẻ kết quả theo số chi nhánh.
4. **Kiến trúc Repository:**
   - Hiện tại logic lấy dữ liệu nằm trong `MockSearchRepository` và `MockAdministrativeRepository`.
   - Khi Backend làm xong API, chỉ cần tạo `RemoteSearchRepository` implement interface `SearchRepository` rồi đổi dependency trong Riverpod Provider (`searchRepositoryProvider`), không cần sửa UI hay ViewModel.

---

## 3. Cấu trúc thư mục

Dự án tổ chức theo mô hình **Feature-first**:

```text
lib/
├── core/                       # Cấu hình dùng chung toàn app
│   ├── constants/              # Bảng màu (app_colors.dart), typography (app_text_styles.dart)
│   ├── theme/                  # Theme Material 3
│   ├── utils/                  # Xử lý tiếng Việt không dấu, format tiền VNĐ, debouncer
│   └── router/                 # Cấu hình routes GoRouter (app_router.dart)
│
├── shared/                     # Dùng chung giữa các màn hình
│   ├── models/                 # Spa, SpaBranch, SpaService, ServiceCategory, AdministrativeUnit
│   ├── data/                   # Mock data danh sách spa, chi nhánh, dịch vụ và đơn vị hành chính
│   └── widgets/                # Button, thẻ đánh giá sao, tag chi nhánh
│
└── features/                   # Từng module chức năng
    ├── home/                   # Màn hình trang chủ (HomeScreen)
    │
    ├── search/                 # Module tìm kiếm & bộ lọc nâng cao
    │   ├── data/               # SearchRepository & MockSearchRepository
    │   ├── models/             # SpaSearchFilter, SpaServiceSearchResult
    │   └── presentation/
    │       ├── view_models/    # SearchViewModel, SearchState (quản lý DraftFilter vs AppliedFilter)
    │       ├── widgets/        # SearchBar, FilterChipBar, FilterBottomSheet, ResultCard...
    │       └── screens/        # SearchScreen
    │
    └── spa_detail/             # Màn hình chi tiết Spa & Đặt lịch
        └── presentation/screens/
            ├── spa_detail_screen.dart        # Chi tiết Spa (highlight dịch vụ vừa chọn)
            ├── branch_selection_screen.dart  # Chọn chi nhánh (ưu tiên chi nhánh theo vùng lọc)
            └── booking_draft_screen.dart     # Xác nhận đặt lịch giả lập
```

---

## 4. Các luồng màn hình chính (Routes)

- `/` : Trang chủ (`HomeScreen`).
- `/search` : Màn hình tìm kiếm & lọc nâng cao (`SearchScreen`).
- `/spa/:spaId?serviceId=...` : Trang thông tin Spa (`SpaDetailScreen`), tự động làm nổi bật dịch vụ nếu được bấm từ kết quả tìm kiếm.
- `/spa/:spaId/branch-select?serviceId=...` : Chọn chi nhánh phù hợp để đặt lịch (`BranchSelectionScreen`).
- `/booking?spaId=...&serviceId=...&branchId=...` : Xác nhận đặt hẹn (`BookingDraftScreen`).

---

## 5. Hướng dẫn chạy và test dự án

### Cài đặt package
```bash
flutter pub get
```

### Chạy kiểm thử tự động
Toàn bộ unit test và widget test nằm trong thư mục `test/`:
```bash
flutter test
```
Bao gồm:
- Test bỏ dấu tiếng Việt và tìm kiếm không phân biệt hoa/thường.
- Test lọc theo địa bàn chi nhánh, không nhân bản kết quả khi Spa có nhiều chi nhánh.
- Test reset phường/xã khi đổi tỉnh trong ViewModel.
- Test khoảng giá, sắp xếp giá tăng/giảm dần.
- Test giao diện SearchBar, BottomSheet lọc và Thẻ dịch vụ.

### Chạy ứng dụng trên máy ảo hoặc thiết bị thật
```bash
flutter run
```

---

## 6. Ghi chú khi phát triển tính năng mới

- Khi thêm màn hình mới, khai báo route vào `lib/core/router/app_router.dart`.
- Giữ đúng màu sắc thiết kế trong `lib/core/constants/app_colors.dart` (tone màu chủ đạo là `#557568` và nền `#FAF7F2`).
- Tránh viết logic lọc hay tính toán trực tiếp bên trong hàm `build()` của Widget; nên đưa vào ViewModel hoặc Repository.
