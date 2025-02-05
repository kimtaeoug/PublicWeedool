import 'package:json_annotation/json_annotation.dart';

part 'model_main.g.dart';

@JsonSerializable()
class MainModel {
  MainModel(this.message, this.data);

  String message;
  Data data;

  factory MainModel.fromJson(Map<String, dynamic> json) =>
      _$MainModelFromJson(json);

  Map<String, dynamic> toJson() => _$MainModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Data {
  Data(
      this.error_code,
      this.nick_name,
      this.quotes,
      this.step,
      this.ba_today,
      this.image_path,
      this.ba_today_flag,
      this.mood_flag,
      this.midterm_flag,
      this.intake_flag,
      this.dmsls_flag,
      this.htp_flag,
      this.rorschach_flag,
      this.dap_flag,
      this.sct_flag,
      this.mmpi_flag,
      this.rqt_flag,
      this.parents_flag,
      this.kwais_flag,
      this.mlst_flag,
      this.pat_flag);

  int error_code;
  String nick_name;
  String quotes;
  int step;
  Batoday? ba_today;
  String image_path;
  bool ba_today_flag;
  bool mood_flag;
  int midterm_flag;
  bool intake_flag;
  bool dmsls_flag;
  bool htp_flag;
  bool rorschach_flag;
  bool dap_flag;
  bool sct_flag;
  bool mmpi_flag;
  bool rqt_flag;
  bool parents_flag;
  bool kwais_flag;
  bool mlst_flag;
  bool pat_flag;

  @JsonKey(name: 'near_center')
  CenterInfo? centerInfo;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Batoday {
  Batoday(this.activity_id, this.activity_name, this.activity_info,
      this.timetag, this.correct);

  String activity_id;
  String activity_name;
  String activity_info;

  List<String> timetag;

  bool correct;

  factory Batoday.fromJson(Map<String, dynamic> json) =>
      _$BatodayFromJson(json);

  Map<String, dynamic> toJson() => _$BatodayToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CenterInfo {
  CenterInfo(this.center_id, this.center_name, this.center_image,
      this.speciality, this.latitude, this.longitude, this.location);

  String center_id;
  String center_name;
  CenterImage center_image;
  List<String> speciality;
  String latitude;
  String longitude;
  String location;

  factory CenterInfo.fromJson(Map<String, dynamic> json) =>
      _$CenterInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CenterInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CenterImage {
  CenterImage(this.main_image_path, this.sub_image_path);

  String? main_image_path;
  List<String>? sub_image_path;

  factory CenterImage.fromJson(Map<String, dynamic> json) =>
      _$CenterImageFromJson(json);

  Map<String, dynamic> toJson() => _$CenterImageToJson(this);
}
