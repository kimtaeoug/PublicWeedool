

import 'package:json_annotation/json_annotation.dart';

part 'model_checkup.g.dart';



@JsonSerializable()
class CheckupModel{


  CheckupModel(this.message,this.data);
  String message;
  Data data;

  factory CheckupModel.fromJson(Map<String,dynamic> json) =>
      _$CheckupModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$CheckupModelToJson(this);
}

@JsonSerializable(explicitToJson:true)
class Data {
  Data(this.error_code,this.result_msg,this.item_name,this.questions,this.mcq_flag);
  int error_code;
  String result_msg;
  String item_name;
  List<String> questions;
  bool mcq_flag;


  factory Data.fromJson(Map<String,dynamic> json) =>
      _$DataFromJson(json);

  
  Map<String,dynamic> toJson() => _$DataToJson(this);
}
