import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/sidebar.dart';
import 'dashboard_screen.dart';
import 'erase_files_screen.dart';
import 'volume_eraser_screen.dart'; 
import 'deleted_data_eraser_screen.dart';
import 'scheduler_screen.dart';
import 'reports_screen.dart'; // Sirf yeh naya import add hua hai

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  bool isDark = false;

  void _onThemeToggle(bool val) {
    setState(() {
      isDark = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Header(isDark: isDark),
                
                // Content area (Changes dynamically based on sidebar/cards)
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
                        isDark: isDark,
                      ),
                      Expanded(
                        child: IndexedStack(
                          index: selectedIndex,
                          children: [
                            // Yahan Dashboard, Erase, Volume, Deleted, Scheduler waisa hi hai
                            DashboardScreen(
                              isDark: isDark,
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
                            const VolumeEraserScreen(), 
                            const DeletedDataEraserScreen(), 
                            const SchedulerScreen(), 
                            const ReportsScreen(), // Sirf yeh naya addition hai
                            const Center(child: Text("Cloud Erase")),
                            const Center(child: Text("Settings")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Single, Clean & Fixed Professional Footer (Sab waisa hi hai)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    border: Border(
                      top: BorderSide(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
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
                              color: isDark ? const Color(0xFF94A3B8) : Colors.grey[700],
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

