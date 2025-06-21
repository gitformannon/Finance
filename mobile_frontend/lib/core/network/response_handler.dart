import 'package:dio/dio.dart';

import 'server_error.dart';

class ResponseHandler<T> {
  ServerError? _error;
  T? _data;

  setException(ServerError error) {
    _error = error;
  }

  set data(T? data) {
    if (data is DioException) throw data;
    this._data = data;
    if (data is String) {
      if (data.isEmpty) {
        _data = null;
      }
    }
  }

  T? get data => _data;

  ServerError? getException() => _error;
}
