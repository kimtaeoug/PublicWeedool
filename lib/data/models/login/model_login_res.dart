

import 'package:json_annotation/json_annotation.dart';

part 'model_login_res.g.dart';



@JsonSerializable()
class LoginResModel{


  LoginResModel(this.message,this.data);
  String message;
  Data? data;

  factory LoginResModel.fromJson(Map<String,dynamic> json) =>
      _$LoginResModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$LoginResModelToJson(this);
}

@JsonSerializable(explicitToJson:true)
class Data {
  Data(this.error_code,this.result_msg,this.uuid,this.nick_name);
  int error_code;
  String result_msg;
  String? uuid;
  String? nick_name;

  factory Data.fromJson(Map<String,dynamic> json) =>
      _$DataFromJson(json);

  
  Map<String,dynamic> toJson() => _$DataToJson(this);
}
