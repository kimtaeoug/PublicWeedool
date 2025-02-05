// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_login_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResModel _$LoginResModelFromJson(Map<String, dynamic> json) =>
    LoginResModel(
      json['message'] as String,
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResModelToJson(LoginResModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['error_code'] as int,
      json['result_msg'] as String,
      json['uuid'] as String?,
      json['nick_name'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'error_code': instance.error_code,
      'result_msg': instance.result_msg,
      'uuid': instance.uuid,
      'nick_name': instance.nick_name,
    };
