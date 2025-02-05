import 'package:weedool/components/wd_apis.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/models/model_checkup.dart';
import 'package:weedool/models/model_checkup_add.dart';
import 'package:weedool/utils/logger.dart';

class TestController{
  Future<CheckupModel> requestCheckup(String category) async {
    Map<String, String> body = {'category': category, 'uuid' : WDCommon().uuid};
    final response = await WDApis().requestCheckup(body);
    return response;
  }

  Future<CheckupAddModel> requestAddCheckup(String category, List<int> value) async {
    Map<String, dynamic> body = {
      'uuid': WDCommon().uuid,
      'category': category,
      'result': value
    };
    final response = await WDApis().requestAddCheckup(body);
    return response;
  }
}