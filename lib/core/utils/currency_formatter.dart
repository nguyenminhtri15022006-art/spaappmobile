import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  );

  static String format(num amount) {
    return _formatter.format(amount).replaceAll(' ', ' ');
  }

  static String formatRange(num min, num max) {
    return '${format(min)} – ${format(max)}';
  }
}
