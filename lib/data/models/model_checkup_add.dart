

import 'package:json_annotation/json_annotation.dart';

part 'model_checkup_add.g.dart';



@JsonSerializable()
class CheckupAddModel{


  CheckupAddModel(this.message,this.data);
  String message;
  Data data;

  factory CheckupAddModel.fromJson(Map<String,dynamic> json) =>
      _$CheckupAddModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$CheckupAddModelToJson(this);
}

@JsonSerializable(explicitToJson:true)
class Data {
  Data(this.error_code,this.result_msg,this.error_msg,this.result);
  int error_code;
  String? result_msg;
  String? error_msg;
  Result? result;


  factory Data.fromJson(Map<String,dynamic> json) =>
      _$DataFromJson(json);

  
  Map<String,dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable(explicitToJson:true)
class Result {
  Result(this.uuid,this.total_score,this.user_level,this.diagnosis,this.description,this.recommend_act);
  String uuid;
  int total_score;
  String user_level;
  String diagnosis;
  String description;
  List<RecommendAct>? recommend_act;


  factory Result.fromJson(Map<String,dynamic> json) =>
      _$ResultFromJson(json);

  
  Map<String,dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable(explicitToJson:true)
class RecommendAct {
  RecommendAct(this.activity,this.activity_id,this.image_code);
  String activity;
  String  activity_id;
  String image_code;


  factory RecommendAct.fromJson(Map<String,dynamic> json) =>
      _$RecommendActFromJson(json);

  
  Map<String,dynamic> toJson() => _$RecommendActToJson(this);
}
