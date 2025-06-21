import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_model.freezed.dart';

part 'error_model.g.dart';

@freezed
class ErrorModel with _$ErrorModel {
  const factory ErrorModel(
      {@Default("") String message,
      @Default("") String error,
      @Default(400) int statusCode}) = _ErrorModel;

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorModelFromJson(json);

  factory ErrorModel.fromBackendError(dynamic error) {
    if (error is Map<String, dynamic>) {
      return ErrorModel.fromJson(error);
    } else if (error is String) {
      return ErrorModel(message: error);
    } else {
      return const ErrorModel(message: "Xatolik yuz berdi");
    }
  }
}
