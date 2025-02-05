// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_checkup_add.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckupAddModel _$CheckupAddModelFromJson(Map<String, dynamic> json) =>
    CheckupAddModel(
      json['message'] as String,
      Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CheckupAddModelToJson(CheckupAddModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['error_code'] as int,
      json['result_msg'] as String?,
      json['error_msg'] as String?,
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'error_code': instance.error_code,
      'result_msg': instance.result_msg,
      'error_msg': instance.error_msg,
      'result': instance.result?.toJson(),
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      json['uuid'] as String,
      json['total_score'] as int,
      json['user_level'] as String,
      json['diagnosis'] as String,
      json['description'] as String,
      (json['recommend_act'] as List<dynamic>?)
          ?.map((e) => RecommendAct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'total_score': instance.total_score,
      'user_level': instance.user_level,
      'diagnosis': instance.diagnosis,
      'description': instance.description,
      'recommend_act': instance.recommend_act?.map((e) => e.toJson()).toList(),
    };

RecommendAct _$RecommendActFromJson(Map<String, dynamic> json) => RecommendAct(
      json['activity'] as String,
      json['activity_id'] as String,
      json['image_code'] as String,
    );

Map<String, dynamic> _$RecommendActToJson(RecommendAct instance) =>
    <String, dynamic>{
      'activity': instance.activity,
      'activity_id': instance.activity_id,
      'image_code': instance.image_code,
    };
