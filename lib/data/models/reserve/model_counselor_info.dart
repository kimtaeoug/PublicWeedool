

import 'package:json_annotation/json_annotation.dart';

part 'model_counselor_info.g.dart';



@JsonSerializable()
class CounselorInfoModel{


  CounselorInfoModel(this.result_code,this.result_msg,this.data);
  int result_code;
  String result_msg;
  Data? data;

  factory CounselorInfoModel.fromJson(Map<String,dynamic> json) =>
      _$CounselorInfoModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$CounselorInfoModelToJson(this);
}

@JsonSerializable(explicitToJson:true)
class Data {
  Data(this.counselor_id,this.counselor_name,this.counselor_img,this.counselor_position,this.counselor_edu_info,this.counselor_career,this.counselor_certificate,this.counselor_speciality);
  String counselor_id;
  String counselor_name;
  String counselor_img;
  String counselor_position;
  List<CounselorEdu>? counselor_edu_info;
  List<CounselorCareer>? counselor_career;
  List<CounselorCertificate>? counselor_certificate;
  List<String>? counselor_speciality;

  factory Data.fromJson(Map<String,dynamic> json) =>
      _$DataFromJson(json);

  
  Map<String,dynamic> toJson() => _$DataToJson(this);
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

@JsonSerializable(explicitToJson:true)
class CounselorCareer {
  CounselorCareer(this.year,this.content);
  @JsonKey(name:'Year')
  String? year;
  @JsonKey(name:'Content')
  String? content;
  

  factory CounselorCareer.fromJson(Map<String,dynamic> json) =>
      _$CounselorCareerFromJson(json);

  
  Map<String,dynamic> toJson() => _$CounselorCareerToJson(this);
}

@JsonSerializable(explicitToJson:true)
class CounselorCertificate {
  CounselorCertificate(this.grade,this.institution,this.year,this.name);
  @JsonKey(name:'Grade')
  String grade;
  @JsonKey(name:'Institution')
  String institution;
  @JsonKey(name:'Year')
  int year;
  @JsonKey(name:'Name')
  String name;
  

  factory CounselorCertificate.fromJson(Map<String,dynamic> json) =>
      _$CounselorCertificateFromJson(json);

  
  Map<String,dynamic> toJson() => _$CounselorCertificateToJson(this);
}
