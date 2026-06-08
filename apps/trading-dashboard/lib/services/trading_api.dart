import 'dart:convert';
import 'dart:html' as html;
import 'dart:async';
import '../models/trading_data.dart';

/// HTTP client for the trading engine API, served at /_p/trading/api/*.
///
/// Uses `dart:html` HttpRequest instead of `package:http` because it's
/// same-origin (served from the same domain through the launcher proxy)
/// and HttpRequest gives direct access to XHR for timeout handling.
class TradingApi {
  static const _basePath = '/_p/trading/api';
  static const _timeout = Duration(seconds: 10);

  static Future<StatusResponse> fetchStatus() async {
    final data = await _get('$_basePath/status');
    return StatusResponse.fromJson(data);
  }

  static Future<List<ConfigMetrics>> fetchConfigs() async {
    final data = await _getList('$_basePath/configs');
    return (data)
        .map((c) => ConfigMetrics.fromJson(c as Map<String, dynamic>))
        .toList();
  }

  static Future<MetricsSnapshot> fetchMetrics() async {
    final data = await _get('$_basePath/metrics');
    return MetricsSnapshot.fromJson(data as Map<String, dynamic>);
  }

  /// Fetch all dashboard data in parallel.
  static Future<DashboardData> fetchAll() async {
    final results = await Future.wait([
      fetchStatus(),
      fetchConfigs(),
      fetchMetrics(),
    ]);
    return DashboardData(
      status: results[0] as StatusResponse,
      configs: results[1] as List<ConfigMetrics>,
      metrics: results[2] as MetricsSnapshot,
    );
  }

  /// Fetches a JSON object endpoint (returns Map<String, dynamic>).
  static Future<Map<String, dynamic>> _get(String url) async {
    final data = await _request(url);
    if (data is! Map<String, dynamic>) {
      throw ApiException('Expected JSON object, got ${data.runtimeType}');
    }
    return data;
  }

  /// Fetches a JSON array endpoint (returns List<dynamic>).
  static Future<List<dynamic>> _getList(String url) async {
    final data = await _request(url);
    if (data is! List<dynamic>) {
      throw ApiException('Expected JSON array, got ${data.runtimeType}');
    }
    return data;
  }

  /// Raw HTTP GET with JSON parsing, returns [dynamic].
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

/// Aggregated dashboard data from all endpoints.
class DashboardData {
  final StatusResponse status;
  final List<ConfigMetrics> configs;
  final MetricsSnapshot metrics;

  DashboardData({
    required this.status,
    required this.configs,
    required this.metrics,
  });
}

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
