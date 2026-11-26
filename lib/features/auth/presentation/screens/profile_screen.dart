import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../view_models/auth_view_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authViewModelProvider).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final success = await ref.read(authViewModelProvider.notifier).updateProfile(
          name: _nameController.text,
          phone: _phoneController.text,
        );
    if (success && mounted) {
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật hồ sơ thành công!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _showPaymentHistoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppColors.surface,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.85,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollCtrl) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Lịch sử thanh toán & Hoàn cọc', style: AppTextStyles.heading2),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  controller: scrollCtrl,
                  children: [
                    _buildPaymentRecord(
                      title: 'Cọc giữ chỗ - Lotus Wellness Spa',
                      date: '24/11/2026 14:30',
                      amount: '- 50.000 đ',
                      status: 'Đã thanh toán',
                      statusColor: AppColors.success,
                    ),
                    _buildPaymentRecord(
                      title: 'Hoàn tiền cọc - Green Spa & Therapy',
                      date: '20/11/2026 10:15',
                      amount: '+ 50.000 đ',
                      status: 'Đã hoàn cọc',
                      statusColor: Colors.blueGrey,
                    ),
                    _buildPaymentRecord(
                      title: 'Cọc dịch vụ Massage - An Miên Spa',
                      date: '15/11/2026 09:00',
                      amount: '- 100.000 đ',
                      status: 'Đã hoàn thành',
                      statusColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentRecord({
    required String title,
    required String date,
    required String amount,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.accent),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: statusColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppColors.surface,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Cài đặt ứng dụng', style: AppTextStyles.heading2),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.language_rounded, color: AppColors.primary),
                title: const Text('Ngôn ngữ'),
                trailing: const Text('Tiếng Việt', style: TextStyle(color: AppColors.textMuted)),
                onTap: () => Navigator.pop(ctx),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
                title: const Text('Đổi mật khẩu'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/forgot-password');
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.dark_mode_outlined, color: AppColors.primary),
                title: const Text('Chế độ giao diện'),
                trailing: const Text('Sáng (Luxury)', style: TextStyle(color: AppColors.textMuted)),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSupportModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppColors.surface,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Trung tâm hỗ trợ khách hàng', style: AppTextStyles.heading2),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.phone_in_talk_rounded, color: AppColors.primary),
                title: const Text('Hotline CSKH 24/7'),
                subtitle: const Text('1900 8888 (Miễn phí cước gọi)'),
                onTap: () => Navigator.pop(ctx),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.mail_outline_rounded, color: AppColors.primary),
                title: const Text('Email hỗ trợ'),
                subtitle: const Text('support@luxuryspa.vn'),
                onTap: () => Navigator.pop(ctx),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.help_outline_rounded, color: AppColors.primary),
                title: const Text('Câu hỏi thường gặp (FAQ)'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;

    if (!authState.isAuthenticated || user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Tài khoản')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.secondaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_outline_rounded, size: 48, color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                const Text('Tài khoản của bạn', style: AppTextStyles.heading2),
                const SizedBox(height: 8),
                const Text(
                  'Đăng nhập để xem thông tin cá nhân, danh sách Spa yêu thích và lịch sử giao dịch.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13.5),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.push('/login'),
                  child: const Text('Đăng nhập hoặc Đăng ký'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tài khoản cá nhân'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check_rounded : Icons.edit_rounded),
            onPressed: () {
              if (_isEditing) {
                _handleSave();
              } else {
                setState(() => _isEditing = true);
              }
            },
            tooltip: _isEditing ? 'Lưu' : 'Chỉnh sửa',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // User Header & Avatar & Tier Badge
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: AppColors.secondary,
                        backgroundImage: NetworkImage(user.avatarUrl),
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  // Tier Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.accent.withOpacity(0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.workspace_premium_rounded, size: 16, color: AppColors.accent),
                        SizedBox(width: 4),
                        Text(
                          'Thành viên Vàng (Gold)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form Info
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
                  const Text('THÔNG TIN LIÊN HỆ', style: AppTextStyles.caption),
                  const SizedBox(height: 14),
                  _buildProfileField(
                    label: 'Họ và tên',
                    controller: _nameController,
                    isEditing: _isEditing,
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 14),
                  _buildProfileField(
                    label: 'Số điện thoại',
                    controller: _phoneController,
                    isEditing: _isEditing,
                    icon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 14),
                  _buildProfileField(
                    label: 'Email',
                    value: user.email,
                    isEditing: false,
                    icon: Icons.email_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Functional Menu Items (NO duplicate Notifications, NO duplicate Bookings!)
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.favorite_rounded, color: Colors.redAccent),
                      title: const Text('Spa & Dịch vụ yêu thích', style: TextStyle(fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push('/favorites'),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    ListTile(
                      leading: const Icon(Icons.receipt_long_rounded, color: AppColors.accent),
                      title: const Text('Lịch sử thanh toán & Hoàn cọc', style: TextStyle(fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _showPaymentHistoryModal(context),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    ListTile(
                      leading: const Icon(Icons.settings_outlined, color: AppColors.primary),
                      title: const Text('Cài đặt tài khoản', style: TextStyle(fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _showSettingsModal(context),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    ListTile(
                      leading: const Icon(Icons.shield_outlined, color: AppColors.primary),
                      title: const Text('Chính sách & Quyền riêng tư', style: TextStyle(fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Chính sách bảo mật áp dụng tiêu chuẩn cao nhất.')),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    ListTile(
                      leading: const Icon(Icons.support_agent_rounded, color: AppColors.primary),
                      title: const Text('Trung tâm hỗ trợ', style: TextStyle(fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _showSupportModal(context),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authViewModelProvider.notifier).logout();
                  if (!context.mounted) return;
                  context.go('/');
                },
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                label: const Text('Đăng xuất tài khoản', style: TextStyle(color: AppColors.error)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    TextEditingController? controller,
    String? value,
    required bool isEditing,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        const SizedBox(height: 4),
        if (isEditing && controller != null)
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          )
        else
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                value ?? controller?.text ?? '',
                style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: AppColors.text),
              ),
            ],
          ),
      ],
    );
  }
}
