import '../../models/chat_message.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final String? errorMessage;
  final List<String> quickPrompts;

  const ChatState({
    this.messages = const [],
    this.isTyping = false,
    this.errorMessage,
    this.quickPrompts = const [
      'Gợi ý gói gội đầu dưỡng sinh',
      'Trị liệu đau vai gáy văn phòng',
      'Spa yên tĩnh cho cặp đôi',
      'Liệu trình phục hồi da mặt',
    ],
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    String? errorMessage,
    List<String>? quickPrompts,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      errorMessage: errorMessage,
      quickPrompts: quickPrompts ?? this.quickPrompts,
    );
  }
}
