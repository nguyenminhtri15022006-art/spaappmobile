class VietnameseUtils {
  VietnameseUtils._();

  static const _vietnameseMap = {
    'a': 'áàảãạăắằẳẵặâấầẩẫậ',
    'A': 'ÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬ',
    'd': 'đ',
    'D': 'Đ',
    'e': 'éèẻẽẹêếềểễệ',
    'E': 'ÉÈẺẼẸÊẾỀỂỄỆ',
    'i': 'íìỉĩị',
    'I': 'ÍÌỈĨỊ',
    'o': 'óòỏõọôốồổỗộơớờởỡợ',
    'O': 'ÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢ',
    'u': 'úùủũụưứừửữự',
    'U': 'ÚÙỦŨỤƯỨỪỬỮỰ',
    'y': 'ýỳỷỹỵ',
    'Y': 'ÝỲỶỸỴ',
  };

  /// Chuyển chuỗi tiếng Việt có dấu thành không dấu và chữ thường
  static String toNonDiacritic(String text) {
    String result = text;
    _vietnameseMap.forEach((nonAccent, accents) {
      for (int i = 0; i < accents.length; i++) {
        result = result.replaceAll(accents[i], nonAccent);
      }
    });
    // Loại bỏ các ký tự dấu tổ hợp (Unicode combining diacritical marks) từ bộ gõ NFD
    result = result.replaceAll(RegExp(r'[\u0300-\u036f]'), '');
    return result.toLowerCase();
  }

  /// Chuẩn hoá chuỗi tìm kiếm (xóa khoảng trắng dư thừa, chuyển không dấu)
  static String normalize(String text) {
    final trimmed = text.trim().replaceAll(RegExp(r'\s+'), ' ');
    return toNonDiacritic(trimmed);
  }

  /// Kiểm tra [source] có chứa từ khoá [query] không (hỗ trợ cả có dấu và không dấu)
  static bool containsSearch(String source, String query) {
    if (query.trim().isEmpty) return true;
    
    final normalizedSource = normalize(source);
    final normalizedQuery = normalize(query);

    // Tìm kiếm trực tiếp cả cụm
    if (normalizedSource.contains(normalizedQuery)) return true;

    // Tìm kiếm theo từng từ (all tokens match)
    final queryTokens = normalizedQuery.split(' ').where((t) => t.isNotEmpty);
    if (queryTokens.isEmpty) return true;

    return queryTokens.every((token) => normalizedSource.contains(token));
  }
}
