import 'package:flutter/material.dart';
import '../theme/theme.dart';
 
class Sidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  // CHANGED: isDark (bool) -> themeMode (AppThemeMode), so sidebar can also
  // follow the new "light greenish" and "dark + green text" modes.
  final AppThemeMode themeMode;
 
  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.themeMode,
  });
 
  @override
  State<Sidebar> createState() => _SidebarState();
}
 
class _SidebarState extends State<Sidebar> {
  int? hoveredIndex;
  bool isCollapsed = false;
  bool isBottomBtnHovered = false;
 
  // Helper flags derived from themeMode
  bool get _isDarkBase =>
      widget.themeMode == AppThemeMode.dark ||
      widget.themeMode == AppThemeMode.greenDark;
  bool get _isGreenLight => widget.themeMode == AppThemeMode.greenLight;
  bool get _isGreenDark => widget.themeMode == AppThemeMode.greenDark;
 
  // ---- Custom grey palette (dynamic based on themeMode now) ----
  Color get sidebarGreyBg {
    // Now uses the exact same mint color (AppColors.greenLightBg) that's
    // used for the main page/dashboard background in greenLight mode.
    if (_isGreenLight) return AppColors.greenLightBg;
    if (_isDarkBase) return AppColors.darkCard;
    return const Color(0xFFF7F7F8); // light grey-white
  }
 
  Color get sidebarGreyText {
    if (_isGreenDark) return AppColors.greenDarkText;
    if (_isGreenLight) return AppColors.greenLightText;
    if (_isDarkBase) return AppColors.darkText;
    return const Color(0xFF3A3A3A);
  }
 
  Color get sidebarGreyBorder {
    if (_isGreenLight) return AppColors.greenLightBorder;
    if (_isDarkBase) return AppColors.darkBorder;
    return const Color(0xFFD5D5D5); // lighter grey line
  }
 
  Color get sidebarHoverBg {
    if (_isGreenLight) return const Color(0xFFDCFCE7);
    if (_isDarkBase) return const Color(0xFF334155);
    return const Color(0xFFE3E8EE); // light grey-blue hover
  }
 
  Color get sidebarSelectedBg {
    if (_isGreenLight) return const Color(0xFFBBF7D0);
    if (_isDarkBase) return const Color(0xFF3B4A5F);
    return const Color(0xFFD6DFE7); // light blue-grey selected
  }
 
  final List<Map<String, dynamic>> menuItems = const [
    {'icon': Icons.grid_view_rounded, 'title': 'Dashboard'},
    {'icon': Icons.description_outlined, 'title': 'Erase Files & Folder'},
    {'icon': Icons.dns_outlined, 'title': 'Volume Eraser'},
    {'icon': Icons.delete_outline, 'title': 'Deleted Data Eraser'},
    {'icon': Icons.access_time, 'title': 'Scheduler'},
    {'icon': Icons.insert_drive_file_outlined, 'title': 'Reports'},
    {'icon': Icons.cloud_outlined, 'title': 'Cloud Erase'},
    {'icon': Icons.settings_outlined, 'title': 'Settings'},
  ];
 
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      // Width increased so text doesn't get cut
      width: isCollapsed ? 56 : 210,
      decoration: BoxDecoration(
        color: sidebarGreyBg,
        // Straight right divider (touches header till footer)
        border: Border(
          right: BorderSide(
            color: sidebarGreyBorder,
            width: 1.2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top divider (Header ke niche touch karega)
          Container(
            height: 1,
            color: sidebarGreyBorder,
          ),
 
          const SizedBox(height: 10),
 
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: menuItems.length,
              itemBuilder: (context, i) {
                return _buildMenuItem(
                  menuItems[i]['icon'],
                  menuItems[i]['title'],
                  i == widget.selectedIndex,
                  i,
                );
              },
            ),
          ),
 
          // Collapse Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => isBottomBtnHovered = true),
              onExit: (_) => setState(() => isBottomBtnHovered = false),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isCollapsed = !isCollapsed;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: 36,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isBottomBtnHovered
                        ? AppColors.primaryTeal
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      isCollapsed
                          ? Icons.dock_outlined
                          : Icons.menu_open_rounded,
                      size: 18,
                      color: isBottomBtnHovered
                          ? Colors.white
                          : sidebarGreyText,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
 
  Widget _buildMenuItem(
    IconData icon,
    String title,
    bool isSelected,
    int index,
  ) {
    bool isHovered = hoveredIndex == index;
 
    // Selected ho toh selected color, warna hover pe hover color, warna transparent
    Color bgColor;
    if (isSelected) {
      bgColor = sidebarSelectedBg;
    } else if (isHovered) {
      bgColor = sidebarHoverBg;
    } else {
      bgColor = Colors.transparent;
    }
 
    bool isHighlighted = isSelected || isHovered;
 
    return Padding(
      // Right side thoda extra padding taaki text/border ke beech gap rahe
      padding: const EdgeInsets.only(left: 8, right: 12, top: 2, bottom: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => hoveredIndex = index),
        onExit: (_) => setState(() => hoveredIndex = null),
        child: Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => widget.onItemSelected(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: isHighlighted
                        ? AppColors.primaryTeal
                        : sidebarGreyText,
                  ),
                  if (!isCollapsed) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isHighlighted
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isHighlighted
                              ? AppColors.primaryTeal
                              : sidebarGreyText,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
 