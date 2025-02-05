// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_checkup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckupModel _$CheckupModelFromJson(Map<String, dynamic> json) => CheckupModel(
      json['message'] as String,
      Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CheckupModelToJson(CheckupModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['error_code'] as int,
      json['result_msg'] as String,
      json['item_name'] as String,
      (json['questions'] as List<dynamic>).map((e) => e as String).toList(),
      json['mcq_flag'] as bool,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'error_code': instance.error_code,
      'result_msg': instance.result_msg,
      'item_name': instance.item_name,
      'questions': instance.questions,
      'mcq_flag': instance.mcq_flag,
    };
