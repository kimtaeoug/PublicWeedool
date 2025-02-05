
import 'package:json_annotation/json_annotation.dart';

part 'model_chart_daily.g.dart';

@JsonSerializable()
class ChartDailyModel{


  ChartDailyModel(this.message,this.data);
  String message;
  Data data;

  factory ChartDailyModel.fromJson(Map<String,dynamic> json) =>
      _$ChartDailyModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$ChartDailyModelToJson(this);
}

@JsonSerializable(explicitToJson:true)
class Data {
  Data(this.error_code,this.result_msg,this.progress,this.achievement,this.daily,this.weekly);
  int error_code;
  String result_msg;
  double progress;
  double achievement;
  List<DataModel> daily;
  List<DataModel> weekly;


  factory Data.fromJson(Map<String,dynamic> json) =>
      _$DataFromJson(json);

  
  Map<String,dynamic> toJson() => _$DataToJson(this);
}


@JsonSerializable(explicitToJson:true)
class DataModel {
  DataModel(this.activity_id,this.active_flag,this.description,this.type,this.activity_name,this.image_code,
  this.count,this.activity_code,this.tag,this.time,this.amount,this.category,this.activity_class,this.emotion,this.end_time);

  // int week;
  String activity_id;
  bool active_flag;
  String description;
  String type;
  String activity_name;
  String image_code;
  Count count;
  String activity_code;
  List<String> tag;
  String time;
  Amount amount;
  String category;
  String activity_class;
  int? emotion;
  String? end_time;


  factory DataModel.fromJson(Map<String,dynamic> json) =>
      _$DataModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$DataModelToJson(this);
}

@JsonSerializable(explicitToJson:true)
class Count{


  Count(this.value,this.unit);
  String value;
  String unit;

  factory Count.fromJson(Map<String,dynamic> json) =>
      _$CountFromJson(json);

  
  Map<String,dynamic> toJson() => _$CountToJson(this);
}

@JsonSerializable(explicitToJson:true)
class Amount{


  Amount(this.value,this.unit);
  String value;
  String unit;

  factory Amount.fromJson(Map<String,dynamic> json) =>
      _$AmountFromJson(json);

  
  Map<String,dynamic> toJson() => _$AmountToJson(this);
}
