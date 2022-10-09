import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/common/custom_input.dart';
import 'package:kelly_user_project/common/custom_popmenu.dart';
import 'package:kelly_user_project/common/filter_button.dart';
import 'package:kelly_user_project/config/config.dart';
import 'package:kelly_user_project/config/event.dart';
import 'package:kelly_user_project/controller/connection_con.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';
import 'package:kelly_user_project/models/parameter.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ParameterPage extends StatefulWidget {
  const ParameterPage({Key? key}) : super(key: key);

  @override
  State<ParameterPage> createState() => _ParameterPageState();
}

class _ParameterPageState extends State<ParameterPage> {
  final parameterCon = Get.put(ParameterCon());
  final connectionCon = Get.put(ConnectionCon());
  @override
  void initState() {   ///读取文件更新数据
    bus.on('updateParameterWithFile', (arg) {
      setState(() {});
    });
    bus.on('updateParameterSuccess', (arg) { 
      
    });

    ///串口指令处理数据
    bus.on('updateParameterWithSerial', (arg) {
      
      Uint8List list = arg;
      List<String> keyList = parameterCon.all_parameter_value.keys.toList();
      for (var i = 0; i < list.length; i++) {
        parameterCon.all_parameter_value[keyList[i]] = list[i];
      }
      setState(() {});
    });
    super.initState();
    
  ///发送 获取参数指令
  
              connectionCon.port!
                  .write(Uint8List.fromList([hexToInt('61'),hexToInt('00'),hexToInt('61')]), timeout: 0);
  





 
  }

  @override
  void dispose() {
    super.dispose();
    bus.off('updateParameterWithFile');
    bus.off('updateParameterWithSerial');
    bus.off('updateParameterSuccess');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: Config.left_menu_margin),
              child: ListView.separated(
                  controller: ScrollController(),
                  itemBuilder: (context, index) {
                    List<String> keys = parameterCon
                        .filter_parameter_maplist.keys
                        .where((element) => true)
                        .toList();
                    List<List<Parameter>> values = parameterCon
                        .filter_parameter_maplist.values
                        .where((element) => true)
                        .toList();

                    switch (keys[index]) {
                      case 'input':
                        return inputGridview(values[index]);
                      case 'enum':
                        return enumGridview(values[index]);
                      case 'switcher':
                        return switcherGridview(values[index]);
                      case 'slider':
                        return sliderGridview(values[index]);
                      default:
                        return SizedBox();
                    }
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 30,
                    );
                  },
                  itemCount: parameterCon.filter_parameter_maplist.keys.length),
            ),
          ),
          FilterButton(
            voidCallback: () {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  ///输入框类型参数布局
  Widget inputGridview(List<Parameter> list) {
    double ratioWidget = (1.sw - Config.left_menu_margin - 20 - 30) / 4;
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: ratioWidget / 120,
      children: list
          .map(
            (e) => Tooltip(
              preferBelow: false,
              message: e.toolTip,
              child: CustomInput(
                title: e.parmName,
                hint: 'hint',
                readOnly: false,
                width: ratioWidget,
                height: 66,
                fieldCon: TextEditingController(
                    text: parameterCon.all_parameter_value[e.parmName]
                        .toString()),
                onChanged: (res) async {
                  await parameterCon.updateParameterValue(e, res);
                },
              ),
            ),
          )
          .toList(),
    );
  }

  ///选择框参数类型布局
  Widget enumGridview(List<Parameter> list) {
    double ratioWidget = (1.sw - Config.left_menu_margin - 20 - 30) / 4;
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: ratioWidget / 120,
      children: list
          .map(
            (e) => CustomPopMenu(
              title: e.parmName,
              width: ratioWidget,
              items: e.enumValue
                  .map((value) => MenuItem(label: value, value: value))
                  .toList(),
              height: 66,
              value: e.enumValue.length == 0 ||
                      parameterCon.all_parameter_value[e.parmName].length == 0
                  ? null
                  : parameterCon.all_parameter_value[e.parmName],
              valueChanged: (res) async {
                await parameterCon.updateParameterValue(e, res);
              },
            ),
          )
          .toList(),
    );
  }

  ///开关类型参数布局
  Widget switcherGridview(List<Parameter> list) {
    double ratioWidget = (1.sw - Config.left_menu_margin - 20 - 30) / 3;
    return StatefulBuilder(builder: (context, switchbuild) {
      return GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: ratioWidget / 60,
        children: list
            .map(
              (e) => Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      e.parmName,
                      style: TextStyle(
                        color: Get.theme.hintColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  CupertinoSwitch(
                    activeColor: Get.theme.primaryColor,
                    value: parameterCon.all_parameter_value[e.parmName],
                    onChanged: (res) async {
                      await parameterCon.updateParameterValue(e, res);
                      switchbuild(() {});
                    },
                  )
                ],
              ),
            )
            .toList(),
      );
    });
  }

  ///滑块类型参数布局
  Widget sliderGridview(List<Parameter> list) {
    double ratioWidget = (1.sw - Config.left_menu_margin - 20 - 30) / 3;
    return StatefulBuilder(
      builder: (context, switchbuild) {
        return GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: ratioWidget / 110,
          children: list
              .map(
                (e) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 21, bottom: 9),
                      child: Text(
                        e.parmName,
                        style: TextStyle(
                          color: Get.theme.hintColor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SfSliderTheme(
                            data: SfSliderThemeData(
                              activeTrackHeight: 40,
                              inactiveTrackHeight: 40,
                              activeTrackColor: Get.theme.primaryColor,
                              inactiveTrackColor: Get.theme.hintColor,
                              trackCornerRadius: 20,
                              thumbRadius: 25,
                            ),
                            child: SfSlider(
                              min: e.sliderMin,
                              max: e.sliderMax,
                              stepSize: 1,
                              value:
                                  parameterCon.all_parameter_value[e.parmName],
                              thumbIcon: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Get.theme.focusColor,
                                ),
                                padding: EdgeInsets.all(4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                              ),
                              onChanged: (res) async {
                                await parameterCon.updateParameterValue(e, res);
                                switchbuild(() {});
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: TextFormField(
                            onChanged: (res) async {
                              if (double.parse(res) > e.sliderMax) {
                                await parameterCon.updateParameterValue(
                                    e, e.sliderMax);
                                switchbuild(() {});
                              }
                              if (double.parse(res) < e.sliderMin) {
                                await parameterCon.updateParameterValue(
                                    e, e.sliderMin);
                                switchbuild(() {});
                              }
                            },
                            onFieldSubmitted: (res) async {
                              parameterCon.all_parameter_value[e.parmName] =
                                  double.parse(res);
                              await parameterCon.updateParameterValue(
                                  e, double.parse(res));
                              switchbuild(() {});
                            },
                            controller: TextEditingController(
                              text: parameterCon.all_parameter_value[e.parmName]
                                  .toStringAsFixed(1),
                            ),
                            style: TextStyle(
                              color: Get.theme.highlightColor,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              .toList(),
        );
      },
    );
  }
}
