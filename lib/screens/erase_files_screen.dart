import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme.dart';
 
class EraseFilesScreen extends StatefulWidget {
  final bool isDark;
  const EraseFilesScreen({super.key, required this.isDark});
 
  @override
  State<EraseFilesScreen> createState() => _EraseFilesScreenState();
}
 
class _EraseFilesScreenState extends State<EraseFilesScreen> {
  List<Map<String, String>> fileItems = [];
  Set<int> selectedIndexes = {};
 
  final List<String> erasureMethods = const [
    'Zero Fill (1-pass)',
    'One Fill (1-pass)',
    'Random Data (1-pass)',
    'NIST SP 800-88 Rev1 (3-pass)',
    'DoD 5220.22-M (E) Extended (7-pass)',
    'DoD 5220.28-M (STD) (3-pass)',
    'HMG IS5 Enhanced (3-pass)',
    'Gutmann Method (35-pass)',
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
 
  String selectedErasureMethod = 'Zero Fill (1-pass)';
  final LayerLink _dropdownLink = LayerLink();
  OverlayEntry? _dropdownOverlay;
  final TextEditingController eraseController = TextEditingController();
 
  @override
  void dispose() {
    _closeDropdown();
    eraseController.dispose();
    super.dispose();
  }

 void _addFiles() {
    setState(() {
      fileItems.addAll([
        {
          'name': 'Confidential_Document.pdf',
          'path': 'C:\\Users\\Demo\\Documents\\Confidential_Document.pdf',
          'size': '2.4 MB',
          'items': '1',
        },
        {
          'name': 'Private_Photo.jpg',
          'path': 'C:\\Users\\Demo\\Pictures\\Private_Photo.jpg',
          'size': '4.1 MB',
          'items': '1',
        },
      ]);
    });
  }
 
  void _addFolder() {
    setState(() {
      fileItems.add({
        'name': 'Financial Records 2025',
        'path': 'D:\\Backups\\Financial Records 2025',
        'size': '142.5 MB',
        'items': '345',
      });
    });
  }
 
  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    final text = data?.text?.trim();
    if (text != null && text.isNotEmpty) {
      setState(() {
        final parts = text.split(RegExp(r'[\\/]'));
        fileItems.add({
          'name': parts.isNotEmpty ? parts.last : text,
          'path': text,
          'size': '—',
          'items': '1',
        });
      });
    }
  }
 
  bool get isAllSelected =>
      fileItems.isNotEmpty && selectedIndexes.length == fileItems.length;
 
  void _toggleSelectAll(bool? val) {
    setState(() {
      if (val == true) {
        selectedIndexes = Set<int>.from(List.generate(fileItems.length, (i) => i));
      } else {
        selectedIndexes.clear();
      }
    });
  }
 
  void _toggleItem(int index, bool? val) {
    setState(() {
      if (val == true) {
        selectedIndexes.add(index);
      } else {
        selectedIndexes.remove(index);
      }
    });
  }
 
  void _removeSelected() {
    setState(() {
      final remaining = <Map<String, String>>[];
      for (int i = 0; i < fileItems.length; i++) {
        if (!selectedIndexes.contains(i)) remaining.add(fileItems[i]);
      }
      fileItems = remaining;
      selectedIndexes.clear();
    });
  }
 
  void _clearList() {
    setState(() {
      fileItems.clear();
      selectedIndexes.clear();
    });
  }

 void _toggleDropdown() {
    if (_dropdownOverlay != null) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }
 
  void _openDropdown() {
    final overlay = Overlay.of(context);
    int? hoveredIndex;
 
    _dropdownOverlay = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeDropdown,
                child: Container(color: Colors.transparent),
              ),
            ),
            CompositedTransformFollower(
              link: _dropdownLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.topLeft,
              followerAnchor: Alignment.bottomLeft,
              offset: const Offset(0, -6),
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(8),
                child: StatefulBuilder(
                  builder: (ctx, setDropState) {
                    return Container(
                      width: 280,
                      constraints: const BoxConstraints(maxHeight: 320),
                      decoration: BoxDecoration(
                        color: widget.isDark ? AppColors.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: erasureMethods.length,
                        itemBuilder: (context, i) {
                          final method = erasureMethods[i];
                          final isHovered = hoveredIndex == i;
 
                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) => setDropState(() => hoveredIndex = i),
                            onExit: (_) => setDropState(() => hoveredIndex = null),
                            child: GestureDetector(
                              onTap: () {
                                setState(() => selectedErasureMethod = method);
                                _closeDropdown();
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                color: isHovered ? AppColors.primaryTeal : Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        method,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isHovered ? Colors.white : (widget.isDark ? AppColors.darkText : AppColors.lightText),
                                        ),
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
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_dropdownOverlay!);
  }
 
  void _closeDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }
 
  void _showConfirmDialog() {
    eraseController.clear();
    final countToErase =
        selectedIndexes.isNotEmpty ? selectedIndexes.length : fileItems.length;
 
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            final isConfirmEnabled = eraseController.text.trim() == 'ERASE';
 
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: 420,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFCE7F3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.warning_amber_rounded,
                              color: Colors.red, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Confirm Erasure',
                            style:
                                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(dialogCtx),
                          child: const Icon(Icons.close, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'You are about to permanently erase $countToErase item(s). '
                      'This action cannot be undone.',
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Type ERASE to confirm:',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: eraseController,
                      onChanged: (_) => setDialogState(() {}),
                      style: const TextStyle(
                        color: AppColors.activeGreenText,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: 'ERASE',
                        hintStyle: TextStyle(
                          color: AppColors.activeGreenText.withOpacity(0.55),
                          fontWeight: FontWeight.w600,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                              color: AppColors.primaryTeal, width: 1.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                              color: AppColors.primaryTeal, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              const BorderSide(color: AppColors.primaryTeal, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _DialogHoverButton(
                          label: 'Cancel',
                          isDark: widget.isDark,
                          onTap: () => Navigator.pop(dialogCtx),
                        ),
                        const SizedBox(width: 12),
                        _ConfirmButton(
                          enabled: isConfirmEnabled,
                          onTap: isConfirmEnabled
                              ? () {
                                  setState(() {
                                    if (selectedIndexes.isNotEmpty) {
                                      _removeSelected();
                                    } else {
                                      _clearList();
                                    }
                                  });
                                  Navigator.pop(dialogCtx);
                                }
                              : null,
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
  Widget build(BuildContext context) {
    Color bgColor = widget.isDark ? AppColors.darkBg : AppColors.lightBg;
    Color cardBg = widget.isDark ? AppColors.darkCard : AppColors.lightCard;
    Color textColor = widget.isDark ? AppColors.darkText : AppColors.lightText;
    Color subTextColor =
        widget.isDark ? AppColors.darkGreyText : AppColors.lightGreyText;
    Color borderColor = widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;
 
    bool isEraseEnabled = fileItems.isNotEmpty;
 
    return Container(
      color: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Erase Files & Folders',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 2),
                Text('Permanently and securely delete sensitive files',
                    style: TextStyle(fontSize: 12, color: subTextColor)),
                const SizedBox(height: 10),
              ],
            ),
          ),
 
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: fileItems.isEmpty
                  ? Column(
                      children: [
                        _uploadBox(textColor, subTextColor, borderColor),
                        Expanded(
                          child: Center(
                            child: Text(
                              'No files added yet',
                              style: TextStyle(fontSize: 13, color: subTextColor),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          _uploadBox(textColor, subTextColor, borderColor),
                          const SizedBox(height: 10),
                          _fileTable(cardBg, textColor, subTextColor, borderColor),
                        ],
                      ),
                    ),
            ),
          ),
 
          Container(
            width: double.infinity,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            decoration: BoxDecoration(
              color: widget.isDark ? AppColors.darkBg : Colors.white,
              border: Border(
                top: BorderSide(color: borderColor, width: 1.0),
              ),
            ),
            child: Row(
              children: [
                Text('Erasure Method: ', style: TextStyle(fontSize: 12, color: subTextColor)),
                CompositedTransformTarget(
                  link: _dropdownLink,
                  child: GestureDetector(
                    onTap: _toggleDropdown,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: widget.isDark ? Colors.white10 : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(selectedErasureMethod, style: TextStyle(fontSize: 12, color: textColor)),
                          const SizedBox(width: 6),
                          Icon(Icons.keyboard_arrow_down, size: 16, color: subTextColor),
                        ],
                      ),
                    ),
                  ),
                ),
 
                const Spacer(),
 
                _EraseNowButton(
                  enabled: isEraseEnabled,
                  onTap: isEraseEnabled ? _showConfirmDialog : () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _uploadBox(Color textColor, Color subTextColor, Color borderColor) {
    return CustomPaint(
      painter: _DashedBorderPainter(color: borderColor),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22),
        child: Column(
          children: [
            Icon(Icons.upload_outlined, size: 28, color: AppColors.primaryTeal),
            const SizedBox(height: 6),
            Text('Drag and drop files or folders here',
                style: TextStyle(fontSize: 13, color: textColor)),
            Text('or use the buttons below',
                style: TextStyle(fontSize: 12, color: subTextColor)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _OutlinedHoverButton(
                  icon: Icons.insert_drive_file_outlined,
                  label: 'Add Files',
                  isDark: widget.isDark,
                  onTap: _addFiles,
                ),
                const SizedBox(width: 12),
                _OutlinedHoverButton(
                  icon: Icons.folder_outlined,
                  label: 'Add Folder',
                  isDark: widget.isDark,
                  onTap: _addFolder,
                ),
              ],
            ),
            const SizedBox(height: 6),
            _CopyPasteLink(onTap: _pasteFromClipboard),
          ],
        ),
      ),
    );
  }
 
  Widget _fileTable(Color cardBg, Color textColor, Color subTextColor, Color borderColor) {
    final dividerColor = widget.isDark ? Colors.white24 : Colors.grey.shade300;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Checkbox(
                  value: isAllSelected,
                  activeColor: AppColors.primaryTeal,
                  onChanged: _toggleSelectAll,
                ),
                Text(
                  selectedIndexes.isEmpty
                      ? '${fileItems.length} items'
                      : '${selectedIndexes.length} selected',
                  style: TextStyle(fontSize: 13, color: textColor),
                ),
                const Spacer(),
                if (selectedIndexes.isNotEmpty) ...[
                  _LightGreenHoverButton(
                    icon: Icons.close,
                    label: 'Remove Selected',
                    onTap: _removeSelected,
                  ),
                  const SizedBox(width: 8),
                ],
                _LightGreenHoverButton(
                  icon: Icons.delete_outline,
                  label: 'Clear List',
                  onTap: _clearList,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: dividerColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2.4),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: dividerColor)),
                  ),
                  children: [
                    _thCell('Name', subTextColor),
                    _thCell('Path', subTextColor),
                    _thCell('Size', subTextColor, alignRight: true),
                    _thCell('Items', subTextColor, alignRight: true),
                  ],
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 265), // Increased to precisely fit 5 visible rows
            child: Scrollbar(
              thumbVisibility: fileItems.length > 5,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2.4),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                  },
                  children: fileItems.asMap().entries.map((entry) {
                    final i = entry.key;
                    final item = entry.value;
                    final isLast = i == fileItems.length - 1;
                    return TableRow(
                      decoration: BoxDecoration(
                        border: isLast
                            ? null
                            : Border(
                                bottom: BorderSide(color: dividerColor)),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Checkbox(
                                value: selectedIndexes.contains(i),
                                activeColor: AppColors.primaryTeal,
                                onChanged: (val) => _toggleItem(i, val),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text(item['name'] ?? '',
                                        style: TextStyle(fontSize: 12, color: textColor)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _pathCell(item['path'] ?? '', subTextColor),
                        _tdCell(item['size'] ?? '', subTextColor, alignRight: true),
                        _tdCell(item['items'] ?? '', subTextColor, alignRight: true),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
 
  Widget _thCell(String label, Color color, {bool alignRight = false}) => Padding(
        padding: EdgeInsets.only(
          top: 6,
          bottom: 6,
          left: alignRight ? 0 : 4,
          right: alignRight ? 8 : 0,
        ),
        child: Align(
          alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(label,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
        ),
      );
 
  Widget _tdCell(String val, Color color, {bool alignRight = false}) => Padding(
        padding: EdgeInsets.only(
          top: 6,
          bottom: 6,
          left: alignRight ? 0 : 4,
          right: alignRight ? 8 : 0,
        ),
        child: Align(
          alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(val, style: TextStyle(fontSize: 12, color: color)),
        ),
      );
 
  Widget _pathCell(String val, Color color) => Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6, left: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Tooltip(
              message: val,
              waitDuration: const Duration(milliseconds: 300),
              child: Text(
                val,
                style: TextStyle(fontSize: 12, color: color),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  _DashedBorderPainter({required this.color});
 
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.95)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(10));
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
            metric.extractPath(distance, distance + dashWidth), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }
 
  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}
 
class _OutlinedHoverButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;
  const _OutlinedHoverButton({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
  });
 
  @override
  State<_OutlinedHoverButton> createState() => _OutlinedHoverButtonState();
}
 
class _OutlinedHoverButtonState extends State<_OutlinedHoverButton> {
  bool hovered = false;
 
  @override
  Widget build(BuildContext context) {
    Color textColor = widget.isDark ? AppColors.darkText : AppColors.lightText;
    Color borderColor = widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;
 
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
                color: hovered ? AppColors.primaryTeal : borderColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon,
                  size: 15,
                  color: textColor),
              const SizedBox(width: 6),
              Text(widget.label,
                  style: TextStyle(
                      fontSize: 12.5,
                      color: textColor,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
 
class _CopyPasteLink extends StatefulWidget {
  final VoidCallback onTap;
  const _CopyPasteLink({required this.onTap});
 
  @override
  State<_CopyPasteLink> createState() => _CopyPasteLinkState();
}
 
class _CopyPasteLinkState extends State<_CopyPasteLink> {
  bool hovered = false;
 
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          'or use copy and paste (Ctrl+V)',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.primaryTeal,
            decoration: TextDecoration.underline,
            fontWeight: hovered ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
 
class _LightGreenHoverButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _LightGreenHoverButton(
      {required this.icon, required this.label, required this.onTap});
 
  @override
  State<_LightGreenHoverButton> createState() => _LightGreenHoverButtonState();
}
 
class _LightGreenHoverButtonState extends State<_LightGreenHoverButton> {
  bool hovered = false;
 
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: hovered ? AppColors.activeGreenBg : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon,
                  size: 15,
                  color: hovered ? AppColors.activeGreenText : AppColors.lightGreyText),
              const SizedBox(width: 4),
              Text(widget.label,
                  style: TextStyle(
                      fontSize: 12,
                      color:
                          hovered ? AppColors.activeGreenText : AppColors.lightGreyText)),
            ],
          ),
        ),
      ),
    );
  }
}
 
class _EraseNowButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onTap;
  const _EraseNowButton({required this.enabled, required this.onTap});
 
  @override
  State<_EraseNowButton> createState() => _EraseNowButtonState();
}
 
class _EraseNowButtonState extends State<_EraseNowButton> {
  bool hovered = false;
 
  @override
  Widget build(BuildContext context) {
    Color buttonColor = widget.enabled
        ? (hovered ? const Color(0xFF0B7A70) : AppColors.primaryTeal)
        : AppColors.primaryTeal.withOpacity(0.4);
 
    return MouseRegion(
      cursor: widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_arrow,
                  size: 16,
                  color: Colors.white.withOpacity(widget.enabled ? 1.0 : 0.6)),
              const SizedBox(width: 4),
              Text('Erase Now',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(widget.enabled ? 1.0 : 0.6),
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
 
class _DialogHoverButton extends StatefulWidget {
  final String label;
  final bool isDark;
  final VoidCallback onTap;
  const _DialogHoverButton(
      {required this.label, required this.isDark, required this.onTap});
 
  @override
  State<_DialogHoverButton> createState() => _DialogHoverButtonState();
}
 
class _DialogHoverButtonState extends State<_DialogHoverButton> {
  bool hovered = false;
 
  @override
  Widget build(BuildContext context) {
    Color borderColor = widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;
    Color textColor = widget.isDark ? AppColors.darkText : AppColors.lightText;
 
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: hovered ? AppColors.primaryTeal : Colors.transparent,
            border: Border.all(color: hovered ? AppColors.primaryTeal : borderColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(widget.label,
              style: TextStyle(
                  fontSize: 13,
                  color: hovered ? Colors.white : textColor,
                  fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
 
class _ConfirmButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onTap;
  const _ConfirmButton({required this.enabled, required this.onTap});
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFFEF4444) : const Color(0xFFEF4444).withOpacity(0.4),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text('Confirm',
            style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

