/// HTTP client for the sweep pairs API.
///
/// Uses `dart:html` HttpRequest (same pattern as trading API) since the
/// sweep dashboard is served same-origin through the launcher proxy.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import '../models/sweep_data.dart';

class SweepApi {
  static const _basePath = '/_p/sweep/api/sweep';
  static const _timeout = Duration(seconds: 10);

  /// Fetch current sweep status.
  static Future<SweepStatus> fetchStatus() async {
    final data = await _get('$_basePath/status');
    return SweepStatus.fromJson(data);
  }

  /// Fetch list of completed signal labels.
  static Future<List<String>> fetchSignals() async {
    final data = await _getList('$_basePath/signals');
    return data.cast<String>();
  }

  /// Fetch aggregate stats for a completed signal.
  static Future<SignalAggregateStats> fetchSignalResult(String label) async {
    final data = await _get('$_basePath/results/$label');
    return SignalAggregateStats.fromJson(label, data);
  }

  /// Fetch all dashboard data.
  static Future<SweepDashboardData> fetchAll() async {
    try {
      final status = await fetchStatus();
      final signals = await fetchSignals();

      // Load results for up to 6 most recent signals
      final recentLabels =
          signals.length > 6 ? signals.sublist(signals.length - 6) : signals;
      final results = <SignalAggregateStats>[];
      for (final label in recentLabels) {
        try {
          results.add(await fetchSignalResult(label));
        } catch (_) {
          // Ignore individual signal fetch errors
        }
      }

      return SweepDashboardData(
        status: status,
        signals: signals,
        completedResults: results,
      );
    } catch (e) {
      return SweepDashboardData();
    }
  }

  /// Fetch a JSON object endpoint.
  static Future<Map<String, dynamic>> _get(String url) async {
    final data = await _request(url);
    if (data is! Map<String, dynamic>) {
      throw ApiException('Expected JSON object, got ${data.runtimeType}');
    }
    return data;
  }

  /// Fetch a JSON array endpoint.
  static Future<List<dynamic>> _getList(String url) async {
    final data = await _request(url);
    if (data is! List<dynamic>) {
      throw ApiException('Expected JSON array, got ${data.runtimeType}');
    }
    return data;
  }

  /// Raw HTTP GET with JSON parsing.
  static Future<dynamic> _request(String url) async {
    final completer = Completer<dynamic>();
    final request = html.HttpRequest();

    request
      ..open('GET', url, async: true)
      ..timeout = _timeout.inMilliseconds;

    request.onLoad.listen((_) {
      if (request.status == null || request.status! >= 400) {
        completer.completeError(
          ApiException('HTTP ${request.status}: ${request.statusText}'),
        );
        return;
      }
      try {
        final parsed = json.decode(request.responseText ?? 'null');
        if (parsed == null) {
          completer.completeError(const ApiException('Empty response'));
          return;
        }
        completer.complete(parsed);
      } catch (e) {
        completer.completeError(ApiException('JSON parse error: $e'));
      }
    });

    request.onError
        .listen((_) => completer.completeError(const ApiException('Network error')));
    request.onTimeout
        .listen((_) => completer.completeError(const ApiException('Request timeout')));

    request.send();
    return completer.future;
  }
}

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
