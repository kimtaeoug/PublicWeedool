import 'package:json_annotation/json_annotation.dart';

part 'model_chart_monthly.g.dart';

@JsonSerializable()
class ChartMonthlyModel {
  ChartMonthlyModel(this.message, this.data);
  String message;
  Data data;

  factory ChartMonthlyModel.fromJson(Map<String, dynamic> json) =>
      _$ChartMonthlyModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChartMonthlyModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Data {
  Data(
      this.error_code,
      this.result_msg,
      this.monthly_mood,
      this.this_month_progress_mean,
      this.last_month_progress_mean,
      this.this_month_data,
      this.this_month_emotion,
      this.last_month_emotion,
      this.all_user_ba_category,
      this.this_month_ba_category,
      this.last_month_ba_category);
  int error_code;
  String result_msg;
  List<MonthlyMoodModel> monthly_mood;
  double this_month_progress_mean;
  double last_month_progress_mean;
  List<MonthDataModel> this_month_data;
  MonthEmotionModel this_month_emotion;
  MonthEmotionModel last_month_emotion;
  CategoryModel all_user_ba_category;
  CategoryModel this_month_ba_category;
  CategoryModel last_month_ba_category;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MonthDataModel {
  MonthDataModel(this.week, this.achievement, this.progress);

  int week;
  double progress;
  double achievement;

  factory MonthDataModel.fromJson(Map<String, dynamic> json) =>
      _$MonthDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$MonthDataModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MonthlyMoodModel {
  MonthlyMoodModel(this.week, this.emotion);
  int week;
  double emotion;

  factory MonthlyMoodModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyMoodModelFromJson(json);

  Map<String, dynamic> toJson() => _$MonthlyMoodModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MonthEmotionModel {
  MonthEmotionModel(this.positive, this.negative, this.same);
  int positive;
  int negative;
  int same;

  factory MonthEmotionModel.fromJson(Map<String, dynamic> json) =>
      _$MonthEmotionModelFromJson(json);

  Map<String, dynamic> toJson() => _$MonthEmotionModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CategoryModel {
  CategoryModel(this.moderation, this.cognition, this.emotion,this.exercise,this.food,this.practice);
  //절제
  int moderation;
  //인지
  int cognition;
  //정서
  int emotion;
  //운동
  int exercise;
  //음식
  int food;
  //실천
  int practice;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
