import 'package:flutter/material.dart';
import '../theme/theme.dart';

class Sidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool isDark;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.isDark,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int? hoveredIndex;
  bool isCollapsed = false;
  bool isBottomBtnHovered = false;

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
      width: isCollapsed ? 64 : 220,
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkCard : AppColors.lightCard,
        // Straight right divider
        border: Border(
          right: BorderSide(
            color: widget.isDark
                ? AppColors.darkBorder
                : AppColors.lightBorder,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top divider (Header ke niche touch karega)
          Container(
            height: 1,
            color: widget.isDark
                ? AppColors.darkBorder
                : AppColors.lightBorder,
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
                          : (widget.isDark
                              ? AppColors.darkGreyText
                              : AppColors.lightGreyText),
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
    bool isHighlighted = isSelected || isHovered;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => hoveredIndex = index),
        onExit: (_) => setState(() => hoveredIndex = null),
        child: Material(
          color: isHighlighted
              ? (widget.isDark
                  ? AppColors.primaryTeal.withOpacity(0.30)
                  : const Color(0xFFE0F2FE))
              : Colors.transparent,
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
                        : (widget.isDark
                            ? AppColors.darkGreyText
                            : AppColors.lightGreyText),
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
                              : (widget.isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText),
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

