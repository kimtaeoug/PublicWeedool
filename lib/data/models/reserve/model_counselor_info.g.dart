// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_counselor_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounselorInfoModel _$CounselorInfoModelFromJson(Map<String, dynamic> json) =>
    CounselorInfoModel(
      json['result_code'] as int,
      json['result_msg'] as String,
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CounselorInfoModelToJson(CounselorInfoModel instance) =>
    <String, dynamic>{
      'result_code': instance.result_code,
      'result_msg': instance.result_msg,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['counselor_id'] as String,
      json['counselor_name'] as String,
      json['counselor_img'] as String,
      json['counselor_position'] as String,
      (json['counselor_edu_info'] as List<dynamic>?)
          ?.map((e) => CounselorEdu.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['counselor_career'] as List<dynamic>?)
          ?.map((e) => CounselorCareer.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['counselor_certificate'] as List<dynamic>?)
          ?.map((e) => CounselorCertificate.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['counselor_speciality'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'counselor_id': instance.counselor_id,
      'counselor_name': instance.counselor_name,
      'counselor_img': instance.counselor_img,
      'counselor_position': instance.counselor_position,
      'counselor_edu_info':
          instance.counselor_edu_info?.map((e) => e.toJson()).toList(),
      'counselor_career':
          instance.counselor_career?.map((e) => e.toJson()).toList(),
      'counselor_certificate':
          instance.counselor_certificate?.map((e) => e.toJson()).toList(),
      'counselor_speciality': instance.counselor_speciality,
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

CounselorCareer _$CounselorCareerFromJson(Map<String, dynamic> json) =>
    CounselorCareer(
      json['Year'] as String?,
      json['Content'] as String?,
    );

Map<String, dynamic> _$CounselorCareerToJson(CounselorCareer instance) =>
    <String, dynamic>{
      'Year': instance.year,
      'Content': instance.content,
    };

CounselorCertificate _$CounselorCertificateFromJson(
        Map<String, dynamic> json) =>
    CounselorCertificate(
      json['Grade'] as String,
      json['Institution'] as String,
      json['Year'] as int,
      json['Name'] as String,
    );

Map<String, dynamic> _$CounselorCertificateToJson(
        CounselorCertificate instance) =>
    <String, dynamic>{
      'Grade': instance.grade,
      'Institution': instance.institution,
      'Year': instance.year,
      'Name': instance.name,
    };
