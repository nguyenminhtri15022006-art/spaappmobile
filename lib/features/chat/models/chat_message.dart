class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? recommendedSpaId;
  final String? recommendedSpaName;
  final String? recommendedServiceId;
  final String? recommendedServiceName;
  final double? recommendedPrice;
  final String? recommendedImageUrl;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.recommendedSpaId,
    this.recommendedSpaName,
    this.recommendedServiceId,
    this.recommendedServiceName,
    this.recommendedPrice,
    this.recommendedImageUrl,
  });

  bool get hasRecommendation =>
      recommendedSpaId != null && recommendedServiceId != null;
}
