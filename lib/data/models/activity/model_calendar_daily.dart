
import 'package:json_annotation/json_annotation.dart';

part 'model_calendar_daily.g.dart';

@JsonSerializable()
class DailyCalendarModel{


  DailyCalendarModel(this.message,this.data);
  String message;
  Data data;

  factory DailyCalendarModel.fromJson(Map<String,dynamic> json) =>
      _$DailyCalendarModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$DailyCalendarModelToJson(this);
}


@JsonSerializable(explicitToJson:true)
class Data {
  Data(this.error_code,this.result_msg,this.progress,this.achievement,this.activity_list);
  int error_code;
  String result_msg;
  double progress;
  double achievement;
  List<Activity> activity_list;


  factory Data.fromJson(Map<String,dynamic> json) =>
      _$DataFromJson(json);

  
  Map<String,dynamic> toJson() => _$DataToJson(this);
}


@JsonSerializable(explicitToJson:true)
class Activity{
  Activity(this.activity,this.activity_class,this.activity_id,this.description,this.amount_description,this.time_tag,this.count,this.category,this.act_done_days,this.state_weekly,this.state_daily);
  String activity;
  String activity_class;
  String activity_id;
  String description;
  String amount_description;
  List<String> time_tag;
  int count;
  String category;
  List<String> act_done_days;
  bool state_weekly;
  bool state_daily;

  factory Activity.fromJson(Map<String,dynamic> json) =>
      _$ActivityFromJson(json);

  
  Map<String,dynamic> toJson() => _$ActivityToJson(this);
}