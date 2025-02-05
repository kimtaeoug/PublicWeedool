

import 'package:json_annotation/json_annotation.dart';

part 'model_center_info.g.dart';



@JsonSerializable()
class CenterInfoModel{


  CenterInfoModel(this.result_code,this.result_msg,this.data);
  int result_code;
  String result_msg;
  Data data;

  factory CenterInfoModel.fromJson(Map<String,dynamic> json) =>
      _$CenterInfoModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$CenterInfoModelToJson(this);
}

@JsonSerializable(explicitToJson:true)
class Data {
  Data(this.center_info,this.counselor_info);
  CenterInfo? center_info;
  List<CounselorInfo>? counselor_info;
  

  factory Data.fromJson(Map<String,dynamic> json) =>
      _$DataFromJson(json);

  
  Map<String,dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable(explicitToJson:true)
class CenterInfo {
  CenterInfo(this.center_id,this.center_name,this.center_img,this.latitude,this.longitude,this.center_category,this.center_tel,this.center_profile,this.center_addr);
  String center_id;
  String center_name;
  CenterImg center_img;
  String latitude;
  String longitude;
  List<String>? center_category;
  String center_tel;
  List<CenterProfile>? center_profile;
  String center_addr;

  

  factory CenterInfo.fromJson(Map<String,dynamic> json) =>
      _$CenterInfoFromJson(json);

  
  Map<String,dynamic> toJson() => _$CenterInfoToJson(this);
}

@JsonSerializable(explicitToJson:true)
class CounselorInfo {
  CounselorInfo(this.counselor_id,this.counselor_name,this.counselor_img,this.counselor_position,this.counselor_edu_info);
  String counselor_id;
  String counselor_name;
  String counselor_img;
  String counselor_position;
  List<CounselorEdu>? counselor_edu_info;
  

  factory CounselorInfo.fromJson(Map<String,dynamic> json) =>
      _$CounselorInfoFromJson(json);

  
  Map<String,dynamic> toJson() => _$CounselorInfoToJson(this);
}

@JsonSerializable(explicitToJson:true)
class CenterImg {
  CenterImg(this.main_img_path,this.sub_img_path);
  @JsonKey(name:'Main_Image_Path')
  String? main_img_path;
  @JsonKey(name:'Sub_Image_Path')
  List<String>? sub_img_path;
  

  factory CenterImg.fromJson(Map<String,dynamic> json) =>
      _$CenterImgFromJson(json);

  
  Map<String,dynamic> toJson() => _$CenterImgToJson(this);
}

@JsonSerializable(explicitToJson:true)
class CenterProfile {
  CenterProfile(this.year,this.content);
  @JsonKey(name:'Year')
  int year;
  @JsonKey(name:'Content')
  String content;
  

  factory CenterProfile.fromJson(Map<String,dynamic> json) =>
      _$CenterProfileFromJson(json);

  
  Map<String,dynamic> toJson() => _$CenterProfileToJson(this);
}

@JsonSerializable(explicitToJson:true)
class CounselorEdu {
  CounselorEdu(this.school,this.major);
  @JsonKey(name:'School')
  String school;
  @JsonKey(name:'Major')
  String major;
  

  factory CounselorEdu.fromJson(Map<String,dynamic> json) =>
      _$CounselorEduFromJson(json);

  
  Map<String,dynamic> toJson() => _$CounselorEduToJson(this);
}



