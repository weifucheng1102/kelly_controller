import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:kelly_user_project/models/parameter.dart';

import '../models/mot_property.dart';

class ParameterCon extends GetxController {
  ///所有筛选数组
  List<MotProperty> property_list = [];

  ///筛选
  List<bool> property_select_more = [];
  List<int> property_isSelect_list = [];

  ///所有参数
  List<Parameter> all_parameterList = [];

  ///根据type 分类参数
  Map<String, List<Parameter>> filter_parameter_maplist = {};

  ///参数的值
  Map<String, dynamic> all_parameter_value = {};

  ///获取筛选
  Future getPropertyFromJson() async {
    final String response =
        await rootBundle.loadString('assets/jsons/mot_property.json');
    final List data = await json.decode(response);
    print(data);
    property_list = data.map((e) => MotProperty.fromJson(e)).toList();
    property_select_more = data.map((e) => false).toList();
    property_isSelect_list = data.map((e) => -1).toList();
  }

  ///获取全部参数
  Future getParameterFromJson() async {
    final String response =
        await rootBundle.loadString('assets/jsons/parameter_data.json');
    final List data = await json.decode(response);
    all_parameterList = data.map((e) => Parameter.fromJson(e)).toList();
    await getAllParameterValue();
    await getParameterWithType(all_parameterList);
  }

  ///获取所有参数 的默认值
  Future getAllParameterValue() async {
    all_parameterList.forEach((element) {
      if (element.parameterTypeEnum == ParameterTypeEnum.Slider) {
        all_parameter_value.addAll({
          element.parmName: 0.0,
        });
      } else if (element.parameterTypeEnum == ParameterTypeEnum.Switcher) {
        all_parameter_value.addAll({
          element.parmName: true,
        });
      } else {
        all_parameter_value.addAll({
          element.parmName: '',
        });
      }
    });
  }

  /// 根据type分类参数
  Future getParameterWithType(List<Parameter> list) async {
    filter_parameter_maplist = {
      'input': [],
      'enum': [],
      'switcher': [],
      'slider': [],
    };

    list.forEach((element) {
      switch (element.parameterTypeEnum) {
        case ParameterTypeEnum.Input:
          filter_parameter_maplist['input']!.add(element);
          break;
        case ParameterTypeEnum.Enum:
          filter_parameter_maplist['enum']!.add(element);
          break;
        case ParameterTypeEnum.Switcher:
          filter_parameter_maplist['switcher']!.add(element);
          break;
        case ParameterTypeEnum.Slider:
          filter_parameter_maplist['slider']!.add(element);
          break;
        default:
      }
    });
  }
}
