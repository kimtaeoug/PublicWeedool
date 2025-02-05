// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_calendar_month.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthCalendarModel _$MonthCalendarModelFromJson(Map<String, dynamic> json) =>
    MonthCalendarModel(
      json['message'] as String,
      Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MonthCalendarModelToJson(MonthCalendarModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['error_code'] as int,
      json['result_msg'] as String,
      (json['history'] as List<dynamic>)
          .map((e) => History.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'error_code': instance.error_code,
      'result_msg': instance.result_msg,
      'history': instance.history.map((e) => e.toJson()).toList(),
    };

History _$HistoryFromJson(Map<String, dynamic> json) => History(
      json['date'] as String,
      (json['progress'] as num).toDouble(),
    );

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
      'date': instance.date,
      'progress': instance.progress,
    };
