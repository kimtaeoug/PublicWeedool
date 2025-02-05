
import 'package:json_annotation/json_annotation.dart';

part 'model_chart_weekly.g.dart';

@JsonSerializable()
class ChartWeeklyModel{


  ChartWeeklyModel(this.message,this.data);
  String message;
  Data data;

  factory ChartWeeklyModel.fromJson(Map<String,dynamic> json) =>
      _$ChartWeeklyModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$ChartWeeklyModelToJson(this);
}

@JsonSerializable(explicitToJson:true)
class Data {
  Data(this.error_code,this.result_msg,this.this_week_progrees_mean,this.last_week_progress_mean,this.this_week_data
  ,this.last_week_data,this.this_week_emotion,this.last_week_emotion,this.weekly_mood);
  int error_code;
  String result_msg;
  double this_week_progrees_mean;
  double last_week_progress_mean;
  List<WeekDataModel> this_week_data;
  List<WeekDataModel> last_week_data;
  WeekEmotionModel this_week_emotion;
  WeekEmotionModel last_week_emotion;
  List<WeeklyMoodModel> weekly_mood;


  factory Data.fromJson(Map<String,dynamic> json) =>
      _$DataFromJson(json);

  
  Map<String,dynamic> toJson() => _$DataToJson(this);
}


@JsonSerializable(explicitToJson:true)
class WeekDataModel {
  WeekDataModel(this.date,this.achievement,this.progress);

  String date;
  double achievement;
  double progress;


  factory WeekDataModel.fromJson(Map<String,dynamic> json) =>
      _$WeekDataModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$WeekDataModelToJson(this);
}

@JsonSerializable(explicitToJson:true)
class WeekEmotionModel{


  WeekEmotionModel(this.positive,this.negative,this.same);
  int positive;
  int negative;
  int same;

  factory WeekEmotionModel.fromJson(Map<String,dynamic> json) =>
      _$WeekEmotionModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$WeekEmotionModelToJson(this);
}

@JsonSerializable(explicitToJson:true)
class WeeklyMoodModel{


  WeeklyMoodModel(this.date,this.day,this.emotion);
  String date;
  String day;
  int emotion;

  factory WeeklyMoodModel.fromJson(Map<String,dynamic> json) =>
      _$WeeklyMoodModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$WeeklyMoodModelToJson(this);
}
