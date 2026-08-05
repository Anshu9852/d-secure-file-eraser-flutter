import 'package:flutter/material.dart';

class DeletedDataEraserScreen extends StatefulWidget {
  const DeletedDataEraserScreen({Key? key}) : super(key: key);

  @override
  State<DeletedDataEraserScreen> createState() => _DeletedDataEraserScreenState();
}

class _DeletedDataEraserScreenState extends State<DeletedDataEraserScreen> {
  int _selectedDriveIndex = 3;
  String _selectedMethod = 'Zero Fill (1-pass)';
  
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _drives = [
    {
      'name': 'System (C:)',
      'isBoot': true,
      'totalSize': '476.9 GB',
      'freeSpace': '95.4 GB',
      'usedSpace': '381.6 GB',
      'percentage': 19,
    },
    {
      'name': 'Work & Projects (D:)',
      'isBoot': false,
      'totalSize': '953.7 GB',
      'freeSpace': '476.8 GB',
      'usedSpace': '476.8 GB',
      'percentage': 50,
    },
    {
      'name': 'Media Library (E:)',
      'isBoot': false,
      'totalSize': '1.8 TB',
      'freeSpace': '814.9 GB',
      'usedSpace': '1.0 TB',
      'percentage': 43,
    },
    {
      'name': 'SanDisk USB (F:)',
      'isBoot': false,
      'totalSize': '59.6 GB',
      'freeSpace': '29.8 GB',
      'usedSpace': '29.8 GB',
      'percentage': 50,
    },
    {
      'name': 'Backup Drive (G:)',
      'isBoot': false,
      'totalSize': '3.6 TB',
      'freeSpace': '1.1 TB',
      'usedSpace': '2.5 TB',
      'percentage': 30,
    },
  ];

  final List<String> _erasureMethods = [
    'Zero Fill (1-pass)',
    'One Fill (1-pass)',
    'Random Data (1-pass)',
    'NIST SP 800-88 Rev1 (3-pass)',
    'DoD 5220.22-M (E) Extended (7-pass)',
    'DoD 5220.28-M (STD) (3-pass)',
    'HMG IS5 Enhanced (3-pass)',
    'Gutmann Method (3-pass)',
    'PCI DSS 3.2.1 (3-pass)',
    'ISO/IEC 27040:2015 (3-pass)',
    'RCMP TSSIT OPS-II (7-pass)',
    'GOST R 50739-95 (2-pass)',
    'AFSSI-5020 (3-pass)',
    'NAVSO P-5239-26 (3-pass)',
    'ISO/IEC 27001:2013 (3-pass)',
    'Random + Zero Combo (2-pass)',
    '7-Pass with Verification (7-pass)',
    'Pfitzner Method (3-pass)',
    'Schneier Method (7-pass)',
    'VSITR (German Standard) (7-pass)',
    'AR 380-19 (US Army) (3-pass)',
    'China GB 17859-2018 (3-pass)',
    'Brazil LGPD (3-pass)',
    'India DPA (3-pass)',
    'Japan APPI (3-pass)',
    'Korea PIPA (3-pass)',
    'Quick Wipe (1-pass)',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Deleted Data Eraser',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Permanently erase already deleted files (free space)',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F4F1),
                        border: Border.all(color: const Color(0xFFB2DCD5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFF0F766E),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'About Free Space Erasure',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'When files are deleted, they remain on the drive until overwritten. This tool overwrites free space, making recovery impossible. Select a volume to begin.',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: Color(0xFF64748B),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    ...List.generate(_drives.length, (index) {
                      final drive = _drives[index];
                      final isSelected = _selectedDriveIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: StatefulBuilder(
                          builder: (context, setHoverState) {
                            bool isHovered = false;
                            return MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (_) => setHoverState(() => isHovered = true),
                              onExit: (_) => setHoverState(() => isHovered = false),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDriveIndex = index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: (isSelected || isHovered)
                                          ? const Color(0xFF0F766E)
                                          : const Color(0xFFE2E8F0),
                                      width: (isSelected || isHovered) ? 1.5 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.02),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Row 1: Icon, Name & Boot Volume
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE6F4F1),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Icon(
                                              Icons.storage_rounded,
                                              color: Color(0xFF0F766E),
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            drive['name'],
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E293B),
                                            ),
                                          ),
                                          if (drive['isBoot'] == true) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE6F4F1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Text(
                                                'Boot Volume',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xFF0F766E),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      // Reduced spacing here to make Total Size closer to the drive name
                                      const SizedBox(height: 10),
                                      // Row 2: Aligned under text with Grey GB values
                                      Padding(
                                        padding: const EdgeInsets.only(left: 32.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text('Total Size', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                                const SizedBox(height: 3),
                                                Text(drive['totalSize'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Color(0xFF64748B))),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text('Free Space', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                                const SizedBox(height: 3),
                                                Text(drive['freeSpace'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Color(0xFF64748B))),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text('Used Space', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                                const SizedBox(height: 3),
                                                Text(drive['usedSpace'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Color(0xFF64748B))),
                                              ],
                                            ),
                                            const SizedBox(width: 20),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      // Progress Bar with Percentage positioned right above it on the right side
                                      Padding(
                                        padding: const EdgeInsets.only(left: 32.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  'Free Space',
                                                  style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 20.0),
                                                  child: Text(
                                                    '${drive['percentage']}%',
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Color(0xFF64748B),
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 20.0),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(4),
                                                child: LinearProgressIndicator(
                                                  value: drive['percentage'] / 100,
                                                  backgroundColor: const Color(0xFFE2E8F0),
                                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                                      Color(0xFF0F766E)),
                                                  minHeight: 6,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selected: ${_drives[_selectedDriveIndex]['name']}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'Method:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedMethod,
                          isDense: true,
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 2, right: 2),
                            child: Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF64748B)),
                          ),
                          style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)),
                          items: _erasureMethods.map((String method) {
                            return DropdownMenuItem<String>(
                              value: method,
                              child: Text(method),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedMethod = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F766E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.play_arrow_rounded, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Erase Deleted Data',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

