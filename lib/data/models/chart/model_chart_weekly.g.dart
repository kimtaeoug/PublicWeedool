// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_chart_weekly.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartWeeklyModel _$ChartWeeklyModelFromJson(Map<String, dynamic> json) =>
    ChartWeeklyModel(
      json['message'] as String,
      Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChartWeeklyModelToJson(ChartWeeklyModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['error_code'] as int,
      json['result_msg'] as String,
      (json['this_week_progrees_mean'] as num).toDouble(),
      (json['last_week_progress_mean'] as num).toDouble(),
      (json['this_week_data'] as List<dynamic>)
          .map((e) => WeekDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['last_week_data'] as List<dynamic>)
          .map((e) => WeekDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      WeekEmotionModel.fromJson(
          json['this_week_emotion'] as Map<String, dynamic>),
      WeekEmotionModel.fromJson(
          json['last_week_emotion'] as Map<String, dynamic>),
      (json['weekly_mood'] as List<dynamic>)
          .map((e) => WeeklyMoodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'error_code': instance.error_code,
      'result_msg': instance.result_msg,
      'this_week_progrees_mean': instance.this_week_progrees_mean,
      'last_week_progress_mean': instance.last_week_progress_mean,
      'this_week_data': instance.this_week_data.map((e) => e.toJson()).toList(),
      'last_week_data': instance.last_week_data.map((e) => e.toJson()).toList(),
      'this_week_emotion': instance.this_week_emotion.toJson(),
      'last_week_emotion': instance.last_week_emotion.toJson(),
      'weekly_mood': instance.weekly_mood.map((e) => e.toJson()).toList(),
    };

WeekDataModel _$WeekDataModelFromJson(Map<String, dynamic> json) =>
    WeekDataModel(
      json['date'] as String,
      (json['achievement'] as num).toDouble(),
      (json['progress'] as num).toDouble(),
    );

Map<String, dynamic> _$WeekDataModelToJson(WeekDataModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'achievement': instance.achievement,
      'progress': instance.progress,
    };

WeekEmotionModel _$WeekEmotionModelFromJson(Map<String, dynamic> json) =>
    WeekEmotionModel(
      json['positive'] as int,
      json['negative'] as int,
      json['same'] as int,
    );

Map<String, dynamic> _$WeekEmotionModelToJson(WeekEmotionModel instance) =>
    <String, dynamic>{
      'positive': instance.positive,
      'negative': instance.negative,
      'same': instance.same,
    };

WeeklyMoodModel _$WeeklyMoodModelFromJson(Map<String, dynamic> json) =>
    WeeklyMoodModel(
      json['date'] as String,
      json['day'] as String,
      json['emotion'] as int,
    );

Map<String, dynamic> _$WeeklyMoodModelToJson(WeeklyMoodModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'day': instance.day,
      'emotion': instance.emotion,
    };
