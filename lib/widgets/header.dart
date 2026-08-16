import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/theme.dart';
 
class Header extends StatefulWidget {
  final bool isDark;
  const Header({super.key, required this.isDark});
 
  @override
  State<Header> createState() => _HeaderState();
}
 
class _HeaderState extends State<Header> {
  int? hoveredIconIndex;
 
  @override
  Widget build(BuildContext context) {
    Color textColor = widget.isDark ? AppColors.darkText : AppColors.lightText;
    Color iconColor = widget.isDark ? AppColors.darkGreyText : AppColors.lightGreyText;
 
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkCard : AppColors.lightCard,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFD5D5D5), // grey line, matches sidebar divider
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: AppColors.primaryTeal, size: 24),
          const SizedBox(width: 8),
          Text(
            'D-Secure File Eraser',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(width: 20),
 
          // Icons
          _buildHeaderIcon(0, Icons.info_outline, "About", iconColor, onTap: () => _showInfoDialog(context)),
          _buildHeaderIcon(1, Icons.tune, "Support", iconColor, onTap: () => _showSupportDialog(context)),
          _buildHeaderIcon(2, Icons.file_download_outlined, "Check for Updates", iconColor, onTap: () => _showSoftwareUpdateDialog(context)),
          _buildHeaderIcon(3, Icons.vpn_key_outlined, "Activation", iconColor, onTap: () => _showActivationDialog(context)),
          _buildHeaderIcon(4, Icons.menu_book_outlined, "Help Manual", iconColor, onTap: () => _showHelpManualDialog(context)),
 
          const Spacer(),
 
          // Purchase Icon
          _buildHeaderIcon(
            5,
            Icons.shopping_cart_outlined,
            "Purchase",
            iconColor,
            onTap: () => _showPurchaseDialog(context),
          ),
        ],
      ),
    );
  }
 
  Widget _buildHeaderIcon(int index, IconData icon, String tooltip, Color defaultColor, {VoidCallback? onTap}) {
    bool isHovered = hoveredIconIndex == index;
 
    Widget iconWidget = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hoveredIconIndex = index),
      onExit: (_) => setState(() => hoveredIconIndex = null),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(right: 6),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isHovered ? AppColors.primaryTeal : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: isHovered ? Colors.white : defaultColor),
        ),
      ),
    );
 
    // First icon (Info) no longer shows a tooltip/name.
    if (tooltip.isEmpty) {
      return iconWidget;
    }
 
    return Tooltip(
      message: tooltip,
      child: iconWidget,
    );
  }
 
  // --- Info Dialog ---
  void _showInfoDialog(BuildContext context) {
    Color textColor = widget.isDark ? AppColors.darkText : AppColors.lightText;
    Color subTextColor = widget.isDark ? AppColors.darkGreyText : AppColors.lightGreyText;
    Color popupBg = widget.isDark ? AppColors.darkBg : AppColors.lightBg;
 
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return Dialog(
          backgroundColor: popupBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: 460,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.shield_outlined, color: AppColors.primaryTeal, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'D-Secure File Eraser',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                      ),
                    ),
                    _DialogCloseIcon(onTap: () => Navigator.pop(dialogCtx)),
                  ],
                ),
                const SizedBox(height: 18),
                Text('Version', style: TextStyle(fontSize: 12, color: subTextColor)),
                const SizedBox(height: 3),
                Text('Edition Version 1.1 File Eraser', style: TextStyle(fontSize: 14, color: textColor)),
                const SizedBox(height: 14),
                Text('Build', style: TextStyle(fontSize: 12, color: subTextColor)),
                const SizedBox(height: 3),
                Text('1.1.2026.08.16', style: TextStyle(fontSize: 14, color: textColor)),
                const SizedBox(height: 16),
                Divider(color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder),
                const SizedBox(height: 14),
                Text('System Information', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor)),
                const SizedBox(height: 8),
                _infoRow('Processor', 'Intel Core i9-13900K @ 3.0GHz', subTextColor, textColor),
                _infoRow('Memory', '32 GB', subTextColor, textColor),
                _infoRow('OS Version', 'Windows 11 Pro (Web Demo)', subTextColor, textColor),
                _infoRow('Manufacturer', 'D-Secure Technologies', subTextColor, textColor),
                _infoRow('Model', 'Custom Sandbox Workstation', subTextColor, textColor),
                const SizedBox(height: 14),
                Center(
                  child: Text(
                    'Copyright © 2026 DSecure Technologies Pvt. Ltd. All rights reserved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: subTextColor),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _TealCloseButton(isDark: widget.isDark, onTap: () => Navigator.pop(dialogCtx)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
 
  Widget _infoRow(String label, String value, Color labelColor, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: labelColor)),
          Text(value, style: TextStyle(fontSize: 12, color: valueColor)),
        ],
      ),
    );
  }
 
  // --- Support Dialog ---
  void _showSupportDialog(BuildContext context) {
    Color subTextColor = widget.isDark ? AppColors.darkGreyText : AppColors.lightGreyText;
    Color textColor = widget.isDark ? AppColors.darkText : AppColors.lightText;
    Color cardBg = widget.isDark ? AppColors.darkBg : AppColors.lightBg;
    Color borderColor = widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;
 
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return Dialog(
          backgroundColor: cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: 460,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Support & Documentation',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                      ),
                    ),
                    _DialogCloseIcon(onTap: () => Navigator.pop(dialogCtx)),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Get help and access resources', style: TextStyle(fontSize: 12, color: subTextColor)),
                const SizedBox(height: 20),
                _SupportOptionBox(
                  title: 'Knowledge Base',
                  subtitle: 'Browse articles and guides',
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  onTap: () => _launchExternalUrl('https://dsecuretech.com/support/knowledge-base'),
                ),
                const SizedBox(height: 10),
                _SupportOptionBox(
                  title: 'Contact Support',
                  subtitle: 'Email: support@dsecuretech.com',
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  onTap: () => _launchExternalUrl('mailto:support@dsecuretech.com'),
                ),
                const SizedBox(height: 10),
                _SupportOptionBox(
                  title: 'Community Forum',
                  subtitle: 'Connect with other users',
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _TealCloseButton(isDark: widget.isDark, onTap: () => Navigator.pop(dialogCtx)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
 
  // --- Software Update Dialog ---
  void _showSoftwareUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return _SoftwareUpdateDialog(isDark: widget.isDark);
      },
    );
  }
 
  // --- Help Manual Dialog ---
  void _showHelpManualDialog(BuildContext context) {
    Color subTextColor = widget.isDark ? AppColors.darkGreyText : AppColors.lightGreyText;
    Color popupBg = widget.isDark ? AppColors.darkBg : AppColors.lightBg;
 
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return Dialog(
          backgroundColor: popupBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: 440,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        'Help Manual',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    _DialogCloseIcon(onTap: () => Navigator.pop(dialogCtx)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'This will open the user manual in your default browser',
                  style: TextStyle(fontSize: 12, color: subTextColor),
                ),
                const SizedBox(height: 28),
                Center(child: Icon(Icons.open_in_new, size: 40, color: subTextColor)),
                const SizedBox(height: 28),
                Center(
                  child: Text(
                    'The complete user manual contains detailed instructions for all features',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, height: 1.4, color: subTextColor),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _ActivationCancelButton(isDark: widget.isDark, onTap: () => Navigator.pop(dialogCtx)),
                    const SizedBox(width: 12),
                    _PurchaseVisitStoreButton(
                      label: 'Open Manual',
                      onTap: () {
                        Navigator.pop(dialogCtx);
                        _launchHelpManual();
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
 
  Future<void> _launchExternalUrl(String urlOrMailto) async {
    final uri = Uri.parse(urlOrMailto);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, webOnlyWindowName: '_blank');
    }
  }
 
  Future<void> _launchHelpManual() async {
    final uri = Uri.parse('https://dsecuretech.com/help-manual');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, webOnlyWindowName: '_blank');
    }
  }
 
  // --- Activation Dialog ---
  void _showActivationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return _ActivationDialog(isDark: widget.isDark, hostContext: context);
      },
    );
  }
 
  // --- Purchase Dialog ---
  void _showPurchaseDialog(BuildContext context) {
    Color popupBg = widget.isDark ? AppColors.darkBg : AppColors.lightBg;
 
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return Dialog(
          backgroundColor: popupBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: 440,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Purchase D-Secure',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                    ),
                    _DialogCloseIcon(onTap: () => Navigator.pop(dialogCtx)),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Upgrade or purchase additional licenses', style: TextStyle(fontSize: 12, color: widget.isDark ? AppColors.darkGreyText : AppColors.lightGreyText)),
                const SizedBox(height: 24),
                Center(child: Icon(Icons.shopping_cart_outlined, size: 48, color: widget.isDark ? AppColors.darkText : AppColors.lightText)),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Visit our store to purchase a license for the Professional or Enterprise edition.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, height: 1.4, color: widget.isDark ? AppColors.darkGreyText : AppColors.lightGreyText),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _PurchaseCancelButton(isDark: widget.isDark, onTap: () => Navigator.pop(dialogCtx)),
                    const SizedBox(width: 12),
                    _PurchaseVisitStoreButton(onTap: () { Navigator.pop(dialogCtx); _launchStoreWebsite(); }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
 
  Future<void> _launchStoreWebsite() async {
    final uri = Uri.parse('https://dsecuretech.com/pricing-and-plan?product=file-eraser');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, webOnlyWindowName: '_blank');
    }
  }
}
 
// --- Helper Classes ---
class _DialogCloseIcon extends StatefulWidget {
  final VoidCallback onTap;
  const _DialogCloseIcon({required this.onTap});
  @override
  State<_DialogCloseIcon> createState() => _DialogCloseIconState();
}
 
class _DialogCloseIconState extends State<_DialogCloseIcon> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: hovered ? Colors.black12 : Colors.transparent, shape: BoxShape.circle),
          child: const Icon(Icons.close, size: 18),
        ),
      ),
    );
  }
}
 
class _PurchaseCancelButton extends StatefulWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _PurchaseCancelButton({required this.isDark, required this.onTap});
  @override
  State<_PurchaseCancelButton> createState() => _PurchaseCancelButtonState();
}
 
class _PurchaseCancelButtonState extends State<_PurchaseCancelButton> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    Color textColor = widget.isDark ? AppColors.darkText : AppColors.lightText;
    Color greyBg = widget.isDark ? AppColors.darkBg : AppColors.lightBg;
    Color borderColor = widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;
 
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: hovered ? AppColors.primaryTeal : greyBg,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: hovered ? AppColors.primaryTeal : borderColor,
              width: 1.0,
            ),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: hovered ? Colors.white : textColor,
            ),
          ),
        ),
      ),
    );
  }
}
 
class _PurchaseVisitStoreButton extends StatefulWidget {
  final VoidCallback onTap;
  final String label;
  const _PurchaseVisitStoreButton({required this.onTap, this.label = 'Visit Store'});
  @override
  State<_PurchaseVisitStoreButton> createState() => _PurchaseVisitStoreButtonState();
}
 
class _PurchaseVisitStoreButtonState extends State<_PurchaseVisitStoreButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: hovered ? const Color(0xFF0B7A70) : AppColors.primaryTeal,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
 
// --- Support box (Knowledge Base / Contact Support / Community Forum) ---
class _SupportOptionBox extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final Color subTextColor;
  final VoidCallback? onTap;
  const _SupportOptionBox({
    required this.title,
    required this.subtitle,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.subTextColor,
    this.onTap,
  });
 
  @override
  State<_SupportOptionBox> createState() => _SupportOptionBoxState();
}
 
class _SupportOptionBoxState extends State<_SupportOptionBox> {
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
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: widget.cardBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hovered ? AppColors.primaryTeal : widget.borderColor,
              width: hovered ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: widget.textColor)),
              const SizedBox(height: 3),
              Text(widget.subtitle, style: TextStyle(fontSize: 11, color: widget.subTextColor)),
            ],
          ),
        ),
      ),
    );
  }
}
 
// --- Grey "Close" button that turns teal on hover (used in Info & Support dialogs) ---
class _TealCloseButton extends StatefulWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _TealCloseButton({required this.isDark, required this.onTap});
  @override
  State<_TealCloseButton> createState() => _TealCloseButtonState();
}
 
class _TealCloseButtonState extends State<_TealCloseButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: hovered ? const Color(0xFF0B7A70) : AppColors.primaryTeal,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Close',
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
}
 
// --- White "Close" button that turns teal on hover (used in Software Update dialog) ---
class _WhiteCloseButton extends StatefulWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _WhiteCloseButton({required this.isDark, required this.onTap});
  @override
  State<_WhiteCloseButton> createState() => _WhiteCloseButtonState();
}
 
class _WhiteCloseButtonState extends State<_WhiteCloseButton> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    Color textColor = widget.isDark ? AppColors.darkText : AppColors.lightText;
    Color greyBg = widget.isDark ? AppColors.darkBg : AppColors.lightBg;
    Color borderColor = widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;
 
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: hovered ? AppColors.primaryTeal : greyBg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: hovered ? AppColors.primaryTeal : borderColor, width: 1.0),
          ),
          child: Text(
            'Close',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: hovered ? Colors.white : textColor,
            ),
          ),
        ),
      ),
    );
  }
}
 
// --- Teal action button (Check for Updates / Restart to Install) ---
class _TealActionButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _TealActionButton({required this.label, required this.onTap});
  @override
  State<_TealActionButton> createState() => _TealActionButtonState();
}
 
class _TealActionButtonState extends State<_TealActionButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          decoration: BoxDecoration(
            color: hovered ? const Color(0xFF0B7A70) : AppColors.primaryTeal,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
 
// --- Full width teal button with icon (Download Update) ---
class _TealFullWidthButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool disabled;
  const _TealFullWidthButton({required this.icon, required this.label, required this.onTap, this.disabled = false});
  @override
  State<_TealFullWidthButton> createState() => _TealFullWidthButtonState();
}
 
class _TealFullWidthButtonState extends State<_TealFullWidthButton> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    Color baseColor = widget.disabled
        ? AppColors.primaryTeal.withOpacity(0.4)
        : (hovered ? const Color(0xFF0B7A70) : AppColors.primaryTeal);
 
    return MouseRegion(
      cursor: widget.disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.disabled ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              Text(widget.label, style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
 
// --- Software Update dialog with staged flow ---
// Stages: initial -> checking -> available -> downloading -> complete
enum _UpdateStage { initial, checking, available, downloading, complete }
 
class _SoftwareUpdateDialog extends StatefulWidget {
  final bool isDark;
  const _SoftwareUpdateDialog({required this.isDark});
 
  @override
  State<_SoftwareUpdateDialog> createState() => _SoftwareUpdateDialogState();
}
 
class _SoftwareUpdateDialogState extends State<_SoftwareUpdateDialog> {
  _UpdateStage stage = _UpdateStage.initial;
  double downloadProgress = 0.0;
  Timer? _progressTimer;
 
  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }
 
  void _checkForUpdates() {
    setState(() => stage = _UpdateStage.checking);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => stage = _UpdateStage.available);
    });
  }
 
  void _downloadUpdate() {
    setState(() {
      stage = _UpdateStage.downloading;
      downloadProgress = 0.0;
    });
    _progressTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (!mounted) return;
      setState(() {
        downloadProgress += 0.08;
        if (downloadProgress >= 1.0) {
          downloadProgress = 1.0;
          timer.cancel();
          stage = _UpdateStage.complete;
        }
      });
    });
  }
 
  @override
  Widget build(BuildContext context) {
    Color textColor = widget.isDark ? AppColors.darkText : AppColors.lightText;
    Color subTextColor = widget.isDark ? AppColors.darkGreyText : AppColors.lightGreyText;
    Color popupBg = widget.isDark ? AppColors.darkBg : AppColors.lightBg;
 
    return Dialog(
      backgroundColor: popupBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 460,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text('Software Update', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                ),
                _DialogCloseIcon(onTap: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 10),
            Text('Check for the latest version', style: TextStyle(fontSize: 12, color: subTextColor)),
            const SizedBox(height: 28),
            _buildStageContent(textColor, subTextColor),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _WhiteCloseButton(isDark: widget.isDark, onTap: () => Navigator.pop(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildStageContent(Color textColor, Color subTextColor) {
    switch (stage) {
      case _UpdateStage.initial:
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.file_download_outlined, size: 40, color: Colors.grey),
              const SizedBox(height: 12),
              Text('Current version: 4.2.1', style: TextStyle(fontSize: 12, color: subTextColor)),
              const SizedBox(height: 16),
              _TealActionButton(label: 'Check for Updates', onTap: _checkForUpdates),
            ],
          ),
        );
 
      case _UpdateStage.checking:
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Icon(Icons.file_download_outlined, size: 40, color: AppColors.primaryTeal),
              const SizedBox(height: 16),
              Text('Checking for updates...', style: TextStyle(fontSize: 13, color: subTextColor)),
              const SizedBox(height: 16),
            ],
          ),
        );
 
      case _UpdateStage.available:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F4F3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primaryTeal.withOpacity(0.4)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_outline, color: AppColors.primaryTeal, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Update Available', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor)),
                        const SizedBox(height: 2),
                        Text('Version 4.3.0 is now available', style: TextStyle(fontSize: 12, color: subTextColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text("What's New:", style: TextStyle(fontSize: 13, color: textColor)),
            const SizedBox(height: 8),
            Text('• Improved erasure performance', style: TextStyle(fontSize: 12, color: subTextColor)),
            const SizedBox(height: 4),
            Text('• Enhanced cloud integration', style: TextStyle(fontSize: 12, color: subTextColor)),
            const SizedBox(height: 4),
            Text('• Bug fixes and stability improvements', style: TextStyle(fontSize: 12, color: subTextColor)),
            const SizedBox(height: 16),
            _TealFullWidthButton(icon: Icons.file_download_outlined, label: 'Download Update', onTap: _downloadUpdate),
          ],
        );
 
      case _UpdateStage.downloading:
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Downloading update...', style: TextStyle(fontSize: 13, color: textColor)),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: downloadProgress,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE0E0E0),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryTeal),
                ),
              ),
              const SizedBox(height: 8),
              Text('update.status.download_progress', style: TextStyle(fontSize: 11, color: subTextColor)),
            ],
          ),
        );
 
      case _UpdateStage.complete:
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Downloading update...', style: TextStyle(fontSize: 13, color: textColor)),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 1.0,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE0E0E0),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryTeal),
                ),
              ),
              const SizedBox(height: 8),
              Text('update.status.download_progress', style: TextStyle(fontSize: 11, color: subTextColor)),
              const SizedBox(height: 16),
              Icon(Icons.check_circle_outline, size: 40, color: AppColors.primaryTeal),
              const SizedBox(height: 12),
              Text('Download Complete', style: TextStyle(fontSize: 13, color: textColor)),
              const SizedBox(height: 16),
              _TealActionButton(label: 'Restart to Install', onTap: () => Navigator.pop(context)),
            ],
          ),
        );
    }
  }
}
 
// ============================================================
// --- Product Activation Dialog (Cloud Login / Product Key / Offline) ---
// ============================================================
enum _ActivationTab { cloud, key, offline }
 
class _ActivationDialog extends StatefulWidget {
  final bool isDark;
  final BuildContext hostContext;
  const _ActivationDialog({required this.isDark, required this.hostContext});
 
  @override
  State<_ActivationDialog> createState() => _ActivationDialogState();
}
 
class _ActivationDialogState extends State<_ActivationDialog> {
  _ActivationTab selectedTab = _ActivationTab.cloud;
 
  // Cloud Login state
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  bool cloudActivating = false;
  String? cloudMessage; // null | 'error' | 'success'
 
  // Product Key state
  final TextEditingController productKeyCtrl = TextEditingController();
  bool keyActivating = false;
  String? keyMessage; // null | 'error' | 'success'
 
  // Offline state
  final TextEditingController offlineCodeCtrl = TextEditingController();
  final String machineCode = 'DSEC-OFFLINE-SANDBOX-2026';
  bool offlineActivated = false;
 
  @override
  void initState() {
    super.initState();
    offlineCodeCtrl.addListener(() => setState(() {}));
  }
 
  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    productKeyCtrl.dispose();
    offlineCodeCtrl.dispose();
    super.dispose();
  }
 
  void _onSignInActivate() {
    if (emailCtrl.text.trim().isEmpty || passwordCtrl.text.trim().isEmpty) {
      setState(() => cloudMessage = 'error');
      return;
    }
    setState(() {
      cloudMessage = null;
      cloudActivating = true;
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        cloudActivating = false;
        cloudMessage = 'success';
      });
    });
  }
 
  void _onActivateProductKey() {
    if (productKeyCtrl.text.trim().isEmpty) {
      setState(() => keyMessage = 'error');
      return;
    }
    setState(() {
      keyMessage = null;
      keyActivating = true;
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        keyActivating = false;
        keyMessage = 'success';
      });
    });
  }
 
  void _onCopyMachineCode() {
    Clipboard.setData(ClipboardData(text: machineCode));
    ScaffoldMessenger.of(widget.hostContext).hideCurrentSnackBar();
    ScaffoldMessenger.of(widget.hostContext).showSnackBar(
      SnackBar(
        content: const Text(
          'Machine code copied',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(seconds: 2),
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    Color textColor = widget.isDark ? AppColors.darkText : AppColors.lightText;
    Color subTextColor = widget.isDark ? AppColors.darkGreyText : AppColors.lightGreyText;
    Color popupBg = widget.isDark ? AppColors.darkBg : AppColors.lightBg;
 
    return Dialog(
      backgroundColor: popupBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 460,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text(
                    'Product Activation',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                _DialogCloseIcon(onTap: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 4),
            Text('Activate your D-Secure license', style: TextStyle(fontSize: 12, color: subTextColor)),
            const SizedBox(height: 16),
            _ActivationTabBar(
              labels: const ['Cloud Login', 'Product Key', 'Offline'],
              selectedIndex: selectedTab.index,
              isDark: widget.isDark,
              onSelect: (i) => setState(() => selectedTab = _ActivationTab.values[i]),
            ),
            const SizedBox(height: 18),
            if (selectedTab == _ActivationTab.cloud) _buildCloudLoginTab(textColor, subTextColor),
            if (selectedTab == _ActivationTab.key) _buildProductKeyTab(textColor, subTextColor),
            if (selectedTab == _ActivationTab.offline) _buildOfflineTab(textColor, subTextColor),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _ActivationCancelButton(isDark: widget.isDark, onTap: () => Navigator.pop(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildCloudLoginTab(Color textColor, Color subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email Address', style: TextStyle(fontSize: 12, color: textColor)),
        const SizedBox(height: 6),
        _ActivationTextField(
          controller: emailCtrl,
          hint: 'your.email@company.com',
          isDark: widget.isDark,
        ),
        const SizedBox(height: 14),
        Text('Password', style: TextStyle(fontSize: 12, color: textColor)),
        const SizedBox(height: 6),
        _ActivationTextField(
          controller: passwordCtrl,
          hint: '••••••••',
          obscureText: true,
          isDark: widget.isDark,
        ),
        if (cloudMessage != null) ...[
          const SizedBox(height: 14),
          _activationMessageBox(
            isError: cloudMessage == 'error',
            text: cloudMessage == 'error' ? 'Please fill in all fields' : 'Activation Successful! Expiry: null',
          ),
        ],
        const SizedBox(height: 16),
        _TealFullWidthTextButton(
          label: cloudActivating ? 'Activating...' : 'Sign In & Activate',
          onTap: cloudActivating ? () {} : _onSignInActivate,
        ),
      ],
    );
  }
 
  Widget _buildProductKeyTab(Color textColor, Color subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Key', style: TextStyle(fontSize: 12, color: textColor)),
        const SizedBox(height: 6),
        _ActivationTextField(
          controller: productKeyCtrl,
          hint: 'XXXX-XXXX-XXXX-XXXX-XXXX',
          isDark: widget.isDark,
        ),
        const SizedBox(height: 6),
        Text(
          'Enter your 25-character product key found in your purchase confirmation email',
          style: TextStyle(fontSize: 11, color: subTextColor),
        ),
        if (keyMessage != null) ...[
          const SizedBox(height: 14),
          _activationMessageBox(
            isError: keyMessage == 'error',
            text: keyMessage == 'error' ? 'Please enter a product key' : 'Product Activated! Expiry: null',
          ),
        ],
        const SizedBox(height: 16),
        _TealFullWidthButton(
          icon: Icons.vpn_key_outlined,
          label: keyActivating ? 'Activating...' : 'Activate',
          onTap: keyActivating ? () {} : _onActivateProductKey,
        ),
        const SizedBox(height: 10),
        Center(
          child: GestureDetector(
            onTap: () {},
            child: const Text(
              "Don't have a key? Get it Now →",
              style: TextStyle(fontSize: 12, color: AppColors.primaryTeal, decoration: TextDecoration.underline),
            ),
          ),
        ),
      ],
    );
  }
 
  Widget _buildOfflineTab(Color textColor, Color subTextColor) {
    Color borderColor = widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;
    bool offlineFilled = offlineCodeCtrl.text.trim().isNotEmpty;
 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 1: Machine Code', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black)),
        const SizedBox(height: 4),
        Text(
          'Generate and send this code to D-Secure Support to receive your activation key',
          style: TextStyle(fontSize: 11, color: subTextColor),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Expanded(child: Text(machineCode, style: const TextStyle(fontSize: 13, color: Colors.black))),
              GestureDetector(
                onTap: _onCopyMachineCode,
                child: const Text(
                  'Copy',
                  style: TextStyle(fontSize: 13, color: AppColors.primaryTeal, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text('Contact: support@dsecuretech.com', style: TextStyle(fontSize: 11, color: subTextColor)),
        const SizedBox(height: 14),
        Text('Step 2: Enter Activation Code', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black)),
        const SizedBox(height: 4),
        Text(
          'Paste the activation code received from D-Secure Support',
          style: TextStyle(fontSize: 11, color: subTextColor),
        ),
        const SizedBox(height: 8),
        _ActivationTextField(
          controller: offlineCodeCtrl,
          hint: 'Paste activation code here...',
          isDark: widget.isDark,
          minLines: 5,
          maxLines: 6,
        ),
        if (offlineActivated) ...[
          const SizedBox(height: 14),
          _activationMessageBox(isError: false, text: 'Activation successful!'),
        ],
        const SizedBox(height: 16),
        _TealFullWidthButton(
          icon: Icons.vpn_key_outlined,
          label: 'Activate Offline',
          onTap: offlineFilled ? () => setState(() => offlineActivated = true) : () {},
          disabled: !offlineFilled,
        ),
      ],
    );
  }
 
  Widget _activationMessageBox({required bool isError, required String text}) {
    Color bg = isError ? const Color(0xFFFDECEC) : const Color(0xFFE6F4F3);
    Color border = isError ? const Color(0xFFF1B4B4) : AppColors.primaryTeal.withOpacity(0.4);
    Color fg = isError ? const Color(0xFFD9534F) : AppColors.primaryTeal;
    IconData icon = isError ? Icons.info_outline : Icons.check_circle_outline;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6), border: Border.all(color: border)),
      child: Row(
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 12, color: fg))),
        ],
      ),
    );
  }
}
 
// --- Segmented tab bar (Cloud Login / Product Key / Offline) ---
class _ActivationTabBar extends StatefulWidget {
  final List<String> labels;
  final int selectedIndex;
  final bool isDark;
  final ValueChanged<int> onSelect;
  const _ActivationTabBar({
    required this.labels,
    required this.selectedIndex,
    required this.isDark,
    required this.onSelect,
  });
 
  @override
  State<_ActivationTabBar> createState() => _ActivationTabBarState();
}
 
class _ActivationTabBarState extends State<_ActivationTabBar> {
  int? hoveredIndex;
 
  @override
  Widget build(BuildContext context) {
    Color trackBg = widget.isDark ? AppColors.darkBg : AppColors.lightBg;
    Color selectedTextColor = widget.isDark ? AppColors.darkText : AppColors.lightText;
    Color unselectedTextColor = widget.isDark ? AppColors.darkGreyText : AppColors.lightGreyText;
    Color hoverBg = widget.isDark ? Colors.white24 : const Color(0xFFDADADA);
 
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: trackBg, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.labels.length, (i) {
          bool selected = widget.selectedIndex == i;
          bool hovered = hoveredIndex == i;
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => hoveredIndex = i),
            onExit: (_) => setState(() => hoveredIndex = null),
            child: GestureDetector(
              onTap: () => widget.onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : (hovered ? hoverBg : Colors.transparent),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.labels[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected ? selectedTextColor : unselectedTextColor,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
 
// --- Text field used across the Activation dialog (email / password / product key / offline code) ---
class _ActivationTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final bool isDark;
  final int minLines;
  final int maxLines;
  final bool flat; // when true, renders without its own border/background (used inside an outer bordered box)
  const _ActivationTextField({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    required this.isDark,
    this.minLines = 1,
    this.maxLines = 1,
    this.flat = false,
  });
 
  @override
  State<_ActivationTextField> createState() => _ActivationTextFieldState();
}
 
class _ActivationTextFieldState extends State<_ActivationTextField> {
  bool focused = false;
 
  @override
  Widget build(BuildContext context) {
    Color textColor = widget.isDark ? AppColors.darkText : AppColors.lightText;
    Color borderColor = widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;
    Color hintColor = widget.isDark ? AppColors.darkGreyText : AppColors.lightGreyText;
    Color focusBg = const Color(0xFFE6F4F3);
 
    Widget field = TextField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      cursorColor: AppColors.primaryTeal,
      style: TextStyle(fontSize: 13, color: textColor),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(fontSize: 13, color: hintColor),
        border: InputBorder.none,
        isDense: true,
        contentPadding: widget.flat
            ? const EdgeInsets.symmetric(horizontal: 6, vertical: 6)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
 
    return Focus(
      onFocusChange: (f) => setState(() => focused = f),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: widget.flat
            ? BoxDecoration(
                color: focused ? focusBg : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              )
            : BoxDecoration(
                color: focused ? focusBg : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: focused ? AppColors.primaryTeal : borderColor, width: focused ? 1.4 : 1.0),
              ),
        child: field,
      ),
    );
  }
}
 
// --- Full width teal button with NO icon (Sign In & Activate) ---
class _TealFullWidthTextButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _TealFullWidthTextButton({required this.label, required this.onTap});
  @override
  State<_TealFullWidthTextButton> createState() => _TealFullWidthTextButtonState();
}
 
class _TealFullWidthTextButtonState extends State<_TealFullWidthTextButton> {
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
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: hovered ? const Color(0xFF0B7A70) : AppColors.primaryTeal,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
 
// --- Grey "Cancel" button that turns teal on hover (used in Activation dialog) ---
class _ActivationCancelButton extends StatefulWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _ActivationCancelButton({required this.isDark, required this.onTap});
  @override
  State<_ActivationCancelButton> createState() => _ActivationCancelButtonState();
}
 
class _ActivationCancelButtonState extends State<_ActivationCancelButton> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    Color textColor = widget.isDark ? AppColors.darkText : AppColors.lightText;
    Color greyBg = widget.isDark ? AppColors.darkBg : AppColors.lightBg;
    Color borderColor = widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;
 
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: hovered ? AppColors.primaryTeal : greyBg,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: hovered ? AppColors.primaryTeal : borderColor, width: 1.0),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: hovered ? Colors.white : textColor,
            ),
          ),
        ),
      ),
    );
  }
}
 