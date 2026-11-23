import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/data/mock_spa_data.dart';

class BookingDraftScreen extends StatefulWidget {
  final String spaId;
  final String serviceId;
  final String branchId;

  const BookingDraftScreen({
    super.key,
    required this.spaId,
    required this.serviceId,
    required this.branchId,
  });

  @override
  State<BookingDraftScreen> createState() => _BookingDraftScreenState();
}

class _BookingDraftScreenState extends State<BookingDraftScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTime = '14:30';

  final List<String> _timeSlots = [
    '09:00',
    '10:30',
    '13:00',
    '14:30',
    '16:00',
    '18:00',
    '19:30',
  ];

  @override
  Widget build(BuildContext context) {
    final spaList = MockSpaData.getSpas();
    final spa = spaList.firstWhere(
      (s) => s.id == widget.spaId,
      orElse: () => spaList.first,
    );

    final service = spa.services.firstWhere(
      (s) => s.id == widget.serviceId,
      orElse: () => spa.services.first,
    );

    final branch = spa.branches.firstWhere(
      (b) => b.id == widget.branchId,
      orElse: () => spa.branches.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Xác nhận đặt lịch hẹn'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            // Thông tin tóm tắt Spa & Chi nhánh
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.spa_rounded, color: AppColors.primary, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          spa.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Chi nhánh: ${branch.name}',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    branch.address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Chi tiết dịch vụ
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  const Text('Dịch vụ đã chọn', style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  Text(
                    service.name,
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Thời lượng: ${service.durationMinutes} phút',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(service.price),
                        style: AppTextStyles.price.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Chọn khung giờ
            const Text('Khung giờ khả dụng', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _timeSlots.map((time) {
                final isSelected = _selectedTime == time;
                return ChoiceChip(
                  label: Text(time),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedTime = time);
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? Colors.white : AppColors.text,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  showCheckmark: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Nút hoàn tất đặt lịch (Giả lập)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28),
                          SizedBox(width: 10),
                          Text(
                            'Đặt lịch thành công!',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      content: Text(
                        'Bạn đã đặt thành công dịch vụ "${service.name}" tại "${branch.name}" lúc $_selectedTime.\n\n(Dữ liệu giả lập Demo Frontend)',
                        style: const TextStyle(fontSize: 13.5, height: 1.4),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            context.go('/');
                          },
                          child: const Text('Về trang chủ'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  'Xác nhận đặt hẹn (Giả lập)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
