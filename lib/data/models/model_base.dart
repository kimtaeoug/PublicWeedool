

import 'package:json_annotation/json_annotation.dart';

part 'model_base.g.dart';



@JsonSerializable()
class BaseModel{


  BaseModel(this.message,this.data);
  String message;
  Data? data;

  factory BaseModel.fromJson(Map<String,dynamic> json) =>
      _$BaseModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$BaseModelToJson(this);
}

@JsonSerializable(explicitToJson:true)
class Data {
  Data(this.error_code,this.result_msg,this.uuid);
  int error_code;
  String? result_msg;
  String? uuid;
  

  factory Data.fromJson(Map<String,dynamic> json) =>
      _$DataFromJson(json);

  
  Map<String,dynamic> toJson() => _$DataToJson(this);
}
