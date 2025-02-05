// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_chart_daily.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartDailyModel _$ChartDailyModelFromJson(Map<String, dynamic> json) =>
    ChartDailyModel(
      json['message'] as String,
      Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChartDailyModelToJson(ChartDailyModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['error_code'] as int,
      json['result_msg'] as String,
      (json['progress'] as num).toDouble(),
      (json['achievement'] as num).toDouble(),
      (json['daily'] as List<dynamic>)
          .map((e) => DataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['weekly'] as List<dynamic>)
          .map((e) => DataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'error_code': instance.error_code,
      'result_msg': instance.result_msg,
      'progress': instance.progress,
      'achievement': instance.achievement,
      'daily': instance.daily.map((e) => e.toJson()).toList(),
      'weekly': instance.weekly.map((e) => e.toJson()).toList(),
    };

DataModel _$DataModelFromJson(Map<String, dynamic> json) => DataModel(
      json['activity_id'] as String,
      json['active_flag'] as bool,
      json['description'] as String,
      json['type'] as String,
      json['activity_name'] as String,
      json['image_code'] as String,
      Count.fromJson(json['count'] as Map<String, dynamic>),
      json['activity_code'] as String,
      (json['tag'] as List<dynamic>).map((e) => e as String).toList(),
      json['time'] as String,
      Amount.fromJson(json['amount'] as Map<String, dynamic>),
      json['category'] as String,
      json['activity_class'] as String,
      json['emotion'] as int?,
      json['end_time'] as String?,
    );

Map<String, dynamic> _$DataModelToJson(DataModel instance) => <String, dynamic>{
      'activity_id': instance.activity_id,
      'active_flag': instance.active_flag,
      'description': instance.description,
      'type': instance.type,
      'activity_name': instance.activity_name,
      'image_code': instance.image_code,
      'count': instance.count.toJson(),
      'activity_code': instance.activity_code,
      'tag': instance.tag,
      'time': instance.time,
      'amount': instance.amount.toJson(),
      'category': instance.category,
      'activity_class': instance.activity_class,
      'emotion': instance.emotion,
      'end_time': instance.end_time,
    };

Count _$CountFromJson(Map<String, dynamic> json) => Count(
      json['value'] as String,
      json['unit'] as String,
    );

Map<String, dynamic> _$CountToJson(Count instance) => <String, dynamic>{
      'value': instance.value,
      'unit': instance.unit,
    };

Amount _$AmountFromJson(Map<String, dynamic> json) => Amount(
      json['value'] as String,
      json['unit'] as String,
    );

Map<String, dynamic> _$AmountToJson(Amount instance) => <String, dynamic>{
      'value': instance.value,
      'unit': instance.unit,
    };
