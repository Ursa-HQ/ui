/// UrsaHQ Health Checker
///
/// Probes each service endpoint to determine live status.
/// All subpaths are same-origin (behind the launcher nginx),
/// so XHR works without CORS issues.
///
/// Uses GET requests with a short timeout for fast checking.
/// Some services don't support HEAD (405 Method Not Allowed),
/// so GET with range 0-0 is used as a lightweight alternative.
library;

import 'dart:async';
import 'dart:html';

import 'package:ursahq_design_system/ursahq_design_system.dart';

/// Probes a single service endpoint and returns its status.
Future<ServiceStatus> probeService(String path) async {
  final completer = Completer<ServiceStatus>();

  try {
    final request = HttpRequest();
    request
      ..open('GET', path, async: true)
      ..timeout = 5000; // milliseconds

    request.onLoad.listen((_) {
      final status = request.status;
      if (status == null) {
        completer.complete(ServiceStatus.down);
      } else if (status >= 200 && status < 500) {
        // 2xx = up, 3xx = redirect (up), 4xx = auth needed (up)
        completer.complete(ServiceStatus.up);
      } else if (status >= 500) {
        completer.complete(ServiceStatus.degraded);
      } else {
        completer.complete(ServiceStatus.down);
      }
    });

    request.onError.listen((_) {
      completer.complete(ServiceStatus.down);
    });

    request.onTimeout.listen((_) {
      completer.complete(ServiceStatus.down);
    });

    request.send();
  } catch (_) {
    completer.complete(ServiceStatus.down);
  }

  return completer.future;
}

/// Runs a full health check across all services.
///
/// Returns a map of path → ServiceStatus with live results.
/// Services that can't be reached are marked [ServiceStatus.down].
Future<Map<String, ServiceStatus>> checkAllServices(
    List<ServiceEntry> services) async {
  final results = <String, ServiceStatus>{};
  final futures = <Future<void>>[];

  for (final service in services) {
    // Root ("Home") — always up
    if (service.path == '/') {
      results[service.path] = ServiceStatus.up;
      continue;
    }
    // Skip external URL services — can't probe them same-origin
    if (service.externalUrl != null) continue;

    futures.add(
      probeService(service.path).then((s) => results[service.path] = s),
    );
  }

  // Wait for all probes with a total timeout
  await Future.wait(futures).timeout(const Duration(seconds: 15));

  return results;
}
