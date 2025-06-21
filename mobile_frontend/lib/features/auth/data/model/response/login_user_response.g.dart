// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginUserResponseImpl _$$LoginUserResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$LoginUserResponseImpl(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? "",
      data: json['data'] == null
          ? null
          : LoginData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LoginUserResponseImplToJson(
        _$LoginUserResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

_$LoginDataImpl _$$LoginDataImplFromJson(Map<String, dynamic> json) =>
    _$LoginDataImpl(
      accessToken: json['accessToken'] as String? ?? "",
      role: json['role'] as String? ?? "",
      name: json['name'] as String? ?? "",
      phone: json['phone'] as String? ?? "",
    );

Map<String, dynamic> _$$LoginDataImplToJson(_$LoginDataImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'role': instance.role,
      'name': instance.name,
      'phone': instance.phone,
    };
