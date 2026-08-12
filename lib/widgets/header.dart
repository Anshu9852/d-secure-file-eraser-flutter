import 'package:flutter/material.dart';
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
          _buildHeaderIcon(0, Icons.info_outline, "Info", iconColor),
          _buildHeaderIcon(1, Icons.tune, "Settings", iconColor),
          _buildHeaderIcon(2, Icons.file_download_outlined, "Download", iconColor),
          _buildHeaderIcon(3, Icons.vpn_key_outlined, "Activation", iconColor),
          _buildHeaderIcon(4, Icons.menu_book_outlined, "Documentation", iconColor),
 
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
    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => hoveredIconIndex = index),
        onExit: (_) => setState(() => hoveredIconIndex = null),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isHovered ? AppColors.primaryTeal : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: isHovered ? Colors.white : defaultColor),
          ),
        ),
      ),
    );
  }
 
  // --- Dialog Logic ---
  void _showPurchaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: 440,
            // Yahan padding vertical badha di hai taaki popup ki height aur spacing badh jaye
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(child: Text('Purchase D-Secure', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
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
            color: hovered ? const Color(0xFF4DB6AC) : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: hovered ? const Color(0xFF26A69A) : borderColor,
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
  const _PurchaseVisitStoreButton({required this.onTap});
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
          child: const Text(
            'Visit Store',
            style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
 