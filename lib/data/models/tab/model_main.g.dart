// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_main.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainModel _$MainModelFromJson(Map<String, dynamic> json) => MainModel(
      json['message'] as String,
      Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MainModelToJson(MainModel instance) => <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['error_code'] as int,
      json['nick_name'] as String,
      json['quotes'] as String,
      json['step'] as int,
      json['ba_today'] == null
          ? null
          : Batoday.fromJson(json['ba_today'] as Map<String, dynamic>),
      json['image_path'] as String,
      json['ba_today_flag'] as bool,
      json['mood_flag'] as bool,
      json['midterm_flag'] as int,
      json['intake_flag'] as bool,
      json['dmsls_flag'] as bool,
      json['htp_flag'] as bool,
      json['rorschach_flag'] as bool,
      json['dap_flag'] as bool,
      json['sct_flag'] as bool,
      json['mmpi_flag'] as bool,
      json['rqt_flag'] as bool,
      json['parents_flag'] as bool,
      json['kwais_flag'] as bool,
      json['mlst_flag'] as bool,
      json['pat_flag'] as bool,
    )..centerInfo = json['near_center'] == null
        ? null
        : CenterInfo.fromJson(json['near_center'] as Map<String, dynamic>);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'error_code': instance.error_code,
      'nick_name': instance.nick_name,
      'quotes': instance.quotes,
      'step': instance.step,
      'ba_today': instance.ba_today?.toJson(),
      'image_path': instance.image_path,
      'ba_today_flag': instance.ba_today_flag,
      'mood_flag': instance.mood_flag,
      'midterm_flag': instance.midterm_flag,
      'intake_flag': instance.intake_flag,
      'dmsls_flag': instance.dmsls_flag,
      'htp_flag': instance.htp_flag,
      'rorschach_flag': instance.rorschach_flag,
      'dap_flag': instance.dap_flag,
      'sct_flag': instance.sct_flag,
      'mmpi_flag': instance.mmpi_flag,
      'rqt_flag': instance.rqt_flag,
      'parents_flag': instance.parents_flag,
      'kwais_flag': instance.kwais_flag,
      'mlst_flag': instance.mlst_flag,
      'pat_flag': instance.pat_flag,
      'near_center': instance.centerInfo?.toJson(),
    };

Batoday _$BatodayFromJson(Map<String, dynamic> json) => Batoday(
      json['activity_id'] as String,
      json['activity_name'] as String,
      json['activity_info'] as String,
      (json['timetag'] as List<dynamic>).map((e) => e as String).toList(),
      json['correct'] as bool,
    );

Map<String, dynamic> _$BatodayToJson(Batoday instance) => <String, dynamic>{
      'activity_id': instance.activity_id,
      'activity_name': instance.activity_name,
      'activity_info': instance.activity_info,
      'timetag': instance.timetag,
      'correct': instance.correct,
    };

CenterInfo _$CenterInfoFromJson(Map<String, dynamic> json) => CenterInfo(
      json['center_id'] as String,
      json['center_name'] as String,
      CenterImage.fromJson(json['center_image'] as Map<String, dynamic>),
      (json['speciality'] as List<dynamic>).map((e) => e as String).toList(),
      json['latitude'] as String,
      json['longitude'] as String,
      json['location'] as String,
    );

Map<String, dynamic> _$CenterInfoToJson(CenterInfo instance) =>
    <String, dynamic>{
      'center_id': instance.center_id,
      'center_name': instance.center_name,
      'center_image': instance.center_image.toJson(),
      'speciality': instance.speciality,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'location': instance.location,
    };

CenterImage _$CenterImageFromJson(Map<String, dynamic> json) => CenterImage(
      json['main_image_path'] as String?,
      (json['sub_image_path'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CenterImageToJson(CenterImage instance) =>
    <String, dynamic>{
      'main_image_path': instance.main_image_path,
      'sub_image_path': instance.sub_image_path,
    };
