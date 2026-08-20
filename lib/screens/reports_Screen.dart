import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../theme/theme.dart';
 
class ReportsScreen extends StatefulWidget {
  // CHANGED: now takes AppThemeMode so this page follows Light/Dark/
  // DSecure/DSecure Light the same way Cloud Erase, sidebar, dashboard do.
  final AppThemeMode themeMode;
  const ReportsScreen({Key? key, required this.themeMode}) : super(key: key);
 
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}
 
class _ReportsScreenState extends State<ReportsScreen> {
  final List<Map<String, dynamic>> _reportsData = [
    {'id': 'RPT-20260225-0012', 'type': 'Files & Folder', 'total': 1240, 'erased': 1240, 'failed': 0, 'date': 'Feb 25, 2026'},
    {'id': 'RPT-20260224-0011', 'type': 'Erase Volume', 'total': 1, 'erased': 1, 'failed': 0, 'date': 'Feb 24, 2026'},
    {'id': 'RPT-20260223-0010', 'type': 'Erase Deleted Data', 'total': 382, 'erased': 379, 'failed': 3, 'date': 'Feb 23, 2026'},
    {'id': 'RPT-20260222-0009', 'type': 'Scheduled Task Erasure', 'total': 870, 'erased': 870, 'failed': 0, 'date': 'Feb 22, 2026'},
    {'id': 'RPT-20260220-0008', 'type': 'Files & Folder', 'total': 55, 'erased': 55, 'failed': 0, 'date': 'Feb 20, 2026'},
    {'id': 'RPT-20260218-0007', 'type': 'Erase Volume', 'total': 1, 'erased': 1, 'failed': 0, 'date': 'Feb 18, 2026'},
    {'id': 'RPT-20260215-0006', 'type': 'Files & Folder', 'total': 3021, 'erased': 3000, 'failed': 21, 'date': 'Feb 15, 2026'},
    {'id': 'RPT-20260210-0005', 'type': 'Scheduled Task Erasure', 'total': 100, 'erased': 100, 'failed': 0, 'date': 'Feb 10, 2026'},
  ];
 
  Set<String> _selectedRows = {};
  String _selectedFilter = 'All Reports';
 
  String? _sortColumn;
  bool _sortAscending = true;
 
  bool _toastsExpanded = false;
 
  DateTime? _startDate;
  DateTime? _endDate;
 
  final LayerLink _startDateLink = LayerLink();
  final LayerLink _endDateLink = LayerLink();
  final LayerLink _allReportsLink = LayerLink();
  OverlayEntry? _openOverlay;
 
  final Color _tealGreen = const Color(0xFF009688);
  final Color _paleGreen = const Color(0xFFE8F5E9);
 
  // ---- Theme-aware colors driven by the 4-mode AppThemeMode. Page-level
  // surfaces (scaffold bg, main card bg/border, toolbar, header row, row
  // text) now follow the theme; the teal accent, red "failed" text, and
  // the toast/calendar/dialog popups keep their existing look untouched. ----
  Color get _pageBg {
    switch (widget.themeMode) {
      case AppThemeMode.light:
        return const Color(0xFFF5F5F5);
      case AppThemeMode.dark:
      case AppThemeMode.greenDark:
        return const Color(0xFF0F172A);
      case AppThemeMode.greenLight:
        return AppColors.greenLightBg;
    }
  }
 
  Color get _cardBg {
    switch (widget.themeMode) {
      case AppThemeMode.light:
        return Colors.white;
      case AppThemeMode.dark:
      case AppThemeMode.greenDark:
        return const Color(0xFF1E293B);
      case AppThemeMode.greenLight:
        return AppColors.greenLightCard;
    }
  }
 
  Color get _cardBorder {
    switch (widget.themeMode) {
      case AppThemeMode.light:
        return Colors.grey.shade300;
      case AppThemeMode.dark:
      case AppThemeMode.greenDark:
        return const Color(0xFF334155);
      case AppThemeMode.greenLight:
        return AppColors.greenLightBorder;
    }
  }
 
  Color get _headingColor {
    switch (widget.themeMode) {
      case AppThemeMode.light:
        return Colors.black;
      case AppThemeMode.dark:
        return Colors.white;
      case AppThemeMode.greenDark:
        return AppColors.greenDarkText;
      case AppThemeMode.greenLight:
        return AppColors.greenLightText;
    }
  }
 
  Color get _bodyGreyColor {
    switch (widget.themeMode) {
      case AppThemeMode.light:
        return Colors.grey[600]!;
      case AppThemeMode.dark:
        return const Color(0xFF94A3B8);
      case AppThemeMode.greenDark:
        return AppColors.greenDarkGreyText;
      case AppThemeMode.greenLight:
        return AppColors.greenLightGreyText;
    }
  }
 
  Color get _toolbarBg {
    switch (widget.themeMode) {
      case AppThemeMode.light:
        return Colors.grey.shade100;
      case AppThemeMode.dark:
      case AppThemeMode.greenDark:
        return const Color(0xFF243044);
      case AppThemeMode.greenLight:
        return const Color(0xFFDCFCE7);
    }
  }
 
  Color get _tableHeaderBg {
    switch (widget.themeMode) {
      case AppThemeMode.light:
        return Colors.grey[50]!;
      case AppThemeMode.dark:
      case AppThemeMode.greenDark:
        return const Color(0xFF243044);
      case AppThemeMode.greenLight:
        return const Color(0xFFDCFCE7);
    }
  }
 
  Color get _rowHoverBg {
    switch (widget.themeMode) {
      case AppThemeMode.light:
        return Colors.grey[100]!;
      case AppThemeMode.dark:
      case AppThemeMode.greenDark:
        return const Color(0xFF243044);
      case AppThemeMode.greenLight:
        return const Color(0xFFDCFCE7);
    }
  }
 
  final List<_ToastItem> _toasts = [];
  int _toastCounter = 0;
 
  final Map<String, String?> _uploadedFileNames = {};
 
  @override
  void dispose() {
    _openOverlay?.remove();
    super.dispose();
  }
 
  List<Map<String, dynamic>> get _filteredData {
    final List<Map<String, dynamic>> list = _reportsData.where((r) {
      if (_selectedFilter != 'All Reports' && r['type'] != _selectedFilter) {
        return false;
      }
      if (_startDate != null || _endDate != null) {
        final d = _parseReportDate(r['date'] as String);
        if (_startDate != null && _endDate != null) {
          if (d.isBefore(_startDate!) || d.isAfter(_endDate!)) return false;
        } else if (_startDate != null) {
          if (d.isBefore(_startDate!)) return false;
        } else if (_endDate != null) {
          if (d.isAfter(_endDate!)) return false;
        }
      }
      return true;
    }).toList();
 
    if (_sortColumn != null) {
      final String key = _sortKeyForColumn(_sortColumn!);
      list.sort((a, b) {
        int cmp;
        if (key == 'date') {
          cmp = _parseReportDate(a['date'] as String)
              .compareTo(_parseReportDate(b['date'] as String));
        } else {
          final va = a[key];
          final vb = b[key];
          if (va is num && vb is num) {
            cmp = va.compareTo(vb);
          } else {
            cmp = va.toString().toLowerCase().compareTo(vb.toString().toLowerCase());
          }
        }
        return _sortAscending ? cmp : -cmp;
      });
    }
    return list;
  }
 
  String _sortKeyForColumn(String column) {
    switch (column) {
      case 'Report ID':
        return 'id';
      case 'Report Type':
        return 'type';
      case 'Total Items':
        return 'total';
      case 'Erased Items':
        return 'erased';
      case 'Failed Items':
        return 'failed';
      case 'Date':
        return 'date';
      default:
        return 'id';
    }
  }
 
  void _toggleSort(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }
    });
  }
 
  bool get _isAllSelected =>
      _filteredData.isNotEmpty &&
      _filteredData.every((r) => _selectedRows.contains(r['id']));
 
  DateTime _parseReportDate(String s) {
    const months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
    };
    final parts = s.replaceAll(',', '').split(' ');
    final month = months[parts[0]] ?? 1;
    final day = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }
 
  String _formatDate(DateTime? d) {
    if (d == null) return "dd-mm-yyyy";
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return "${d.year}-$mm-$dd";
  }
 
  void _closeOverlay() {
    _openOverlay?.remove();
    _openOverlay = null;
  }
 
  void _showToast(String message, {Duration duration = const Duration(seconds: 4)}) {
    final String id = 'toast_${_toastCounter++}';
    setState(() {
      _toasts.insert(0, _ToastItem(id, message));
    });
    Future.delayed(duration, () {
      if (mounted) {
        setState(() {
          _toasts.removeWhere((t) => t.id == id);
          if (_toasts.isEmpty) _toastsExpanded = false;
        });
      }
    });
  }
 
  void _dismissToast(String id) {
    setState(() {
      _toasts.removeWhere((t) => t.id == id);
      if (_toasts.isEmpty) _toastsExpanded = false;
    });
  }
 
  void _handleUploadReports() {
    if (_selectedRows.isEmpty) {
      _showToast("Please select report to upload");
      return;
    }
    final int count = _selectedRows.length;
    _showToast("Starting upload process...");
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _showToast("Upload complete. Success: $count, Failed: 0");
      }
    });
  }
 
  void _handleSavePdf() {
    if (_selectedRows.isEmpty) {
      _showToast("Please select at least one report to save");
      return;
    }
    _showToast(
      "This is a demo app, so full report downloads are not available in the web sandbox.",
    );
  }
 
  Widget _buildToastStack() {
    if (_toasts.isEmpty) return const SizedBox.shrink();
 
    if (!_toastsExpanded) {
      final int peekCount = _toasts.length > 3 ? 3 : _toasts.length;
      return GestureDetector(
        onTap: () => setState(() => _toastsExpanded = true),
        child: SizedBox(
          width: 380,
          height: 60 + (peekCount - 1) * 6.0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (int i = peekCount - 1; i >= 1; i--)
                Positioned(
                  top: i * 6.0,
                  left: i * 4.0,
                  right: i * 4.0,
                  child: Opacity(
                    opacity: 1 - (i * 0.3),
                    child: _buildToastCard(_toasts[i], interactive: false),
                  ),
                ),
              _buildToastCard(
                _toasts.first,
                badgeCount: _toasts.length > 1 ? _toasts.length : null,
              ),
            ],
          ),
        ),
      );
    }
 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => setState(() => _toastsExpanded = false),
          child: Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Collapse", style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_up, size: 16, color: Colors.grey[700]),
              ],
            ),
          ),
        ),
        ..._toasts.map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildToastCard(t),
            )),
      ],
    );
  }
 
  Widget _buildToastCard(_ToastItem toast, {int? badgeCount, bool interactive = true}) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      child: Container(
        width: 380,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: _tealGreen,
              child: const Icon(Icons.check, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                toast.message,
                style: const TextStyle(color: Colors.black, fontSize: 13),
              ),
            ),
            const SizedBox(width: 10),
            if (badgeCount != null && badgeCount > 1)
              Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(color: _tealGreen, borderRadius: BorderRadius.circular(10)),
                child: Text('+${badgeCount - 1}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            if (interactive)
              GestureDetector(
                onTap: () => _dismissToast(toast.id),
                child: Icon(Icons.close, size: 16, color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }
 
  void _openPreview() {
    if (_selectedRows.isEmpty) {
      _showToast("Please select a report to preview");
      return;
    }
 
    final Uri previewUri = kIsWeb
        ? Uri.parse('${Uri.base.origin}/assets/assets/sample_reports/sample_report.pdf')
        : Uri.parse('https://d-secure-file-erase-sand-box.vercel.app/assets/assets/sample_reports/sample_report.pdf');
 
    launchUrl(
      previewUri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    ).catchError((e) {
      debugPrint('Preview failed to open: $e');
      return false;
    });
  }
 
  void _openCalendarPopup(BuildContext context, LayerLink link, bool isStart) {
    _closeOverlay();
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeOverlay,
              ),
            ),
            CompositedTransformFollower(
              link: link,
              showWhenUnlinked: false,
              offset: const Offset(0, 44),
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(8),
                child: _CalendarPopup(
                  initialMonth: (isStart ? _startDate : _endDate) ?? DateTime.now(),
                  initialSelected: isStart ? _startDate : _endDate,
                  tealGreen: _tealGreen,
                  onSelect: (date) {
                    setState(() {
                      if (isStart) {
                        _startDate = date;
                      } else {
                        _endDate = date;
                      }
                    });
                  },
                  onClose: _closeOverlay,
                ),
              ),
            ),
          ],
        );
      },
    );
    _openOverlay = entry;
    overlay.insert(entry);
  }
 
  void _openReportTypeDropdown(BuildContext context) {
    _closeOverlay();
    final overlay = Overlay.of(context);
    const options = [
      'All Reports',
      'Files & Folder',
      'Erase Volume',
      'Erase Deleted Data',
      'Scheduled Task Erasure',
    ];
    final entry = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeOverlay,
              ),
            ),
            CompositedTransformFollower(
              link: _allReportsLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 44),
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  width: 210,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: options.map((opt) {
                      return _DropdownHoverItem(
                        text: opt,
                        selected: _selectedFilter == opt,
                        tealGreen: _tealGreen,
                        onTap: () {
                          setState(() => _selectedFilter = opt);
                          _closeOverlay();
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    _openOverlay = entry;
    overlay.insert(entry);
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg, // CHANGED: was hardcoded _lightGrey
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPageHeader(context),
                const SizedBox(height: 20),
                Expanded(
                  child: _buildMainTableContainer(),
                ),
                const SizedBox(height: 16),
                _buildFooterButtons(),
              ],
            ),
          ),
          Positioned(
            top: -34,
            right: 24,
            child: _buildToastStack(),
          ),
        ],
      ),
    );
  }
 
  Widget _buildPageHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reports",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal, color: _headingColor),
            ),
            const SizedBox(height: 4),
            Text(
              "View and manage erasure compliance reports",
              style: TextStyle(fontSize: 12, color: _bodyGreyColor),
            ),
          ],
        ),
        _HoverButton(
          text: "Report Settings",
          icon: Icons.settings,
          onTap: () => _showReportSettingsDialog(context),
          hoverBorderColor: _tealGreen,
        ),
      ],
    );
  }
 
  Widget _buildMainTableContainer() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg, // CHANGED: was Colors.white
        border: Border.all(color: _cardBorder), // CHANGED: was Colors.grey.shade300
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildTableToolbar(),
          Divider(color: _cardBorder, height: 1),
          _buildTableHeader(),
          Divider(color: _cardBorder, height: 1),
          Expanded(
            child: _filteredData.isEmpty
                ? Center(
                    child: Text(
                      "No reports found matching the current filters",
                      style: TextStyle(color: _bodyGreyColor, fontSize: 13),
                    ),
                  )
                : ListView.separated(
                    itemCount: _filteredData.length,
                    separatorBuilder: (context, index) => Divider(color: _cardBorder.withOpacity(0.6), height: 1),
                    itemBuilder: (context, index) {
                      return _buildTableRow(_filteredData[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
 
  Widget _buildTableToolbar() {
    return Container(
      color: _toolbarBg, // CHANGED: was Colors.grey.shade100
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Checkbox(
              value: _isAllSelected,
              activeColor: _tealGreen,
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    _selectedRows.addAll(_filteredData.map((r) => r['id'] as String));
                  } else {
                    for (final r in _filteredData) {
                      _selectedRows.remove(r['id']);
                    }
                  }
                });
              },
            ),
            Text("Select All", style: TextStyle(color: _bodyGreyColor, fontSize: 12)),
            if (_selectedRows.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                "${_selectedRows.length} selected",
                style: TextStyle(color: _tealGreen, fontWeight: FontWeight.normal, fontSize: 12),
              ),
            ],
              const SizedBox(width: 24),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 36,
                child: TextField(
                  cursorColor: _tealGreen,
                  style: TextStyle(color: _headingColor),
                  decoration: InputDecoration(
                    hintText: "Search reports...",
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                    prefixIcon: const Icon(Icons.search, size: 18),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: _tealGreen),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    fillColor: _cardBg, // CHANGED: was Colors.white
                    filled: true,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            _buildDateButton(_formatDate(_startDate), _startDateLink, () => _openCalendarPopup(context, _startDateLink, true)),
            const SizedBox(width: 8),
            _buildDateButton(_formatDate(_endDate), _endDateLink, () => _openCalendarPopup(context, _endDateLink, false)),
            const SizedBox(width: 16),
            _buildReportTypeButton(context),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.close, size: 20, color: Colors.grey),
              onPressed: () {
                setState(() {
                  _selectedFilter = 'All Reports';
                  _startDate = null;
                  _endDate = null;
                });
              },
            )
          ],
        ),
      ),
    );
  }
 
  Widget _buildDateButton(String text, LayerLink link, VoidCallback onTap) {
    return CompositedTransformTarget(
      link: link,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: _cardBg, // CHANGED: was Colors.white
              border: Border.all(color: _cardBorder), // CHANGED: was Colors.grey.shade300
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(text, style: TextStyle(color: _bodyGreyColor, fontSize: 13)),
                const SizedBox(width: 8),
                Icon(Icons.calendar_today, size: 16, color: _bodyGreyColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
 
  Widget _buildReportTypeButton(BuildContext context) {
    return CompositedTransformTarget(
      link: _allReportsLink,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _openReportTypeDropdown(context),
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: _cardBg, // CHANGED: was Colors.white
              border: Border.all(color: _cardBorder), // CHANGED: was Colors.grey.shade300
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_selectedFilter, style: TextStyle(fontSize: 13, color: _bodyGreyColor)),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
 
  Widget _buildTableHeader() {
    return Container(
      color: _tableHeaderBg, // CHANGED: was Colors.grey[50]
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          const SizedBox(width: 48),
          Expanded(flex: 2, child: _buildSortableHeader("Report ID")),
          Expanded(flex: 2, child: _buildSortableHeader("Report Type")),
          Expanded(flex: 1, child: _buildSortableHeader("Total Items")),
          Expanded(flex: 1, child: _buildSortableHeader("Erased Items")),
          Expanded(flex: 1, child: _buildSortableHeader("Failed Items")),
          Expanded(flex: 1, child: _buildSortableHeader("Date")),
        ],
      ),
    );
  }
 
  Widget _buildSortableHeader(String title) {
    final bool isActive = _sortColumn == title;
    return InkWell(
      onTap: () => _toggleSort(title),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: TextStyle(color: _bodyGreyColor, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(width: 4),
          Icon(
            isActive
                ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                : Icons.unfold_more,
            size: 14,
            color: isActive ? _tealGreen : Colors.grey[400],
          ),
        ],
      ),
    );
  }
 
  Widget _buildTableRow(Map<String, dynamic> data) {
    final String id = data['id'] as String;
    bool isSelected = _selectedRows.contains(id);
    int failedItems = data['failed'];
 
    return Material(
      color: _cardBg, // CHANGED: was Colors.white
      child: InkWell(
        hoverColor: _rowHoverBg, // CHANGED: was Colors.grey[100]
        onTap: () {
          setState(() {
            isSelected ? _selectedRows.remove(id) : _selectedRows.add(id);
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: 22,
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  activeColor: _tealGreen,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (val) {
                    setState(() {
                      val == true ? _selectedRows.add(id) : _selectedRows.remove(id);
                    });
                  },
                ),
                Expanded(
                  flex: 2,
                  child: Tooltip(
                    message: data['id'].toString(),
                    decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)),
                    textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                    child: Row(
                      children: [
                        Icon(Icons.description_outlined, size: 13, color: _bodyGreyColor),
                        const SizedBox(width: 6),
                        Text(data['id'], style: TextStyle(color: _headingColor, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Tooltip(
                    message: data['type'].toString(),
                    decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)),
                    textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                    child: Text(data['type'], style: TextStyle(color: _bodyGreyColor, fontSize: 11)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Tooltip(
                    message: data['total'].toString(),
                    decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)),
                    textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                    child: Text(data['total'].toString(), style: TextStyle(color: _bodyGreyColor, fontSize: 11)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Tooltip(
                    message: data['erased'].toString(),
                    decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)),
                    textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                    child: Text(data['erased'].toString(), style: TextStyle(color: _tealGreen, fontSize: 11, fontWeight: FontWeight.normal)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Tooltip(
                    message: failedItems.toString(),
                    decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)),
                    textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                    child: Text(failedItems.toString(), style: TextStyle(color: failedItems > 0 ? Colors.red : _bodyGreyColor, fontSize: 11)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Tooltip(
                    message: data['date'].toString(),
                    decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)),
                    textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                    child: Text(data['date'], style: TextStyle(color: _bodyGreyColor, fontSize: 11)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
 
  Widget _buildFooterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _HoverButton(text: "Preview", icon: Icons.remove_red_eye_outlined, fullTealHover: true, onTap: _openPreview),
        const SizedBox(width: 12),
        _HoverButton(text: "Upload", icon: Icons.upload_file, fullTealHover: true, onTap: _handleUploadReports),
        const SizedBox(width: 12),
        _HoverButton(text: "Save PDF", icon: Icons.picture_as_pdf_outlined, fullTealHover: true, onTap: _handleSavePdf),
      ],
    );
  }
 
  void _showReportSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Report Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 4),
              Text("Customize report templates and signature", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSettingsInput("Custom Report Header Text", "Data Erasure Certificate"),
                  _buildSettingsInput("Default Technician Name", "James Anderson"),
                  _buildSettingsInput("Default Validator Name", "Sarah Mitchell"),
                  _buildUploadRow("Technician Signature Image"),
                  _buildUploadRow("Validator Signature Image"),
                  _buildUploadRow("Company Logo"),
                  _buildUploadRow("Watermark"),
                ],
              ),
            ),
          ),
          actions: [
            _RectHoverButton(
              text: "Cancel",
              onTap: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _tealGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              onPressed: () {
                Navigator.pop(context);
                _showToast("Settings saved successfully");
              },
              child: const Text("Save Settings", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
 
  Widget _buildSettingsInput(String label, String defaultVal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: defaultVal,
            cursorColor: _tealGreen,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: _tealGreen)),
              hoverColor: _paleGreen,
            ),
          ),
        ],
      ),
    );
  }
 
  Widget _buildUploadRow(String label) {
    final String? pickedFile = _uploadedFileNames[label];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    pickedFile ?? "No files selected",
                    style: TextStyle(color: pickedFile != null ? Colors.grey[800] : Colors.grey[400], fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _RectHoverButton(
                text: "Upload",
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles();
                  if (result != null && result.files.isNotEmpty) {
                    setState(() {
                      _uploadedFileNames[label] = result.files.single.name;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
 
class _HoverButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onTap;
  final bool fullTealHover;
  final Color? borderColor;
  final Color? hoverBorderColor;
 
  const _HoverButton({
    required this.text,
    required this.icon,
    this.onTap,
    this.fullTealHover = false,
    this.borderColor,
    this.hoverBorderColor,
  });
 
  @override
  __HoverButtonState createState() => __HoverButtonState();
}
 
class __HoverButtonState extends State<_HoverButton> {
  bool _isHovered = false;
 
  @override
  Widget build(BuildContext context) {
    final Color hoverBg = widget.fullTealHover ? const Color(0xFF009688) : const Color(0xFFE8F5E9);
    final Color normalContentColor = Colors.grey.shade600;
    final Color hoverContentColor = widget.fullTealHover ? Colors.white : const Color(0xFF009688);
    final Color normalBorder = widget.borderColor ?? Colors.grey.shade300;
 
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered ? hoverBg : Colors.grey.shade200,
            border: Border.all(
              color: _isHovered ? (widget.hoverBorderColor ?? hoverBg) : normalBorder,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 18, color: _isHovered ? hoverContentColor : normalContentColor),
              const SizedBox(width: 8),
              Text(
                widget.text,
                style: TextStyle(color: _isHovered ? hoverContentColor : normalContentColor, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 
class _RectHoverButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
 
  const _RectHoverButton({required this.text, this.onTap});
 
  @override
  __RectHoverButtonState createState() => __RectHoverButtonState();
}
 
class __RectHoverButtonState extends State<_RectHoverButton> {
  bool _isHovered = false;
 
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFF009688) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: _isHovered ? Colors.white : Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
 
class _DropdownHoverItem extends StatefulWidget {
  final String text;
  final bool selected;
  final Color tealGreen;
  final VoidCallback onTap;
 
  const _DropdownHoverItem({
    required this.text,
    required this.selected,
    required this.tealGreen,
    required this.onTap,
  });
 
  @override
  State<_DropdownHoverItem> createState() => _DropdownHoverItemState();
}
 
class _DropdownHoverItemState extends State<_DropdownHoverItem> {
  bool _hover = false;
 
  @override
  Widget build(BuildContext context) {
    final bool highlight = _hover || widget.selected;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          color: highlight ? widget.tealGreen : Colors.white,
          child: Row(
            children: [
              if (widget.selected)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.check, size: 14, color: Colors.white),
                ),
              Text(
                widget.text,
                style: TextStyle(
                  fontSize: 13,
                  color: highlight ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 
enum _CalMode { day, month, year }
 
class _CalendarPopup extends StatefulWidget {
  final DateTime initialMonth;
  final DateTime? initialSelected;
  final Color tealGreen;
  final ValueChanged<DateTime?> onSelect;
  final VoidCallback onClose;
 
  const _CalendarPopup({
    required this.initialMonth,
    required this.initialSelected,
    required this.tealGreen,
    required this.onSelect,
    required this.onClose,
  });
 
  @override
  State<_CalendarPopup> createState() => _CalendarPopupState();
}
 
class _CalendarPopupState extends State<_CalendarPopup> {
  late int _year;
  late int _month;
  DateTime? _selected;
  _CalMode _mode = _CalMode.day;
 
  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const List<String> _monthAbbr = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const List<String> _weekdayAbbr = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
 
  @override
  void initState() {
    super.initState();
    _year = widget.initialMonth.year;
    _month = widget.initialMonth.month;
    _selected = widget.initialSelected;
  }
 
  int get _decadeStart => (_year ~/ 12) * 12;
 
  void _prev() {
    setState(() {
      if (_mode == _CalMode.day) {
        _month--;
        if (_month < 1) {
          _month = 12;
          _year--;
        }
      } else if (_mode == _CalMode.month) {
        _year--;
      } else {
        _year -= 12;
      }
    });
  }
 
  void _next() {
    setState(() {
      if (_mode == _CalMode.day) {
        _month++;
        if (_month > 12) {
          _month = 1;
          _year++;
        }
      } else if (_mode == _CalMode.month) {
        _year++;
      } else {
        _year += 12;
      }
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 4),
          if (_mode == _CalMode.day) _buildDayGrid(),
          if (_mode == _CalMode.month) _buildMonthGrid(),
          if (_mode == _CalMode.year) _buildYearGrid(),
          if (_mode == _CalMode.day) ...[
            const SizedBox(height: 4),
            Divider(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 4),
            _buildFooter(),
          ],
        ],
      ),
    );
  }
 
  Widget _buildHeader() {
    String label;
    VoidCallback? onLabelTap;
    if (_mode == _CalMode.day) {
      label = "${_monthNames[_month - 1]}, $_year";
      onLabelTap = () => setState(() => _mode = _CalMode.month);
    } else if (_mode == _CalMode.month) {
      label = "$_year";
      onLabelTap = () => setState(() => _mode = _CalMode.year);
    } else {
      label = "$_decadeStart - ${_decadeStart + 11}";
      onLabelTap = null;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MouseRegion(
          cursor: onLabelTap != null ? SystemMouseCursors.click : MouseCursor.defer,
          child: GestureDetector(
            onTap: onLabelTap,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ),
        ),
        Row(
          children: [
            _NavArrowButton(icon: Icons.keyboard_arrow_up, onTap: _prev),
            const SizedBox(width: 4),
            _NavArrowButton(icon: Icons.keyboard_arrow_down, onTap: _next),
          ],
        ),
      ],
    );
  }
 
  Widget _buildDayGrid() {
    final daysInMonth = DateTime(_year, _month + 1, 0).day;
    final prevMonthDays = DateTime(_year, _month, 0).day;
    final firstOfMonth = DateTime(_year, _month, 1);
    final leadingDays = firstOfMonth.weekday % 7;
    final totalCells = ((leadingDays + daysInMonth) / 7).ceil() * 7;
 
    final today = DateTime.now();
    final cells = <Widget>[];
 
    for (int i = 0; i < totalCells; i++) {
      final dayNum = i - leadingDays + 1;
      DateTime cellDate;
      bool inCurrentMonth = true;
      if (dayNum < 1) {
        final prevMonth = _month == 1 ? 12 : _month - 1;
        final prevYear = _month == 1 ? _year - 1 : _year;
        cellDate = DateTime(prevYear, prevMonth, prevMonthDays + dayNum);
        inCurrentMonth = false;
      } else if (dayNum > daysInMonth) {
        final nextMonth = _month == 12 ? 1 : _month + 1;
        final nextYear = _month == 12 ? _year + 1 : _year;
        cellDate = DateTime(nextYear, nextMonth, dayNum - daysInMonth);
        inCurrentMonth = false;
      } else {
        cellDate = DateTime(_year, _month, dayNum);
      }
 
      final bool isSelected = _selected != null &&
          _selected!.year == cellDate.year &&
          _selected!.month == cellDate.month &&
          _selected!.day == cellDate.day;
      final bool isToday = today.year == cellDate.year && today.month == cellDate.month && today.day == cellDate.day;
 
      cells.add(_DayCell(
        label: '${cellDate.day}',
        dimmed: !inCurrentMonth,
        isSelected: isSelected,
        isToday: isToday,
        tealGreen: widget.tealGreen,
        onTap: () {
          setState(() => _selected = cellDate);
          widget.onSelect(cellDate);
          widget.onClose();
        },
      ));
    }
 
    return Column(
      children: [
        Row(
          children: _weekdayAbbr
              .map((d) => Expanded(
                    child: Center(
                      child: Text(d, style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w600)),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 2),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          childAspectRatio: 1.25,
          children: cells,
        ),
      ],
    );
  }
 
  Widget _buildMonthGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      childAspectRatio: 2.6,
      children: List.generate(12, (i) {
        final monthIndex = i + 1;
        return _GridChoiceCell(
          label: _monthAbbr[i],
          isActive: monthIndex == _month,
          tealGreen: widget.tealGreen,
          onTap: () => setState(() {
            _month = monthIndex;
            _mode = _CalMode.day;
          }),
        );
      }),
    );
  }
 
  Widget _buildYearGrid() {
    final start = _decadeStart;
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      childAspectRatio: 2.6,
      children: List.generate(12, (i) {
        final y = start + i;
        return _GridChoiceCell(
          label: '$y',
          isActive: y == _year,
          tealGreen: widget.tealGreen,
          onTap: () => setState(() {
            _year = y;
            _mode = _CalMode.month;
          }),
        );
      }),
    );
  }
 
  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _TextLinkButton(
          text: "Clear",
          tealGreen: widget.tealGreen,
          onTap: () {
            setState(() => _selected = null);
            widget.onSelect(null);
            widget.onClose();
          },
        ),
        _TextLinkButton(
          text: "Today",
          tealGreen: widget.tealGreen,
          onTap: () {
            final now = DateTime.now();
            setState(() {
              _year = now.year;
              _month = now.month;
              _selected = now;
              _mode = _CalMode.day;
            });
            widget.onSelect(now);
            widget.onClose();
          },
        ),
      ],
    );
  }
}
 
class _NavArrowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
 
  const _NavArrowButton({required this.icon, required this.onTap});
 
  @override
  State<_NavArrowButton> createState() => _NavArrowButtonState();
}
 
class _NavArrowButtonState extends State<_NavArrowButton> {
  bool _hover = false;
 
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _hover ? Colors.grey.shade200 : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(widget.icon, size: 16, color: Colors.grey[700]),
        ),
      ),
    );
  }
}
 
class _DayCell extends StatefulWidget {
  final String label;
  final bool dimmed;
  final bool isSelected;
  final bool isToday;
  final Color tealGreen;
  final VoidCallback onTap;
 
  const _DayCell({
    required this.label,
    required this.dimmed,
    required this.isSelected,
    required this.isToday,
    required this.tealGreen,
    required this.onTap,
  });
 
  @override
  State<_DayCell> createState() => _DayCellState();
}
 
class _DayCellState extends State<_DayCell> {
  bool _hover = false;
 
  @override
  Widget build(BuildContext context) {
    Color? bg;
    Color textColor = widget.dimmed ? Colors.grey.shade400 : Colors.grey.shade800;
    Border? border;
 
    if (widget.isSelected) {
      bg = widget.tealGreen;
      textColor = Colors.white;
      border = Border.all(color: Colors.black, width: 1);
    } else if (_hover) {
      bg = Colors.grey.shade200;
    }
 
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Center(
          child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bg,
              shape: widget.isSelected ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: widget.isSelected ? BorderRadius.circular(4) : null,
              border: border,
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
                fontWeight: widget.isToday && !widget.isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
 
class _GridChoiceCell extends StatefulWidget {
  final String label;
  final bool isActive;
  final Color tealGreen;
  final VoidCallback onTap;
 
  const _GridChoiceCell({
    required this.label,
    required this.isActive,
    required this.tealGreen,
    required this.onTap,
  });
 
  @override
  State<_GridChoiceCell> createState() => _GridChoiceCellState();
}
 
class _GridChoiceCellState extends State<_GridChoiceCell> {
  bool _hover = false;
 
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.isActive ? widget.tealGreen : (_hover ? Colors.grey.shade200 : Colors.transparent),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 12,
              color: widget.isActive ? Colors.white : Colors.grey.shade800,
            ),
          ),
        ),
      ),
    );
  }
}
 
class _TextLinkButton extends StatefulWidget {
  final String text;
  final Color tealGreen;
  final VoidCallback onTap;
 
  const _TextLinkButton({required this.text, required this.tealGreen, required this.onTap});
 
  @override
  State<_TextLinkButton> createState() => _TextLinkButtonState();
}
 
class _TextLinkButtonState extends State<_TextLinkButton> {
  bool _hover = false;
 
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 13,
            color: widget.tealGreen,
            fontWeight: FontWeight.w600,
            decoration: _hover ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
 
class _ToastItem {
  final String id;
  final String message;
  _ToastItem(this.id, this.message);
}
 