import 'package:flutter/material.dart';
 
class VolumeEraserScreen extends StatefulWidget {
  const VolumeEraserScreen({Key? key}) : super(key: key);
 
  @override
  State<VolumeEraserScreen> createState() => _VolumeEraserScreenState();
}
 
class _VolumeEraserScreenState extends State<VolumeEraserScreen> {
  String selectedVolume = 'D:';
  String selectedMethod = 'Zero Fill (1-pass)';
 
  final List<String> erasureMethods = [
    'Zero Fill (1-pass)',
    'One Fill (1-pass)',
    'Random Data (1-pass)',
    'NIST SP 800-88 Rev1 (3-pass)',
    'DoD 5220.22-M (E) Extended (7-pass)',
    'DoD 5220.28-M (STD) (3-pass)',
    'HMG IS5 Enhanced (3-pass)',
  ];
 
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final ScrollController _scrollController = ScrollController();
 
  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _closeDropdown();
    }
  }
 
  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
 
  @override
  void dispose() {
    _closeDropdown();
    _scrollController.dispose();
    super.dispose();
  }
 
  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeDropdown,
              child: const SizedBox.expand(),
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, -255),
            child: Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
                child: Container(
                  width: 310,
                  height: 245,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: erasureMethods.length,
                    itemBuilder: (context, index) {
                      String method = erasureMethods[index];
                      bool isSelected = selectedMethod == method;
                      return _HoverableMenuItem(
                        method: method,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            selectedMethod = method;
                          });
                          _closeDropdown();
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
 
  Widget _buildVolumeCard({
    required String volumeId,
    required String title,
    required bool isBootVolume,
    required String totalSize,
    required String usedSize,
    required String freeSize,
    required double usagePercentage,
    required String percentageText,
  }) {
    final bool isSelected = selectedVolume == volumeId;
 
    return InkWell(
      onTap: () {
        setState(() {
          selectedVolume = volumeId;
        });
        if (isBootVolume) {
          _showBootVolumeSafetyDialog();
        }
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? const Color(0xFF14B8A6) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF3F2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFB8CCC8)),
                  ),
                  child: const Icon(
                    Icons.dns_rounded,
                    color: Color(0xFF14B8A6),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                    color: Color(0xFF1E293B),
                  ),
                ),
                if (isBootVolume) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE7F3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Boot Volume',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: Color(0xFFBE185D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 36.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 85,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Size',
                          style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          totalSize,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 85,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Used',
                          style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          usedSize,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Free',
                          style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          freeSize,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 36.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Usage',
                    style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                  ),
                  Text(
                    percentageText,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 36.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: usagePercentage,
                  minHeight: 5.0,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF14B8A6)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  void _showBootVolumeSafetyDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 440,
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFDC2626),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Boot Volume Safety',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
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
                          const SizedBox(height: 6),
                          const Text(
                            'You have selected the primary boot volume. D-Secure will securely wipe recoverable free space and user files while leaving your operating system completely safe and bootable.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _HoverableButton(
                      text: 'Cancel',
                      isWhiteButton: true,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 10),
                    _HoverableButton(
                      text: 'Confirm',
                      isWhiteButton: false,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
 
  void _showConfirmVolumeEraserDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return _ConfirmEraserDialogContent(selectedVolume: selectedVolume);
      },
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
              color: const Color(0xFFF3F4F6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Volume Eraser',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Securely erase entire volumes and drives',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFFF3F4F6),
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCE9F5),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFB3CFE8)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 1.0),
                              child: Icon(
                                Icons.warning_amber_rounded,
                                color: Color(0xFF14B8A6),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Warning: Permanent Data Loss',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF64748B),
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Securely delete all data on the chosen volume. Make sure to save anything important first. System files will stay safe, even if the boot volume is selected.',
                                    style: TextStyle(
                                      color: Color(0xFF334155),
                                      fontSize: 11,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildVolumeCard(
                        volumeId: 'C:',
                        title: 'System (C:)',
                        isBootVolume: true,
                        totalSize: '476.9 GB',
                        usedSize: '381.6 GB',
                        freeSize: '95.4 GB',
                        usagePercentage: 0.80,
                        percentageText: '80%',
                      ),
                      const SizedBox(height: 12),
                      _buildVolumeCard(
                        volumeId: 'D:',
                        title: 'Work & Projects (D:)',
                        isBootVolume: false,
                        totalSize: '953.7 GB',
                        usedSize: '476.8 GB',
                        freeSize: '476.8 GB',
                        usagePercentage: 0.50,
                        percentageText: '50%',
                      ),
                      const SizedBox(height: 12),
                      _buildVolumeCard(
                        volumeId: 'E:',
                        title: 'Media Library (E:)',
                        isBootVolume: false,
                        totalSize: '1.8 TB',
                        usedSize: '1.0 TB',
                        freeSize: '814.9 GB',
                        usagePercentage: 0.56,
                        percentageText: '56%',
                      ),
                      const SizedBox(height: 12),
                      _buildVolumeCard(
                        volumeId: 'F:',
                        title: 'SanDisk USB (F:)',
                        isBootVolume: false,
                        totalSize: '59.6 GB',
                        usedSize: '29.8 GB',
                        freeSize: '29.8 GB',
                        usagePercentage: 0.50,
                        percentageText: '50%',
                      ),
                      const SizedBox(height: 12),
                      _buildVolumeCard(
                        volumeId: 'G:',
                        title: 'Backup Drive (G:)',
                        isBootVolume: false,
                        totalSize: '3.6 TB',
                        usedSize: '2.5 TB',
                        freeSize: '1.1 TB',
                        usagePercentage: 0.70,
                        percentageText: '70%',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected: $selectedVolume',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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
                      const SizedBox(width: 8),
                      CompositedTransformTarget(
                        link: _layerLink,
                        child: GestureDetector(
                          onTap: _toggleDropdown,
                          child: Container(
                            height: 30,
                            padding: const EdgeInsets.only(left: 8, right: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: const Color(0xFFCBD5E1)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  selectedMethod,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFF334155),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 14,
                                  color: Color(0xFF64748B),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      ElevatedButton.icon(
                        onPressed: _showConfirmVolumeEraserDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 16),
                        label: const Text(
                          'Erase Volume',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
 
class _ConfirmEraserDialogContent extends StatefulWidget {
  final String selectedVolume;
 
  const _ConfirmEraserDialogContent({Key? key, required this.selectedVolume}) : super(key: key);
 
  @override
  State<_ConfirmEraserDialogContent> createState() => _ConfirmEraserDialogContentState();
}
 
class _ConfirmEraserDialogContentState extends State<_ConfirmEraserDialogContent> {
  final TextEditingController _controller = TextEditingController();
  bool _isConfirmed = false;
 
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final isValid = _controller.text.trim() == 'Confirm';
      if (isValid != _isConfirmed) {
        setState(() {
          _isConfirmed = isValid;
        });
      }
    });
  }
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 440,
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFDC2626),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Confirm Volume Eraser',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
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
                      const SizedBox(height: 6),
                      Text(
                        'You are about to permanently erase all data on System (${widget.selectedVolume}). This action cannot be undone.',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 11.5, color: Color(0xFF334155)),
                children: [
                  TextSpan(text: 'Type '),
                  TextSpan(
                    text: 'Confirm',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' to confirm:'),
                ],
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: TextField(
                controller: _controller,
                cursorColor: const Color(0xFF14B8A6),
                style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  hintText: 'Confirm',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFF14B8A6), width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _TealHoverButton(
                  text: 'Cancel',
                  isCancel: true,
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 10),
                _ConfirmActionButton(
                  isEnabled: _isConfirmed,
                  onTap: () {
                    if (_isConfirmed) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
 
class _TealHoverButton extends StatefulWidget {
  final String text;
  final bool isCancel;
  final VoidCallback onTap;
 
  const _TealHoverButton({
    Key? key,
    required this.text,
    required this.isCancel,
    required this.onTap,
  }) : super(key: key);
 
  @override
  State<_TealHoverButton> createState() => _TealHoverButtonState();
}
 
class _TealHoverButtonState extends State<_TealHoverButton> {
  bool isHovered = false;
 
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: isHovered ? const Color(0xFF14B8A6) : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isHovered ? const Color(0xFF14B8A6) : const Color(0xFFCBD5E1),
            ),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isHovered ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }
}
 
class _ConfirmActionButton extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback onTap;
 
  const _ConfirmActionButton({Key? key, required this.isEnabled, required this.onTap}) : super(key: key);
 
  @override
  State<_ConfirmActionButton> createState() => _ConfirmActionButtonState();
}
 
class _ConfirmActionButtonState extends State<_ConfirmActionButton> {
  bool isHovered = false;
 
  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
 
    if (!widget.isEnabled) {
      bgColor = const Color(0xFFDC2626).withOpacity(0.5);
      fgColor = Colors.white.withOpacity(0.7);
    } else {
      bgColor = isHovered ? const Color(0xFFB91C1C) : const Color(0xFFDC2626);
      fgColor = Colors.white;
    }
 
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: widget.isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Confirm',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fgColor,
            ),
          ),
        ),
      ),
    );
  }
}
 
class _HoverableButton extends StatefulWidget {
  final String text;
  final bool isWhiteButton;
  final VoidCallback onTap;
 
  const _HoverableButton({
    Key? key,
    required this.text,
    required this.isWhiteButton,
    required this.onTap,
  }) : super(key: key);
 
  @override
  State<_HoverableButton> createState() => _HoverableButtonState();
}
 
class _HoverableButtonState extends State<_HoverableButton> {
  bool isHovered = false;
 
  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Border? border;
 
    if (widget.isWhiteButton) {
      backgroundColor = isHovered ? const Color(0xFF14B8A6) : Colors.white;
      textColor = isHovered ? Colors.white : const Color(0xFF64748B);
      border = Border.all(color: isHovered ? const Color(0xFF14B8A6) : const Color(0xFFCBD5E1));
    } else {
      backgroundColor = isHovered ? const Color(0xFFB91C1C) : const Color(0xFFDC2626);
      textColor = Colors.white;
      border = null;
    }
 
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
            border: border,
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
 
class _HoverableMenuItem extends StatefulWidget {
  final String method;
  final bool isSelected;
  final VoidCallback onTap;
 
  const _HoverableMenuItem({
    Key? key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);
 
  @override
  State<_HoverableMenuItem> createState() => _HoverableMenuItemState();
}
 
class _HoverableMenuItemState extends State<_HoverableMenuItem> {
  bool isHovered = false;
 
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          height: 34,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isHovered ? const Color(0xFF14B8A6) : Colors.transparent,
          ),
          child: Text(
            widget.method,
            style: TextStyle(
              fontSize: 12,
              color: isHovered
                  ? Colors.white
                  : (widget.isSelected
                      ? const Color(0xFF14B8A6)
                      : const Color(0xFF334155)),
              fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
 