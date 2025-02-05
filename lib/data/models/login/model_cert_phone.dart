

import 'package:json_annotation/json_annotation.dart';

part 'model_cert_phone.g.dart';



@JsonSerializable()
class CertPhoneModel{


  CertPhoneModel(this.msg,this.errorCode);
  String msg;
  String errorCode;

  factory CertPhoneModel.fromJson(Map<String,dynamic> json) =>
      _$CertPhoneModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$CertPhoneModelToJson(this);
}
