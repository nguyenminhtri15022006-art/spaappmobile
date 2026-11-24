import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/data/mock_spa_data.dart';
import '../../../../shared/widgets/not_found_view.dart';
import '../../../auth/presentation/view_models/auth_view_model.dart';
import '../view_models/booking_draft_view_model.dart';

class BookingFormScreen extends ConsumerStatefulWidget {
  final String spaId;
  final String serviceId;
  final String branchId;

  const BookingFormScreen({
    super.key,
    required this.spaId,
    required this.serviceId,
    required this.branchId,
  });

  @override
  ConsumerState<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends ConsumerState<BookingFormScreen> {
  late DateTime _selectedDate;
  late String _selectedTime;
  late final TextEditingController _notesController;

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
  void initState() {
    super.initState();
    final existingDraft = ref.read(bookingDraftProvider);
    final isSameDraft = existingDraft.spaId == widget.spaId &&
        existingDraft.serviceId == widget.serviceId &&
        existingDraft.branchId == widget.branchId;

    if (isSameDraft && existingDraft.selectedDate != null) {
      // Giữ nguyên ngày, giờ và ghi chú đã chọn khi người dùng quay lại (ví dụ sau khi đăng nhập)
      _selectedDate = existingDraft.selectedDate!;
      _selectedTime = existingDraft.selectedTime ?? '14:30';
      _notesController = TextEditingController(text: existingDraft.notes);
    } else {
      _selectedDate = DateTime.now().add(const Duration(days: 1));
      _selectedTime = '14:30';
      _notesController = TextEditingController();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(bookingDraftProvider.notifier).initDraft(
              spaId: widget.spaId,
              serviceId: widget.serviceId,
              branchId: widget.branchId,
              initialDate: _selectedDate,
              initialTime: _selectedTime,
            );
      });
    }

    _notesController.addListener(() {
      ref.read(bookingDraftProvider.notifier).updateCustomerInfo(
            notes: _notesController.text,
          );
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.text,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      ref.read(bookingDraftProvider.notifier).updateDate(picked);
    }
  }

  void _proceedToConfirmation() {
    final authState = ref.read(authViewModelProvider);

    // Lưu notes và thông tin người dùng vào draft
    ref.read(bookingDraftProvider.notifier).updateCustomerInfo(
          notes: _notesController.text,
          name: authState.user?.name,
          phone: authState.user?.phone,
        );

    // Kiểm tra đăng nhập
    if (!authState.isAuthenticated) {
      // Lưu lại URL hiện tại kèm query params để quay lại sau khi đăng nhập
      final currentUrl =
          '/booking?spaId=${widget.spaId}&serviceId=${widget.serviceId}&branchId=${widget.branchId}';
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đăng nhập trước khi xác nhận đặt lịch'),
          backgroundColor: AppColors.accent,
        ),
      );
      context.push('/login?redirect=${Uri.encodeComponent(currentUrl)}');
      return;
    }

    // Chuyển sang màn hình xác nhận
    context.push(
      '/booking/confirm?spaId=${widget.spaId}&serviceId=${widget.serviceId}&branchId=${widget.branchId}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final spaList = MockSpaData.getSpas();

    // Kiểm tra ID hợp lệ, hiển thị NotFoundView nếu không tìm thấy
    final spaMatches = spaList.where((s) => s.id == widget.spaId);
    if (spaMatches.isEmpty) {
      return const Scaffold(
        body: SafeArea(
          child: NotFoundView(
            title: 'Không tìm thấy Spa',
            message: 'Mã Spa không tồn tại hoặc dữ liệu đã bị xóa.',
          ),
        ),
      );
    }
    final spa = spaMatches.first;

    final serviceMatches = spa.services.where((s) => s.id == widget.serviceId);
    if (serviceMatches.isEmpty) {
      return const Scaffold(
        body: SafeArea(
          child: NotFoundView(
            title: 'Không tìm thấy dịch vụ',
            message: 'Dịch vụ này không thuộc danh mục của Spa đã chọn.',
          ),
        ),
      );
    }
    final service = serviceMatches.first;

    final branchMatches = spa.branches.where((b) => b.id == widget.branchId);
    if (branchMatches.isEmpty) {
      return const Scaffold(
        body: SafeArea(
          child: NotFoundView(
            title: 'Không tìm thấy chi nhánh',
            message: 'Chi nhánh đã chọn không khả dụng.',
          ),
        ),
      );
    }
    final branch = branchMatches.first;

    final dateFormat = DateFormat('EEEE, dd/MM/yyyy', 'vi_VN');
    final formattedDate = dateFormat.format(_selectedDate);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chọn thời gian hẹn'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin dịch vụ & chi nhánh đã chọn
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          service.imageUrl,
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.spa, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              spa.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.storefront_rounded,
                          size: 16, color: AppColors.textMuted),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${branch.name} (${branch.address})',
                          style: const TextStyle(
                              fontSize: 12.5, color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.schedule_rounded,
                              size: 16, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Text(
                            '${service.durationMinutes} phút',
                            style: const TextStyle(
                                fontSize: 12.5, color: AppColors.textSecondary),
                          ),
                        ],
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
            const SizedBox(height: 24),

            // 1. CHỌN NGÀY
            const Text('1. Chọn ngày thực hiện', style: AppTextStyles.heading3),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _selectDatePicker(context),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border, width: 1.2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded,
                        color: AppColors.primary, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    const Text(
                      'Thay đổi',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. CHỌN KHUNG GIỜ
            const Text('2. Chọn khung giờ hẹn', style: AppTextStyles.heading3),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _timeSlots.map((time) {
                final isSelected = _selectedTime == time;
                return ChoiceChip(
                  label: Text(time),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) {
                      setState(() => _selectedTime = time);
                      ref.read(bookingDraftProvider.notifier).updateTime(time);
                    }
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
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
            const SizedBox(height: 24),

            // 3. GHI CHÚ
            const Text('3. Yêu cầu thêm (tùy chọn)',
                style: AppTextStyles.heading3),
            const SizedBox(height: 10),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText:
                    'Ví dụ: Cần KTV có tay nghề cao, massage giảm đau vùng cổ...',
              ),
            ),
            const SizedBox(height: 32),

            // Nút Tiếp tục xác nhận
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _proceedToConfirmation,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Tiếp tục xác nhận',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
