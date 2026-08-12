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
                              // TODO: hook up Google Drive OAuth connect flow here.
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
          ),
        ),
      ),
    );
  }
}
 