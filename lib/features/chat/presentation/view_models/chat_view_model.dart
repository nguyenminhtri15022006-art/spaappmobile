import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/chat_message.dart';
import '../../repositories/chat_repository.dart';
import 'chat_state.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return MockChatRepository();
});

final chatViewModelProvider =
    StateNotifierProvider<ChatViewModel, ChatState>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return ChatViewModel(repo);
});

class ChatViewModel extends StateNotifier<ChatState> {
  final ChatRepository _repository;

  ChatViewModel(this._repository) : super(const ChatState()) {
    _initWelcomeMessage();
  }

  void _initWelcomeMessage() {
    final welcomeMsg = ChatMessage(
      id: 'welcome',
      text: 'Xin chào quý khách! Tôi là trợ lý AI chuyên về chăm sóc sức khỏe và thư giãn Luxury Wellness. Hôm nay quý khách cần tìm liệu trình phục hồi, gội đầu dưỡng sinh, hay dịch vụ massage nào?',
      isUser: false,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(messages: [welcomeMsg]);
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isTyping) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isTyping: true,
      errorMessage: null,
    );

    try {
      final aiResponse = await _repository.sendMessage(
        trimmed,
        history: state.messages,
      );

      state = state.copyWith(
        messages: [...state.messages, aiResponse],
        isTyping: false,
      );
    } catch (e) {
      state = state.copyWith(
        isTyping: false,
        errorMessage: 'Đã có lỗi xảy ra khi kết nối tới trợ lý AI. Vui lòng thử lại.',
      );
    }
  }

  void resetChat() {
    _initWelcomeMessage();
  }
}
