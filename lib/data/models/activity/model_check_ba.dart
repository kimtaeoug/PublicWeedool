

import 'package:json_annotation/json_annotation.dart';

part 'model_check_ba.g.dart';



@JsonSerializable()
class BaCheckModel{


  BaCheckModel(this.message,this.data);
  String message;
  Data? data;

  factory BaCheckModel.fromJson(Map<String,dynamic> json) =>
      _$BaCheckModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$BaCheckModelToJson(this);
}

@JsonSerializable(explicitToJson:true)
class Data {
  Data(this.error_code,this.result_msg,this.daily_end,this.weekly_end,this.weekly_progress);
  int error_code;
  String result_msg;
  bool daily_end;
  bool weekly_end;
  List<String> weekly_progress;

  factory Data.fromJson(Map<String,dynamic> json) =>
      _$DataFromJson(json);

  
  Map<String,dynamic> toJson() => _$DataToJson(this);
}
