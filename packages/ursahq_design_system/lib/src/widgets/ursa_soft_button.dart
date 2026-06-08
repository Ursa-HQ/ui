/// Soft link button with hover animation.
///
/// Mapping of the `soft-link-button` CSS pattern:
/// - default: bg=background-subtle, color=text-accent, border=solid-default
/// - hover: bg=interactive-default, color=text-high-contrast-accent,
///          border=border-hover, translateY(-2px), box-shadow
library;

import 'package:flutter/material.dart';

import '../theme/ursa_colors.dart';

/// Visual variant for [UrsaSoftButton].
enum UrsaSoftButtonVariant { soft, outlined }

/// Animated soft link button with hover lift and theming.
class UrsaSoftButton extends StatefulWidget {
  final String label;
  final Widget? icon;
  final VoidCallback? onTap;
  final UrsaSoftButtonVariant variant;

  const UrsaSoftButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.variant = UrsaSoftButtonVariant.soft,
  });

  @override
  State<UrsaSoftButton> createState() => _UrsaSoftButtonState();
}

class _UrsaSoftButtonState extends State<UrsaSoftButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<UrsaColors>()!;

    final Color bgColor = switch (widget.variant) {
      UrsaSoftButtonVariant.soft =>
        _isHovered ? c.interactiveDefault : c.backgroundSubtle,
      UrsaSoftButtonVariant.outlined =>
        _isHovered ? c.interactiveDefault : Colors.transparent,
    };

    final Color textColor = switch (widget.variant) {
      UrsaSoftButtonVariant.soft || UrsaSoftButtonVariant.outlined =>
        _isHovered ? c.accentContrast : c.accent11,
    };

    final Color borderColor = switch (widget.variant) {
      UrsaSoftButtonVariant.soft || UrsaSoftButtonVariant.outlined =>
        _isHovered ? c.borderHover : c.solidDefault,
    };

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -2.0 : 0.0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: c.shadowSubtle,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: 6),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
