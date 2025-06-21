
import 'package:dio/dio.dart' hide Headers;
import 'package:easy_localization/easy_localization.dart';

import '../constants/app_routes.dart';
import '../constants/locale_keys.dart';
import '../di/get_it.dart';
import '../helpers/logger_helpers.dart';
import '../navigation/navigation_service.dart';
import '../storage/local_data_source.dart';

class ServerError implements Exception {
  int? _errorCode;
  dynamic _errorMessage;

  ServerError.withError({DioException? error}) {
    _handleError(error);
  }

  int getErrorCode() => _errorCode ?? 502;

  dynamic getErrorMessage() => _errorMessage;

  _handleError(DioException? error) async {
    _errorCode = error?.response?.statusCode ?? 502;
    AppLoggerUtils.w("error type --${error!.type}");
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        _errorMessage = LocaleKeys.noConnection.tr();
        break;
      case DioExceptionType.sendTimeout:
        _errorMessage = LocaleKeys.serverError.tr();
        break;
      case DioExceptionType.receiveTimeout:
        _errorMessage = LocaleKeys.serverError.tr();
        break;
      case DioExceptionType.cancel:
        _errorMessage = LocaleKeys.canceledRequest.tr();
        break;
      case DioExceptionType.unknown:
        {
          _errorMessage = LocaleKeys.somethingWrong.tr();
        }
        break;
      case DioExceptionType.badCertificate:
        // TODO: Handle this case.
        break;
      case DioExceptionType.badResponse:
        {
          _errorMessage = error.response?.data ?? "";
          if (error.response!.statusCode == 401) {
            getItInstance<NavigationService>().navigateTo(AppRoutes.login);
            getItInstance<LocalDataSource>().setUserToken("");
          }
        }
        break;
      case DioExceptionType.connectionError:
        _errorMessage = LocaleKeys.noConnection.tr();
        break;
    }

    return _errorMessage;
  }
}
