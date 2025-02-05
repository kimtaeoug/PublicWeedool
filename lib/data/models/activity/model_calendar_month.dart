
import 'package:json_annotation/json_annotation.dart';

part 'model_calendar_month.g.dart';

@JsonSerializable()
class MonthCalendarModel{


  MonthCalendarModel(this.message,this.data);
  String message;
  Data data;

  factory MonthCalendarModel.fromJson(Map<String,dynamic> json) =>
      _$MonthCalendarModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$MonthCalendarModelToJson(this);
}


@JsonSerializable(explicitToJson:true)
class Data {
  Data(this.error_code,this.result_msg,this.history);
  int error_code;
  String result_msg;
  List<History> history;


  factory Data.fromJson(Map<String,dynamic> json) =>
      _$DataFromJson(json);

  
  Map<String,dynamic> toJson() => _$DataToJson(this);
}


@JsonSerializable(explicitToJson:true)
class History{
  History(this.date,this.progress);
  String date;
  double progress;

  factory History.fromJson(Map<String,dynamic> json) =>
      _$HistoryFromJson(json);

  
  Map<String,dynamic> toJson() => _$HistoryToJson(this);
}