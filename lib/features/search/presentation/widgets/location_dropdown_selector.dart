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
    required Future<List<AdministrativeUnit>> Function() fetcher,
    required ValueChanged<AdministrativeUnit?> onSelected,
    bool allowAll = false,
    String allLabel = 'Tất cả',
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
        allLabel: allLabel,
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
        // Dropdown 1: Tỉnh / Thành phố (34 đơn vị hành chính)
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
              title: 'Chọn Tỉnh / Thành phố (34 tỉnh thành)',
              fetcher: () => widget.repository.getProvinces(),
              allowAll: true,
              allLabel: 'Tất cả Tỉnh / Thành phố (Toàn quốc)',
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
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(
                        Icons.clear_rounded,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
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

        // Dropdown 2: Phường / Xã / Đặc khu (phụ thuộc Tỉnh đã chọn)
        const Text(
          'Phường / Xã / Đặc khu',
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
                  final pName = selectedProvince?.name ?? 'Tỉnh đã chọn';
                  _openSelectionDialog(
                    context: context,
                    title: 'Chọn Xã / Phường tại $pName',
                    fetcher: () => widget.repository.getWards(widget.selectedProvinceCode!),
                    allowAll: true,
                    allLabel: 'Tất cả Xã / Phường tại $pName',
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
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(
                        Icons.clear_rounded,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
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
  final Future<List<AdministrativeUnit>> Function() fetcher;
  final ValueChanged<AdministrativeUnit?> onSelected;
  final bool allowAll;
  final String allLabel;

  const _SearchableUnitBottomSheet({
    required this.title,
    required this.fetcher,
    required this.onSelected,
    this.allowAll = false,
    this.allLabel = 'Tất cả',
  });

  @override
  State<_SearchableUnitBottomSheet> createState() =>
      _SearchableUnitBottomSheetState();
}

class _SearchableUnitBottomSheetState extends State<_SearchableUnitBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<AdministrativeUnit> _allUnits = [];
  List<AdministrativeUnit> _filteredUnits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final results = await widget.fetcher();
    if (mounted) {
      setState(() {
        _allUnits = results;
        _filteredUnits = results;
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _filteredUnits = _allUnits;
      });
      return;
    }
    setState(() {
      _filteredUnits = _allUnits.where((u) => u.matchesQuery(query)).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header cố định với ô tìm kiếm
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
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                // Ô tìm kiếm địa danh (hỗ trợ tiếng Việt có dấu/không dấu, không mất focus IME)
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.search, size: 18, color: AppColors.textMuted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          autocorrect: false,
                          enableSuggestions: true,
                          style: const TextStyle(fontSize: 13.5, color: AppColors.text),
                          decoration: const InputDecoration(
                            hintText: 'Nhập tên phường, quận cũ hoặc mã...',
                            hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                        ),
                      ),
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _searchController,
                        builder: (context, value, _) {
                          if (value.text.isEmpty) return const SizedBox.shrink();
                          return IconButton(
                            icon: const Icon(Icons.cancel_rounded, size: 16),
                            color: AppColors.textMuted,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          );
                        },
                      ),
                    ],
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
                : _filteredUnits.isEmpty && !widget.allowAll
                    ? const Center(
                        child: Text(
                          'Không tìm thấy địa phương phù hợp',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 16 + bottomInset),
                        itemCount: (widget.allowAll ? 1 : 0) + _filteredUnits.length,
                        itemBuilder: (context, index) {
                          if (widget.allowAll && index == 0) {
                            return ListTile(
                              title: Text(
                                widget.allLabel,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              leading: const Icon(
                                Icons.all_inclusive_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              onTap: () {
                                widget.onSelected(null);
                                Navigator.pop(context);
                              },
                            );
                          }

                          final unitIndex = widget.allowAll ? index - 1 : index;
                          final unit = _filteredUnits[unitIndex];

                          return ListTile(
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
