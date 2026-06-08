/// Skip-to-main-content link for keyboard accessibility.
///
/// Hidden by default, visible on focus. Focus moves it into view
/// with solid background.
library;

import 'package:flutter/material.dart';

import '../theme/ursa_colors.dart';

/// Skip-to-main-content accessibility widget.
///
/// Renders a hidden link that becomes visible when focused via Tab key.
/// Focuses the main content area on activation.
class UrsaSkipToMainContent extends StatefulWidget {
  const UrsaSkipToMainContent({super.key});

  @override
  State<UrsaSkipToMainContent> createState() => _UrsaSkipToMainContentState();
}

class _UrsaSkipToMainContentState extends State<UrsaSkipToMainContent> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<UrsaColors>()!;

    return Semantics(
      label: 'Skip to main content',
      child: Focus(
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: Container(
          padding: _isFocused
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
              : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: _isFocused ? c.solidDefault : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Skip to main content',
            style: TextStyle(
              fontSize: 14,
              color: _isFocused ? c.accentContrast : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
