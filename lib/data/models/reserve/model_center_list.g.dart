// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_center_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CenterListModel _$CenterListModelFromJson(Map<String, dynamic> json) =>
    CenterListModel(
      json['result_code'] as int,
      json['result_msg'] as String,
      (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CenterListModelToJson(CenterListModel instance) =>
    <String, dynamic>{
      'result_code': instance.result_code,
      'result_msg': instance.result_msg,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['center_id'] as String,
      json['center_name'] as String,
      CenterImg.fromJson(json['center_img'] as Map<String, dynamic>),
      json['location'] as String,
      json['latitude'] as String,
      json['longitude'] as String,
      (json['category'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'center_id': instance.center_id,
      'center_name': instance.center_name,
      'center_img': instance.center_img.toJson(),
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'category': instance.category,
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
