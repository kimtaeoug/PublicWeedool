import 'package:json_annotation/json_annotation.dart';
part 'model_activity_add.g.dart';
@JsonSerializable()
class ActivityAddModel {
  final String message;
  final Data data;

  ActivityAddModel(this.message, this.data);

  factory ActivityAddModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityAddModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityAddModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Data {
  int error_code;
  String result_msg;
  List<AddActivity> items;

  Data(this.error_code, this.result_msg, this.items);

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AddActivity {
  final String description;
  final String category;
  final List<String> time_tag;
  final Amount amount;
  final String time;
  final Count count;
  final String image_code;
  final String activity_name;
  final String type;
  final String activitiy_id;
  final String dailyWeeklyClass;
  final String activity_code;
  final List<String> tag;

  AddActivity(
      this.description,
      this.category,
      this.time_tag,
      this.amount,
      this.time,
      this.count,
      this.image_code,
      this.activity_name,
      this.type,
      this.activitiy_id,
      this.dailyWeeklyClass,
      this.activity_code,
      this.tag);

  factory AddActivity.fromJson(Map<String, dynamic> json) =>
      _$AddActivityFromJson(json);

  Map<String, dynamic> toJson() => _$AddActivityToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Amount {
  final String value;
  final String unit;

  Amount(this.value, this.unit);

  factory Amount.fromJson(Map<String, dynamic> json) => _$AmountFromJson(json);

  Map<String, dynamic> toJson() => _$AmountToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Count {
  final String value;
  final String unit;

  Count(this.value, this.unit);

  factory Count.fromJson(Map<String, dynamic> json) => _$CountFromJson(json);

  Map<String, dynamic> toJson() => _$CountToJson(this);
}
