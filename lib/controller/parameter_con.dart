import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/common/show_success_dialog.dart';
import 'package:kelly_user_project/config/event.dart';
import 'package:kelly_user_project/models/parameter.dart';

import '../common/custom_dialog.dart';
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

  ///实时参数
  List<Parameter> real_time_data_list = [];

  ///实时参数值
  Map<int, dynamic> real_time_data_value = {};

  ///实时参数对应色折线图颜色
  Map<int, Color> real_time_data_color = {};

  ///选择要显示的实时参数
  List<int> real_time_data_select = [];

  ///获取筛选
  Future getPropertyFromJson() async {
    final String response =
        await rootBundle.loadString('assets/jsons/mot_property.json');
    final List data = await json.decode(response);
    print(data);
    property_list = data.map((e) => MotProperty.fromJson(e)).toList();
    property_select_more = data.map((e) => false).toList();
    await getDefaultProPertySelectList();
  }

  ///获取默认选择的筛选 （-1 为不选择）
  Future getDefaultProPertySelectList() async {
    property_isSelect_list = property_list.map((e) => -1).toList();
  }

  ///获取全部参数
  Future getParameterFromJson() async {
    final String response =
        await rootBundle.loadString('assets/jsons/parameter_data.json');
    final List data = await json.decode(response);
    all_parameterList = data.map((e) => Parameter.fromJson(e)).toList();
    await getParameterWithType(all_parameterList);
    await getAllParameterValue();
  }

  ///获取所有参数 的默认值
  Future getAllParameterValue() async {
    filter_parameter_maplist['input']?.forEach((element) {
      all_parameter_value.addAll({
        element.parmName: '',
      });
    });

    filter_parameter_maplist['enum']?.forEach((element) {
      all_parameter_value.addAll({
        element.parmName: '',
      });
    });
    filter_parameter_maplist['switcher']?.forEach((element) {
      all_parameter_value.addAll({
        element.parmName: true,
      });
    });
    filter_parameter_maplist['slider']?.forEach((element) {
      all_parameter_value.addAll({
        element.parmName: 0.0,
      });
    });

    // all_parameterList.forEach((element) {
    //   if (element.parameterTypeEnum == ParameterTypeEnum.Slider) {
    //     all_parameter_value.addAll({
    //       element.parmName: 0.0,
    //     });
    //   } else if (element.parameterTypeEnum == ParameterTypeEnum.Switcher) {
    //     all_parameter_value.addAll({
    //       element.parmName: true,
    //     });
    //   } else {
    //     all_parameter_value.addAll({
    //       element.parmName: '',
    //     });
    //   }
    // });
  }

  ///根据category 筛选参数
  ///根据 category  筛选 参数
  Future getParameterWithProperty() async {
    List<Parameter> temp_categpry_parm = List.generate(
        all_parameterList.length, (index) => all_parameterList[index]);

    for (var i = 0; i < property_isSelect_list.length; i++) {
      int item = property_isSelect_list[i];
      if (item != -1) {
        String mapKey = property_list[i].motMetaKey;
        String mapValue = property_list[i].motMetaValues[item];
        temp_categpry_parm.removeWhere(
            (element) => element.motProperties[mapKey] != mapValue);
      }
    }

    // if (select_filter_map.keys.isEmpty) {
    //   temp_categpry_parm = all_parameterList;
    // } else {
    //   select_filter_map.keys.forEach((propertyKey) {
    //     all_parameterList.forEach((element) {
    //       if (element.motProperties.keys.contains(propertyKey) &&
    //           element.motProperties[propertyKey] ==
    //               select_filter_map[propertyKey]) {
    //         temp_categpry_parm.add(element);
    //       }
    //     });
    //   });
    // }

    await getParameterWithType(temp_categpry_parm);
  }

  ///更新参数值
  Future updateParameterValue(Parameter parameter, value) async {
    all_parameter_value[parameter.parmName] = value;
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

    print(filter_parameter_maplist);
  }

  ///获取实时参数
  Future getRealTimeDataFromJson() async {
    final String response =
        await rootBundle.loadString('assets/jsons/real_time_data.json');
    final List data = await json.decode(response);
    real_time_data_list = data.map((e) => Parameter.fromJson(e)).toList();
    real_time_data_list.forEach((element) {
      real_time_data_value.addAll({element.motId: null});
    });

    ///设置实时参数全选
    real_time_data_select = List.generate(real_time_data_list.length,
        (index) => real_time_data_list[index].motId);
    real_time_data_list.forEach((element) {
      real_time_data_color.addAll({element.motId: randomColor()});
    });
  }

  ///读文件
  Future<void> parameterReadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select File',
    );

    if (result != null && result.files.isNotEmpty) {
      String contents = await File(result.files.first.path!).readAsString();
      print(contents);

      ///转json
      Map map = json.decode(contents);

      ///更新参数

      map.keys.forEach((element) {
        print(element);
        if (all_parameter_value.keys.contains(element)) {
          all_parameter_value[element] = map[element];
        }
      });

      ///通知参数页 更新数据
      bus.emit('updateParameterWithFile');
    }
  }

  ///写文件
  writeFile(context) async {
    String str = json.encode(all_parameter_value);
    print(str);
    str = str.replaceAll(',', ',\r\n');

    if (GetPlatform.isMobile) {
      String? path = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
      print(path);
      File file = await File(path! + '/parameter.txt').create(recursive: true);

      file.writeAsString(str, mode: FileMode.write).whenComplete(() {
        CustomDialog.showCustomDialog(context, child: ShowSuccessDialog());
      });
    } else {
      final String? result = await FilePicker.platform
          .saveFile(fileName: 'parameter.txt', dialogTitle: 'save File');
      if (result != null && result.isNotEmpty) {
        File(result).writeAsString(str, mode: FileMode.write).whenComplete(() {
          CustomDialog.showCustomDialog(context, child: ShowSuccessDialog());
        });
      }
    }
  }
}
