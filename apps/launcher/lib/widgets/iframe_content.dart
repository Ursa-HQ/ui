/// UrsaHQ Iframe Content Widget
///
/// Renders a third-party service inside an iframe using Flutter web's
/// [HtmlElementView]. A single iframe element is reused across all
/// service navigations — only the `src` attribute is updated.
///
/// This keeps the UrsaHQ shell (sidebar + chrome) persistently visible
/// around the embedded service.
library;

import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:ursahq_design_system/ursahq_design_system.dart';

/// The single view type identifier for our shared iframe.
const _iframeViewType = 'ursahq-service-iframe';

/// Shared iframe element reused across all service navigations.
html.IFrameElement? _iframeElement;

/// Whether [_iframeElement] has been registered with the platform view system.
bool _iframeRegistered = false;

/// URL to set on the iframe once the element is created.
String? _pendingIframeUrl;

/// Callback fired when the iframe loads (used to clear the loading overlay).
void Function()? _onIframeLoad;

/// Callback fired when the iframe errors.
void Function()? _onIframeError;

/// Registers the shared iframe element with Flutter's platform view system.
///
/// Must be called once before [IframeContent] is first built.
void _ensureIframeRegistered() {
  if (_iframeRegistered) return;
  ui.platformViewRegistry.registerViewFactory(_iframeViewType, (int viewId) {
    _iframeElement = html.IFrameElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.border = 'none'
      ..allow = 'fullscreen *'
      ..setAttribute('allowfullscreen', 'true');
    // Apply any pending URL immediately
    if (_pendingIframeUrl != null) {
      _iframeElement!.src = _pendingIframeUrl!;
      _pendingIframeUrl = null;
    }
    // Attach load/error listeners
    _iframeElement!.onLoad.listen((_) => _onIframeLoad?.call());
    _iframeElement!.onError.listen((_) => _onIframeError?.call());
    return _iframeElement!;
  });
  _iframeRegistered = true;
}

/// A widget that displays a service in an iframe.
///
/// The [url] is loaded into a shared iframe element. When the URL changes,
/// the `src` attribute is updated without recreating the DOM element.
class IframeContent extends StatefulWidget {
  /// The URL to load in the iframe.
  final String url;

  /// Optional label for error/loading states.
  final String? label;

  const IframeContent({
    super.key,
    required this.url,
    this.label,
  });

  @override
  State<IframeContent> createState() => _IframeContentState();
}

class _IframeContentState extends State<IframeContent> {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _ensureIframeRegistered();
    _loadUrl(widget.url);
  }

  @override
  void didUpdateWidget(IframeContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _loadUrl(widget.url);
    }
  }

  void _loadUrl(String url) {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    // Set callbacks BEFORE setting src so we never miss the load event
    _onIframeLoad = () {
      if (mounted) setState(() => _isLoading = false);
    };
    _onIframeError = () {
      if (mounted) setState(() => _hasError = true);
    };

    // Store as pending in case element doesn't exist yet
    _pendingIframeUrl = url;

    // If element already exists, set src now
    if (_iframeElement != null) {
      _iframeElement!.src = url;
    }
    // Otherwise the factory callback will pick up _pendingIframeUrl
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<UrsaColors>()!;
    final label = widget.label ?? 'Service';

    if (_hasError) {
      return _ErrorState(c: c, label: label);
    }

    return Stack(
      children: [
        // The iframe
        Positioned.fill(
          child: HtmlElementView(viewType: _iframeViewType),
        ),
        // Loading overlay
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: c.backgroundCanvas,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: c.accent9,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Loading $label…',
                      style: UrsaTypography.bodyMedium?.copyWith(
                        color: c.textLowContrast,
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
}

class _ErrorState extends StatelessWidget {
  final UrsaColors c;
  final String label;

  const _ErrorState({required this.c, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: c.backgroundCanvas,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 48,
              color: c.textLowContrast,
            ),
            const SizedBox(height: 12),
            Text(
              'Failed to load $label',
              style: UrsaTypography.bodyLarge?.copyWith(
                color: c.textHighContrast,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Service may be offline or blocking framing.',
              style: UrsaTypography.bodySmall?.copyWith(
                color: c.textLowContrast,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
