import 'package:flutter/material.dart';
import '../theme/theme.dart';

class DashboardScreen extends StatefulWidget {
  final bool isDark;
  final Function(bool) onThemeToggle;
  final Function(int) onNavigate;

  const DashboardScreen({
    super.key,
    required this.isDark,
    required this.onThemeToggle,
    required this.onNavigate,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isViewAllHovered = false;
  int? hoveredThemeBtn;
  int? hoveredActionBoxIndex;

  final List<Map<String, dynamic>> reports = const [
    {'id': 'RPT-20260225-0012', 'files': '1240', 'success': '1240', 'failed': '0', 'date': '2026-02-25', 'time': '14:12', 'hasWarning': false},
    {'id': 'RPT-20260224-0011', 'files': '1', 'success': '1', 'failed': '0', 'date': '2026-02-24', 'time': '09:45', 'hasWarning': false},
    {'id': 'RPT-20260223-0010', 'files': '382', 'success': '379', 'failed': '3', 'date': '2026-02-23', 'time': '23:01', 'hasWarning': true},
    {'id': 'RPT-20260222-0009', 'files': '870', 'success': '870', 'failed': '0', 'date': '2026-02-22', 'time': '03:00', 'hasWarning': false},
    {'id': 'RPT-20260220-0008', 'files': '55', 'success': '55', 'failed': '0', 'date': '2026-02-20', 'time': '16:30', 'hasWarning': false},
  ];

  @override
  Widget build(BuildContext context) {
    Color cardBg = widget.isDark ? AppColors.darkCard : AppColors.lightCard;
    Color textColor = widget.isDark ? AppColors.darkText : AppColors.lightText;
    Color subTextColor = widget.isDark ? AppColors.darkGreyText : AppColors.lightGreyText;
    Color borderColor = widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      color: widget.isDark ? AppColors.darkBg : AppColors.lightBg,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(20), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('System Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 2),
              Text('Monitor your security operations and system health', style: TextStyle(fontSize: 12, color: subTextColor)),
              const SizedBox(height: 16),
              _licenseStatusCard(cardBg, textColor, subTextColor, borderColor),
              const SizedBox(height: 18),
              Text('Quick Actions', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: subTextColor)),
              const SizedBox(height: 8),
              _quickActionsRow(cardBg, textColor, subTextColor, borderColor),
              const SizedBox(height: 20),
              Text('System Health', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: subTextColor)),
              const SizedBox(height: 8),
              _systemHealthRow(cardBg, textColor, subTextColor, borderColor),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Reports', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: subTextColor)),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => isViewAllHovered = true),
                    onExit: (_) => setState(() => isViewAllHovered = false),
                    child: GestureDetector(
                      onTap: () {},
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isViewAllHovered ? AppColors.primaryTeal.withOpacity(0.12) : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryTeal)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _recentReportsTable(cardBg, textColor, subTextColor, borderColor),
              const SizedBox(height: 10), // Reduced bottom empty space to balance scrolling proportions
            ],
          ),
        ),
      ),
    );
  }

  Widget _licenseStatusCard(Color bg, Color text, Color subText, Color border) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: border)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Color(0xFFFCE7F3), shape: BoxShape.circle),
            child: const Icon(Icons.shield_outlined, color: Color(0xFFDB2777), size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('License Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: text)),
              const SizedBox(height: 6),
              Text('Pro Edition - Licensed to: Enterprise Security Team', style: TextStyle(color: subText, fontSize: 12)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('Activated: ', style: TextStyle(color: subText, fontSize: 11)),
                  Text('2026-01-10 ', style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.w500)),
                  Text('Expires: ', style: TextStyle(color: subText, fontSize: 11)),
                  Text('2030-12-31 ', style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.w500)),
                  Text('Days Left: ', style: TextStyle(color: subText, fontSize: 11)),
                  Text('1621', style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.w500)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _quickActionsRow(Color bg, Color text, Color subText, Color border) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _actionBoxCard(0, Icons.find_in_page_outlined, 'Erase Files', 'Securely delete files', bg, text, subText, border)),
          const SizedBox(width: 12),
          Expanded(child: _actionBoxCard(1, Icons.dns_outlined, 'Erase Volume', 'Wipe entire drives', bg, text, subText, border)),
          const SizedBox(width: 12),
          Expanded(child: _actionBoxCard(2, Icons.access_time, 'Schedule Task', 'Automate erasure', bg, text, subText, border)),
          const SizedBox(width: 12),
          Expanded(child: _themeBoxCard(3, bg, text, subText, border)),
        ],
      ),
    );
  }

  Widget _actionBoxCard(int boxIndex, IconData icon, String title, String subtitle, Color bg, Color text, Color subText, Color border) {
    bool isHovered = hoveredActionBoxIndex == boxIndex;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hoveredActionBoxIndex = boxIndex),
      onExit: (_) => setState(() => hoveredActionBoxIndex = null),
      child: GestureDetector(
        onTap: () => widget.onNavigate(boxIndex + 1), 
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 130,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isHovered ? AppColors.primaryTeal : border, width: isHovered ? 1.5 : 1.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.primaryTeal, size: 20),
              const SizedBox(height: 10),
              Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: text)),
              Text(subtitle, style: TextStyle(color: subText, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _themeBoxCard(int boxIndex, Color bg, Color text, Color subText, Color border) {
    bool isHovered = hoveredActionBoxIndex == boxIndex;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hoveredActionBoxIndex = boxIndex),
      onExit: (_) => setState(() => hoveredActionBoxIndex = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 130,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isHovered ? AppColors.primaryTeal : border, width: isHovered ? 1.5 : 1.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(Icons.wb_sunny_outlined, size: 13, color: subText), const SizedBox(width: 6), Text('Theme Mode', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: text))]),
            Text('Customize appearance', style: TextStyle(color: subText, fontSize: 10)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(color: widget.isDark ? Colors.white10 : const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _themeInteractiveBtn(Icons.wb_sunny_outlined, 0, false),
                  _themeInteractiveBtn(Icons.nightlight_outlined, 1, true),
                  _themeInteractiveBtn(Icons.shield_outlined, 2, false),
                  _themeInteractiveBtn(Icons.flash_on_outlined, 3, false),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _themeInteractiveBtn(IconData icon, int index, bool isDarkBtn) {
    bool isSelected = (widget.isDark && isDarkBtn) || (!widget.isDark && index == 0);
    bool isHovered = hoveredThemeBtn == index;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hoveredThemeBtn = index),
      onExit: (_) => setState(() => hoveredThemeBtn = null),
      child: GestureDetector(
        onTap: () {
          if (index == 0) widget.onThemeToggle(false);
          if (index == 1) widget.onThemeToggle(true);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? (widget.isDark ? AppColors.darkCard : Colors.white) : (isHovered ? AppColors.primaryTeal.withOpacity(0.15) : Colors.transparent),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, size: 14, color: isSelected ? AppColors.primaryTeal : (isHovered ? AppColors.primaryTeal : AppColors.lightGreyText)),
        ),
      ),
    );
  }

  Widget _systemHealthRow(Color bg, Color text, Color subText, Color border) {
    return Row(
      children: [
        Expanded(child: _statCard('Total Operations', '0', 'All time', text, subText, bg, border)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Drive Status', '4 Ready', 'All drives are healthy', text, const Color(0xFFEF4444), bg, border)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Scheduled Tasks', '3 Active', 'Running imminently', text, AppColors.primaryTeal, bg, border)),
      ],
    );
  }

  Widget _statCard(String title, String value, String subtitle, Color valColor, Color subColor, Color bg, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18), // Increased height for system health cards slightly to match proportions
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: AppColors.lightGreyText, fontSize: 10)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: valColor)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: subColor, fontSize: 10, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _recentReportsTable(Color bg, Color text, Color subText, Color border) {
    return Container(
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: border)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Increased overall height slightly for balanced proportions
      child: Table(
        columnWidths: const {0: FlexColumnWidth(2.6), 1: FlexColumnWidth(1), 2: FlexColumnWidth(1), 3: FlexColumnWidth(1), 4: FlexColumnWidth(1.2), 5: FlexColumnWidth(1)},
        children: [
          TableRow(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: border.withOpacity(0.9), width: 1.0))), // Made divider lines slightly more visible and professional
            children: [_th('Report ID', subText), _th('Files', subText), _th('Success', subText), _th('Failed', subText), _th('Date', subText), _th('Time', subText)],
          ),
          ...reports.asMap().entries.map((entry) {
            int index = entry.key;
            var r = entry.value;
            bool isWarn = r['hasWarning'];
            Color iconColor = isWarn ? const Color(0xFFF59E0B) : AppColors.primaryTeal;
            bool isLast = index == reports.length - 1;
            return TableRow(
              decoration: BoxDecoration(border: isLast ? null : Border(bottom: BorderSide(color: border.withOpacity(0.7), width: 0.8))), // Enhanced visibility of row dividers slightly
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: Row(
                    children: [
                      Icon(isWarn ? Icons.warning_amber_rounded : Icons.check_circle_outline, size: 15, color: iconColor),
                      const SizedBox(width: 8),
                      Text(r['id'], style: TextStyle(fontSize: 12, color: text, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                _td(r['files'], text),
                _td(r['success'], isWarn ? const Color(0xFFF59E0B) : AppColors.primaryTeal),
                _td(r['failed'], isWarn ? const Color(0xFFF59E0B) : subText),
                _td(r['date'], subText),
                _td(r['time'], subText),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _th(String label, Color color) => Padding(padding: const EdgeInsets.symmetric(vertical: 13), child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)));
  Widget _td(String val, Color color) => Padding(padding: const EdgeInsets.symmetric(vertical: 13), child: Text(val, style: TextStyle(fontSize: 12, color: color)));
}

