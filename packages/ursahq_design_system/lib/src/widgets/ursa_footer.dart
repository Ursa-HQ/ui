/// Generic site footer — a configurable footer column layout.
///
/// Renders a list of [UrsaFooterColumn] entries as a centered wrapped grid,
/// followed by an optional copyright line.
library;

import 'package:flutter/material.dart';

import '../theme/ursa_colors.dart';
import 'ursa_soft_button.dart';

/// A single column in the footer grid.
class UrsaFooterColumn {
  final String heading;
  final List<UrsaSoftButton> buttons;

  const UrsaFooterColumn({
    required this.heading,
    required this.buttons,
  });
}

/// Site footer with configurable column grid and copyright.
///
/// Consumers provide [columns] and an optional [copyright] string.
/// Each column renders a heading followed by [UrsaSoftButton] items.
class UrsaFooter extends StatelessWidget {
  final List<UrsaFooterColumn> columns;
  final String? copyright;

  const UrsaFooter({
    super.key,
    required this.columns,
    this.copyright,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<UrsaColors>()!;
    final narrow = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      color: c.backgroundCanvas,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
      child: Column(
        children: [
          Wrap(
            spacing: narrow ? 16 : 36,
            runSpacing: 32,
            alignment: WrapAlignment.center,
            children: columns.map((col) {
              return _FooterColumn(
                heading: col.heading,
                children: col.buttons,
              );
            }).toList(),
          ),
          if (copyright != null)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                copyright!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: c.textHighContrast.withValues(alpha: 0.8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String heading;
  final List<Widget> children;

  const _FooterColumn({
    required this.heading,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<UrsaColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          heading,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: c.textHighContrast,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}
