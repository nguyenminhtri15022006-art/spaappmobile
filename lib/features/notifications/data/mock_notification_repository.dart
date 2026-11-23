import '../models/notification_item.dart';

class MockNotificationRepository {
  final List<NotificationItem> _items = [
    NotificationItem(
      id: 'noti_1',
      title: 'Đặt lịch thành công!',
      message: 'Lịch hẹn của bạn tại Lotus Wellness Spa vào 14:30 ngày mai đã được xác nhận.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      type: 'booking',
    ),
    NotificationItem(
      id: 'noti_2',
      title: 'Ưu đãi tháng 11',
      message: 'Nhận ngay mã giảm giá 30% cho dịch vụ Gội đầu dưỡng sinh canh thuốc Dao Đỏ.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      type: 'promo',
    ),
    NotificationItem(
      id: 'noti_3',
      title: 'Chào mừng bạn đến với Spa Marketplace',
      message: 'Khám phá hàng trăm liệu trình chăm sóc sức khỏe và thư giãn cao cấp gần bạn.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      type: 'system',
    ),
  ];

  Future<List<NotificationItem>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_items);
  }

  Future<void> markAsRead(String id) async {
    final index = _items.indexWhere((n) => n.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(isRead: true);
    }
  }

  Future<void> markAllAsRead() async {
    for (int i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(isRead: true);
    }
  }
}
