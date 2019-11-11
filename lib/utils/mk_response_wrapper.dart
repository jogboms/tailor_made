import 'dart:convert' show json;

import 'package:http/http.dart' as http;
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/utils/mk_settings.dart';

typedef TransformFunction<T> = T Function(dynamic data, String message);

class ForbiddenException implements Exception {
  ForbiddenException([this.message]);

  final String message;

  @override
  String toString() => this.message;
}

class NotAuthorisedException implements Exception {
  NotAuthorisedException([this.message]);

  final String message;

  @override
  String toString() => this.message;
}

class MkResponseException implements Exception {
  MkResponseException([this.message]);

  final String message;

  @override
  String toString() => this.message;
}

class MkResponseWrapper<T> {
  MkResponseWrapper(
    this._response, {
    TransformFunction<T> onTransform,
  }) {
    try {
      final dynamic responseJson = json.decode(_response.body);
      message = responseJson != null && responseJson["message"] != null
          ? responseJson["message"]
          : MkSettings.isDev ? _response.reasonPhrase : MkStrings.errorMessage;
      rawData = _response.statusCode < 300 ? responseJson["data"] : null;
    } catch (e) {
      message = _response.statusCode == 502 && !MkSettings.isDev ? MkStrings.errorMessage : e.toString();
      rawData = null;
    }

    if (onTransform != null) {
      data = onTransform(rawData, message);
    }
  }

  final http.Response _response;
  String message;
  dynamic rawData;
  T data;

  int get statusCode => _response.statusCode;

  String get reasonPhrase => _response.reasonPhrase;

  bool get isOk {
    if (statusCode >= 200 && statusCode < 300) {
      return true;
    } else if (statusCode >= 400 && statusCode < 500) {
      return false;
    } else if (statusCode >= 500) {
      return false;
    }
    return false;
  }

  bool get isNotOk => !isOk;

  bool get isBadRequest => statusCode == 400;

  bool get isNotFound => statusCode == 404;

  bool get isNotAcceptable => statusCode == 406;

  bool get isNotAuthorized => statusCode == 401;

  bool get isForbidden => statusCode == 403;

  bool get isTooLarge => statusCode == 413;
}
