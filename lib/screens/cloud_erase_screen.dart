import 'package:flutter/material.dart';
 
/// Cloud Erase screen — matches the "Cloud Erase" section of the
/// D-Secure File Eraser UI shown in the reference screenshots.
///
/// Usage (inside home_screen.dart sidebar navigation):
///
///   onTap: () {
///     setState(() {
///       _selectedScreen = const CloudEraseScreen();
///     });
///   }
///
/// or, if you're using named routes / Navigator.push:
///
///   Navigator.push(
///     context,
///     MaterialPageRoute(builder: (_) => const CloudEraseScreen()),
///   );
class CloudEraseScreen extends StatefulWidget {
  const CloudEraseScreen({super.key});
 
  @override
  State<CloudEraseScreen> createState() => _CloudEraseScreenState();
}
 
class _CloudEraseScreenState extends State<CloudEraseScreen> {
  // Controls the small "Google Drive" dropdown popup.
  bool _isDropdownOpen = false;
 
  // Controls the hover colour of the "Connect to Google Drive" box.
  bool _isHoveringConnect = false;
 
  // ---- Connect / Disconnect flow ----
  bool _isConnecting = false; // true while the loading spinner is shown
  bool _isConnected = false; // true once "Demo User" account is connected
  bool _isHoveringDisconnect = false;
 
  // ---- Erase Mode box selection (Files & Folders / Erase Account / Deleted Files) ----
  int? _selectedEraseMode;
  int? _hoveredEraseMode;
 
  // ---- Erase Account mode: Google Drive storage box hover / selection ----
  bool _isHoveringAccountBox = false;
  bool _isAccountBoxSelected = false;
 
  // ---- Deleted Files mode: Google Drive trash box hover / selection ----
  bool _isHoveringDeletedBox = false;
  bool _isDeletedBoxSelected = false;
  bool _isHoveringEraseDeletedBtn = false;
 
  // ---- Files & Folders table (select-all hover, row hover, scrolling) ----
  bool _isHoveringSelectAll = false;
  String? _hoveredRowKey;
  final ScrollController _tableScrollController = ScrollController();
  late List<_FileNode> _fileTree = _buildInitialFileTree();
 
  // Vertical offset (from the top of the card's inner content) where the
  // Google Drive popup should sit — i.e. right below the dropdown row.
  // ("Cloud Service" label height + spacing + dropdown row height).
  static const double _dropdownPopupTopOffset = 62.0;
 
  // ---- Colours pulled from the screenshots ----
  static const Color pageBackground = Color(0xFFF2F2F2);
  static const Color boxBorderGrey = Color(0xFFD9D9D9);
 
  // Note box — light grey-blue background with a light teal-blue border.
  static const Color noteBackground = Color(0xFFE9EFF5);
  static const Color noteBorder = Color(0xFFB7D6DC);
 
  // Note icon — simple outlined circle (not filled solid), grey fill,
  // green ring + green "i" information symbol.
  static const Color noteIconGreen = Color(0xFF3CA55C);
 
  static const Color infoTextGrey = Color(0xFF6B6B6B);
  static const Color infoBoxBackground = Color(0xFFECECEC); // grey OAuth box
  static const Color connectHoverGreen = Color(0xFF2E7D46);
  static const Color popupTeal = Color(0xFF1F7A5C);
 
  // ---- Connected account box — same grey-blue style as the Note box ----
  static const Color connectedBoxBackground = noteBackground; // 0xFFE9EFF5
  static const Color connectedBoxBorder = noteBorder; // 0xFFB7D6DC
 
  // ---- Disconnect button (rectangle, grey) ----
  static const Color disconnectBg = Color(0xFFE3E3E3);
  static const Color disconnectBgHover = Color(0xFFD3D3D3);
  static const Color disconnectText = Color(0xFF6B6B6B);
 
  // ---- Erase Mode boxes ----
  static const Color eraseModeBoxBg = Color(0xFFF2F2F2); // default grey bg
  static const Color eraseModeBoxBorder = Color(0xFFD9D9D9); // default grey border
  static const Color eraseModeHoverBorder = Color(0xFFA9D8B6); // light green thin border (hover)
  static const Color eraseModeSelectedBg = Color(0xFFDCE6ED); // grey-blue (selected)
  static const Color eraseModeSelectedBorder = Color(0xFF3CA55C); // thick green border (selected)
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- Heading ----------
              const Text(
                'Cloud Erase',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Securely delete files from cloud storage services',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
 
              // ---------- Note box (light grey-blue, reduced height) ----------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: noteBackground,
                  border: Border.all(color: noteBorder),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Single information icon — circle ring + "i" both
                    // green, no extra background circle behind it.
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.info_outline,
                        size: 18,
                        color: noteIconGreen,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Note:',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Please ensure your internet connection remains active throughout the erasure process.',
                            style: TextStyle(
                              fontSize: 12,
                              color: infoTextGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
 
              const SizedBox(height: 24),
 
              // ---------- Single Cloud Service box (white) ----------
              // Contains: "Cloud Service" label, Google Drive selector,
              // the grey OAuth strip, and the "Connect to Google Drive" box —
              // all on the same white background, matching the reference.
              // Box height slightly increased (more vertical padding).
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 26,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: boxBorderGrey),
                  borderRadius: BorderRadius.circular(4),
                ),
                // Outer Stack so the dropdown popup can paint ON TOP of the
                // OAuth strip / Connect button below it, instead of being
                // hidden behind them.
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cloud Service',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
 
                        // "Google Drive" selector row (popup lives outside
                        // this Column now — see Positioned below).
                        GestureDetector(
                          onTap: () {
                            setState(
                              () => _isDropdownOpen = !_isDropdownOpen,
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: boxBorderGrey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Google Drive',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(
                                  _isDropdownOpen
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 20,
                                  color: Colors.grey[700],
                                ),
                              ],
                            ),
                          ),
                        ),
 
                        const SizedBox(height: 14),
 
                        // ---- Connecting spinner / Connected account box /
                        // OAuth strip + Connect button — only one of these
                        // three states is shown at a time. ----
                        if (_isConnecting)
                          // ---- Loading spinner — same width as the OAuth
                          // strip / Connect box below it used to take. ----
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            alignment: Alignment.center,
                            child: const SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  connectHoverGreen,
                                ),
                              ),
                            ),
                          )
                        else if (_isConnected)
                          // ---- Connected account box — grey-blue, same
                          // style as the Note box above. ----
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: connectedBoxBackground,
                              border: Border.all(color: connectedBoxBorder),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  size: 20,
                                  color: noteIconGreen,
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Demo User',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: infoTextGrey,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'demo.user@gmail.com',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: infoTextGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                MouseRegion(
                                  onEnter: (_) => setState(
                                    () => _isHoveringDisconnect = true,
                                  ),
                                  onExit: (_) => setState(
                                    () => _isHoveringDisconnect = false,
                                  ),
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isConnected = false;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 150),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _isHoveringDisconnect
                                            ? disconnectBgHover
                                            : disconnectBg,
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'Disconnect',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: disconnectText,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else ...[
                          // ---- Grey OAuth strip — width hugs the text only,
                          // rest of the row stays the box's white background ----
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: infoBoxBackground,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Connect to your cloud service to browse and securely erase files. We use OAuth 2.0 authentication - your credentials are never stored.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: infoTextGrey,
                                ),
                              ),
                            ),
                          ),
 
                          const SizedBox(height: 14),
 
                          // ---- "Connect to Google Drive" — white box on the
                          // same white page background ----
                          MouseRegion(
                            onEnter: (_) =>
                                setState(() => _isHoveringConnect = true),
                            onExit: (_) =>
                                setState(() => _isHoveringConnect = false),
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                // Start the connect flow: show the spinner,
                                // then reveal the connected account box.
                                setState(() {
                                  _isConnecting = true;
                                });
                                Future.delayed(
                                  const Duration(milliseconds: 900),
                                  () {
                                    if (!mounted) return;
                                    setState(() {
                                      _isConnecting = false;
                                      _isConnected = true;
                                      _selectedEraseMode = 0;
                                    });
                                  },
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: _isHoveringConnect
                                      ? connectHoverGreen
                                      : Colors.white,
                                  border: Border.all(
                                    color: _isHoveringConnect
                                        ? connectHoverGreen
                                        : boxBorderGrey,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.link,
                                      size: 17,
                                      color: _isHoveringConnect
                                          ? Colors.white
                                          : Colors.grey[700],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Connect to Google Drive',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: _isHoveringConnect
                                            ? Colors.white
                                            : Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
 
                    // ---- Google Drive popup — sits ABOVE / on top of the
                    // OAuth strip and Connect button (last child of the
                    // Stack paints last, i.e. on top of everything else). ----
                    if (_isDropdownOpen)
                      Positioned(
                        top: _dropdownPopupTopOffset,
                        left: 0,
                        right: 0,
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(4),
                          child: GestureDetector(
                            onTap: () {
                              // Selecting the option closes the popup.
                              setState(() => _isDropdownOpen = false);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: popupTeal,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Google Drive',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(
                                    Icons.check,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
 
              if (_isConnected) ...[
                const SizedBox(height: 24),
 
                // ---------- "Erase Mode" section ----------
                const Text(
                  'Erase Mode',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _eraseModeBox(
                          index: 0,
                          icon: Icons.folder_outlined,
                          title: 'Files & Folders',
                          subtitle: 'Select and erase individual items',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _eraseModeBox(
                          index: 1,
                          icon: Icons.dns_outlined,
                          title: 'Erase Account',
                          subtitle: 'Erase all data from account',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _eraseModeBox(
                          index: 2,
                          icon: Icons.delete_outline,
                          title: 'Deleted Files',
                          subtitle: 'Erase trash/deleted items',
                        ),
                      ),
                    ],
                  ),
                ),
 
                if (_selectedEraseMode == 0) ...[
                  const SizedBox(height: 16),
                  _buildFileTableSection(),
                ],
                if (_selectedEraseMode == 1) ...[
                  const SizedBox(height: 16),
                  _buildEraseAccountSection(),
                ],
                if (_selectedEraseMode == 2) ...[
                  const SizedBox(height: 16),
                  _buildDeletedFilesSection(),
                ],
              ] else ...[
                const SizedBox(height: 60),
 
                // ---------- "Select a service to connect" placeholder ----------
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_outlined,
                        size: 46,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Select a service to connect',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
 
  // ---- One of the three "Erase Mode" boxes (Files & Folders / Erase
  // Account / Deleted Files). Grey by default, thin light-green border on
  // hover, grey-blue background + thick green border when selected. ----
  Widget _eraseModeBox({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    bool isSelected = _selectedEraseMode == index;
    bool isHovered = _hoveredEraseMode == index;
 
    Color bg = isSelected ? eraseModeSelectedBg : eraseModeBoxBg;
    Color borderColor;
    double borderWidth;
    if (isSelected) {
      borderColor = eraseModeSelectedBorder;
      borderWidth = 2.0;
    } else if (isHovered) {
      borderColor = eraseModeHoverBorder;
      borderWidth = 1.0;
    } else {
      borderColor = eraseModeBoxBorder;
      borderWidth = 1.0;
    }
 
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredEraseMode = index),
      onExit: (_) => setState(() => _hoveredEraseMode = null),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => _selectedEraseMode = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: borderColor, width: borderWidth),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: noteIconGreen),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10.5,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 
  // ==================== Erase Account section ====================
  // Google Drive storage box (Total Size / Used / Free + usage bar) and the
  // "Erase All Account Data" button — shown when the "Erase Account" mode
  // box is selected.
 
  static const Color _accountCloudIconBg = Color(0xFFFBE1E1);
  static const Color _accountCloudIconRed = Color(0xFFDC2626);
  static const Color _accountNormalRed = Color(0xFFE0524F); // normal (not dark) red
  static const Color _accountUsageTrack = Color(0xFFD7DEE8);
  static const double _accountIconIndent = 52; // icon box width + gap
 
  // ---- Deleted Files box colours ----
  static const Color _deletedAmber = Color(0xFFF59E0B);
  static const Color _deletedBtnDisabled = Color(0xFFB9DDD4); // pale teal
  static const Color _deletedBtnHover = Color(0xFF1F6B4F); // full hover green
 
  Widget _buildEraseAccountSection() {
    final bool isSelected = _isAccountBoxSelected;
    final bool isHovered = _isHoveringAccountBox;
 
    Color borderColor;
    double borderWidth = 1;
    if (isSelected) {
      borderColor = connectHoverGreen; // teal green
      borderWidth = 1.6;
    } else if (isHovered) {
      borderColor = eraseModeHoverBorder; // light thin green
    } else {
      borderColor = boxBorderGrey;
    }
 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHoveringAccountBox = true),
          onExit: (_) => setState(() => _isHoveringAccountBox = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () =>
                setState(() => _isAccountBoxSelected = !_isAccountBoxSelected),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: borderColor, width: borderWidth),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- Header row: cloud icon + "Google Drive" + tag ----
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _accountCloudIconBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.cloud_outlined,
                          size: 18,
                          color: _accountNormalRed,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Google Drive',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _accountCloudIconBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Cloud Storage',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: _accountCloudIconRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
 
                  // ---- Total Size + Usage — stacked, left-aligned with
                  // the "Google Drive" text above (not the icon), so they
                  // line up with each other. ----
                  Padding(
                    padding: const EdgeInsets.only(left: _accountIconIndent),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Size',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '14.0 GB',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 10),
 
                        // ---- "Usage" label + percentage ----
                        Row(
                          children: [
                            Text(
                              'Usage',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '56%',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
 
                        // ---- Usage bar ----
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: SizedBox(
                            height: 6,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 56,
                                  child: Container(color: _accountNormalRed),
                                ),
                                Expanded(
                                  flex: 44,
                                  child: Container(color: _accountUsageTrack),
                                ),
                              ],
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
        ),
 
        const SizedBox(height: 16),
 
        // ---- "Erase All Account Data" — disabled (pale) until the Google
        // Drive box above is selected, then enabled (solid red). ----
        GestureDetector(
          onTap: isSelected ? _showAccountEraseConfirmDialog : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? _accountNormalRed
                  : const Color(0xFFF1B8B8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow, size: 15, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Erase All Account Data',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
 
  void _showAccountEraseConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ConfirmAccountEraseDialog(
        onConfirmed: () {
          // TODO: hook up actual "erase all account data" action here.
        },
      ),
    );
  }
 
  // ==================== Deleted Files section ====================
  // Google Drive trash box (Items in Trash / Trash Size + warning text) and
  // the "Erase Deleted Files" button — shown when the "Deleted Files" mode
  // box is selected.
 
  Widget _buildDeletedFilesSection() {
    final bool isSelected = _isDeletedBoxSelected;
    final bool isHovered = _isHoveringDeletedBox;
 
    Color borderColor;
    double borderWidth = 1;
    if (isSelected) {
      borderColor = connectHoverGreen; // teal green
      borderWidth = 1.6;
    } else if (isHovered) {
      borderColor = eraseModeHoverBorder; // light thin green
    } else {
      borderColor = boxBorderGrey;
    }
 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHoveringDeletedBox = true),
          onExit: (_) => setState(() => _isHoveringDeletedBox = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => setState(
              () => _isDeletedBoxSelected = !_isDeletedBoxSelected,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: borderColor, width: borderWidth),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- Header row: cloud icon (outline only, teal green)
                  // + "Google Drive" (grey text) ----
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: eraseModeSelectedBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.cloud_outlined,
                          size: 18,
                          color: connectHoverGreen,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Google Drive',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
 
                  // ---- "Items in Trash" / "Trash Size" columns — indented
                  // to line up with the "Google Drive" text above. ----
                  Padding(
                    padding: const EdgeInsets.only(left: _accountIconIndent),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Items in Trash',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '124 files',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: _deletedAmber,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trash Size',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '114.4 MB GB',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: _deletedAmber,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(child: SizedBox.shrink()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
 
                  // ---- Warning text ----
                  Padding(
                    padding: const EdgeInsets.only(left: _accountIconIndent),
                    child: Text(
                      'These items are currently in trash and can be '
                      'recovered. Erasing will permanently delete them.',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.red[400],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
 
        const SizedBox(height: 16),
 
        // ---- "Erase Deleted Files" — disabled (pale teal) until the
        // Google Drive box above is selected, then enabled (teal green),
        // hovers to a fuller green. ----
        MouseRegion(
          onEnter: (_) => setState(() => _isHoveringEraseDeletedBtn = true),
          onExit: (_) => setState(() => _isHoveringEraseDeletedBtn = false),
          cursor: isSelected
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: isSelected ? _showDeletedFilesEraseConfirmDialog : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: !isSelected
                    ? _deletedBtnDisabled
                    : (_isHoveringEraseDeletedBtn
                        ? _deletedBtnHover
                        : connectHoverGreen),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow, size: 15, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Erase Deleted Files',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
 
  void _showDeletedFilesEraseConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ConfirmDeletedFilesEraseDialog(
        onConfirmed: () {
          // TODO: hook up actual "erase deleted files" action here.
        },
      ),
    );
  }
 
  // ==================== Erase confirmation dialog ====================
 
  void _showEraseConfirmDialog(int itemCount) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ConfirmEraseDialog(
        itemCount: itemCount,
        onConfirmed: () {
          // TODO: hook up actual cloud erase action here.
        },
      ),
    );
  }
 
  // ==================== Files & Folders table ====================
 
  static const TextStyle _tableHeaderTextStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );
 
  static final TextStyle _tableCellTextStyle = TextStyle(
    fontSize: 11,
    color: Colors.grey[700],
  );
 
  Widget _buildFileTableSection() {
    int selectedCount = _countSelected(_fileTree);
    bool hasSelection = selectedCount > 0;
    bool allSelected = _isAllSelected(_fileTree);
 
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: boxBorderGrey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- "Select All" + selected count + Erase Selected button ----
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MouseRegion(
                  onEnter: (_) =>
                      setState(() => _isHoveringSelectAll = true),
                  onExit: (_) =>
                      setState(() => _isHoveringSelectAll = false),
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _setSelectedRecursive(_fileTree, !allSelected);
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _isHoveringSelectAll
                            ? Colors.grey[200]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_box_outlined,
                              size: 16, color: Colors.grey[700]),
                          const SizedBox(width: 6),
                          Text(
                            'Select All',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '$selectedCount selected',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: hasSelection
                          ? () => _showEraseConfirmDialog(selectedCount)
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: hasSelection
                              ? const Color(0xFFDC2626)
                              : const Color(0xFFF1B8B8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.delete_outline,
                                size: 14, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              'Erase Selected',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
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
 
          // ---- Divider line (black) ----
          Container(height: 1, color: Colors.black),
 
          // ---- Column header row (Name / Path / Size / Items) ----
          Container(
            width: double.infinity,
            color: const Color(0xFFF5F5F5),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                const SizedBox(width: 78),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Tooltip(
                          message: 'Name',
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          child: Text('Name', style: _tableHeaderTextStyle),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 3,
                        child: Tooltip(
                          message: 'Path',
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          child: Text('Path', style: _tableHeaderTextStyle),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 3),
                SizedBox(
                  width: 70,
                  child: Tooltip(
                    message: 'Size',
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    child: Text(
                      'Size',
                      textAlign: TextAlign.right,
                      style: _tableHeaderTextStyle,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 50,
                  child: Tooltip(
                    message: 'Items',
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    child: Text(
                      'Items',
                      textAlign: TextAlign.right,
                      style: _tableHeaderTextStyle,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
 
          // ---- Scrollable data rows ----
          SizedBox(
            height: 320,
            child: Scrollbar(
              controller: _tableScrollController,
              thumbVisibility: true,
              trackVisibility: true,
              child: SingleChildScrollView(
                controller: _tableScrollController,
                padding: const EdgeInsets.only(right: 6),
                child: Column(
                  children: _buildFileRows(_fileTree, 0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
 
  List<Widget> _buildFileRows(List<_FileNode> nodes, int depth) {
    final List<Widget> rows = [];
    for (final node in nodes) {
      rows.add(_buildFileRow(node, depth));
      if (node.isFolder && node.expanded) {
        rows.addAll(_buildFileRows(node.children, depth + 1));
      }
    }
    return rows;
  }
 
  Widget _buildFileRow(_FileNode node, int depth) {
    bool isHovered = _hoveredRowKey == node.path;
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredRowKey = node.path),
      onExit: (_) => setState(() => _hoveredRowKey = null),
      child: Container(
        decoration: BoxDecoration(
          color: isHovered ? Colors.grey[200] : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            SizedBox(width: depth * 20.0),
            SizedBox(
              width: 15,
              height: 15,
              child: Transform.scale(
                scale: 0.65,
                child: Checkbox(
                  value: node.selected,
                  onChanged: (v) => _toggleNodeSelected(node, v ?? false),
                  activeColor: noteIconGreen,
                  checkColor: Colors.white,
                  side: BorderSide(color: Colors.grey[350]!, width: 1.3),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              width: 18,
              child: node.isFolder
                  ? GestureDetector(
                      onTap: () =>
                          setState(() => node.expanded = !node.expanded),
                      child: Icon(
                        node.expanded
                            ? Icons.keyboard_arrow_down
                            : Icons.chevron_right,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Icon(
              node.isFolder
                  ? Icons.folder_outlined
                  : Icons.insert_drive_file_outlined,
              size: 16,
              color: node.isFolder ? noteIconGreen : Colors.grey[500],
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Tooltip(
                      message: node.name,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      child: Text(
                        node.name,
                        style: _tableCellTextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 3,
                    child: Tooltip(
                      message: node.path,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      child: Text(
                        node.path,
                        style: _tableCellTextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
            SizedBox(
              width: 70,
              child: Tooltip(
                message: node.size,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
                textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                child: Text(
                  node.size,
                  textAlign: TextAlign.right,
                  style: _tableCellTextStyle,
                ),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 50,
              child: Tooltip(
                message: node.items,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
                textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                child: Text(
                  node.items,
                  textAlign: TextAlign.right,
                  style: _tableCellTextStyle,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
 
  // ---- Selection helpers ----
 
  void _toggleNodeSelected(_FileNode node, bool value) {
    setState(() {
      node.selected = value;
      if (node.isFolder) {
        _setSelectedRecursive(node.children, value);
      }
    });
  }
 
  void _setSelectedRecursive(List<_FileNode> nodes, bool value) {
    for (final n in nodes) {
      n.selected = value;
      if (n.isFolder) _setSelectedRecursive(n.children, value);
    }
  }
 
  int _countSelected(List<_FileNode> nodes) {
    int count = 0;
    for (final n in nodes) {
      if (n.selected) count++;
      if (n.isFolder) count += _countSelected(n.children);
    }
    return count;
  }
 
  bool _isAllSelected(List<_FileNode> nodes) {
    for (final n in nodes) {
      if (!n.selected) return false;
      if (n.isFolder && !_isAllSelected(n.children)) return false;
    }
    return true;
  }
 
  // ---- Sample file/folder tree (matches the reference screenshots) ----
  List<_FileNode> _buildInitialFileTree() {
    return [
      _FileNode(
        name: 'Q1_Financial_Report.xlsx',
        path: 'My Drive / Q1_Financial_Report.xlsx',
        size: '2.3 MB',
        items: '1',
      ),
      _FileNode(
        name: 'Project_Roadmap_2026.pptx',
        path: 'My Drive / Project_Roadmap_2026.pptx',
        size: '4.9 MB',
        items: '1',
      ),
      _FileNode(
        name: 'Employee_Records_Backup.zip',
        path: 'My Drive / Employee_Records_Backup.zip',
        size: '84.9 MB',
        items: '1',
      ),
      _FileNode(
        name: 'Client Contracts',
        path: 'My Drive / Client Contracts',
        items: '3',
        isFolder: true,
        children: [
          _FileNode(
            name: 'Client_Agreement_ACME.pdf',
            path: 'My Drive / Client Contracts / Client_Agreement_ACME.pdf',
            size: '1.7 MB',
            items: '1',
          ),
          _FileNode(
            name: 'Client_Agreement_XYZ.pdf',
            path: 'My Drive / Client Contracts / Client_Agreement_XYZ.pdf',
            size: '1.9 MB',
            items: '1',
          ),
          _FileNode(
            name: 'System_Audit_Logs.txt',
            path: 'My Drive / Client Contracts / System_Audit_Logs.txt',
            size: '312.5 KB',
            items: '1',
          ),
        ],
      ),
      _FileNode(
        name: 'Old Projects Archive',
        path: 'My Drive / Old Projects Archive',
        items: '3',
        isFolder: true,
        children: [
          _FileNode(
            name: 'Client_Agreement_ACME.pdf',
            path: 'My Drive / Old Projects Archive / Client_Agreement_ACME.pdf',
            size: '1.7 MB',
            items: '1',
          ),
          _FileNode(
            name: 'Client_Agreement_XYZ.pdf',
            path: 'My Drive / Old Projects Archive / Client_Agreement_XYZ.pdf',
            size: '1.9 MB',
            items: '1',
          ),
          _FileNode(
            name: 'System_Audit_Logs.txt',
            path: 'My Drive / Old Projects Archive / System_Audit_Logs.txt',
            size: '312.5 KB',
            items: '1',
          ),
        ],
      ),
    ];
  }
}
 
// ---- Data model for one row in the Files & Folders table ----
class _FileNode {
  final String name;
  final String path;
  final String size;
  final String items;
  final bool isFolder;
  final List<_FileNode> children;
  bool selected;
  bool expanded;
 
  _FileNode({
    required this.name,
    required this.path,
    this.size = '',
    required this.items,
    this.isFolder = false,
    this.children = const [],
    this.selected = false,
    this.expanded = false,
  });
}
 
// ---------------------------------------------------------------------
// "Confirm Cloud File Erasure" popup — shown when the user taps the
// (enabled) "Erase Selected" button in the Files & Folders table.
// ---------------------------------------------------------------------
class _ConfirmEraseDialog extends StatefulWidget {
  const _ConfirmEraseDialog({
    required this.itemCount,
    required this.onConfirmed,
  });
 
  final int itemCount;
  final VoidCallback onConfirmed;
 
  @override
  State<_ConfirmEraseDialog> createState() => _ConfirmEraseDialogState();
}
 
class _ConfirmEraseDialogState extends State<_ConfirmEraseDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isHoveringInput = false;
  bool _isHoveringCancel = false;
  bool _isHoveringConfirm = false;
 
  // ---- Colours pulled from the reference screenshots ----
  static const Color _warningCircleBg = Color(0xFFFBE1E1);
  static const Color _warningIconRed = Color(0xFFDC2626);
  static const Color _confirmRed = Color(0xFFDC2626);
  static const Color _confirmRedDisabled = Color(0xFFF1B8B8);
  static const Color _confirmRedHover = Color(0xFFB91C1C);
  static const Color _inputHoverBg = Color(0xFFEAF6EE); // pale/water green
  static const Color _inputHoverBorder = // teal green
      _CloudEraseScreenState.connectHoverGreen;
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final bool isConfirmEnabled = _controller.text.trim() == 'ERASE';
 
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Header: warning icon + title + close (X) ----
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: _warningCircleBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: _warningIconRed,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Confirm Cloud File Erasure',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, top: 4),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
 
              // ---- Body warning text ----
              Text(
                'You are about to permanently erase ${widget.itemCount} '
                'item(s) from your cloud storage. Cloud files cannot be '
                'recovered after erasure.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
 
              // ---- "Type ERASE to confirm:" ----
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 12.5, color: Colors.grey[700]),
                  children: const [
                    TextSpan(text: 'Type '),
                    TextSpan(
                      text: 'ERASE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(text: ' to confirm:'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
 
              // ---- Confirmation text field ----
              MouseRegion(
                onEnter: (_) => setState(() => _isHoveringInput = true),
                onExit: (_) => setState(() => _isHoveringInput = false),
                child: Container(
                  decoration: BoxDecoration(
                    color: _isHoveringInput ? _inputHoverBg : Colors.white,
                    border: Border.all(
                      color: _isHoveringInput
                          ? _inputHoverBorder
                          : Colors.grey[400]!,
                      width: _isHoveringInput ? 1.4 : 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _controller,
                    onChanged: (_) => setState(() {}),
                    cursorColor: _CloudEraseScreenState.connectHoverGreen,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      hintText: 'ERASE',
                      hintStyle: TextStyle(color: Colors.grey[350]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
 
              // ---- Cancel / Confirm buttons ----
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MouseRegion(
                    onEnter: (_) => setState(() => _isHoveringCancel = true),
                    onExit: (_) => setState(() => _isHoveringCancel = false),
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: _isHoveringCancel
                              ? _CloudEraseScreenState.connectHoverGreen
                              : Colors.white,
                          border: Border.all(
                            color: _isHoveringCancel
                                ? _CloudEraseScreenState.connectHoverGreen
                                : Colors.grey[400]!,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.close,
                              size: 15,
                              color: _isHoveringCancel
                                  ? Colors.white
                                  : Colors.grey[700],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _isHoveringCancel
                                    ? Colors.white
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  MouseRegion(
                    onEnter: (_) => setState(() => _isHoveringConfirm = true),
                    onExit: (_) => setState(() => _isHoveringConfirm = false),
                    cursor: isConfirmEnabled
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.basic,
                    child: GestureDetector(
                      onTap: isConfirmEnabled
                          ? () {
                              Navigator.of(context).pop();
                              widget.onConfirmed();
                            }
                          : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: !isConfirmEnabled
                              ? _confirmRedDisabled
                              : (_isHoveringConfirm
                                  ? _confirmRedHover
                                  : _confirmRed),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 15,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 
// ---------------------------------------------------------------------
// "Confirm Cloud Account Erasure" popup — shown when the user taps the
// (enabled) "Erase All Account Data" button in the Erase Account section.
// ---------------------------------------------------------------------
class _ConfirmAccountEraseDialog extends StatefulWidget {
  const _ConfirmAccountEraseDialog({required this.onConfirmed});
 
  final VoidCallback onConfirmed;
 
  @override
  State<_ConfirmAccountEraseDialog> createState() =>
      _ConfirmAccountEraseDialogState();
}
 
class _ConfirmAccountEraseDialogState
    extends State<_ConfirmAccountEraseDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isHoveringInput = false;
  bool _isHoveringCancel = false;
  bool _isHoveringConfirm = false;
 
  // ---- Colours pulled from the reference screenshots ----
  static const Color _warningCircleBg = Color(0xFFFBE1E1);
  static const Color _warningIconRed = Color(0xFFDC2626);
  static const Color _confirmRed = Color(0xFFDC2626);
  static const Color _confirmRedDisabled = Color(0xFFF1B8B8);
  static const Color _confirmRedHover = Color(0xFFB91C1C);
  static const Color _inputHoverBg = Color(0xFFEAF6EE); // pale/water green
  static const Color _inputHoverBorder = // teal green
      _CloudEraseScreenState.connectHoverGreen;
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final bool isConfirmEnabled = _controller.text.trim() == 'ERASE';
 
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Header: warning icon + title + close (X) ----
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: _warningCircleBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: _warningIconRed,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Confirm Cloud Account Erasure',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, top: 4),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
 
              // ---- Body warning text ----
              Text(
                'You are about to erase all data in Google Drive. This will '
                'permanently delete all files and folders. This action '
                'cannot be undone.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
 
              // ---- "Type ERASE to confirm:" ----
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 12.5, color: Colors.grey[700]),
                  children: const [
                    TextSpan(text: 'Type '),
                    TextSpan(
                      text: 'ERASE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(text: ' to confirm:'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
 
              // ---- Confirmation text field ----
              MouseRegion(
                onEnter: (_) => setState(() => _isHoveringInput = true),
                onExit: (_) => setState(() => _isHoveringInput = false),
                child: Container(
                  decoration: BoxDecoration(
                    color: _isHoveringInput ? _inputHoverBg : Colors.white,
                    border: Border.all(
                      color: _isHoveringInput
                          ? _inputHoverBorder
                          : Colors.grey[400]!,
                      width: _isHoveringInput ? 1.4 : 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _controller,
                    onChanged: (_) => setState(() {}),
                    cursorColor: _CloudEraseScreenState.connectHoverGreen,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      hintText: 'ERASE',
                      hintStyle: TextStyle(color: Colors.grey[350]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
 
              // ---- Cancel / Confirm buttons ----
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MouseRegion(
                    onEnter: (_) => setState(() => _isHoveringCancel = true),
                    onExit: (_) => setState(() => _isHoveringCancel = false),
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: _isHoveringCancel
                              ? _CloudEraseScreenState.connectHoverGreen
                              : Colors.white,
                          border: Border.all(
                            color: _isHoveringCancel
                                ? _CloudEraseScreenState.connectHoverGreen
                                : Colors.grey[400]!,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.close,
                              size: 15,
                              color: _isHoveringCancel
                                  ? Colors.white
                                  : Colors.grey[700],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _isHoveringCancel
                                    ? Colors.white
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  MouseRegion(
                    onEnter: (_) => setState(() => _isHoveringConfirm = true),
                    onExit: (_) => setState(() => _isHoveringConfirm = false),
                    cursor: isConfirmEnabled
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.basic,
                    child: GestureDetector(
                      onTap: isConfirmEnabled
                          ? () {
                              Navigator.of(context).pop();
                              widget.onConfirmed();
                            }
                          : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: !isConfirmEnabled
                              ? _confirmRedDisabled
                              : (_isHoveringConfirm
                                  ? _confirmRedHover
                                  : _confirmRed),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 15,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 
// ---------------------------------------------------------------------
// "Confirm Cloud Trash Erasure" popup — shown when the user taps the
// (enabled) "Erase Deleted Files" button in the Deleted Files section.
// Mirrors _ConfirmAccountEraseDialog's layout, size, and behaviour.
// ---------------------------------------------------------------------
class _ConfirmDeletedFilesEraseDialog extends StatefulWidget {
  const _ConfirmDeletedFilesEraseDialog({required this.onConfirmed});
 
  final VoidCallback onConfirmed;
 
  @override
  State<_ConfirmDeletedFilesEraseDialog> createState() =>
      _ConfirmDeletedFilesEraseDialogState();
}
 
class _ConfirmDeletedFilesEraseDialogState
    extends State<_ConfirmDeletedFilesEraseDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isHoveringInput = false;
  bool _isHoveringCancel = false;
  bool _isHoveringConfirm = false;
 
  // ---- Colours pulled from the reference screenshots ----
  static const Color _warningCircleBg = Color(0xFFFBE1E1);
  static const Color _warningIconRed = Color(0xFFDC2626);
  static const Color _confirmRed = Color(0xFFDC2626);
  static const Color _confirmRedDisabled = Color(0xFFF1B8B8);
  static const Color _confirmRedHover = Color(0xFFB91C1C);
  static const Color _inputHoverBg = Color(0xFFEAF6EE); // pale/water green
  static const Color _inputHoverBorder = // teal green
      _CloudEraseScreenState.connectHoverGreen;
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final bool isConfirmEnabled = _controller.text.trim() == 'ERASE';
 
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Header: warning icon + title + close (X) ----
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: _warningCircleBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: _warningIconRed,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Confirm Cloud Trash Erasure',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, top: 4),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
 
              // ---- Body warning text ----
              Text(
                'You are about to erase all deleted/trashed files in Google '
                'Drive. This will permanently remove items from the trash. '
                'This action cannot be undone.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
 
              // ---- "Type ERASE to confirm:" ----
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 12.5, color: Colors.grey[700]),
                  children: const [
                    TextSpan(text: 'Type '),
                    TextSpan(
                      text: 'ERASE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(text: ' to confirm:'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
 
              // ---- Confirmation text field ----
              MouseRegion(
                onEnter: (_) => setState(() => _isHoveringInput = true),
                onExit: (_) => setState(() => _isHoveringInput = false),
                child: Container(
                  decoration: BoxDecoration(
                    color: _isHoveringInput ? _inputHoverBg : Colors.white,
                    border: Border.all(
                      color: _isHoveringInput
                          ? _inputHoverBorder
                          : Colors.grey[400]!,
                      width: _isHoveringInput ? 1.4 : 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _controller,
                    onChanged: (_) => setState(() {}),
                    cursorColor: _CloudEraseScreenState.connectHoverGreen,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      hintText: 'ERASE',
                      hintStyle: TextStyle(color: Colors.grey[350]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
 
              // ---- Cancel / Confirm buttons ----
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MouseRegion(
                    onEnter: (_) => setState(() => _isHoveringCancel = true),
                    onExit: (_) => setState(() => _isHoveringCancel = false),
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: _isHoveringCancel
                              ? _CloudEraseScreenState.connectHoverGreen
                              : Colors.white,
                          border: Border.all(
                            color: _isHoveringCancel
                                ? _CloudEraseScreenState.connectHoverGreen
                                : Colors.grey[400]!,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.close,
                              size: 15,
                              color: _isHoveringCancel
                                  ? Colors.white
                                  : Colors.grey[700],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _isHoveringCancel
                                    ? Colors.white
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  MouseRegion(
                    onEnter: (_) => setState(() => _isHoveringConfirm = true),
                    onExit: (_) => setState(() => _isHoveringConfirm = false),
                    cursor: isConfirmEnabled
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.basic,
                    child: GestureDetector(
                      onTap: isConfirmEnabled
                          ? () {
                              Navigator.of(context).pop();
                              widget.onConfirmed();
                            }
                          : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: !isConfirmEnabled
                              ? _confirmRedDisabled
                              : (_isHoveringConfirm
                                  ? _confirmRedHover
                                  : _confirmRed),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 15,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 