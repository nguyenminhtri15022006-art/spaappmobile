import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/data/mock_administrative_repository.dart';
import '../../../../shared/models/administrative_unit.dart';

class LocationDropdownSelector extends StatefulWidget {
  final String? selectedProvinceCode;
  final String? selectedWardCode;
  final AdministrativeRepository repository;
  final ValueChanged<String?> onProvinceChanged;
  final ValueChanged<String?> onWardChanged;

  const LocationDropdownSelector({
    super.key,
    required this.selectedProvinceCode,
    required this.selectedWardCode,
    required this.repository,
    required this.onProvinceChanged,
    required this.onWardChanged,
  });

  @override
  State<LocationDropdownSelector> createState() => _LocationDropdownSelectorState();
}

class _LocationDropdownSelectorState extends State<LocationDropdownSelector> {
  void _openSelectionDialog({
    required BuildContext context,
    required String title,
    required Future<List<AdministrativeUnit>> Function(String query) fetcher,
    required ValueChanged<AdministrativeUnit?> onSelected,
    bool allowAll = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SearchableUnitBottomSheet(
        title: title,
        fetcher: fetcher,
        onSelected: onSelected,
        allowAll: allowAll,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedProvince = widget.selectedProvinceCode != null
        ? widget.repository.getProvinceByCode(widget.selectedProvinceCode!)
        : null;

    final selectedWard = widget.selectedWardCode != null
        ? widget.repository.getWardByCode(widget.selectedWardCode!)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown 1: Tỉnh / Thành phố
        const Text(
          'Tỉnh / Thành phố',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () {
            _openSelectionDialog(
              context: context,
              title: 'Chọn Tỉnh / Thành phố',
              fetcher: (q) => widget.repository.getProvinces(query: q),
              allowAll: true,
              onSelected: (unit) {
                widget.onProvinceChanged(unit?.code);
              },
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 1.2),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_city_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedProvince?.name ?? 'Tất cả Tỉnh / Thành phố',
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedProvince != null
                          ? AppColors.text
                          : AppColors.textSecondary,
                      fontWeight: selectedProvince != null
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (selectedProvince != null)
                  GestureDetector(
                    onTap: () => widget.onProvinceChanged(null),
                    child: const Icon(
                      Icons.clear_rounded,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                  )
                else
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Dropdown 2: Xã / Phường / Đặc khu
        const Text(
          'Xã / Phường / Thị trấn',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: widget.selectedProvinceCode == null
              ? null
              : () {
                  _openSelectionDialog(
                    context: context,
                    title: 'Chọn Xã / Phường tại ${selectedProvince?.name}',
                    fetcher: (q) => widget.repository.getWards(
                      widget.selectedProvinceCode!,
                      query: q,
                    ),
                    allowAll: true,
                    onSelected: (unit) {
                      widget.onWardChanged(unit?.code);
                    },
                  );
                },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: widget.selectedProvinceCode == null
                  ? AppColors.chipBackground.withOpacity(0.5)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.selectedProvinceCode == null
                    ? AppColors.border.withOpacity(0.5)
                    : AppColors.border,
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.map_outlined,
                  size: 20,
                  color: widget.selectedProvinceCode == null
                      ? AppColors.textMuted
                      : AppColors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.selectedProvinceCode == null
                        ? 'Vui lòng chọn Tỉnh/Thành phố trước'
                        : (selectedWard?.name ?? 'Tất cả xã / phường'),
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.selectedProvinceCode == null
                          ? AppColors.textMuted
                          : (selectedWard != null
                              ? AppColors.text
                              : AppColors.textSecondary),
                      fontWeight: selectedWard != null
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (selectedWard != null)
                  GestureDetector(
                    onTap: () => widget.onWardChanged(null),
                    child: const Icon(
                      Icons.clear_rounded,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                  )
                else
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: widget.selectedProvinceCode == null
                        ? AppColors.textMuted.withOpacity(0.5)
                        : AppColors.textMuted,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchableUnitBottomSheet extends StatefulWidget {
  final String title;
  final Future<List<AdministrativeUnit>> Function(String query) fetcher;
  final ValueChanged<AdministrativeUnit?> onSelected;
  final bool allowAll;

  const _SearchableUnitBottomSheet({
    required this.title,
    required this.fetcher,
    required this.onSelected,
    this.allowAll = false,
  });

  @override
  State<_SearchableUnitBottomSheet> createState() =>
      _SearchableUnitBottomSheetState();
}

class _SearchableUnitBottomSheetState extends State<_SearchableUnitBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<AdministrativeUnit> _units = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUnits('');
  }

  Future<void> _loadUnits(String query) async {
    setState(() => _isLoading = true);
    final results = await widget.fetcher(query);
    if (mounted) {
      setState(() {
        _units = results;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Ô tìm kiếm địa danh
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => _loadUnits(val),
                    style: const TextStyle(fontSize: 13.5),
                    decoration: const InputDecoration(
                      hintText: 'Nhập tên phường, quận cũ hoặc mã...',
                      hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                      prefixIcon: Icon(Icons.search, size: 18, color: AppColors.textMuted),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Danh sách đơn vị hành chính
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      if (widget.allowAll)
                        ListTile(
                          title: const Text(
                            'Tất cả',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          leading: const Icon(Icons.all_inclusive, color: AppColors.primary),
                          onTap: () {
                            widget.onSelected(null);
                            Navigator.pop(context);
                          },
                        ),
                      ..._units.map(
                        (unit) => ListTile(
                          title: Text(
                            unit.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.text,
                            ),
                          ),
                          subtitle: unit.aliases.isNotEmpty
                              ? Text(
                                  'Bao gồm: ${unit.aliases.join(", ")}',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: AppColors.textMuted,
                                  ),
                                )
                              : null,
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                          onTap: () {
                            widget.onSelected(unit);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
