

import 'package:json_annotation/json_annotation.dart';

part 'model_chart_dmsls.g.dart';



@JsonSerializable()
class ChartDmslsModel{


  ChartDmslsModel(this.result_code,this.result_msg,this.data);
  int result_code;
  String result_msg;
  List<Data>? data;

  factory ChartDmslsModel.fromJson(Map<String,dynamic> json) =>
      _$ChartDmslsModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$ChartDmslsModelToJson(this);
}

@JsonSerializable(explicitToJson:true)
class Data {
  Data(this.total_score,this.level,this.timestamp,this.round,this.diagnosis,this.description);
  int total_score;
  String level;
  String timestamp;
  int round;
  String diagnosis;
  String description;

  factory Data.fromJson(Map<String,dynamic> json) =>
      _$DataFromJson(json);

  
  Map<String,dynamic> toJson() => _$DataToJson(this);
}
