// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_activity_add.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityAddModel _$ActivityAddModelFromJson(Map<String, dynamic> json) =>
    ActivityAddModel(
      json['message'] as String,
      Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActivityAddModelToJson(ActivityAddModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['error_code'] as int,
      json['result_msg'] as String,
      (json['items'] as List<dynamic>)
          .map((e) => AddActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'error_code': instance.error_code,
      'result_msg': instance.result_msg,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

AddActivity _$AddActivityFromJson(Map<String, dynamic> json) => AddActivity(
      json['description'] as String,
      json['category'] as String,
      (json['time_tag'] as List<dynamic>).map((e) => e as String).toList(),
      Amount.fromJson(json['amount'] as Map<String, dynamic>),
      json['time'] as String,
      Count.fromJson(json['count'] as Map<String, dynamic>),
      json['image_code'] as String,
      json['activity_name'] as String,
      json['type'] as String,
      json['activity_id'] as String,
      json['class'] as String,
      json['activity_code'] as String,
      (json['tag'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AddActivityToJson(AddActivity instance) =>
    <String, dynamic>{
      'description': instance.description,
      'category': instance.category,
      'time_tag': instance.time_tag,
      'amount': instance.amount.toJson(),
      'time': instance.time,
      'count': instance.count.toJson(),
      'image_code': instance.image_code,
      'activity_name': instance.activity_name,
      'type': instance.type,
      'activity_id': instance.activitiy_id,
      'class': instance.dailyWeeklyClass,
      'activity_code': instance.activity_code,
      'tag': instance.tag,
    };

Amount _$AmountFromJson(Map<String, dynamic> json) => Amount(
      json['value'] as String,
      json['unit'] as String,
    );

Map<String, dynamic> _$AmountToJson(Amount instance) => <String, dynamic>{
      'value': instance.value,
      'unit': instance.unit,
    };

Count _$CountFromJson(Map<String, dynamic> json) => Count(
      json['value'] as String,
      json['unit'] as String,
    );

Map<String, dynamic> _$CountToJson(Count instance) => <String, dynamic>{
      'value': instance.value,
      'unit': instance.unit,
    };
