import '../../../shared/data/mock_spa_data.dart';
import '../models/chat_message.dart';

abstract class ChatRepository {
  Future<ChatMessage> sendMessage(String text, {List<ChatMessage> history = const []});
}

class MockChatRepository implements ChatRepository {
  @override
  Future<ChatMessage> sendMessage(String text, {List<ChatMessage> history = const []}) async {
    // Simulate thinking/typing latency
    await Future.delayed(const Duration(milliseconds: 900));

    final lower = text.toLowerCase();
    final spas = MockSpaData.getSpas();

    if (lower.contains('gội đầu') || lower.contains('goi dau') || lower.contains('tóc') || lower.contains('da đầu')) {
      final lotus = spas.firstWhere((s) => s.id == 'spa_lotus');
      final srv = lotus.services.firstWhere((s) => s.id == 'srv_lotus_gd60');

      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Chào bạn, với nhu cầu chăm sóc tóc và thư giãn sâu, mình gợi ý liệu trình Gội đầu dưỡng sinh thảo mộc tại Lotus Wellness Spa. Liệu trình sử dụng nước nấu từ bồ kết và sả chanh tự nhiên kết hợp ấn huyệt vùng đầu cổ giúp giải tỏa căng thẳng rất tốt.',
        isUser: false,
        timestamp: DateTime.now(),
        recommendedSpaId: lotus.id,
        recommendedSpaName: lotus.name,
        recommendedServiceId: srv.id,
        recommendedServiceName: srv.name,
        recommendedPrice: srv.price,
        recommendedImageUrl: srv.imageUrl,
      );
    }

    if (lower.contains('vai gáy') || lower.contains('vai gay') || lower.contains('đau mỏi') || lower.contains('dau moi') || lower.contains('văn phòng')) {
      final green = spas.firstWhere((s) => s.id == 'spa_green');
      final srv = green.services.firstWhere((s) => s.id == 'srv_green_cvg60');

      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Đau mỏi cổ vai gáy là vấn đề rất phổ biến của người làm việc văn phòng. Green Spa & Therapy có liệu trình Trị liệu cổ vai gáy chuyên sâu kết hợp chườm ngải cứu thảo dược giúp đả thông kinh lạc và giảm đau mỏi tức thì.',
        isUser: false,
        timestamp: DateTime.now(),
        recommendedSpaId: green.id,
        recommendedSpaName: green.name,
        recommendedServiceId: srv.id,
        recommendedServiceName: srv.name,
        recommendedPrice: srv.price,
        recommendedImageUrl: srv.imageUrl,
      );
    }

    if (lower.contains('massage') || lower.contains('đá nóng') || lower.contains('da nong') || lower.contains('body') || lower.contains('cặp đôi')) {
      final anMien = spas.firstWhere((s) => s.id == 'spa_an');
      final srv = anMien.services.firstWhere((s) => s.id == 'srv_an_ms90');

      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Để phục hồi năng lượng toàn thân trong không gian thanh tịnh, An Miên Spa là lựa chọn hàng đầu. Gói Massage Body đá nóng 90 phút kết hợp tinh dầu organic ấm áp sẽ giúp bạn hoàn toàn thư giãn.',
        isUser: false,
        timestamp: DateTime.now(),
        recommendedSpaId: anMien.id,
        recommendedSpaName: anMien.name,
        recommendedServiceId: srv.id,
        recommendedServiceName: srv.name,
        recommendedPrice: srv.price,
        recommendedImageUrl: srv.imageUrl,
      );
    }

    if (lower.contains('da') || lower.contains('facial') || lower.contains('mặt') || lower.contains('trẻ hóa')) {
      final elite = spas.firstWhere((s) => s.id == 'spa_elite');
      final srv = elite.services.firstWhere((s) => s.id == 'srv_elite_fc75');

      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Về chăm sóc và trẻ hóa làn da, Elite Beauty & Spa cung cấp liệu trình Chăm sóc da chuyên sâu 75 phút với công nghệ cấp ẩm vi điểm và điện di tinh chất collagen thiên nhiên.',
        isUser: false,
        timestamp: DateTime.now(),
        recommendedSpaId: elite.id,
        recommendedSpaName: elite.name,
        recommendedServiceId: srv.id,
        recommendedServiceName: srv.name,
        recommendedPrice: srv.price,
        recommendedImageUrl: srv.imageUrl,
      );
    }

    // Default general wellness advice
    final lotus = spas.first;
    final srv = lotus.services.first;

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'Cảm ơn bạn đã chia sẻ! Để chăm sóc sức khỏe và tinh thần tốt nhất hôm nay, bạn có thể tham khảo gói trị liệu thư giãn tiêu biểu bên dưới, hoặc cho mình biết rõ hơn về tình trạng sức khỏe của bạn nhé.',
      isUser: false,
      timestamp: DateTime.now(),
      recommendedSpaId: lotus.id,
      recommendedSpaName: lotus.name,
      recommendedServiceId: srv.id,
      recommendedServiceName: srv.name,
      recommendedPrice: srv.price,
      recommendedImageUrl: srv.imageUrl,
    );
  }
}
