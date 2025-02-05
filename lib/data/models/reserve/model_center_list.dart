

import 'package:json_annotation/json_annotation.dart';

part 'model_center_list.g.dart';



@JsonSerializable()
class CenterListModel{


  CenterListModel(this.result_code,this.result_msg,this.data);
  int result_code;
  String result_msg;
  List<Data>? data;

  factory CenterListModel.fromJson(Map<String,dynamic> json) =>
      _$CenterListModelFromJson(json);

  
  Map<String,dynamic> toJson() => _$CenterListModelToJson(this);
}

@JsonSerializable(explicitToJson:true)
class Data {
  Data(this.center_id,this.center_name,this.center_img,this.location,this.latitude,this.longitude,this.category);
  String center_id;
  String center_name;
  CenterImg center_img;
  String location;
  String latitude;
  String longitude;
  List<String>? category;
  

  factory Data.fromJson(Map<String,dynamic> json) =>
      _$DataFromJson(json);

  
  Map<String,dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable(explicitToJson:true)
class CenterImg {
  CenterImg(this.main_img_path,this.sub_img_path);
  @JsonKey(name:'Main_Image_Path')
  String? main_img_path;
  @JsonKey(name:'Sub_Image_Path')
  List<String>? sub_img_path;
  

  factory CenterImg.fromJson(Map<String,dynamic> json) =>
      _$CenterImgFromJson(json);

  
  Map<String,dynamic> toJson() => _$CenterImgToJson(this);
}



