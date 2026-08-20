import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../widgets/header.dart';
import '../widgets/sidebar.dart';
import 'dashboard_screen.dart';
import 'erase_files_screen.dart';
import 'volume_eraser_screen.dart';
import 'deleted_data_eraser_screen.dart';
import 'scheduler_screen.dart';
import 'reports_screen.dart';
import 'cloud_erase_screen.dart';
import 'settings_screen.dart';
 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
 
  AppThemeMode themeMode = AppThemeMode.light;
 
  bool get isDark =>
      themeMode == AppThemeMode.dark || themeMode == AppThemeMode.greenDark;
 
  void _onThemeToggle(AppThemeMode mode) {
    setState(() {
      themeMode = mode;
    });
  }
 
  Color get _scaffoldBg {
    switch (themeMode) {
      case AppThemeMode.dark:
      case AppThemeMode.greenDark:
        return const Color(0xFF0F172A);
      case AppThemeMode.greenLight:
        return AppColors.greenLightBg;
      case AppThemeMode.light:
        return const Color(0xFFF8FAFC);
    }
  }
 
  Color get _panelBg {
    switch (themeMode) {
      case AppThemeMode.dark:
      case AppThemeMode.greenDark:
        return const Color(0xFF1E293B);
      case AppThemeMode.greenLight:
        return AppColors.greenLightCard;
      case AppThemeMode.light:
        return Colors.white;
    }
  }
 
  Color get _panelBorder {
    switch (themeMode) {
      case AppThemeMode.dark:
      case AppThemeMode.greenDark:
        return const Color(0xFF334155);
      case AppThemeMode.greenLight:
        return AppColors.greenLightBorder;
      case AppThemeMode.light:
        return const Color(0xFFE2E8F0);
    }
  }
 
  Color get _footerBg {
    switch (themeMode) {
      case AppThemeMode.dark:
      case AppThemeMode.greenDark:
        return const Color(0xFF1E293B);
      case AppThemeMode.greenLight:
        return AppColors.greenLightCard;
      case AppThemeMode.light:
        return const Color(0xFFF1F5F9);
    }
  }
 
  Color get _footerText {
    switch (themeMode) {
      case AppThemeMode.dark:
        return const Color(0xFF94A3B8);
      case AppThemeMode.greenDark:
        return AppColors.greenDarkGreyText;
      case AppThemeMode.greenLight:
        return AppColors.greenLightGreyText;
      case AppThemeMode.light:
        return Colors.grey[700]!;
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            decoration: BoxDecoration(
              color: _panelBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _panelBorder),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Header(isDark: isDark),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Sidebar(
                        selectedIndex: selectedIndex,
                        onItemSelected: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        themeMode: themeMode,
                      ),
                      Expanded(
                        child: IndexedStack(
                          index: selectedIndex,
                          children: [
                            DashboardScreen(
                              themeMode: themeMode,
                              onThemeToggle: _onThemeToggle,
                              onNavigate: (index) {
                                int targetIndex = index;
                                if (index == 3) targetIndex = 4;
                                setState(() {
                                  selectedIndex = targetIndex;
                                });
                              },
                            ),
                            EraseFilesScreen(isDark: isDark),
                            // [CHANGED] Was `const VolumeEraserScreen()`.
                            // Now passes themeMode so this page follows
                            // Light/Dark/DSecure/DSecure Light like the
                            // sidebar, Cloud Erase, Scheduler, Reports do.
                            VolumeEraserScreen(themeMode: themeMode),
                            DeletedDataEraserScreen(themeMode: themeMode),
                            SchedulerScreen(themeMode: themeMode),
                            ReportsScreen(themeMode: themeMode),
                            CloudEraseScreen(themeMode: themeMode),
                            SettingsScreen(
                              themeMode: themeMode,
                              onThemeModeChanged: _onThemeToggle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    color: _footerBg,
                    border: const Border(
                      top: BorderSide(
                        color: Color(0xFFD5D5D5),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle_outline, size: 13, color: Colors.teal),
                          const SizedBox(width: 6),
                          Text(
                            "Ready | Last operation:",
                            style: TextStyle(
                              fontSize: 11,
                              color: _footerText,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.shield_outlined, size: 13, color: Colors.teal),
                          const SizedBox(width: 5),
                          Text(
                            "Licensed",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 