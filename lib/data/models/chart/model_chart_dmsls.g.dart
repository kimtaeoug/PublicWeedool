// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_chart_dmsls.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartDmslsModel _$ChartDmslsModelFromJson(Map<String, dynamic> json) =>
    ChartDmslsModel(
      json['result_code'] as int,
      json['result_msg'] as String,
      (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChartDmslsModelToJson(ChartDmslsModel instance) =>
    <String, dynamic>{
      'result_code': instance.result_code,
      'result_msg': instance.result_msg,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['total_score'] as int,
      json['level'] as String,
      json['timestamp'] as String,
      json['round'] as int,
      json['diagnosis'] as String,
      json['description'] as String,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'total_score': instance.total_score,
      'level': instance.level,
      'timestamp': instance.timestamp,
      'round': instance.round,
      'diagnosis': instance.diagnosis,
      'description': instance.description,
    };
