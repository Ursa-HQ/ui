/// Reusable row of CTA buttons.
///
/// Centered, wrapping row of soft-link-button links.
/// External links (http) open in new tab; internal links use onNavigate callback.
library;

import 'package:flutter/material.dart';

import 'ursa_soft_button.dart';

/// One link in a CTA bar.
class UrsaCTALink {
  final String label;
  final String href;

  const UrsaCTALink({required this.label, required this.href});
}

/// Reusable centered row of CTA buttons.
class UrsaCTABar extends StatelessWidget {
  final List<UrsaCTALink> links;
  final ValueChanged<String>? onNavigate;

  const UrsaCTABar({
    super.key,
    required this.links,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: links.map<Widget>((link) {
        return UrsaSoftButton(
          label: link.label,
          onTap: () => onNavigate?.call(link.href),
        );
      }).toList(),
    );
  }
}
