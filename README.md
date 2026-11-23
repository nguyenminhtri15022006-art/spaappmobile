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
2. **Bộ lọc địa điểm & khoảng cách:**
   - Lọc địa điểm áp dụng theo từng chi nhánh, không áp dụng cho địa chỉ chung của Spa.
   - Đơn vị hành chính theo mô hình 2 cấp: **Tỉnh/Thành phố → Xã/Phường/Thị trấn**.
   - Khi đổi Tỉnh/Thành phố, Xã/Phường đã chọn phải tự động reset về rỗng để tránh sai lệch mã địa bàn.
   - Bộ lọc khoảng cách tính theo khoảng cách địa lý thực tế (công thức Haversine tới tọa độ tham chiếu), không dùng số lượng chi nhánh để lọc hay sắp xếp.
3. **Tìm kiếm & Hiển thị kết quả:**
   - Hỗ trợ gõ tiếng Việt có dấu lẫn không dấu (ví dụ: gõ `goi dau` vẫn tìm được `Gội đầu dưỡng sinh`).
   - Không phân biệt chữ hoa/thường.
   - Nếu 1 Spa có nhiều chi nhánh cùng khớp với bộ lọc, **chỉ hiển thị 1 thẻ kết quả duy nhất** cho dịch vụ đó của Spa kèm số lượng chi nhánh phù hợp (ví dụ: `Lotus Bến Nghé (+2 chi nhánh)`), không nhân bản thẻ kết quả theo số chi nhánh.
4. **Kiến trúc Repository:**
   - Hiện tại logic dữ liệu nằm trong các Mock Repository: `MockSearchRepository`, `MockAdministrativeRepository`, `MockAuthRepository`, `MockBookingRepository`, `MockFavoritesRepository`, `MockNotificationRepository`.
   - Khi Backend hoàn thành REST API, chỉ cần tạo các Remote Repository implement các Interface tương ứng rồi thay đổi Provider trong Riverpod, không cần sửa UI hay ViewModel.
5. **Xử lý Not Found:**
   - Khi tìm kiếm Spa, Dịch vụ hoặc Chi nhánh bằng ID không hợp lệ, hệ thống luôn hiển thị `NotFoundView` thay vì tự động lấy phần tử đầu tiên.
6. **Xác thực & Bảo toàn Booking Draft:**
   - Cho phép khách vãng lai tự do xem Spa và Dịch vụ.
   - Khi bấm xác nhận đặt lịch, nếu chưa đăng nhập sẽ chuyển sang màn hình Đăng nhập kèm tham số `redirect`. Sau khi đăng nhập thành công sẽ tự động quay lại màn hình đặt lịch mà không làm mất Spa, Chi nhánh, Dịch vụ, ngày giờ và ghi chú đã chọn.

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
│   └── widgets/                # Button, StarRating, BadgeTag, AppDrawer, FavoriteButton, NotFoundView, SpaServiceCard, BranchCard, BookingSummaryCard
│
└── features/                   # Từng module chức năng
    ├── auth/                   # Xác thực tài khoản (Login, Register, ForgotPassword, Profile)
    │   ├── models/             # UserModel
    │   ├── data/               # AuthRepository, MockAuthRepository
    │   └── presentation/       # AuthViewModel, LoginScreen, RegisterScreen, ForgotPasswordScreen, ProfileScreen
    │
    ├── booking/                # Luồng đặt lịch & quản lý lịch hẹn
    │   ├── models/             # BookingModel, BookingDraft
    │   ├── data/               # BookingRepository, MockBookingRepository
    │   └── presentation/       # BookingDraftViewModel, MyBookingsViewModel, BookingFormScreen, BookingConfirmationScreen, BookingSuccessScreen, MyBookingsScreen, BookingDetailScreen
    │
    ├── favorites/              # Danh sách Spa yêu thích
    │   ├── data/               # FavoritesRepository, MockFavoritesRepository
    │   └── presentation/       # FavoritesViewModel, FavoritesScreen
    │
    ├── home/                   # Màn hình trang chủ (HomeScreen) kèm Hamburger Menu (AppDrawer)
    │
    ├── map/                    # Bản đồ chi nhánh (MapPlaceholderScreen)
    │
    ├── notifications/          # Thông báo người dùng (NotificationsScreen)
    │
    ├── search/                 # Module tìm kiếm & bộ lọc nâng cao
    │   ├── data/               # SearchRepository & MockSearchRepository
    │   ├── models/             # SpaSearchFilter, SpaServiceSearchResult
    │   └── presentation/       # SearchViewModel, SearchScreen, FilterBottomSheet...
    │
    └── spa_detail/             # Màn hình chi tiết Spa & Dịch vụ
        └── presentation/screens/
            ├── spa_detail_screen.dart        # Chi tiết Spa (highlight dịch vụ vừa chọn, nút yêu thích)
            ├── service_detail_screen.dart    # Chi tiết 1 dịch vụ cụ thể
            └── branch_selection_screen.dart  # Chọn chi nhánh (ưu tiên chi nhánh theo vùng lọc)
```

---

## 4. Danh sách Routes đầy đủ

- `/` : Trang chủ (`HomeScreen`).
- `/search` : Màn hình tìm kiếm & lọc nâng cao (`SearchScreen`). Hỗ trợ query `categoryId`.
- `/spa/:spaId` : Trang thông tin Spa (`SpaDetailScreen`), tự động làm nổi bật dịch vụ nếu có query `serviceId`.
- `/spa/:spaId/service/:serviceId` : Chi tiết một dịch vụ (`ServiceDetailScreen`).
- `/spa/:spaId/branch-select?serviceId=...` : Chọn chi nhánh phù hợp (`BranchSelectionScreen`).
- `/booking?spaId=...&serviceId=...&branchId=...` : Chọn ngày & giờ đặt lịch (`BookingFormScreen`).
- `/booking/confirm` : Màn hình xác nhận thông tin lịch hẹn (`BookingConfirmationScreen`).
- `/booking/success?bookingId=...` : Màn hình thông báo đặt lịch thành công (`BookingSuccessScreen`).
- `/my-bookings` : Danh sách lịch hẹn cá nhân (`MyBookingsScreen`).
- `/my-bookings/:bookingId` : Chi tiết lịch hẹn & hủy hẹn (`BookingDetailScreen`).
- `/favorites` : Danh sách Spa yêu thích (`FavoritesScreen`).
- `/notifications` : Danh sách thông báo (`NotificationsScreen`).
- `/map` : Bản đồ vị trí chi nhánh (`MapPlaceholderScreen`).
- `/login` : Màn hình đăng nhập (`LoginScreen`), hỗ trợ query `redirect`.
- `/register` : Màn hình đăng ký (`RegisterScreen`), hỗ trợ query `redirect`.
- `/forgot-password` : Khôi phục mật khẩu (`ForgotPasswordScreen`).
- `/profile` : Xem & chỉnh sửa hồ sơ cá nhân (`ProfileScreen`).

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
- **`vietnamese_utils_test.dart`**: Test bỏ dấu tiếng Việt, tìm kiếm không phân biệt hoa/thường, xóa khoảng trắng thừa.
- **`mock_search_repository_test.dart`**: Test tìm kiếm theo từ khóa, lọc theo địa bàn, không lặp chi nhánh, lọc giá, sắp xếp giá, tính khoảng cách Haversine và trả về null khi ID không hợp lệ.
- **`search_view_model_test.dart`**: Test reset phường/xã khi đổi tỉnh trong ViewModel, quản lý Draft vs Applied filter, Empty State.
- **`auth_view_model_test.dart`**: Test đăng nhập, đăng ký có validation, cập nhật hồ sơ, đăng xuất.
- **`booking_view_model_test.dart`**: Test lưu lịch hẹn vào Mock Repository, cập nhật trạng thái hủy lịch, lọc lịch hẹn theo trạng thái.
- **`favorites_view_model_test.dart`**: Test thêm/bớt yêu thích và đồng bộ trạng thái.
- **`app_drawer_test.dart`**: Test Hamburger menu render đầy đủ các mục điều hướng.
- **`not_found_view_test.dart`**: Test hiển thị Not Found khi ID không hợp lệ.
- **`search_widget_test.dart`**: Test giao diện SearchBar, BottomSheet lọc và Thẻ dịch vụ.

### Chạy ứng dụng trên máy ảo hoặc thiết bị thật
```bash
flutter run
```

---

## 6. Ghi chú khi phát triển tính năng mới

- Khi thêm màn hình mới, khai báo route vào `lib/core/router/app_router.dart`.
- Giữ đúng màu sắc thiết kế trong `lib/core/constants/app_colors.dart` (tone màu chủ đạo là `#557568` và nền `#FAF7F2`).
- Tránh viết logic lọc hay tính toán trực tiếp bên trong hàm `build()` của Widget; nên đưa vào ViewModel hoặc Repository.
