// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_check_ba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaCheckModel _$BaCheckModelFromJson(Map<String, dynamic> json) => BaCheckModel(
      json['message'] as String,
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BaCheckModelToJson(BaCheckModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['error_code'] as int,
      json['result_msg'] as String,
      json['daily_end'] as bool,
      json['weekly_end'] as bool,
      (json['weekly_progress'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'error_code': instance.error_code,
      'result_msg': instance.result_msg,
      'daily_end': instance.daily_end,
      'weekly_end': instance.weekly_end,
      'weekly_progress': instance.weekly_progress,
    };
