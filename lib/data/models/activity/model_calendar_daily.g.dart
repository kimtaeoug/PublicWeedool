// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_calendar_daily.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyCalendarModel _$DailyCalendarModelFromJson(Map<String, dynamic> json) =>
    DailyCalendarModel(
      json['message'] as String,
      Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DailyCalendarModelToJson(DailyCalendarModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['error_code'] as int,
      json['result_msg'] as String,
      (json['progress'] as num).toDouble(),
      (json['achievement'] as num).toDouble(),
      (json['activity_list'] as List<dynamic>)
          .map((e) => Activity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'error_code': instance.error_code,
      'result_msg': instance.result_msg,
      'progress': instance.progress,
      'achievement': instance.achievement,
      'activity_list': instance.activity_list.map((e) => e.toJson()).toList(),
    };

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      json['activity'] as String,
      json['activity_class'] as String,
      json['activity_id'] as String,
      json['description'] as String,
      json['amount_description'] as String,
      (json['time_tag'] as List<dynamic>).map((e) => e as String).toList(),
      json['count'] as int,
      json['category'] as String,
      (json['act_done_days'] as List<dynamic>).map((e) => e as String).toList(),
      json['state_weekly'] as bool,
      json['state_daily'] as bool,
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'activity': instance.activity,
      'activity_class': instance.activity_class,
      'activity_id': instance.activity_id,
      'description': instance.description,
      'amount_description': instance.amount_description,
      'time_tag': instance.time_tag,
      'count': instance.count,
      'category': instance.category,
      'act_done_days': instance.act_done_days,
      'state_weekly': instance.state_weekly,
      'state_daily': instance.state_daily,
    };
