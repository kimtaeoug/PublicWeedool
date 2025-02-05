// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_chart_monthly.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartMonthlyModel _$ChartMonthlyModelFromJson(Map<String, dynamic> json) =>
    ChartMonthlyModel(
      json['message'] as String,
      Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChartMonthlyModelToJson(ChartMonthlyModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['error_code'] as int,
      json['result_msg'] as String,
      (json['monthly_mood'] as List<dynamic>)
          .map((e) => MonthlyMoodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['this_month_progress_mean'] as num).toDouble(),
      (json['last_month_progress_mean'] as num).toDouble(),
      (json['this_month_data'] as List<dynamic>)
          .map((e) => MonthDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      MonthEmotionModel.fromJson(
          json['this_month_emotion'] as Map<String, dynamic>),
      MonthEmotionModel.fromJson(
          json['last_month_emotion'] as Map<String, dynamic>),
      CategoryModel.fromJson(
          json['all_user_ba_category'] as Map<String, dynamic>),
      CategoryModel.fromJson(
          json['this_month_ba_category'] as Map<String, dynamic>),
      CategoryModel.fromJson(
          json['last_month_ba_category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'error_code': instance.error_code,
      'result_msg': instance.result_msg,
      'monthly_mood': instance.monthly_mood.map((e) => e.toJson()).toList(),
      'this_month_progress_mean': instance.this_month_progress_mean,
      'last_month_progress_mean': instance.last_month_progress_mean,
      'this_month_data':
          instance.this_month_data.map((e) => e.toJson()).toList(),
      'this_month_emotion': instance.this_month_emotion.toJson(),
      'last_month_emotion': instance.last_month_emotion.toJson(),
      'all_user_ba_category': instance.all_user_ba_category.toJson(),
      'this_month_ba_category': instance.this_month_ba_category.toJson(),
      'last_month_ba_category': instance.last_month_ba_category.toJson(),
    };

MonthDataModel _$MonthDataModelFromJson(Map<String, dynamic> json) =>
    MonthDataModel(
      json['week'] as int,
      (json['achievement'] as num).toDouble(),
      (json['progress'] as num).toDouble(),
    );

Map<String, dynamic> _$MonthDataModelToJson(MonthDataModel instance) =>
    <String, dynamic>{
      'week': instance.week,
      'progress': instance.progress,
      'achievement': instance.achievement,
    };

MonthlyMoodModel _$MonthlyMoodModelFromJson(Map<String, dynamic> json) =>
    MonthlyMoodModel(
      json['week'] as int,
      (json['emotion'] as num).toDouble(),
    );

Map<String, dynamic> _$MonthlyMoodModelToJson(MonthlyMoodModel instance) =>
    <String, dynamic>{
      'week': instance.week,
      'emotion': instance.emotion,
    };

MonthEmotionModel _$MonthEmotionModelFromJson(Map<String, dynamic> json) =>
    MonthEmotionModel(
      json['positive'] as int,
      json['negative'] as int,
      json['same'] as int,
    );

Map<String, dynamic> _$MonthEmotionModelToJson(MonthEmotionModel instance) =>
    <String, dynamic>{
      'positive': instance.positive,
      'negative': instance.negative,
      'same': instance.same,
    };

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      json['moderation'] as int,
      json['cognition'] as int,
      json['emotion'] as int,
      json['exercise'] as int,
      json['food'] as int,
      json['practice'] as int,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'moderation': instance.moderation,
      'cognition': instance.cognition,
      'emotion': instance.emotion,
      'exercise': instance.exercise,
      'food': instance.food,
      'practice': instance.practice,
    };
