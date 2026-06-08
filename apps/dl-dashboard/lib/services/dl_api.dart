import 'dart:convert';
import 'dart:html' as html;
import 'dart:async';
import '../models/dl_data.dart';

/// HTTP client for the dukascopy-dl API, served at /_p/dl/api/*.
///
/// Uses `dart:html` HttpRequest for same-origin requests through the launcher proxy.
class DlApi {
  static const _basePath = '/_p/dl/api';
  static const _timeout = Duration(seconds: 10);

  /// Fetch current download status.
  static Future<DlStatus> fetchStatus() async {
    final data = await _get('$_basePath/dl/status');
    return DlStatus.fromJson(data);
  }

  /// Fetch verification report for a specific pair.
  static Future<VerifyReport> fetchVerify(String pair) async {
    final data = await _get('$_basePath/dl/verify/$pair');
    return VerifyReport.fromJson(data);
  }

  /// Raw HTTP GET with JSON parsing, returns [Map<String, dynamic>].
  static Future<Map<String, dynamic>> _get(String url) async {
    final data = await _request(url);
    if (data is! Map<String, dynamic>) {
      throw ApiException('Expected JSON object, got ${data.runtimeType}');
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

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
