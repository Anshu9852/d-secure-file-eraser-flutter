import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/theme.dart';
 
class SettingsScreen extends StatefulWidget {
  final AppThemeMode themeMode;
  final ValueChanged<AppThemeMode> onThemeModeChanged;
  const SettingsScreen({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });
 
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}
 
class _Option {
  final String code;
  final String label;
  const _Option(this.code, this.label);
}
 
class _ToastMsg {
  final String id;
  final String text;
  _ToastMsg(this.id, this.text);
}
 
class _SettingsScreenState extends State<SettingsScreen> {
  int selectedTab = 0;
  bool resetHovered = false;
  final ScrollController _pageScrollController = ScrollController();
 
  // ---------------- Appearance tab ----------------
  // Derived directly from widget.themeMode so it always stays in sync with
  // the rest of the app (sidebar, background, etc.) instead of keeping its
  // own separate local state.
  String get _appearanceMode {
    switch (widget.themeMode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.greenDark:
        return 'DSecure';
      case AppThemeMode.greenLight:
        return 'DSecure Light';
    }
  }
 
  AppThemeMode _labelToMode(String label) {
    switch (label) {
      case 'Dark':
        return AppThemeMode.dark;
      case 'DSecure':
        return AppThemeMode.greenDark;
      case 'DSecure Light':
        return AppThemeMode.greenLight;
      default:
        return AppThemeMode.light;
    }
  }
 
  // Backward-compatible dark flag (Dark aur DSecure dono dark base hain)
  bool get _isDark =>
      widget.themeMode == AppThemeMode.dark ||
      widget.themeMode == AppThemeMode.greenDark;
 
  final Map<String, bool> _appearanceHover = {
    'Light': false,
    'Dark': false,
    'DSecure': false,
    'DSecure Light': false,
  };
 
  final List<String> _tabs = const ['General', 'Ignore List', 'Appearance', 'Language'];
 
  String erasureMethod = 'ZERO_FILL';
  static const List<_Option> _erasureMethods = [
    _Option('ZERO_FILL', 'Zero Fill (1-pass)'),
    _Option('ONE_FILL', 'One Fill (1-pass)'),
    _Option('RANDOM_DATA', 'Random Data (1-pass)'),
    _Option('NIST_SP_800_88_REV1', 'NIST SP 800-88 Rev1 (3-pass)'),
    _Option('DOD_5220_22_M_E', 'DoD 5220.22-M (E) Extended (7-pass)'),
    _Option('DOD_5220_28_M_STD', 'DoD 5220.28-M (STD) (3-pass)'),
    _Option('HMG_IS5_ENHANCED', 'HMG IS5 Enhanced (3-pass)'),
    _Option('GUTMANN', 'Gutmann Method (35-pass)'),
    _Option('PCI_DSS_3_2_1', 'PCI DSS 3.2.1 (3-pass)'),
    _Option('ISO_IEC_27040_2015', 'ISO/IEC 27040:2015 (3-pass)'),
    _Option('RCMP_TSSIT_OPS_II', 'RCMP TSSIT OPS-II (7-pass)'),
    _Option('GOST_R_50739_95', 'GOST R 50739-95 (2-pass)'),
    _Option('AFSSI_5020', 'AFSSI-5020 (3-pass)'),
    _Option('NAVSO_P_5239_26', 'NAVSO P-5239-26 (3-pass)'),
    _Option('ISO_IEC_27001_2013', 'ISO/IEC 27001:2013 (3-pass)'),
    _Option('RANDOM_ZERO_COMBO', 'Random + Zero Combo (2-pass)'),
    _Option('SEVEN_PASS_VERIFICATION', '7-Pass with Verification (7-pass)'),
    _Option('PFITZNER', 'Pfitzner Method (3-pass)'),
    _Option('SCHNEIER', 'Schneier Method (7-pass)'),
    _Option('VSITR', 'VSITR (German Standard) (7-pass)'),
    _Option('AR_380_19', 'AR 380-19 (US Army) (3-pass)'),
    _Option('CHINA_GB_17859_2018', 'China GB 17859-2018 (3-pass)'),
    _Option('BRAZIL_LGPD', 'Brazil LGPD (3-pass)'),
    _Option('INDIA_DPA', 'India DPA (3-pass)'),
    _Option('JAPAN_APPI', 'Japan APPI (3-pass)'),
    _Option('KOREA_PIPA', 'Korea PIPA (3-pass)'),
    _Option('QUICK_WIPE', 'Quick Wipe (1-pass)'),
  ];
 
  String verificationLevel = 'Standard (Recommended)';
  static const List<_Option> _verificationLevels = [
    _Option('None (Fastest)', 'None (Fastest)'),
    _Option('Standard (Recommended)', 'Standard (Recommended)'),
    _Option('Full (Slowest, Most Secure)', 'Full (Slowest, Most Secure)'),
  ];
 
  bool autoGenerateReports = true;
  bool requireConfirmation = true;
  bool checkForUpdates = true;
 
  // ---------------- Language tab ----------------
  String applicationLanguage = 'English (US)';
  static const List<_Option> _languageOptions = [
    _Option('العربية (Arabic)', 'العربية (Arabic)'),
    _Option('Български (Bulgarian)', 'Български (Bulgarian)'),
    _Option('বাংলা (Bengali)', 'বাংলা (Bengali)'),
    _Option('Čeština (Czech)', 'Čeština (Czech)'),
    _Option('Dansk (Danish)', 'Dansk (Danish)'),
    _Option('Deutsch (German)', 'Deutsch (German)'),
    _Option('Ελληνικά (Greek)', 'Ελληνικά (Greek)'),
    _Option('English (US)', 'English (US)'),
    _Option('English (Canada)', 'English (Canada)'),
    _Option('English (UK)', 'English (UK)'),
    _Option('Español (Spanish)', 'Español (Spanish)'),
    _Option('Español (Mexico)', 'Español (Mexico)'),
    _Option('Eesti (Estonian)', 'Eesti (Estonian)'),
    _Option('فارسی (Persian)', 'فارسی (Persian)'),
    _Option('Suomi (Finnish)', 'Suomi (Finnish)'),
    _Option('Filipino', 'Filipino'),
    _Option('Français (French)', 'Français (French)'),
    _Option('Français (Canada)', 'Français (Canada)'),
    _Option('עברית (Hebrew)', 'עברית (Hebrew)'),
    _Option('हिन्दी (Hindi)', 'हिन्दी (Hindi)'),
    _Option('Hrvatski (Croatian)', 'Hrvatski (Croatian)'),
    _Option('Magyar (Hungarian)', 'Magyar (Hungarian)'),
    _Option('Bahasa Indonesia', 'Bahasa Indonesia'),
    _Option('Italiano (Italian)', 'Italiano (Italian)'),
    _Option('日本語 (Japanese)', '日本語 (Japanese)'),
    _Option('한국어 (Korean)', '한국어 (Korean)'),
    _Option('Lietuvių (Lithuanian)', 'Lietuvių (Lithuanian)'),
    _Option('Latviešu (Latvian)', 'Latviešu (Latvian)'),
    _Option('Bahasa Melayu (Malay)', 'Bahasa Melayu (Malay)'),
    _Option('Nederlands (Dutch)', 'Nederlands (Dutch)'),
    _Option('Norsk (Norwegian)', 'Norsk (Norwegian)'),
    _Option('Polski (Polish)', 'Polski (Polish)'),
    _Option('Português (Brazil)', 'Português (Brazil)'),
    _Option('Română (Romanian)', 'Română (Romanian)'),
    _Option('Русский (Russian)', 'Русский (Russian)'),
    _Option('Slovenčina (Slovenian)', 'Slovenčina (Slovenian)'),
    _Option('Slovenščina (Slovenian)', 'Slovenščina (Slovenian)'),
    _Option('Српски (Serbian)', 'Српски (Serbian)'),
    _Option('Svenska (Swedish)', 'Svenska (Swedish)'),
    _Option('ไทย (Thai)', 'ไทย (Thai)'),
    _Option('Türkçe (Turkish)', 'Türkçe (Turkish)'),
    _Option('Українська (Ukrainian)', 'Українська (Ukrainian)'),
    _Option('Tiếng Việt (Vietnamese)', 'Tiếng Việt (Vietnamese)'),
    _Option('中文 (Simplified)', '中文 (Simplified)'),
    _Option('中文 (China)', '中文 (China)'),
    _Option('中文 (Traditional)', '中文 (Traditional)'),
  ];
 
  String dateFormat = 'MM/DD/YYYY';
  static const List<_Option> _dateFormatOptions = [
    _Option('MM/DD/YYYY', 'MM/DD/YYYY'),
    _Option('DD/MM/YYYY', 'DD/MM/YYYY'),
    _Option('YYYY-MM-DD', 'YYYY-MM-DD'),
  ];
 
  String timeFormat = '12-hour (AM/PM)';
  static const List<_Option> _timeFormatOptions = [
    _Option('12-hour (AM/PM)', '12-hour (AM/PM)'),
    _Option('24-hour', '24-hour'),
  ];
 
  // Colors
  static const Color teal = Color(0xFF14B8A6);
 
  // CHANGED: ab sirf isDark (true/false) nahi, poore themeMode ke hisaab se
  // colors decide hote hain — taaki DSecure (greenDark) aur DSecure Light
  // (greenLight) click karne par Settings page ka background/text bhi
  // (sidebar ki tarah) sahi se badle, sirf sidebar hi na badle.
  Color get _bgColor {
    switch (widget.themeMode) {
      case AppThemeMode.light:
        return const Color(0xFFF3F4F6);
      case AppThemeMode.dark:
        return const Color(0xFF0F172A);
      case AppThemeMode.greenDark:
        return const Color(0xFF0F172A); // dark background, text green
      case AppThemeMode.greenLight:
        return AppColors.greenLightBg; // halka mint background
    }
  }
 
  Color get _cardColor {
    switch (widget.themeMode) {
      case AppThemeMode.light:
        return Colors.white;
      case AppThemeMode.dark:
        return const Color(0xFF1E293B);
      case AppThemeMode.greenDark:
        return const Color(0xFF1E293B);
      case AppThemeMode.greenLight:
        return AppColors.greenLightCard;
    }
  }
 
  Color get _borderColor {
    switch (widget.themeMode) {
      case AppThemeMode.light:
        return const Color(0xFFE2E8F0);
      case AppThemeMode.dark:
        return const Color(0xFF334155);
      case AppThemeMode.greenDark:
        return const Color(0xFF334155);
      case AppThemeMode.greenLight:
        return AppColors.greenLightBorder;
    }
  }
 
  Color get _titleColor {
    switch (widget.themeMode) {
      case AppThemeMode.light:
        return const Color(0xFF0F172A);
      case AppThemeMode.dark:
        return Colors.white;
      case AppThemeMode.greenDark:
        return AppColors.greenDarkText; // #4ADE80
      case AppThemeMode.greenLight:
        return AppColors.greenLightText;
    }
  }
 
  Color get _labelColor {
    switch (widget.themeMode) {
      case AppThemeMode.light:
        return Colors.grey[600]!;
      case AppThemeMode.dark:
        return const Color(0xFF94A3B8);
      case AppThemeMode.greenDark:
        return AppColors.greenDarkGreyText;
      case AppThemeMode.greenLight:
        return AppColors.greenLightGreyText;
    }
  }
 
  Color get _tabBarBg {
    switch (widget.themeMode) {
      case AppThemeMode.light:
        return const Color(0xFFE2E8F0);
      case AppThemeMode.dark:
        return const Color(0xFF1E293B);
      case AppThemeMode.greenDark:
        return const Color(0xFF1E293B);
      case AppThemeMode.greenLight:
        return AppColors.greenLightBorder;
    }
  }
 
  Color get _dividerColor {
    switch (widget.themeMode) {
      case AppThemeMode.light:
        return const Color(0xFFD1D5DB);
      case AppThemeMode.dark:
        return const Color(0xFF475569);
      case AppThemeMode.greenDark:
        return const Color(0xFF475569);
      case AppThemeMode.greenLight:
        return AppColors.greenLightBorder;
    }
  }
 
  // ---------------- Toast / notification stack ----------------
  final List<_ToastMsg> _toasts = [];
  bool _toastsExpanded = false;
  Timer? _autoDismissTimer;
  int _toastCounter = 0;
 
  void _pushToast(String text) {
    setState(() {
      _toastCounter++;
      _toasts.insert(0, _ToastMsg('t$_toastCounter', text));
    });
    _ensureAutoDismiss();
  }
 
  void _ensureAutoDismiss() {
    _autoDismissTimer ??= Timer.periodic(const Duration(milliseconds: 2200), (timer) {
      if (!mounted || _toasts.isEmpty) {
        timer.cancel();
        _autoDismissTimer = null;
        return;
      }
      setState(() {
        _toasts.removeLast(); // oldest goes first
        if (_toasts.isEmpty) _toastsExpanded = false;
      });
      if (_toasts.isEmpty) {
        timer.cancel();
        _autoDismissTimer = null;
      }
    });
  }
 
  void _clearAllToasts() {
    setState(() {
      _toasts.clear();
      _toastsExpanded = false;
    });
    _autoDismissTimer?.cancel();
    _autoDismissTimer = null;
  }
 
  void _removeToast(String id) {
    setState(() {
      _toasts.removeWhere((t) => t.id == id);
      if (_toasts.isEmpty) _toastsExpanded = false;
    });
  }
 
  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _pageScrollController.dispose();
    super.dispose();
  }
 
  void _resetToDefaults() {
    setState(() {
      erasureMethod = 'ZERO_FILL';
      verificationLevel = 'Standard (Recommended)';
      autoGenerateReports = true;
      requireConfirmation = true;
      checkForUpdates = true;
    });
    _pushToast('Settings reset to defaults');
  }
 
  void _saveChanges() {
    _pushToast('Settings saved successfully');
  }
 
  @override
  Widget build(BuildContext context) {
    // Outer container fills all available space with plain (non-blue) grey,
    // all the way down to the footer.
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: _bgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Fixed header + tab bar — these never scroll.
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Configure application preferences and behaviour',
                      style: TextStyle(fontSize: 12, color: _labelColor),
                    ),
                    const SizedBox(height: 20),
 
                    // Tab bar
                    _buildTabBar(),
 
                    // Extra breathing room before the white card
                    const SizedBox(height: 40),
                  ],
                ),
              ),
 
              // Scrollable white-card section — the scrollbar starts right
              // here (where the white card begins) and runs down to the
              // footer, since the footer lives just outside this Expanded.
              Expanded(
                child: Scrollbar(
                  controller: _pageScrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  thickness: 8,
                  radius: const Radius.circular(8),
                  child: SingleChildScrollView(
                    controller: _pageScrollController,
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // White settings card — content depends on selected tab
                        selectedTab == 1
                            ? _buildIgnoreListCard()
                            : selectedTab == 2
                                ? _buildAppearanceCard()
                                : selectedTab == 3
                                    ? _buildLanguageCard()
                                    : _buildGeneralSettingsCard(),
 
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
 
              // Footer — divider + Reset/Save buttons. Fixed at the bottom of
              // the page for every tab; it never moves regardless of how
              // tall the tab content above happens to be.
              // Divider line — full-bleed, no side padding, so it touches the
              // sidebar's vertical line on the left and the outer border on the right.
              Container(height: 1, color: _dividerColor),
 
              // Buttons row (side padding restored)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildResetButton(),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
 
        // Toast notification stack — top-right corner of the settings page
        Positioned(
          top: 16,
          right: 16,
          child: _buildToastStack(),
        ),
      ],
    );
  }
 
  Widget _buildGeneralSettingsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(46),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General Settings',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _titleColor,
            ),
          ),
          const SizedBox(height: 18),
 
          // Default Erasure Method
          Text('Default Erasure Method', style: TextStyle(fontSize: 12, color: _labelColor)),
          const SizedBox(height: 6),
          _buildDropdown(
            value: erasureMethod,
            options: _erasureMethods,
            maxVisibleItems: 6,
            onChanged: (val) => setState(() => erasureMethod = val),
          ),
          const SizedBox(height: 6),
          Text(
            'This method will be used by default for all erasure operations',
            style: TextStyle(fontSize: 11, color: _labelColor),
          ),
          const SizedBox(height: 20),
 
          // Verification Level
          Text('Verification Level', style: TextStyle(fontSize: 12, color: _labelColor)),
          const SizedBox(height: 6),
          _buildDropdown(
            value: verificationLevel,
            options: _verificationLevels,
            maxVisibleItems: 3,
            onChanged: (val) => setState(() => verificationLevel = val),
          ),
          const SizedBox(height: 6),
          Text(
            'Higher verification levels ensure data is completely erased',
            style: TextStyle(fontSize: 11, color: _labelColor),
          ),
          const SizedBox(height: 24),
 
          // Checkboxes
          _buildCheckboxRow(
            label: 'Automatically generate reports after each operation',
            value: autoGenerateReports,
            onChanged: (val) => setState(() => autoGenerateReports = val!),
          ),
          const SizedBox(height: 12),
          _buildCheckboxRow(
            label: 'Require confirmation before erasing',
            value: requireConfirmation,
            onChanged: (val) => setState(() => requireConfirmation = val!),
          ),
          const SizedBox(height: 12),
          _buildCheckboxRow(
            label: 'Check for updates on startup',
            value: checkForUpdates,
            onChanged: (val) => setState(() => checkForUpdates = val!),
          ),
        ],
      ),
    );
  }
 
  // ---------------- Appearance tab ----------------
 
  Widget _buildAppearanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theme',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _titleColor,
            ),
          ),
          const SizedBox(height: 20),
          _buildThemeRow('Light', 'Clean and bright interface'),
          const SizedBox(height: 12),
          _buildThemeRow('Dark', 'Easy on the eyes in low light'),
          const SizedBox(height: 12),
          _buildThemeRow(
            'DSecure',
            'Enterprise dark theme',
            isBrand: true,
          ),
          const SizedBox(height: 12),
          _buildThemeRow(
            'DSecure Light',
            'Enterprise light theme',
            isBrand: true,
          ),
        ],
      ),
    );
  }
 
  Widget _buildThemeRow(
    String value,
    String subtitle, {
    bool isBrand = false,
  }) {
    final bool selected = _appearanceMode == value;
    final bool hovered = _appearanceHover[value] ?? false;
 
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _appearanceHover[value] = true),
      onExit: (_) => setState(() => _appearanceHover[value] = false),
      child: GestureDetector(
        // CHANGED: ab local state ki jagah HomeScreen ke themeMode ko
        // update karta hai, taaki poora app (sidebar/background/text)
        // turant naye theme me switch ho jaye.
        onTap: () => widget.onThemeModeChanged(_labelToMode(value)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: double.infinity,
          // Taller boxes than before.
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            // Each theme option is its own standalone box: white background
            // with a grey border by default (not just a row separated by a
            // divider line). Hovering greys the background — but only while
            // it's not the selected option. Once selected, the background
            // stays white/plain and only the border turns teal.
            color: selected
                ? _cardColor
                : (hovered
                    ? (_isDark
                        ? const Color(0xFF243044)
                        : const Color(0xFFF3F4F6))
                    : _cardColor),
            border: Border.all(
              color: selected ? teal : _borderColor,
              width: 1.4,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 11.5, color: _labelColor),
                    ),
                  ],
                ),
              ),
              if (isBrand)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: teal.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Brand',
                    style: TextStyle(
                      fontSize: 11,
                      color: teal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
 
  // ---------------- Language tab ----------------
 
  Widget _buildLanguageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(46),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Language & Region',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _titleColor,
            ),
          ),
          const SizedBox(height: 18),
 
          // Application Language
          Text('Application Language', style: TextStyle(fontSize: 12, color: _labelColor)),
          const SizedBox(height: 6),
          _buildDropdown(
            value: applicationLanguage,
            options: _languageOptions,
            maxVisibleItems: 6,
            onChanged: (val) => setState(() => applicationLanguage = val),
          ),
          const SizedBox(height: 20),
 
          // Date Format
          Text('Date Format', style: TextStyle(fontSize: 12, color: _labelColor)),
          const SizedBox(height: 6),
          _buildDropdown(
            value: dateFormat,
            options: _dateFormatOptions,
            maxVisibleItems: 3,
            onChanged: (val) => setState(() => dateFormat = val),
          ),
          const SizedBox(height: 20),
 
          // Time Format
          Text('Time Format', style: TextStyle(fontSize: 12, color: _labelColor)),
          const SizedBox(height: 6),
          _buildDropdown(
            value: timeFormat,
            options: _timeFormatOptions,
            maxVisibleItems: 2,
            onChanged: (val) => setState(() => timeFormat = val),
          ),
        ],
      ),
    );
  }
 
  // ---------------- Ignore List tab ----------------
 
  final List<String> _ignoreListItems = [];
  bool _addFilesHovered = false;
  bool _addFoldersHovered = false;
  static const Color _tealDark = Color(0xFF0F9488);
 
  Future<void> _pickIgnoreFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result != null && result.paths.isNotEmpty) {
        setState(() {
          _ignoreListItems.addAll(result.paths.whereType<String>());
        });
      }
    } catch (_) {
      // FilePicker not available on this platform/build — ignore silently.
    }
  }
 
  Future<void> _pickIgnoreFolder() async {
    try {
      final path = await FilePicker.platform.getDirectoryPath();
      if (path != null) {
        setState(() => _ignoreListItems.add(path));
      }
    } catch (_) {
      // FilePicker not available on this platform/build — ignore silently.
    }
  }
 
  Widget _buildIgnoreActionButton({
    required IconData icon,
    required String label,
    required bool hovered,
    required ValueChanged<bool> onHoverChanged,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: hovered ? _tealDark : teal,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _buildIgnoreListCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: title on the left, action buttons on the right
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Ignore List',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _titleColor,
                ),
              ),
              const Spacer(),
              _buildIgnoreActionButton(
                icon: Icons.insert_drive_file_outlined,
                label: 'Add Files',
                hovered: _addFilesHovered,
                onHoverChanged: (v) => setState(() => _addFilesHovered = v),
                onTap: _pickIgnoreFiles,
              ),
              const SizedBox(width: 12),
              _buildIgnoreActionButton(
                icon: Icons.create_new_folder_outlined,
                label: 'Add Folders',
                hovered: _addFoldersHovered,
                onHoverChanged: (v) => setState(() => _addFoldersHovered = v),
                onTap: _pickIgnoreFolder,
              ),
            ],
          ),
          const SizedBox(height: 28),
 
          Text(
            'Items in this list will be excluded from all erase operations.',
            style: TextStyle(fontSize: 12, color: _labelColor),
          ),
          const SizedBox(height: 24),
 
          // Body area — reduced height, empty-state text sits near the top
          // instead of dead-center in a tall blank box.
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 70),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 12),
            child: _ignoreListItems.isEmpty
                ? Text(
                    'No items in ignore list',
                    style: TextStyle(fontSize: 12, color: _labelColor),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _ignoreListItems
                        .map(
                          (path) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              path,
                              style: TextStyle(fontSize: 12.5, color: _labelColor),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
 
  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _tabBarBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_tabs.length, (index) {
          final bool isSelected = selectedTab == index;
 
          // No hover color — the white "button" only appears once the tab
          // is actually selected (tapped), not on mouse hover.
          return GestureDetector(
            onTap: () => setState(() => selectedTab = index),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                margin: const EdgeInsets.only(right: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (_isDark ? const Color(0xFF334155) : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? _titleColor : _labelColor,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
 
  // ---------------- Dropdown field + custom popup ----------------
 
  OverlayEntry? _dropdownOverlayEntry;
 
  void _closeDropdown() {
    _dropdownOverlayEntry?.remove();
    _dropdownOverlayEntry = null;
  }
 
  void _openDropdown({
    required BuildContext fieldContext,
    required List<_Option> options,
    required String selectedCode,
    required ValueChanged<String> onSelect,
    required int maxVisibleItems,
  }) {
    _closeDropdown();
    final RenderBox box = fieldContext.findRenderObject() as RenderBox;
    final Offset offset = box.localToGlobal(Offset.zero);
    final double width = box.size.width;
    const double itemHeight = 42;
    final int visible = options.length < maxVisibleItems ? options.length : maxVisibleItems;
    final double listHeight = itemHeight * visible;
 
    _dropdownOverlayEntry = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeDropdown,
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy + box.size.height + 4,
              width: width,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: listHeight,
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _DropdownList(
                    options: options,
                    selectedCode: selectedCode,
                    itemHeight: itemHeight,
                    teal: teal,
                    labelColor: _labelColor,
                    onSelect: (code) {
                      onSelect(code);
                      _closeDropdown();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    Overlay.of(context).insert(_dropdownOverlayEntry!);
  }
 
  Widget _buildDropdown({
    required String value,
    required List<_Option> options,
    required int maxVisibleItems,
    required ValueChanged<String> onChanged,
  }) {
    // Static-look box matching the screenshot exactly (plain text + grey arrow icon).
    // Tapping opens a custom scrollable popup (max `maxVisibleItems` rows visible)
    // with teal hover highlighting, positioned to match the field's width exactly.
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (details) {
            _openDropdown(
              fieldContext: context,
              options: options,
              selectedCode: value,
              onSelect: onChanged,
              maxVisibleItems: maxVisibleItems,
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                ),
                Icon(Icons.keyboard_arrow_down, color: _labelColor, size: 18),
              ],
            ),
          ),
        );
      },
    );
  }
 
  Widget _buildCheckboxRow({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: teal,
              checkColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(fontSize: 12.5, color: _labelColor),
          ),
        ],
      ),
    );
  }
 
  Widget _buildResetButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => resetHovered = true),
      onExit: (_) => setState(() => resetHovered = false),
      child: GestureDetector(
        onTap: _resetToDefaults,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            color: resetHovered
                ? teal
                : (_isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: resetHovered ? teal : _borderColor,
            ),
          ),
          child: Text(
            'Reset to Defaults',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: resetHovered ? Colors.white : _titleColor,
            ),
          ),
        ),
      ),
    );
  }
 
  Widget _buildSaveButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _saveChanges,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            color: teal,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'Save Changes',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
 
  // ---------------- Toast UI ----------------
 
  Widget _buildToastCard(_ToastMsg t, {bool showClose = false, double width = 300}) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(color: teal, shape: BoxShape.circle),
            child: const Icon(Icons.check, size: 13, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              t.text,
              style: TextStyle(fontSize: 13, color: _titleColor, fontWeight: FontWeight.w500),
            ),
          ),
          if (showClose) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => _removeToast(t.id),
              child: Icon(Icons.close, size: 16, color: _labelColor),
            ),
          ],
        ],
      ),
    );
  }
 
  Widget _buildToastStack() {
    if (_toasts.isEmpty) return const SizedBox.shrink();
 
    if (!_toastsExpanded) {
      // Collapsed: show the newest toast on top, with a faint peek of the
      // next one behind it to hint there are more stacked underneath.
      // Show a peek layer for every extra toast behind the front one, each
      // stacked a little further back with less opacity, so it's clear how
      // many messages are piled up underneath — however many there are.
      const double cardWidth = 300;
      final int peekCount = _toasts.length - 1 > 5 ? 5 : _toasts.length - 1;
      // All cards — front and every peek behind it — share the exact same
      // width, so nothing sticks out wider than the front message. Peeks
      // only shift down-left a little to hint depth, they never get wider.
      return GestureDetector(
        onTap: () => setState(() => _toastsExpanded = true),
        child: SizedBox(
          width: cardWidth + (6.0 * peekCount),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (int i = peekCount; i >= 1; i--)
                Positioned(
                  top: 6.0 * i,
                  left: 6.0 * i,
                  child: Opacity(
                    opacity: (0.55 - i * 0.08).clamp(0.12, 0.55),
                    child: _buildToastCard(_toasts[i], width: cardWidth),
                  ),
                ),
              _buildToastCard(_toasts.first, width: cardWidth),
            ],
          ),
        ),
      );
    }
 
    // Expanded: list every active toast with its own close button, plus a
    // "Clear All" action. They still auto-dismiss one by one over time.
    return Container(
      width: 320,
      constraints: const BoxConstraints(maxHeight: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, right: 2),
            child: GestureDetector(
              onTap: _clearAllToasts,
              child: Text(
                'Clear All',
                style: TextStyle(
                  fontSize: 12,
                  color: _labelColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: _toasts.map((t) => _buildToastCard(t, showClose: true)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 
// ---------------- Popup list with smooth scroll + custom scrollbar ----------------
// The scrollbar sits in its own reserved strip on the right so hovering over
// it never triggers the teal hover highlight on the row underneath.
 
class _DropdownList extends StatefulWidget {
  final List<_Option> options;
  final String selectedCode;
  final double itemHeight;
  final Color teal;
  final Color labelColor;
  final ValueChanged<String> onSelect;
 
  const _DropdownList({
    required this.options,
    required this.selectedCode,
    required this.itemHeight,
    required this.teal,
    required this.labelColor,
    required this.onSelect,
  });
 
  @override
  State<_DropdownList> createState() => _DropdownListState();
}
 
class _DropdownListState extends State<_DropdownList> {
  final ScrollController _controller = ScrollController();
  double _thumbTop = 0;
  double _thumbHeight = 0;
  bool _showThumb = false;
 
  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateThumb);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateThumb());
  }
 
  void _updateThumb() {
    if (!_controller.hasClients || !mounted) return;
    final viewport = _controller.position.viewportDimension;
    final maxScroll = _controller.position.maxScrollExtent;
    final totalContent = viewport + maxScroll;
    if (totalContent <= 0 || viewport <= 0) return;
    setState(() {
      _showThumb = maxScroll > 0;
      _thumbHeight = (viewport / totalContent) * viewport;
      final scrollFraction = maxScroll == 0 ? 0.0 : _controller.offset / maxScroll;
      _thumbTop = scrollFraction * (viewport - _thumbHeight);
    });
  }
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          controller: _controller,
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemCount: widget.options.length,
          itemBuilder: (context, index) {
            final opt = widget.options[index];
            return Padding(
              // Reserve space on the right for the scrollbar strip so that
              // strip never overlaps the hoverable row content.
              padding: const EdgeInsets.only(right: 12),
              child: _DropdownItem(
                label: opt.label,
                height: widget.itemHeight,
                selected: opt.code == widget.selectedCode,
                teal: widget.teal,
                labelColor: widget.labelColor,
                onTap: () => widget.onSelect(opt.code),
              ),
            );
          },
        ),
        if (_showThumb)
          Positioned(
            right: 3,
            top: _thumbTop,
            child: Container(
              width: 4,
              height: _thumbHeight,
              decoration: BoxDecoration(
                color: widget.labelColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
      ],
    );
  }
}
 
class _DropdownItem extends StatefulWidget {
  final String label;
  final double height;
  final bool selected;
  final Color teal;
  final Color labelColor;
  final VoidCallback onTap;
 
  const _DropdownItem({
    required this.label,
    required this.height,
    required this.selected,
    required this.teal,
    required this.labelColor,
    required this.onTap,
  });
 
  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}
 
class _DropdownItemState extends State<_DropdownItem> {
  bool _hovered = false;
 
  @override
  Widget build(BuildContext context) {
    final bool active = _hovered;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          color: active ? widget.teal : Colors.transparent,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 13,
                    color: active ? Colors.white : Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.selected)
                Icon(
                  Icons.check,
                  size: 15,
                  color: active ? Colors.white : Colors.black,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
 