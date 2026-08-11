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

  void _showConfirmDialog() {
    final driveName = _drives[_selectedDriveIndex]['name'];
    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            bool isMatched = confirmController.text == 'ERASE';

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
              backgroundColor: Colors.white,
              child: Container(
                width: 440,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Color(0xFFE11D48),
                              size: 22,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Confirm Deleted Data Erasure',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(4),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'You are about to erase all recoverable deleted data on $driveName. This process will overwrite all free space and may take several hours.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF475569),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 12, color: Color(0xFF475569)),
                        children: [
                          TextSpan(text: 'Type '),
                          TextSpan(
                            text: 'ERASE',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                          ),
                          TextSpan(text: ' to confirm:'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: confirmController,
                      onChanged: (value) {
                        setStateDialog(() {});
                      },
                      cursorColor: const Color(0xFF0F9D94),
                      style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                      decoration: InputDecoration(
                        hintText: 'ERASE',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        filled: true,
                        fillColor: confirmController.text.isNotEmpty
                            ? const Color(0xFFE6F4F1)
                            : Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFF0F9D94), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF1E293B),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: const BorderSide(color: Color(0xFFCBD5E1), width: 1),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F9D94),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF0F9D94).withOpacity(0.5),
                            disabledForegroundColor: Colors.white.withOpacity(0.7),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: isMatched
                              ? () {
                                  Navigator.of(context).pop();
                                }
                              : null,
                          child: const Text(
                            'Confirm',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

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
                        children: const [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFF0F9D94),
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                          ? const Color(0xFF0F9D94)
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
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE6F4F1),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Icon(
                                              Icons.sd_storage_outlined,
                                              color: Color(0xFF0F9D94),
                                              size: 20,
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
                                                  color: Color(0xFF0F9D94),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 10),
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
                                                      Color(0xFF0F9D94)),
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
          ErasureBottomBar(
            selectedDriveName: _drives[_selectedDriveIndex]['name'],
            selectedMethod: _selectedMethod,
            erasureMethods: _erasureMethods,
            onMethodChanged: (newMethod) {
              setState(() {
                _selectedMethod = newMethod;
              });
            },
            onErasePressed: _showConfirmDialog,
          ),
        ],
      ),
    );
  }
}

class ErasureBottomBar extends StatelessWidget {
  final String selectedDriveName;
  final String selectedMethod;
  final List<String> erasureMethods;
  final ValueChanged<String> onMethodChanged;
  final VoidCallback onErasePressed;

  const ErasureBottomBar({
    Key? key,
    required this.selectedDriveName,
    required this.selectedMethod,
    required this.erasureMethods,
    required this.onMethodChanged,
    required this.onErasePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Selected: $selectedDriveName',
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
              ErasureMethodDropdown(
                selectedMethod: selectedMethod,
                erasureMethods: erasureMethods,
                onMethodChanged: onMethodChanged,
              ),
              const SizedBox(width: 12),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F9D94),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    elevation: 0,
                  ),
                  onPressed: onErasePressed,
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
    );
  }
}

class ErasureMethodDropdown extends StatelessWidget {
  final String selectedMethod;
  final List<String> erasureMethods;
  final ValueChanged<String> onMethodChanged;

  const ErasureMethodDropdown({
    Key? key,
    required this.selectedMethod,
    required this.erasureMethods,
    required this.onMethodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: selectedMethod,
      padding: EdgeInsets.zero,
      offset: const Offset(0, -252),
      position: PopupMenuPosition.over,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: Color(0xFFCBD5E1), width: 1),
      ),
      color: Colors.white,
      elevation: 4,
      constraints: const BoxConstraints(
        minWidth: 310,
        maxWidth: 310,
        maxHeight: 245,
      ),
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFCBD5E1)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedMethod,
              style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Color(0xFF64748B),
            ),
          ],
        ),
      ),
      itemBuilder: (BuildContext context) {
        return erasureMethods.map((String method) {
          return PopupMenuItem<String>(
            value: method,
            height: 35,
            padding: EdgeInsets.zero,
            child: _PopupItemTile(
              method: method,
              isSelected: selectedMethod == method,
            ),
          );
        }).toList();
      },
      onSelected: onMethodChanged,
    );
  }
}

class _PopupItemTile extends StatefulWidget {
  final String method;
  final bool isSelected;

  const _PopupItemTile({
    Key? key,
    required this.method,
    required this.isSelected,
  }) : super(key: key);

  @override
  State<_PopupItemTile> createState() => _PopupItemTileState();
}

class _PopupItemTileState extends State<_PopupItemTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.transparent;
    Color textColor = const Color(0xFF1E293B);

    if (widget.isSelected) {
      bgColor = const Color(0xFF0F9D94);
      textColor = Colors.white;
    } else if (_isHovered) {
      bgColor = const Color(0xFF0F9D94).withOpacity(0.15);
      textColor = const Color(0xFF0F9D94);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        height: 35,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        color: bgColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.method,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor,
                  fontWeight: widget.isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.isSelected)
              const Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}

