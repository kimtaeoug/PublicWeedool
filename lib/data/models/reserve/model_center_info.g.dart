// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_center_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CenterInfoModel _$CenterInfoModelFromJson(Map<String, dynamic> json) =>
    CenterInfoModel(
      json['result_code'] as int,
      json['result_msg'] as String,
      Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CenterInfoModelToJson(CenterInfoModel instance) =>
    <String, dynamic>{
      'result_code': instance.result_code,
      'result_msg': instance.result_msg,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['center_info'] == null
          ? null
          : CenterInfo.fromJson(json['center_info'] as Map<String, dynamic>),
      (json['counselor_info'] as List<dynamic>?)
          ?.map((e) => CounselorInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'center_info': instance.center_info?.toJson(),
      'counselor_info':
          instance.counselor_info?.map((e) => e.toJson()).toList(),
    };

CenterInfo _$CenterInfoFromJson(Map<String, dynamic> json) => CenterInfo(
      json['center_id'] as String,
      json['center_name'] as String,
      CenterImg.fromJson(json['center_img'] as Map<String, dynamic>),
      json['latitude'] as String,
      json['longitude'] as String,
      (json['center_category'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      json['center_tel'] as String,
      (json['center_profile'] as List<dynamic>?)
          ?.map((e) => CenterProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['center_addr'] as String,
    );

Map<String, dynamic> _$CenterInfoToJson(CenterInfo instance) =>
    <String, dynamic>{
      'center_id': instance.center_id,
      'center_name': instance.center_name,
      'center_img': instance.center_img.toJson(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'center_category': instance.center_category,
      'center_tel': instance.center_tel,
      'center_profile':
          instance.center_profile?.map((e) => e.toJson()).toList(),
      'center_addr': instance.center_addr,
    };

CounselorInfo _$CounselorInfoFromJson(Map<String, dynamic> json) =>
    CounselorInfo(
      json['counselor_id'] as String,
      json['counselor_name'] as String,
      json['counselor_img'] as String,
      json['counselor_position'] as String,
      (json['counselor_edu_info'] as List<dynamic>?)
          ?.map((e) => CounselorEdu.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CounselorInfoToJson(CounselorInfo instance) =>
    <String, dynamic>{
      'counselor_id': instance.counselor_id,
      'counselor_name': instance.counselor_name,
      'counselor_img': instance.counselor_img,
      'counselor_position': instance.counselor_position,
      'counselor_edu_info':
          instance.counselor_edu_info?.map((e) => e.toJson()).toList(),
    };

CenterImg _$CenterImgFromJson(Map<String, dynamic> json) => CenterImg(
      json['Main_Image_Path'] as String?,
      (json['Sub_Image_Path'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CenterImgToJson(CenterImg instance) => <String, dynamic>{
      'Main_Image_Path': instance.main_img_path,
      'Sub_Image_Path': instance.sub_img_path,
    };

CenterProfile _$CenterProfileFromJson(Map<String, dynamic> json) =>
    CenterProfile(
      json['Year'] as int,
      json['Content'] as String,
    );

Map<String, dynamic> _$CenterProfileToJson(CenterProfile instance) =>
    <String, dynamic>{
      'Year': instance.year,
      'Content': instance.content,
    };

CounselorEdu _$CounselorEduFromJson(Map<String, dynamic> json) => CounselorEdu(
      json['School'] as String,
      json['Major'] as String,
    );

Map<String, dynamic> _$CounselorEduToJson(CounselorEdu instance) =>
    <String, dynamic>{
      'School': instance.school,
      'Major': instance.major,
    };
