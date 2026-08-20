import 'package:flutter/material.dart';
import '../theme/theme.dart';
 
class DeletedDataEraserScreen extends StatefulWidget {
  final AppThemeMode themeMode;
  const DeletedDataEraserScreen({Key? key, required this.themeMode}) : super(key: key);
 
  @override
  State<DeletedDataEraserScreen> createState() => _DeletedDataEraserScreenState();
}
 
class _DeletedDataEraserScreenState extends State<DeletedDataEraserScreen> {
  // [CHANGED] null = no selection → button disabled
  int? _selectedDriveIndex;
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
 
  // [CHANGED] teal green — consistent color used everywhere
  static const Color _teal = Color(0xFF14B8A6);
  static const Color _tealDark = Color(0xFF0F9488);
 
  Color get _pageBg {
    switch (widget.themeMode) {
      case AppThemeMode.dark:
      case AppThemeMode.greenDark:
        return const Color(0xFF0F172A);
      case AppThemeMode.greenLight:
        return AppColors.greenLightBg;
      case AppThemeMode.light:
        // [CHANGED] grey background
        return const Color(0xFFF3F4F6);
    }
  }
 
  Color get _cardBg {
    switch (widget.themeMode) {
      case AppThemeMode.dark:
      case AppThemeMode.greenDark:
        return const Color(0xFF1E293B);
      case AppThemeMode.greenLight:
        return AppColors.greenLightCard;
      case AppThemeMode.light:
        return Colors.white;
    }
  }
 
  Color get _cardBorder {
    switch (widget.themeMode) {
      case AppThemeMode.dark:
      case AppThemeMode.greenDark:
        return const Color(0xFF334155);
      case AppThemeMode.greenLight:
        return AppColors.greenLightBorder;
      case AppThemeMode.light:
        return const Color(0xFFE2E8F0);
    }
  }
 
  Color get _headingColor {
    switch (widget.themeMode) {
      case AppThemeMode.dark:
        return Colors.white;
      case AppThemeMode.greenDark:
        return AppColors.greenDarkText;
      case AppThemeMode.greenLight:
        return AppColors.greenLightText;
      case AppThemeMode.light:
        return const Color(0xFF1E293B);
    }
  }
 
  Color get _bodyGreyColor {
    switch (widget.themeMode) {
      case AppThemeMode.dark:
        return const Color(0xFF94A3B8);
      case AppThemeMode.greenDark:
        return AppColors.greenDarkGreyText;
      case AppThemeMode.greenLight:
        return AppColors.greenLightGreyText;
      case AppThemeMode.light:
        return const Color(0xFF64748B);
    }
  }
 
  void _showConfirmDialog() {
    final driveName = _drives[_selectedDriveIndex!]['name'];
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
                            _WarningIconBadge(),
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B)),
                          ),
                          TextSpan(text: ' to confirm:'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // [CHANGED] TextField height reduced + hover water-blue bg
                    _HoverTextField(confirmController: confirmController, onChanged: () => setStateDialog(() {})),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // [CHANGED] Cancel button — teal green hover
                        _CancelButton(onTap: () => Navigator.of(context).pop()),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // [CHANGED] red instead of teal — solid red once
                            // "ERASE" is typed, light/pale red while disabled.
                            backgroundColor: const Color(0xFFDC2626),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                const Color(0xFFDC2626).withOpacity(0.4),
                            disabledForegroundColor: Colors.white.withOpacity(0.85),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: isMatched
                              ? () => Navigator.of(context).pop()
                              : null,
                          child: const Text(
                            'Confirm',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
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
    // [CHANGED] enabled only when a drive is selected
    final bool eraseEnabled = _selectedDriveIndex != null;
 
    return Scaffold(
      backgroundColor: _pageBg,
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
                    Text(
                      'Deleted Data Eraser',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: _headingColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Permanently erase already deleted files (free space)',
                      style: TextStyle(
                        fontSize: 11,
                        color: _bodyGreyColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // info box — untouched
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
                            color: Color(0xFF14B8A6),
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
                              onEnter: (_) =>
                                  setHoverState(() => isHovered = true),
                              onExit: (_) =>
                                  setHoverState(() => isHovered = false),
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
                                    color: _cardBg,
                                    border: Border.all(
                                      color: (isSelected || isHovered)
                                          ? _teal
                                          : _cardBorder,
                                      width:
                                          (isSelected || isHovered) ? 1.5 : 1,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE6F4F1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Icon(
                                              Icons.sd_storage_outlined,
                                              color: _teal,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            drive['name'],
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: _headingColor,
                                            ),
                                          ),
                                          if (drive['isBoot'] == true) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color:
                                                    const Color(0xFFE6F4F1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Text(
                                                'Boot Volume',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: _teal,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 32.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Total Size',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            _bodyGreyColor)),
                                                const SizedBox(height: 3),
                                                Text(drive['totalSize'],
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            _bodyGreyColor)),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Free Space',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            _bodyGreyColor)),
                                                const SizedBox(height: 3),
                                                Text(drive['freeSpace'],
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            _bodyGreyColor)),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Used Space',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            _bodyGreyColor)),
                                                const SizedBox(height: 3),
                                                Text(drive['usedSpace'],
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            _bodyGreyColor)),
                                              ],
                                            ),
                                            const SizedBox(width: 20),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 32.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Free Space',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: _bodyGreyColor),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20.0),
                                                  child: Text(
                                                    '${drive['percentage']}%',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: _bodyGreyColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                child: LinearProgressIndicator(
                                                  value: drive['percentage'] /
                                                      100,
                                                  backgroundColor:
                                                      const Color(0xFFE2E8F0),
                                                  valueColor:
                                                      const AlwaysStoppedAnimation<
                                                              Color>(_teal),
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
            selectedDriveName: _selectedDriveIndex != null
                ? _drives[_selectedDriveIndex!]['name']
                : 'None',
            selectedMethod: _selectedMethod,
            erasureMethods: _erasureMethods,
            onMethodChanged: (newMethod) {
              setState(() {
                _selectedMethod = newMethod;
              });
            },
            // [CHANGED] only enable when drive selected
            onErasePressed: eraseEnabled ? _showConfirmDialog : null,
            barBg: _cardBg,
            borderColor: _cardBorder,
            labelColor: _bodyGreyColor,
          ),
        ],
      ),
    );
  }
}
 
// [NEW] Light-red circle behind the dialog's warning icon.
class _WarningIconBadge extends StatelessWidget {
  const _WarningIconBadge();
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xFFFEE2E2),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.warning_amber_rounded,
        color: Color(0xFFE11D48),
        size: 20,
      ),
    );
  }
}
 
// [CHANGED] Hover water-blue TextField with reduced height
class _HoverTextField extends StatefulWidget {
  final TextEditingController confirmController;
  final VoidCallback onChanged;
 
  const _HoverTextField({
    Key? key,
    required this.confirmController,
    required this.onChanged,
  }) : super(key: key);
 
  @override
  State<_HoverTextField> createState() => _HoverTextFieldState();
}
 
class _HoverTextFieldState extends State<_HoverTextField> {
  bool _isHovered = false;
 
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          // [CHANGED] water-blue hover background
          color: _isHovered ? const Color(0xFFE8F4FB) : Colors.white,
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF14B8A6)
                : const Color(0xFFCBD5E1),
            width: _isHovered ? 1.4 : 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: TextField(
          controller: widget.confirmController,
          onChanged: (_) => widget.onChanged(),
          cursorColor: const Color(0xFF14B8A6),
          style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)),
          decoration: InputDecoration(
            hintText: 'ERASE',
            hintStyle: const TextStyle(
                color: Color(0xFF94A3B8), fontSize: 12),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
 
// [CHANGED] Cancel button with teal green hover
class _CancelButton extends StatefulWidget {
  final VoidCallback onTap;
 
  const _CancelButton({Key? key, required this.onTap}) : super(key: key);
 
  @override
  State<_CancelButton> createState() => _CancelButtonState();
}
 
class _CancelButtonState extends State<_CancelButton> {
  bool _isHovered = false;
 
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            // [CHANGED] teal green on hover, white when not hovered
            color: _isHovered ? const Color(0xFF14B8A6) : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _isHovered
                  ? const Color(0xFF14B8A6)
                  : const Color(0xFFCBD5E1),
            ),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color:
                  _isHovered ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
        ),
      ),
    );
  }
}
 
class ErasureBottomBar extends StatelessWidget {
  final String selectedDriveName;
  final String selectedMethod;
  final List<String> erasureMethods;
  final ValueChanged<String> onMethodChanged;
  // [CHANGED] nullable — null = disabled
  final VoidCallback? onErasePressed;
  final Color barBg;
  final Color borderColor;
  final Color labelColor;
 
  // [CHANGED] teal green consistent color
  static const Color _teal = Color(0xFF14B8A6);
 
  const ErasureBottomBar({
    Key? key,
    required this.selectedDriveName,
    required this.selectedMethod,
    required this.erasureMethods,
    required this.onMethodChanged,
    required this.onErasePressed,
    this.barBg = Colors.white,
    this.borderColor = const Color(0xFFE2E8F0),
    this.labelColor = const Color(0xFF64748B),
  }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    final bool enabled = onErasePressed != null;
 
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: barBg,
        border: Border(
          top: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Selected: $selectedDriveName',
            style: TextStyle(fontSize: 11, color: labelColor),
          ),
          Row(
            children: [
              Text(
                'Method:',
                style: TextStyle(fontSize: 12, color: labelColor),
              ),
              const SizedBox(width: 4),
              ErasureMethodDropdown(
                selectedMethod: selectedMethod,
                erasureMethods: erasureMethods,
                onMethodChanged: onMethodChanged,
              ),
              const SizedBox(width: 12),
              // [CHANGED] disabled = light teal, enabled = solid teal
              MouseRegion(
                cursor: enabled
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: enabled
                        ? _teal
                        : _teal.withOpacity(0.4), // [CHANGED] light teal when disabled
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: _teal.withOpacity(0.4),
                    disabledForegroundColor: Colors.white,
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
 
  // [CHANGED] teal green
  static const Color _teal = Color(0xFF14B8A6);
 
  @override
  Widget build(BuildContext context) {
    // [CHANGED] Flutter's PopupMenuButton auto-highlights the item matching
    // `initialValue` with the theme's default focus/highlight grey (and
    // bolds its text) as soon as the menu opens — even with no mouse hover.
    // This Theme override strips that default grey/splash/highlight so every
    // item looks identical at rest; only our own MouseRegion-driven teal
    // hover in _PopupItemTile ever adds color.
    return Theme(
      data: Theme.of(context).copyWith(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: PopupMenuButton<String>(
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
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF1E293B)),
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
              teal: _teal,
            ),
          );
        }).toList();
      },
      onSelected: onMethodChanged,
      ),
    );
  }
}
 
class _PopupItemTile extends StatefulWidget {
  final String method;
  final bool isSelected;
  // [CHANGED] teal passed in for consistency
  final Color teal;
 
  const _PopupItemTile({
    Key? key,
    required this.method,
    required this.isSelected,
    required this.teal,
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
 
    if (_isHovered) {
      // sirf hover pe teal green — koi fixed color nahi
      bgColor = widget.teal;
      textColor = Colors.white;
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
                // [CHANGED] Same normal weight for every row, selected or
                // not — the checkmark alone indicates the current selection.
                style: TextStyle(
                  fontSize: 12,
                  color: textColor,
                  fontWeight: FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.isSelected)
              const Icon(Icons.check, size: 14, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
 