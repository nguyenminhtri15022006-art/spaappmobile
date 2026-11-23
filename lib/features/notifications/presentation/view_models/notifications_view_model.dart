import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_notification_repository.dart';
import '../../models/notification_item.dart';

final notificationRepositoryProvider = Provider<MockNotificationRepository>((ref) {
  return MockNotificationRepository();
});

class NotificationsState {
  final List<NotificationItem> notifications;
  final bool isLoading;

  const NotificationsState({
    this.notifications = const [],
    this.isLoading = false,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationsState copyWith({
    List<NotificationItem>? notifications,
    bool? isLoading,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final notificationsViewModelProvider =
    StateNotifierProvider<NotificationsViewModel, NotificationsState>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return NotificationsViewModel(repo);
});

class NotificationsViewModel extends StateNotifier<NotificationsState> {
  final MockNotificationRepository _repository;

  NotificationsViewModel(this._repository) : super(const NotificationsState()) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true);
    final items = await _repository.getNotifications();
    state = state.copyWith(notifications: items, isLoading: false);
  }

  Future<void> markAsRead(String id) async {
    await _repository.markAsRead(id);
    await loadNotifications();
  }

  Future<void> markAllAsRead() async {
    await _repository.markAllAsRead();
    await loadNotifications();
  }
}
